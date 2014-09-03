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

export PATH=$PATH:/home/stephen/.gem/ruby/2.1.0/bin:/home/stephen/code
export EDITOR=emacs
export BROWSER=chromium
export PAGER=less
export XCURSOR_THEME=whiteglass
export PYTHONPATH=$PYTHONPATH:/home/stephen/repos/tcga

# Add my SSH key to the keychain
eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

# Run my .bashrc only if this is an interactive login shell.  Do not run it when
# this is a graphical login.
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac
