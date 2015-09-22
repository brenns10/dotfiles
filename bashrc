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
alias xbox='sudo xboxdrv -d -s'
alias se=sudoedit

# Function definitions
bitb() {
    local P="$(hg paths 2>/dev/null | grep 'bitbucket.org' | head -1)"
    local URL="$(echo $P | sed -e's|.*\(bitbucket.org.*\)|http://\1|')"
    [[ -n $URL ]] && /usr/bin/chromium $URL || echo "No BitBucket path found!"
}

# Bash prompt
PS1='[\u@\h \W]\$ '

# Command not found
[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

# Arch logo and info
archey3

# Random command of the day
echo "Your random command for the day:"
whatis $(ls /bin | shuf -n 1)

echo ""
