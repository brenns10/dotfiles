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

source /usr/share/git/git-prompt.sh

## Print a notification when this file runs.
#zenity --warning --text="Running .bashrc"
#echo "Running .bashrc"

# Alias definitions
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias cls='clear'
alias x='xclip -selection c -i'
alias c='xclip -selection c -i -f'
alias v='xclip -selection c -o'
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias xbox='sudo xboxdrv -d -s'
alias se=sudoedit
alias mc='sudo -i -u minecraft screen -r'

# Bash prompt
export PURPLE="\[\033[0;35m\]"
export ORANGE="\[\033[0;33m\]"
export GREEN="\[\033[0;32m\]"
export CYAN="\[\033[0;36m\]"
export NO_COLOR="\[\033[0m\]"
PS1='$(__git_ps1 "(%s)")'
export PS1="
${PURPLE}\\u${NO_COLOR} at ${ORANGE}\\h${NO_COLOR} in ${GREEN}\\W${NO_COLOR} $PS1
\$ "
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
# Explicitly unset color (default anyhow). Use 1 to set it.
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWUPSTREAM="auto git"

# Command not found
[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

# Arch logo and info
archey3

# Random command of the day
echo "Your random command for the day:"
whatis $(ls /bin | shuf -n 1)

echo ""
