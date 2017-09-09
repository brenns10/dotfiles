# Determine OS for later configuration.
# http://stackoverflow.com/a/394247
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
alias diff='diff --color=auto'
alias grep='grep --color=auto'
export LESS=-R

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
# Foreground colors
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
# And the actual declarations + PS1
user="$FG_MAGENTA"
if [ -n "$SSH_CLIENT" ]; then
    host="$FG_ORANGE$BG_LIGHT"
else
    host="$FG_YELLOW"
fi
dir="$FG_GREEN"
export PS1="\n$user\\u$RESET at $host\\h$RESET in $dir\\w$RESET $PS1\n\$ "
export GIT_PS1_SHOWDIRTYSTATE=0
export GIT_PS1_SHOWUNTRACKEDFILES=0
# Explicitly unset color (default anyhow). Use 1 to set it.
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_DESCRIBE_STYLE="branch"
#export GIT_PS1_SHOWUPSTREAM="auto git"

# fzf
fzfc=$GOPATH/src/github.com/junegunn/fzf/shell/completion.bash
[ -r $fzfc ] && . $fzfc
fzfk=$GOPATH/src/github.com/junegunn/fzf/shell/key-bindings.bash
[ -r $fzfk ] && . $fzfk
export FZF_COMPLETION_OPTS='--bind ctrl-k:kill-line'

# Command not found, if it exists
[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

# Arch logo and info, if it exists
which archey3 >/dev/null && archey3

# Work around weird double run issue, once without path
if hash sbrennan-setup 2>/dev/null; then
	sbrennan-setup --prompt
fi
