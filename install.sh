#!env bash

# Find dotfiles directory path
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Register the execution date for backups
date_suffix=$(date +_%F-%T-%N)

if [ ! -d "$DOTFILES_DIR/bash-it" ]; then
    echo "Download and configure bash-it..."
    git clone -q --depth=1 https://github.com/bash-it/bash-it.git "$DOTFILES_DIR/bash-it"
fi

# Make symlink for a bunch of files.
for file in $(find $DOTFILES_DIR -type f -name .bash_profile -o -name .bashrc -o -name .inputrc -o -name .gitconfig -o -name .emacs); do
    
    # Get the filename from path
    target=$(basename $file)

    if [ -f ~/$target ] && [ ! -L ~/$target ]; then
	# Backup the existing file before linking.
	mv ~/$target ~/$target$date_suffix
    fi

    # Makes the symlink to dotfile.
    ln -sfv $file ~
done

