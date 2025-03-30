#!/bin/zsh

# ===================================================================================
# Script Name: bootstrap-dotfiles.sh
# Description: This script sets up, manages, and can destroy dotfiles from a GitHub repository.
#              Hidden files are included. Includes a `destroy` function for cleanup.
#
# Usage: 
#   1. Make the script executable:
#      chmod +x bootstrap-dotfiles.sh
#   2. Run the script:
#      ./bootstrap-dotfiles.sh
#   3. To destroy symbolic links:
#      ./bootstrap-dotfiles.sh --destroy
#
# Author: Kristopher Newman
# Copyright: © 2025 Kristopher Newman
# ===================================================================================

# Define the source and target directories
DOTFILES_REPO="https://github.com/khaosx/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"  # Changed to hidden directory
TARGET_DIR="$HOME"

# Function to destroy symbolic links
destroy() {
    echo "Destroying symbolic links in $DOTFILES_DIR..."
    setopt dotglob # Enable hidden files
    for item in "$DOTFILES_DIR"/*; do
        item_name=$(basename "$item")
        target_item="$TARGET_DIR/$item_name"
        
        # Remove symbolic links only
        if [[ -L "$target_item" ]]; then
            echo "Removing symbolic link: $target_item"
            rm -f "$target_item"
        fi
    done
    unsetopt dotglob # Restore default behavior
    echo "Symbolic links removed successfully."
}

# Check for the '--destroy' parameter
if [[ "$1" == "--destroy" ]]; then
    destroy
    exit 0
fi

# Step 1: Clone the repository if it doesn't already exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository into $DOTFILES_DIR..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo "Checking for updates in the dotfiles repository..."
    cd "$DOTFILES_DIR"

    # Fetch the latest changes and check if there are updates
    git fetch
    LOCAL_HASH=$(git rev-parse HEAD)
    REMOTE_HASH=$(git rev-parse '@{u}')

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "Local repository is outdated. Pulling latest changes..."
        git pull
    else
        echo "Local repository is up to date."
    fi
fi

# Step 2: Update symbolic links for files, ensuring directories exist
echo "Processing dotfiles (including hidden files)..."
setopt dotglob # Enable the inclusion of hidden files
for item in $DOTFILES_DIR/*; do
    # Get the basename of the file or directory
    item_name=$(basename "$item")
    target_item="$TARGET_DIR/$item_name"

    # Skip excluded files and directories
    if [[ "$item_name" == "README.md" || "$item_name" == "bootstrap-dotfiles.sh" || "$item_name" == ".git" ]]; then
        echo "Skipping $item_name: excluded from processing."
        continue
    fi

    # Handle directories
    if [[ -d "$item" ]]; then
        echo "Processing directory: $item_name"

        # Ensure the target directory exists
        if [[ ! -d "$target_item" ]]; then
            echo "Creating target directory: $target_item"
            mkdir -p "$target_item"
        fi

        # Create or update symbolic links for files inside the directory
        for file in $item/*; do
            file_name=$(basename "$file")
            target_file="$target_item/$file_name"

            # Remove existing symbolic links or files
            if [[ -e "$target_file" || -L "$target_file" ]]; then
                echo "Removing existing $target_file..."
                rm -rf "$target_file"
            fi

            # Create symbolic link
            ln -s "$file" "$target_file"
            echo "Linked $file to $target_file"
        done
    else
        # Handle files directly in the dotfiles directory
        echo "Processing file: $item_name"

        # Remove existing symbolic links or files
        if [[ -e "$target_item" || -L "$target_item" ]]; then
            echo "Removing existing $target_item..."
            rm -rf "$target_item"
        fi

        # Create symbolic link
        ln -s "$item" "$target_item"
        echo "Linked $item to $target_item"
    fi
done
unsetopt dotglob # Restore default behavior
source ~/.zshrc

echo "Dotfiles setup and updates completed."
