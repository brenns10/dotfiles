# -*- mode: sh -*-
#-------------------------------------------------------------------------------
#
# File:         ~/.bashrc
#
# Author:       Stephen Brennan
#
# Date Created: Tuesday, 23 January 2016
#
# Description:  Run by bash for any login shell.
#
#-------------------------------------------------------------------------------

echo '~/.bash_profile'
# Load our profile.
[[ -r ~/.profile ]] && . ~/.profile

# When interactive, run bashrc.
[[ $- = *i* ]] && [[ -r ~/.bashrc ]] && . ~/.bashrc
