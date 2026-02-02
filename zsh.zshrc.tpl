# .zshrc.tpl - Zsh Profile Configuration
# Managed by 1Password (op inject)
# Author: Kristopher Newman
#
# This file is sourced whenever a new interactive non-login shell is started.
# It is generated from a template in the dotfiles repo.

# Aliases:
# This sources the file generated from .aliases.tpl
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Shell Options:
setopt hist_ignore_dups

# Colors
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Prompt Customization:
export PROMPT='%F{green}%n@%m%f %F{blue}%~%f $ '

# Path modifications:
export PATH="$PATH:/Users/kris/scripts:/usr/local/sbin:$HOME/.local/bin"

# EOF