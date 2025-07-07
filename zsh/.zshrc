# .zshrc - Zsh Profile Configuration
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
export PROMPT='%F{green}%n@%m%f %F{blue}%~%f $ '

function merge_files() {
  # Get the name of the current directory.
  local output_file="${PWD##*/}.txt"

  # Check if the output file already exists and remove it to start fresh.
  if [[ -f "$output_file" ]]; then
    rm "$output_file"
  fi

  # Loop through all files in the current directory.
  for file in *; do
    # Check if the item is a file and not the output file itself.
    if [[ -f "$file" ]] && [[ "$file" != "$output_file" ]]; then
      # Append a comment with the filename to the output file.
      echo "### START OF FILE: $file ###" >> "$output_file"
      # Append the content of the file to the output file.
      cat "$file" >> "$output_file"
      # Append a newline for separation.
      echo "\n### END OF FILE: $file ###\n" >> "$output_file"
    fi
  done

  echo "All files have been merged into $output_file"
}
