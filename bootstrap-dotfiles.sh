#!/bin/bash

# Define the source and target directories
DOTFILES_REPO="https://github.com/khaosx/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
TARGET_DIR="$HOME"

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
    REMOTE_HASH=$(git rev-parse @{u})

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "Local repository is outdated. Pulling latest changes..."
        git pull
    else
        echo "Local repository is up to date."
    fi
fi

# Step 2: Iterate over the contents of the dotfiles directory and update symbolic links
echo "Updating symbolic links for dotfiles..."
for item in "$DOTFILES_DIR"/*; do
    # Get the basename of the file or directory
    item_name=$(basename "$item")
    target_item="$TARGET_DIR/$item_name"

    # Skip the README.md file
    if [ "$item_name" == "README.md" ]; then
        echo "Skipping $item_name: excluded from symbolic link creation."
        continue
    fi

    # Remove existing symbolic links or files
    if [ -e "$target_item" ] || [ -L "$target_item" ]; then
        echo "Removing existing $target_item..."
        rm -rf "$target_item"
    fi

    # Create symbolic links for files and directories
    ln -s "$item" "$target_item"
    echo "Linked $item to $target_item"
done

echo "Dotfiles setup and updates completed."
