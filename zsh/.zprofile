# .zprofile - Zsh Profile Configuration
# Author: Kristopher Newman
# Date: 2025-02-05
#
# This file is sourced only once, at the start of an interactive login shell.
# It is used to set environment variables, define functions, and run commands
# that should be executed only upon login.
#
# Note: Changes to this file require a new login or sourcing the file
#       for the changes to take effect.  (source ~/.zprofile)

# Path modifications:
export PATH="$HOME/bin:$PATH"

# Environment Variables:
## Set brew update to only run once a week
export HOMEBREW_AUTO_UPDATE_SECS=604800
## Define location of Brew bundle
export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile"
## Set location for ansible config file
export ANSIBLE_CONFIG="$HOME/.ansible.cfg"

## I won't fucking use VIM, ever. Stop trying to make it a thing.
export EDITOR=nano

# Added for HomeBrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# EOF
