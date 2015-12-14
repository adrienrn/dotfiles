#!env bash

# Find dotfiles directory path
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Register the execution date for backups
date_suffix=$(date +_%F-%T-%N)

# Make symlink for a bunch of files.
for file in $(find $DOTFILES_DIR -type f -name .bash_profile -o -name .bashrc -o -name .inputrc -o -name .emacs); do
    
    # Get the filename from path
    target=$(basename $file)

    if [ -f ~/$target ] && [ ! -L ~/$target ]; then
	# Backup the existing file before linking.
	mv ~/$target ~/$target$date_suffix
    fi

    # Makes the symlink to dotfile.
    ln -sfv $file ~
done

