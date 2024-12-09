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
alias mailsync='bash -c "journalctl --user-unit mbsync -f & systemctl --user start mbsync.service; kill %1"'
function cde() { mkdir -p "$1" && cd "$1"; }
function tmuxenv() {
  eval "$(tmux show-env -s)"
}

export LESS=-R

# Try to source one of potentially many scripts
__cond_source() {
  for f in "$@"; do
    if [ -r "$f" ]; then
      source "$f"
      return 0
    fi
  done
}

# _simplecfg:
# I use the same .bashrc in small VMs and docker images that share my host
# filesystem. Frequently they are read-only and there is some extra penalty
# for accessing many files. Skip some of the more custom, exciting features
# of my config in those cases.
_hostname=$(hostname)
_simplecfg=false
if [[ "$_hostname" =~ ^DOCKER_.*$ ]] || [ "$_hostname" = "virtme-ng" ]; then
	_simplecfg=true
fi

# fzf: fzf is a wonderful tool for quickly finding filenames and command
#      history, and probably more too. Configure it when available.
export FZF_DEFAULT_OPTS='--bind ctrl-k:kill-line'
__cond_source "/usr/share/fzf/completion.bash" \
              "/etc/bash_completion.d/fzf" \
              "$GOPATH/src/github.com/junegunn/fzf/shell/completion.bash"
__cond_source "/usr/share/fzf/key-bindings.bash" \
              "/usr/share/fzf/shell/key-bindings.bash" \
              "$GOPATH/src/github.com/junegunn/fzf/shell/key-bindings.bash"
# This is my own implementation of the fzf history command. Rather than relying
# on the builtin bash history, let's use the sqlite3 history database.
__fzf_history_query__() {
  local output
  output=$(
    python3 ~/bin/dbhist.py "$1" |
      FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output}
  if [ -z "$READLINE_POINT" ]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}
__fzf_history__() {
    __fzf_history_query__ 'select command from command order by command_id desc'
}
__fzf_cwd_history__() {
    __fzf_history_query__ "select command from command where cwd = "\""$PWD"\"" order by command_id desc"
}
# C-x C-r - Like CTRL-R but with just commands from the current directory
bind -m emacs-standard -x '"\C-x\C-r": __fzf_cwd_history__'
bind -m vi-command -x '"\C-x\C-r": __fzf_cwd_history__'
bind -m vi-insert -x '"\C-x\C-r": __fzf_cwd_history__'

# Source command-not-found tools if available
if [ "$_simplecfg" = "false" ]; then
    [ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh
fi

# Bash history with sqlite
HISTDB=$HOME/.bash_db_hist.sqlite
[ "$_simplecfg" = "false" ] && source ~/bin/bash-history-sqlite.sh

# cdt = enter temporary directory
source ~/bin/bash-cdt.sh

# Source customizations in ~/.bashrc.ext
__cond_source ~/.bashrc.ext

#####
# BEGIN: PS1 Configuration
# My PS1 is multiple lines, e.g.:
#
#   stephen at host in ~/repos/linux (master)
#   $
#
# For each element, set a _PS1_FOR_FOO, and then we combine them at the end.

# GIT
if [ "$_simplecfg" = "false" ]; then
	__cond_source "/usr/share/git/completion/git-completion.sh" \
	              "/usr/share/bash-completion/completions/git"
	__cond_source "/usr/share/git/completion/git-prompt.sh" \
	              "/usr/share/git-core/contrib/completion/git-prompt.sh"
	_PS1_FOR_GIT='$(__git_ps1 " (%s)")'
	
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
fi

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
