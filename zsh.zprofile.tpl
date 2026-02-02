# .zprofile.tpl - Zsh Profile Configuration
# Managed by 1Password (op inject)
# Author: Kristopher Newman
#
# This file is generated from a template. Do not edit ~/.zprofile directly.

# Path modifications:
export PATH="$HOME/bin:$PATH"

# Environment Variables:
## Set brew update to only run once a week
export HOMEBREW_AUTO_UPDATE_SECS=604800

## Define location of Brew bundle
export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile"

## Set location for ansible config file
export ANSIBLE_CONFIG="$HOME/.ansible.cfg"

## 1Password Injected Secrets
## This pulls the vault password from 1Password during the bootstrap process
export ANSIBLE_VAULT_PASSWORD="{{ op://khaosx-infrastructure/pfkutx4v5qzxgmoehc3wjn2ugy/ANSIBLE_VAULT_PASSWORD }}"

## I won't fucking use VIM, ever. Stop trying to make it a thing.
export EDITOR=nano

# Added for HomeBrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# EOF