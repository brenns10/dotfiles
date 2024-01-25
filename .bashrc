# ~/.bashrc - loaded for interactive bash sessions

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias c='wl-copy'
alias v='wl-paste'
alias cls='clear'
alias g=git
alias vim=nvim
alias uctl='systemctl --user'
alias mailsync='bash -c "journalctl --user -u mbsync -f & systemctl --user start mbsync.service; kill %1"'
function cde() { mkdir -p "$1" && cd "$1"; }

export LESS=-R

# fzf: fzf is a wonderful tool for quickly finding filenames and command
#      history, and probably more too. Configure it when available.
fzfd="$GOPATH/src/github.com/junegunn/fzf/shell"
[ -d "$fzfd" ] || fzfd=/usr/share/fzf
export FZF_DEFAULT_OPTS='--bind ctrl-k:kill-line'
if [ -d "$fzfd" ]; then
  source "$fzfd/completion.bash"
  source "$fzfd/key-bindings.bash"
fi
# This is my own implementation of the fzf history command. Rather than relying
# on the builtin bash history, let's use the sqlite3 history database.
__fzf_history__() {
  local output
  output=$(
    python3 ~/bin/dbhist.py 'select command from command order by command_id desc' |
      FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output}
  if [ -z "$READLINE_POINT" ]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}

# Source command-not-found tools if available
[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

# Bash history with sqlite
HISTDB=$HOME/.bash_db_hist.sqlite
source ~/bin/bash-history-sqlite.sh

#####
# BEGIN: PS1 Configuration
# My PS1 is multiple lines, e.g.:
#
#   stephen at host in ~/repos/linux (master)
#   $
#
# For each element, set a _PS1_FOR_FOO, and then we combine them at the end.

# GIT
GIT_SCRIPTS='/usr/share/git/completion'
GIT_PS1_SHOWDIRTYSTATE=0
GIT_PS1_SHOWUNTRACKEDFILES=0
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_DESCRIBE_STYLE="branch"
_PS1_FOR_GIT=''
if [ -r "$GIT_SCRIPTS/git-prompt.sh" ]; then
    source $GIT_SCRIPTS/git-prompt.sh
    source $GIT_SCRIPTS/git-completion.bash
    _PS1_FOR_GIT='$(__git_ps1 " (%s)")'
fi

# l (my linux build helper script)
_PS1_FOR_LHELP=''
function __lhelper_ps1 {
    if [ ! -z "$LHELP_ENV" ]; then
        echo " [$LHELP_ENV]"
    fi
}
if hash l >/dev/null 2>&1; then
	_PS1_FOR_LHELP="\$(__lhelper_ps1)"
fi

# virtualenv: since the PS1 is multiple lines, we need to do it manually
VIRTUAL_ENV_DISABLE_PROMPT=1
function __virtualenv_ps1 {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		echo "(${VIRTUAL_ENV##*/}) "
	fi
}
_PS1_FOR_VENV="\$(__virtualenv_ps1)"

# Color variables for readability
FG_RED="\[\033[0;31m\]"
FG_ORANGE="\[\033[1;31m\]"
FG_GREEN="\[\033[0;32m\]"
FG_YELLOW="\[\033[0;33m\]"
FG_BLUE="\[\033[0;34m\]"
FG_MAGENTA="\[\033[0;35m\]"
FG_PURPLE="\[\033[1;35m\]"
FG_CYAN="\[\033[0;36m\]"
BG_LIGHT="\[\033[40m\]"
BG_RED="\[\033[41m\]"
BG_GREEN="\[\033[42m\]"
BG_YELLOW="\[\033[43m\]"
BG_BLUE="\[\033[44m\]"
BG_MAGENTA="\[\033[45m\]"
BG_CYAN="\[\033[46m\]"
BG_WHITE="\[\033[47m\]"
RESET="\[\033[0m\]"

# Set the PS1
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
