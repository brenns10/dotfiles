# -*- mode: sh -*-
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

# Determine OS for later configuration.
# http://stackoverflow.com/a/394247
OS='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
    OS='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    OS='mac'
fi

# Variables
export GOPATH=$HOME/go
if [ "$OS" = "mac" ]; then
    # put homebrew items before system but after local
    export PATH=/usr/local/sbin:$PATH
fi
export PATH=$HOME/bin:$GOPATH/bin:$HOME/.local/bin:$PATH
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export ALTERNATE_EDITOR=""
export BROWSER=google-chrome-stable
export PAGER=less
export _JAVA_OPTIONS='-Dawn.useSystemAAFontSettings=setting'
export SSH_ASKPASS=/usr/bin/ksshaskpass

# RBenv, if it exists
if [ -d "$HOME/.rbenv" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

if [ "$OS" != "mac" ]; then
    export SSH_AUTH_SOCK=$HOME/ssh-agent.sock
    # Start SSH agent if not running.
    ssh-add -l &> /dev/null
    RESULT=$?
    if [ "$RESULT" -eq 2 ]; then
        rm "$SSH_AUTH_SOCK"
        ssh-agent -a "$SSH_AUTH_SOCK"
    fi
fi

