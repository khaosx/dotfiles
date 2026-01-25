#!/bin/bash

# Script to create symbolic links for dotfiles
# Source files are expected in ~/Projects/dotfiles
# Target links are created in $HOME
#
# Usage: ./link_configs_manual.sh [--force]
#   --force  Remove existing files/links and regenerate all symlinks

# Parse arguments
FORCE=false
if [[ "$1" == "--force" || "$1" == "-f" ]]; then
    FORCE=true
fi

# Define base directories
CONFIGS_DIR="$HOME/Projects/dotfiles"
TARGET_DIR="$HOME"

echo "Starting dotfile symlink creation..."
echo "Source directory: $CONFIGS_DIR"
echo "Target directory: $TARGET_DIR"
[[ "$FORCE" == true ]] && echo "Mode: FORCE (will remove existing files)"
echo "---"

# Define the links:
# Each pair is: "Source Path (relative to CONFIGS_DIR)" "Target Path (relative to TARGET_DIR)"
links=(
    ".Brewfile"           ".Brewfile"
    "git/.gitconfig"      ".gitconfig"
    "git/.gitignore"      ".gitignore"
    "git/.gitmessage"     ".gitmessage"
    "ssh/.ssh/config"     ".ssh/config"
    "zsh/.aliases"        ".aliases"
    "zsh/.zprofile"       ".zprofile"
    "zsh/.zshrc"          ".zshrc"
)

# Ensure links array has an even number of elements (pairs)
if [ $((${#links[@]} % 2)) -ne 0 ]; then
    echo "[ERROR] The links array definition is incorrect (must have pairs)."
    exit 1
fi

# Loop through the links array (processing pairs)
for (( i=0; i<${#links[@]}; i+=2 )); do
    source_rel_path="${links[i]}"
    target_rel_path="${links[i+1]}"

    # Construct full paths
    full_source_path="$CONFIGS_DIR/$source_rel_path"
    full_target_path="$TARGET_DIR/$target_rel_path"

    echo "Processing: $target_rel_path"

    # Check if the source file/directory exists
    if [ ! -e "$full_source_path" ]; then
        echo "  [SKIP] Source does not exist: $full_source_path"
        echo "---"
        continue
    fi

    # Ensure the target directory exists before creating the link
    target_dir=$(dirname "$full_target_path")
    if [ ! -d "$target_dir" ]; then
        echo "  Creating target directory: $target_dir"
        mkdir -p "$target_dir"
        if [ $? -ne 0 ]; then
            echo "  [ERROR] Failed to create target directory: $target_dir"
            echo "---"
            continue
        fi
    fi

    # Handle --force: remove existing file/link
    if [[ "$FORCE" == true && -e "$full_target_path" ]]; then
        echo "  Removing existing: $full_target_path"
        rm -f "$full_target_path"
    fi

    # Check if the target already exists
    if [ -L "$full_target_path" ]; then
        current_link_target=$(readlink "$full_target_path")
        if [ "$current_link_target" == "$full_source_path" ]; then
            echo "  [OK] Link already exists and points correctly."
        else
            echo "  [WARN] Link exists but points to '$current_link_target'."
            echo "         Run with --force to replace, or remove manually."
        fi
    elif [ -e "$full_target_path" ]; then
        echo "  [WARN] Target exists but is not a symlink: $full_target_path"
        echo "         Run with --force to replace, or back up and remove manually."
    else
        # Target does not exist, create the symlink
        ln -s "$full_source_path" "$full_target_path"
        if [ $? -eq 0 ]; then
            echo "  [OK] Link created."
        else
            echo "  [ERROR] Failed to create symlink."
        fi
    fi
    echo "---"
done

echo "Script finished."
