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

# Load our profile.
[[ -r ~/.profile ]] && . ~/.profile

# When interactive, run bashrc.
[[ $- = *i* ]] && [[ -r ~/.bashrc ]] && . ~/.bashrc
if [ hash aactivator ]; then
	eval "$(aactivator init)"
fi
