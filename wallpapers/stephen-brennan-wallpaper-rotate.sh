#!/bin/bash
#-------------------------------------------------------------------------------
#
# File:         ~/.wallpapers/stephen-brennan-wallpaper-rotate.sh
#
# Author:       Stephen Brennan
#
# Date Created: Thursday, 31 July 2014
#
# Description:  Rotate through wallpapers in a directory.  Run on login.  Only
#               allow one instance running at a time.  Exit on logout.  Usually
#               placed in ~/.wallpapers with a collection of images.
#
# Source:       https://bbs.archlinux.org/viewtopic.php?id=148299
#
#-------------------------------------------------------------------------------


echo "Stephen's Wallpaper Rotation"
echo "----------------------------"

# Find other instances of this script.
A=$(pidof -x -o $$ $0)

# Find the directory of the script and cd into it.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# If any other instances are running.
if [ -n "$A" ]
then
    echo "It looks like another instance of the service is running."
    echo "Here are the matching processes:"
    echo
    # Display pgrep output for processes that aren't this.
    pgrep -fa "$0" | grep -v "^$$"
    echo

    # If we aren't instructed to ignore, shut down.
    if [ "-i" != "$1" ]; then
        echo "The service will now shut down."
        echo "Ignore this error with the -i flag."
        exit
    fi
    echo "This error is being ignored."
    echo "----------------------------"
fi

# Every 30 seconds choose a new background.
while true; do
    # find any file in this dir that is jpg or png
    # randomly choose one
    file=`find -type f -name '*.jpg' -o -name '*.png' | shuf -n 1`
    echo "=> \"$file\""
    feh --bg-scale "$file"
    # End when we log out and no X screen is avaialable.
    if [ $? -ne 0 ]; then
        echo "Feh Error, exiting."
        exit
    fi
    sleep 30
done
