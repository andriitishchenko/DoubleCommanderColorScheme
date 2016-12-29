#!/bin/bash
FORCEACTION=0
echo -e "\n\n"
if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "This script works for MAC OSx only!"
	echo "BYE!"
	exit 1
fi

if [ -z "$HOME" ]; then
    echo "Cannot define user home directory in $HOME"
    exit
fi

DBLSETTINGS="$HOME/Library/Preferences/doublecmd"
THISPATH="$(pwd)"
THEMEROOT="$(pwd)/Themes"

confirm() {
    select result in Yes No
    do
        echo $result
        if [[ $result != "Yes" ]]; then
            echo -e "BYE!\n" 1>&2; exit 1;
        fi
        break;
    done
}


usage() { 
        echo "Nothing to do."
        echo -e "Usage $0 [themename]
        -             [-l  list]
        -             [-c  <name> create new theme] 
        -             [-f -c <name> replase existing theme]
        \n\n" 1>&2; exit 1;
}

backup() {
    if [ -f "$DBLSETTINGS/backup.tar.gz" ] ; then
        return
    fi
    echo "Creating backup ..."
    echo "Backup creates only once with Your original files."
    cd $DBLSETTINGS
    tar -C $DBLSETTINGS  -cvjf "backup.tar.gz" --exclude="backup.tar.gz" ./
    cd $THISPATH
    echo "... done"
}

restore() {
    echo "Restore backup ..."
    tar -xvf "$DBLSETTINGS/backup.tar.gz"
    echo "... done"
}

createtheme() {
    echo "Creating theme: \"$1\"..."
    themeselect=$1

    if [ -z "${themeselect}" ] ; then
        usage
    fi

    THEMEAPPLY="$THEMEROOT/$themeselect"

    if [ -d "$THEMEAPPLY" ] && [ $FORCEACTION == 0 ] ; then
        echo "Theme exist, use new Theme name"  1>&2; exit 1;
    fi
    DCONFIG=$THEMEAPPLY/config
    mkdir -p $DCONFIG
    files=( doublecmd.xml extassoc.xml highlighters.xml multiarc.ini pixmaps.txt shortcuts.scf )
    for i in "${files[@]}"
    do
        cp $DBLSETTINGS/$i $DCONFIG/
    done
    echo "... done"

    echo -e "Prepare \"Double Commander\" window size for capturing screenshot.
    Make sure there is no secure info displayed :)"
    read -rsp $'Press any key to continue...\n' -n1 key

    echo "Select \"Double Commander\" window to make a screenshot for \"$1\" theme on the next step"
    read -rsp $'Press any key to continue...\n' -n1 key
    
    open "/Applications/Double Commander.app" 2>/dev/null
    screencapture -W  "$THEMEAPPLY/$themeselect.png"
    echo "Finish"
}

#while getopts ":s:p:l:r" o; do
while getopts ":l:r:c:f" o; do
    case "${o}" in
        f)
            FORCEACTION=1
            ;;
        c)
            createtheme ${OPTARG}
            exit
            ;;
        r)
            restore
            exit
            ;;
        l)
            echo "Available Themes:"
            ls -1 ./Themes
            echo ""
            exit
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# read theme
themeselect=${1}

if [ -z "${themeselect}" ] ; then
    usage
fi

THEMEAPPLY="$THEMEROOT/$themeselect"

if [ ! -d "$THEMEAPPLY" ] ; then
    usage
fi

echo -e "The original config files of Double Commander will be replased with files from \"${themeselect}\" Theme.
Shortcuts and all other settings will be overwritten.
Do you want to continue?"
confirm

pkill -9 "doublecmd"

backup

echo "Moving files ..."
    cp -L $THEMEAPPLY/config/* $DBLSETTINGS
echo "... done"

open "/Applications/Double Commander.app" 2>/dev/null