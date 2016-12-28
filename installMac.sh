#!/bin/bash
echo -e "\n\n"
if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "This script works for MAC OSx only!"
	echo "BYE!"
	exit 1
fi
echo "Assume that you forked this to your GIT account and probably will wish to edit some configs."
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

pkill -9 "doublecmd"

destpath="$HOME/Library/Preferences/doublecmd/"
thispath="$(pwd)/doublecmd/"

echo "Creating links ..."
##ln -sf "$thispath/*.*" $destpath

for f in $thispath* ; do 
 	filename=$(basename "$f")
 	echo "$f - > $destpath$filename"
	ln -sf $f $destpath$filename
done

echo "Done"
