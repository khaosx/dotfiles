# My Dotfiles

This repository contains my personal configuration files (dotfiles) for setting up my development environment on macOS and Linux systems.

## Management Method
These dotfiles are managed using the Git bare repository technique. This method allows tracking files directly in the home directory without needing symlinks for most files (except where the target location is outside ~, like VSCode settings).   

## Structure
The files within this repository are organized to mirror their target locations within the $HOME directory. For example:
- .zshrc is stored as zsh/.zshrc in the repo but targets ~/.zshrc.
- .gitconfig is stored as git/.gitconfig in the repo but targets ~/.gitconfig.
- VSCode's settings.json is stored under vscode/Library/Application\ Support/Code/User/settings.json to reflect its target path ~/Library/Application Support/Code/User/settings.json.
