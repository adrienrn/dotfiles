
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#
# Local dotfile for machine specific options
# https://github.com/necolas/dotfiles
#

if [ -f "$HOME/.dotfiles.local" ]; then
    # Non-commited configuration, @TODO rename that.
    source "$HOME/.dotfiles.local";
fi

#
# Locate dotfiles.
# @see https://github.com/webpro/dotfiles
#

if [ "$DOTFILES_DIR" == "" ] || [ ! -d "$DOTFILES_DIR" ]; then
    READLINK=$(which greadlink || which readlink)
    CURRENT_SCRIPT=$BASH_SOURCE

    if [ $(uname) != "Darwin" ] && [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
	SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT" 2>/dev/null)
	if [ "$?" != 0 ]; then
	    # System does not support -f option, probably MacOs
	    echo "System does not support -f option, set DOTFILES_DIR environement variable manually."
	    return # `exit 1` would quit the shell itself
	fi 
	DOTFILES_DIR=$(dirname "$SCRIPT_PATH")
    elif [ -d "$HOME/.dotfiles" ]; then
	DOTFILES_DIR="$HOME/.dotfiles"
    else
	echo "Unable to find dotfiles, exiting."
	return # `exit 1` would quit the shell itself
    fi
fi

#
# Load the shell dotfiles.
# @see https://github.com/webpro/dotfiles
#

# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in "$DOTFILES_DIR"/system/{path,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source $file;
done;
unset file;

# Set LSCOLORS
if [ "$(which dircolors)" != "" ]; then
    eval "$(dircolors "$DOTFILES_DIR"/system/dircolors)"
else
    # System has no dircolors, probably MacOs or freebsd
    : # No-op, do nothing
fi

# Enable bash-it
source "$BASH_IT/bash_it.sh"
if [ "$(bash-it show plugins | grep -E 'fasd.*\[x\]')" == "" ]; then
    bash-it enable plugin fasd;
fi
if [ "$(bash-it show completions | grep -E 'git.*\[x\]')" == "" ]; then
    bash-it enable completion git;
fi
if [ "$(bash-it show aliases | grep -E 'git.*\[x\]')" == "" ]; then
    bash-it enable alias git;
fi

# Clean up
unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
