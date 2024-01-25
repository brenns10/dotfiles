#!/bin/bash
# Arrays and functions necessary for doing the setup symlinking.
# These live in a separate shell script so I can source them when I
# reload configs for dark / light mode.

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

LINKS=(
	.archey3.cfg
	.bash_profile
	.bashrc
	bin/autosuspend
	bin/bash-history-sqlite.sh
	bin/bash-preexec.sh
	bin/bash-tagsearch.sh
	bin/commandstats
	bin/dark
	bin/dbhist.py
	bin/git-when-merged
	bin/imap-pass
	bin/light
	bin/monitor-internet
	bin/mutt-notmuch-py
	bin/newmirrors
	bin/paste
	bin/post-email-hook
	bin/sbrennan-setup
	bin/ssh-list-async
	bin/synchronize_namedqueries.py
	bin/syncmail
	bin/tagsearch-preview.sh
	bin/urlc
	bin/urls
	bin/viewchain
	bin/wait-for-internet
	bin/widevine-update
	bin/yank
	.config/alacritty/solarized_dark.toml
	.config/alacritty/solarized_light.toml
	.config/aerc/accounts.conf
	.config/aerc/aerc.conf
	.config/aerc/binds.conf
	.config/afew/config
	.config/alot/themes/solarized_dark
	.config/alot/themes/solarized_light
	.config/autostart/ssh-add.desktop
	.config/notmuchqueries.json
	.config/nvim/init.vim
	.config/plasma-workspace/env/askpass.sh
	.config/systemd/user/mbsync.service
	.config/systemd/user/mbsync.timer
	.config/tmux/tmuxcolors-dark.conf
	.config/tmux/tmuxcolors-light.conf
	.doom.d
	.gitconfig
	.hgrc
	.lc.json
	.mutt/account_stephen
	.mutt/mailcap
	.mutt/mutt-solarized-dark-16.muttrc
	.mutt/vim-keys.rc
	.profile
	.spacemacs
	.spacemacs.d/snippets
	.ssh/authorized_keys
	.ssh/config
	.vim
	.xprofile
)

M4_ONLY=(
	.vim/vimcolor.vim
)

M4_LINKS=(
	.alacritty.toml
	bin/lc
	.config/alot/config
	.msmtprc
	.mbsyncrc
	.mutt/muttrc
	.tmux.conf
)

create_symlink() {
	mkdir -p "$(dirname "$HOME/$1")"
	rm -f "$HOME/$1"
	echo -e "LINK\t$1"
	ln -s "$DIR/$1" "$HOME/$1"
}

M4_CONTEXT=()

# Add OS to M4 Context
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]] ; then
	M4_CONTEXT+=( -DOS=linux )
elif [[ "$unamestr" == 'Darwin' ]]; then
	M4_CONTEXT+=( -DOS=mac )
else
	M4_CONTEXT+=( -DOS=unknown )
fi

THEMELOC=$HOME/.config/stephen-colortheme
if ! [ -f "$THEMELOC" ]; then
	echo -n light >"$THEMELOC"
fi
THEME="$(cat "$THEMELOC")"

M4_CONTEXT+=( -DTHEME="$THEME" )

do_m4() {
	echo -e "M4\t$1"
	m4 "${M4_CONTEXT[@]}" "$DIR/$1.m4" > $DIR/$1
}
create_m4_symlink() {
	do_m4 "$1"
	create_symlink "$1"
}