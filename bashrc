# -*- mode: sh -*-
#-------------------------------------------------------------------------------
#
# File:         ~/.bashrc
#
# Author:       Stephen Brennan
#
# Date Created: Tuesday, 29 July 2014
#
# Description:  Run by bash for any interactive shell.
#
#-------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Determine OS for later configuration.
# http://stackoverflow.com/a/394247
OS='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
    OS='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    OS='mac'
fi

# Alias definitions
if [[ $OS == "mac" ]]; then
    # Mac versions of ls
    alias ls='ls -G'
    alias la='ls -Ga'
    alias ll='ls -Gl'
    alias lla='ls -Gla'
    # pbcopy versions of clipboard stuff
    alias c='pbcopy'
    alias v='pbpaste'
else
    # GNU coreutils ls
    alias ls='ls --color=auto'
    alias la='ls -a'
    alias ll='ls -l'
    alias lla='ls -la'
    # xclip versions of clipboard stuff
    alias c='xclip -selection c -i'
    alias v='xclip -selection c -o'
fi
alias cls='clear'
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias xbox='sudo xboxdrv -d -s'
alias se=sudoedit
alias mc='sudo -i -u minecraft screen -r'
alias g=git

# Where are the git scripts?
GIT_SCRIPTS="$HOME"
if [[ "$OS" == 'linux' ]]; then
    GIT_SCRIPTS='/usr/share/git/completion'
elif [[ "$OS" == 'mac' ]]; then
    GIT_SCRIPTS='/Applications/Xcode.app/Contents/Developer/usr/share/git-core'
fi

# Use __git_ps1 and git completion if they're available.
PS1=''
if [ -r "$GIT_SCRIPTS/git-prompt.sh" ]; then
    source $GIT_SCRIPTS/git-prompt.sh
    source $GIT_SCRIPTS/git-completion.bash
    PS1='$(__git_ps1 "(%s)")'
fi
export PURPLE="\[\033[0;35m\]"
export ORANGE="\[\033[0;33m\]"
export GREEN="\[\033[0;32m\]"
export CYAN="\[\033[0;36m\]"
export NO_COLOR="\[\033[0m\]"
export PS1="
${PURPLE}\\u${NO_COLOR} at ${ORANGE}\\h${NO_COLOR} in ${GREEN}\\w${NO_COLOR} $PS1
\$ "
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
# Explicitly unset color (default anyhow). Use 1 to set it.
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWUPSTREAM="auto git"

# Command not found, if it exists
[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

# Arch logo and info, if it exists
which archey3 >/dev/null && archey3

# RBenv, if it exists
if [ -d "$HOME/.rbenv" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi
