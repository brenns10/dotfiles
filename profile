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

# Variables
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.rvm/bin:$PATH
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c"
export SUDO_EDITOR="emacsclient -t"
export ALTERNATE_EDITOR=""
export BROWSER=chromium
export PAGER=less
export _JAVA_OPTIONS='-Dawn.useSystemAAFontSettings=setting'
export SSH_AUTH_SOCK=$HOME/ssh-agent.sock
export SSH_ASKPASS=/usr/bin/ksshaskpass

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Start SSH agent if not running.
ssh-add -l &> /dev/null
RESULT=$?
if [ "$RESULT" -eq 2 ]; then
    rm "$SSH_AUTH_SOCK"
    ssh-agent -a "$SSH_AUTH_SOCK"
fi
