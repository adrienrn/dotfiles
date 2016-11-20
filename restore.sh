#!env bash

for file in $(find ~ -maxdepth 1 -name .bash_profile -o -name .bashrc -o -name .inputrc -o -name .gitconfig -o -name .emacs); do
    filename=$(basename $file)
    latestBackup=$(cd ~; ls $filename"_"* 2>/dev/null | sort -rn | head -n 1)
    homeDirectory=~
    # Is $file a symlink? 
    if [ -L $file ]; then
	echo "$filename is a symlink"
	echo -n "Looking for backup..."
	if [ "$latestBackup" != "" ]; then
	    echo " '$latestBackup'"
	    rm $file
	    cp $homeDirectory"/"$latestBackup $homeDirectory"/"$filename
	else
	    echo " no backup found!"
	    rm $file
	fi
    fi
done
