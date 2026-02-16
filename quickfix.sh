#!/usr/bin/env bash
set -euo pipefail

# Self-contained run: fetch dotfiles into a temporary workspace.
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT
DOTFILES_DIR="$WORK_DIR/dotfiles"

git clone --depth 1 https://github.com/khaosx/dotfiles "$DOTFILES_DIR"

# Remove existing files/symlinks so copies always land as regular files.
rm -f "$HOME/.Brewfile" \
      "$HOME/.gitconfig" \
      "$HOME/.gitignore" \
      "$HOME/.gitmessage" \
      "$HOME/.ansible-lint"

# Force copy static files.
cp -f "$DOTFILES_DIR/sh.Brewfile" "$HOME/.Brewfile"
cp -f "$DOTFILES_DIR/git.gitconfig" "$HOME/.gitconfig"
cp -f "$DOTFILES_DIR/git.gitignore" "$HOME/.gitignore"
cp -f "$DOTFILES_DIR/git.gitmessage" "$HOME/.gitmessage"
cp -f "$DOTFILES_DIR/ansible.ansible-lint" "$HOME/.ansible-lint"

# Render template files from 1Password and overwrite outputs.
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

op inject -f -i "$DOTFILES_DIR/ssh.config.tpl" -o "$HOME/.ssh/config"
op inject -f -i "$DOTFILES_DIR/zsh.aliases.tpl" -o "$HOME/.aliases"
op inject -f -i "$DOTFILES_DIR/zsh.zprofile.tpl" -o "$HOME/.zprofile"
op inject -f -i "$DOTFILES_DIR/zsh.zshrc.tpl" -o "$HOME/.zshrc"

# Import and apply macOS Terminal profile.
open -g "$DOTFILES_DIR/ConsoleDefault.terminal" >/dev/null 2>&1
defaults write com.apple.Terminal "Default Window Settings" -string "ConsoleDefault"
defaults write com.apple.Terminal "Startup Window Settings" -string "ConsoleDefault"

# Secure permissions.
chmod 600 "$HOME/.ssh/config"

echo "Quickfix applied successfully. Dotfiles were fetched to a temporary directory and cleaned up."
