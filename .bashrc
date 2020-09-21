# ~/.bashrc - loaded for interactive bash sessions
# Stephen Brennan

#
# Determine OS for later configuration.
# http://stackoverflow.com/a/394247
#
OS='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
    OS='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    OS='mac'
    # mac has python3 installed
    PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
    export PATH
fi

#
# Alias definitions
#
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
alias xbox='sudo xboxdrv -d -s'
alias se=sudoedit
alias g=git
alias diff='diff --color=auto'
alias grep='grep --color=auto'
export LESS=-R
alias vim=nvim

#
# fzf: fzf is a wonderful tool for quickly finding filenames and command
#      history, and probably more too. Configure it when available.
#
fzfc=$GOPATH/src/github.com/junegunn/fzf/shell/completion.bash
[ -r $fzfc ] && . $fzfc
fzfk=$GOPATH/src/github.com/junegunn/fzf/shell/key-bindings.bash
[ -r $fzfk ] && . $fzfk
export FZF_COMPLETION_OPTS='--bind ctrl-k:kill-line'

#
# cnf: Command Not Found. Where present, this can hook into the "cammand not
#      found message and suggest a package you could install which contains it.
#
[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

#####
# BEGIN: PS1 Configuration
#
# It's difficult but the result looks nice and can help me focus, and show
# important information in an easily scannable location. Each section below
# (until END) deals with
#

#
# Git PS1
#

# Find the location of Git scripts.
GIT_SCRIPTS="$HOME"
if [[ "$OS" == 'linux' ]]; then
    GIT_SCRIPTS='/usr/share/git/completion'
elif [[ "$OS" == 'mac' ]]; then
    GIT_SCRIPTS='/Applications/Xcode.app/Contents/Developer/usr/share/git-core'
fi

# Configure variables for Git PS1
export GIT_PS1_SHOWDIRTYSTATE=0
export GIT_PS1_SHOWUNTRACKEDFILES=0
# Explicitly unset color (default anyhow). Use 1 to set it.
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_DESCRIBE_STYLE="branch"
#export GIT_PS1_SHOWUPSTREAM="auto git"

# Set _PS1_FOR_GIT when it is available, and enable completion similarly.
_PS1_FOR_GIT=''
if [ -r "$GIT_SCRIPTS/git-prompt.sh" ]; then
    source $GIT_SCRIPTS/git-prompt.sh
    source $GIT_SCRIPTS/git-completion.bash
    _PS1_FOR_GIT='$(__git_ps1 " (%s)")'
fi

#
# l PS1: when the "l" helper (a personal tool for building, configuring, and
#        running Linux kernel builds) is installed, display its status.
_PS1_FOR_LHELP=''
function __lhelper_ps1 {
    if [ ! -z "$LHELP_ENV" ]; then
        echo " [$LHELP_ENV]"
    fi
}
if hash l >/dev/null; then
	_PS1_FOR_LHELP="\$(__lhelper_ps1)"
fi

#
# Virtualenv: Since I'm configuring my PS1 with multiple lines, the default
#             virtualenv PS1 is wonky. Fix it up here.
#
function __virtualenv_ps1 {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		echo "(${VIRTUAL_ENV##*/}) "
	fi
}
_PS1_FOR_VENV="\$(__virtualenv_ps1)"
# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

#
# Color definitions, because I don't like trying to read them.
#
FG_RED="\[\033[0;31m\]"
FG_ORANGE="\[\033[1;31m\]"
FG_GREEN="\[\033[0;32m\]"
FG_YELLOW="\[\033[0;33m\]"
FG_BLUE="\[\033[0;34m\]"
FG_MAGENTA="\[\033[0;35m\]"
FG_PURPLE="\[\033[1;35m\]"
FG_CYAN="\[\033[0;36m\]"
# Background colors
BG_LIGHT="\[\033[40m\]"
BG_RED="\[\033[41m\]"
BG_GREEN="\[\033[42m\]"
BG_YELLOW="\[\033[43m\]"
BG_BLUE="\[\033[44m\]"
BG_MAGENTA="\[\033[45m\]"
BG_CYAN="\[\033[46m\]"
BG_WHITE="\[\033[47m\]"
# Reset
RESET="\[\033[0m\]"

#
# Set the final PS1
#

user="$FG_MAGENTA"
# Use a different color for hosts we SSH to
if [ -n "$SSH_CLIENT" ]; then
    host="$FG_ORANGE$BG_LIGHT"
else
    host="$FG_YELLOW"
fi
dir="$FG_GREEN"
export PS1="\n$FG_GREEN$_PS1_FOR_VENV$RESET$user\\u$RESET at $host\\h$RESET in $dir\\w$RESET$_PS1_FOR_LHELP$_PS1_FOR_GIT\n\$ "
#
# END: PS1 Configuration
#####
alias vim=nvim

#
# archey3: Finally, print out a nice pretty distro ascii art with assorted
#          system information.
#
hash archey3 >/dev/null && archey3
