#!/usr/bin/bash
# bash-cdt.sh: bash toolkit for "CD to Tempdir" aka cdt command.

function cdt() {
    if [ "$1" = "-d" ]; then
        if [ -n "$CDT" ]; then
            _uekbuild_yesno "Delete $CDT?" || return 1
            cd $CDT/..
            rm -rf $CDT
            CDT=""
            echo "Done!"
        else
            echo "No temporary directory..."
        fi
        return 0
    fi
    local newdir
    if [ -z "$CDT" ] || [ "$1" = "-n" ]; then
        read -r -p "Enter a short description: " newdir
        CDT="$HOME/Temporary/$(date +%Y-%m-%d)_$newdir"
        mkdir -p "$CDT"
        cd "$CDT"
        echo "$CDT"
    else
        cd "$CDT"
    fi
}
