#!/bin/bash
echo -e "\n\n"
if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "This script works for MAC OSx only!"
	exit 1
fi
echo "Assume that you forked GIT to your arrount and probably wish to edit some configs."
echo "This script will link config files from this folder to Double Commander so you can edit and share it."
echo "Default path: ~/Library/Preferences/doublecmd/"
echo "Do you wish to continue?"
select result in Yes No
do
    echo $result
    if [[ $result == "No" ]]; then
    	echo "BYE!"
    	exit
    fi
    break;
done

if [ -z "$HOME" ]; then
	echo "Cannot define user home directory in $HOME"
    exit
fi

destpath="$HOME/Library/Preferences/doublecmd/"
thispath="$(pwd)/doublecmd/"
ln -sf "$thispath/*.*" $destpath

echo "Done"