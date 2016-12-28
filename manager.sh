#!/bin/bash
echo -e "\n\n"
if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "This script works for MAC OSx only!"
	echo "BYE!"
	exit 1
fi








usage() { echo "Usage: $0 [-s <45|90>] [-p <string>]" 1>&2; exit 1; }

while getopts ":s:p:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ((s == 45 || s == 90)) || usage
            ;;
        p)
            p=${OPTARG}
            ;;
        l)
            ls ./Themes
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${s}" ] || [ -z "${p}" ]; then
    usage
fi

echo "s = ${s}"
echo "p = ${p}"




exit




if [ $# -eq 0 ]; then
    echo "Nothing to do."
    echo -e "Usage $0 <themename>\n\n"
    exit
fi


if [ -z "$HOME" ]; then
    echo "Cannot define user home directory in $HOME"
    exit
fi

pkill -9 "doublecmd"

destpath="$HOME/Library/Preferences/doublecmd"
thispath="$(pwd)"

echo "Create backup ..."
cd $destpath
tar -C $destpath  -cvjf "backup.tar.gz" --exclude="backup.tar.gz" ./
cd $thispath
echo "... done"
#unpack
# tar -xvf backup.tar.gz
# tar -xvf backup.tar.gz -C pathToUnpack


exit






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

open "/Applications/Double Commander.app" 2>/dev/null