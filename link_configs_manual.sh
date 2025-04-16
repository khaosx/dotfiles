#!/bin/bash

# ============================================================
# link_configs_manual.sh
#
# Production script to manually create symbolic links for
# dotfiles managed within the ~/configs directory.
# This script should be run from the user's home directory
# after cloning the configs repo to ~/configs.
# ============================================================

# Define source and target directories
CONFIGS_DIR="$HOME/configs"
TARGET_DIR="$HOME"
BACKUP_DIR="$HOME/.config_backups_$(date +%Y%m%d_%H%M%S)"

# List of files/dirs to link, relative to CONFIGS_DIR
# Format: "source_path_in_configs:target_path_in_home"
# Use ':' as delimiter. Target path is relative to TARGET_DIR ($HOME)
files_to_link=(
    ".Brewfile:.Brewfile"
    "git/.gitconfig:.gitconfig"
    "git/.gitmessage:.gitmessage"
    "ssh/.ssh/config:.ssh/config" # Note the target path includes.ssh/
    "vscode/Library/Application Support/Code/User/settings.json:Library/Application Support/Code/User/settings.json" # Target includes Library/...
    "zsh/.aliases:.aliases"
    "zsh/.zprofile:.zprofile"
    "zsh/.zshrc:.zshrc"
    # Add other files/directories here following the same pattern
)

echo "Starting manual symlinking process..."
echo "Source directory: $CONFIGS_DIR"
echo "Target directory: $TARGET_DIR"
echo "Backups will be placed in: $BACKUP_DIR"
echo "---"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Loop through the list and create links
for item in "${files_to_link[@]}"; do
    IFS=':' read -r source_rel target_rel <<< "$item"

    source_abs="$CONFIGS_DIR/$source_rel"
    target_abs="$TARGET_DIR/$target_rel"
    target_parent_dir=$(dirname "$target_abs")

    echo "Processing: $source_rel -> $target_rel"

    # 1. Check if source file/dir exists
    if [! -e "$source_abs" ]; then
        echo "  Source file/directory not found: $source_abs. Skipping."
        continue
    fi

    # 2. Create target parent directory if it doesn't exist
    if [! -d "$target_parent_dir" ]; then
        echo "  Creating parent directory: $target_parent_dir"
        mkdir -p "$target_parent_dir"
    fi

    # 3. Check if target exists and back it up if it's not already a link to the correct source
    if [ -e "$target_abs" ]; then
        if [ -L "$target_abs" ]; then
            # It's a symlink, check if it points to the correct source
            link_target=$(readlink "$target_abs")
            if [ "$link_target" == "$source_abs" ]; then
                echo "  [INFO] Correct symlink already exists: $target_abs -> $source_abs. Skipping."
                continue
            else
                echo "  [INFO] Existing symlink points elsewhere ($link_target). Backing up and removing."
                mv "$target_abs" "$BACKUP_DIR/"
            fi
        else
            # It's a regular file or directory, back it up
            echo "  [INFO] Existing file/directory found at target. Backing up: $target_abs"
            mv "$target_abs" "$BACKUP_DIR/"
        fi
    fi

    # 4. Create the symlink
    echo "  Creating symlink: $target_abs -> $source_abs"
    ln -s "$source_abs" "$target_abs"
    if [ $? -ne 0 ]; then
        echo "  Failed to create symlink for $target_abs."
    fi

    echo "---"
done

echo "Manual symlinking process complete."
echo "Check $BACKUP_DIR for any backed-up files."

exit 0