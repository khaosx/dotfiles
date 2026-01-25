#!/bin/bash

# Script to create symbolic links for dotfiles
# Source files are expected in ~/Projects/dotfiles
# Target links are created in $HOME

# Define base directories
CONFIGS_DIR="$HOME/Projects/dotfiles"
TARGET_DIR="$HOME" # Usually $HOME, but keep flexible if needed

echo "Starting dotfile symlink creation..."
echo "Source directory: $CONFIGS_DIR"
echo "Target directory: $TARGET_DIR"
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
    echo "  Source: $full_source_path"
    echo "  Target: $full_target_path"

    # --- Pre-checks ---

    # 1. Check if the source file/directory exists
    if [ ! -e "$full_source_path" ]; then
        echo "  [SKIP] Source does not exist: $full_source_path"
        echo "---"
        continue # Skip to the next link definition
    fi

    # 2. Ensure the target directory exists before creating the link
    target_dir=$(dirname "$full_target_path")
    if [ ! -d "$target_dir" ]; then
        echo "  Creating target directory: $target_dir"
        mkdir -p "$target_dir"
        if [ $? -ne 0 ]; then
            echo "  [ERROR] Failed to create target directory: $target_dir"
            echo "---"
            continue # Skip if directory creation failed
        fi
    fi

    # --- Link Creation / Check ---

    # 3. Check if the target already exists
    if [ -L "$full_target_path" ]; then
        # Target exists and is a symlink
        current_link_target=$(readlink "$full_target_path")
        if [ "$current_link_target" == "$full_source_path" ]; then
            echo "  [OK] Link already exists and points correctly."
        else
            echo "  [WARN] Link exists but points to '$current_link_target'."
            echo "         Consider removing it manually and re-running: rm \"$full_target_path\""
            # If you want to automatically overwrite, replace the above 'echo' lines with:
            # echo "  Overwriting existing link..."
            # ln -sf "$full_source_path" "$full_target_path"
        fi
    elif [ -e "$full_target_path" ]; then
        # Target exists but is not a symlink (it's a regular file or directory)
        echo "  [WARN] Target exists but is not a symlink: $full_target_path"
        echo "         Please back up and remove it manually if you want a link."
    else
        # Target does not exist, create the symlink
        echo "  Creating symlink..."
        # Use ln -s to create the symbolic link
        ln -s "$full_source_path" "$full_target_path"
        if [ $? -eq 0 ]; then
            echo "  [OK] Link created successfully."
        else
            echo "  [ERROR] Failed to create symlink."
        fi
    fi
    echo "---"
done

echo "Script finished."