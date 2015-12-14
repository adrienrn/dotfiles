# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#
# Locate dotfiles.
# @see https://github.com/webpro/dotfiles
#

READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
    SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
    DOTFILES_DIR=$(dirname "$SCRIPT_PATH")
elif [ -d "$HOME/.dotfiles" ]; then
    DOTFILES_DIR="$HOME/.dotfiles"
else
    echo "Unable to find dotfiles, exiting."
    return # `exit 1` would quit the shell itself
fi

#
# Load the shell dotfiles.
# @see https://github.com/webpro/dotfiles
#

# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in "$DOTFILES_DIR"/system/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Enable bash-it
source "$BASH_IT/bash_it.sh"

# Clean up
unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE
