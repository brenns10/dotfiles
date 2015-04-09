#-------------------------------------------------------------------------------
#
# File:         ~/.profile
#
# Author:       Stephen Brennan
#
# Date Created: Tuesday, 29 July 2014
#
# Description:  Run by bash or DE when logging in.
#
#-------------------------------------------------------------------------------

## Print a notification when this file runs.
#zenity --warning --text="Running .profile"
#echo "Running .profile"

export PATH=$PATH:/home/stephen/.gem/ruby/2.2.0/bin:/home/stephen/bin
export EDITOR=emacs
export BROWSER=firefox
export PAGER=less
export PYTHONPATH=$PYTHONPATH:/home/stephen/repos/tcga:/home/stephen/repos/notifyme
export _JAVA_OPTIONS='-Dawn.useSystemAAFontSettings=setting'
export SSH_AUTH_SOCK="/home/stephen/ssh-agent.sock"
export SSH_ASKPASS=/usr/lib/ssh/x11-ssh-askpass

if [ ! -a "$SSH_AUTH_SOCK" ]; then
   ssh-agent -a "$SSH_AUTH_SOCK"
fi &> /dev/null

if not ssh-add -l; then
   ssh-add
fi &> /dev/null

