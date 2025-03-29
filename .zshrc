# .zprofile - Zsh Profile Configuration
# Author: Kristopher Newman
# Date: 2025-02-05
#
# This file is sourced whenever a new interactive non-login shell is started.
# It is used to set aliases, define functions, set shell options, and customize
# the shell environment for interactive use.
#
# Note: Changes to this file require opening a new terminal or sourcing the file
#       for the changes to take effect. (source ~/.zshrc)

# Aliases:
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
export PS1="\[$(tput setaf 243)\]\u\[$(tput setaf 245)\]@\[$(tput setaf 249)\]\h \[$(tput setaf 254)\]\w \[$(tput sgr0)\]$ "

# Plugins (e.g., Oh-My-Zsh):
plugins=(git brew history)

# EOF
