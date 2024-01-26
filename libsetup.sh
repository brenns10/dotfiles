#!/bin/bash
# Arrays and functions necessary for doing the setup symlinking.
# These live in a separate shell script so I can source them when I
# reload configs for dark / light mode.

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXT="$DIR/ext"
DST="$HOME"

LINKS=(
	.archey3.cfg
	.bash_profile
	.bashrc
	bin/autosuspend
	bin/bash-cdt.sh
	bin/bash-history-sqlite.sh
	bin/bash-preexec.sh
	bin/commandstats
	bin/dark
	bin/dbhist.py
	bin/dotfiles-add
	bin/extract-vmlinux
	bin/git-qref
	bin/git-when-merged
	bin/imap-pass
	bin/kconfig
	bin/light
	bin/monitor-internet
	bin/mutt-notmuch-py
	bin/myrpmbuild
	bin/newmirrors
	bin/paste
	bin/post-email-hook
	bin/sbrennan-setup
	bin/ssh-list-async
	bin/synchronize_namedqueries.py
	bin/syncmail
	bin/urlc
	bin/urls
	bin/viewchain
	bin/wait-for-internet
	bin/widevine-update
	bin/yank
	.config/aerc/accounts.conf
	.config/aerc/aerc.conf
	.config/aerc/binds.conf
	.config/afew/config
	.config/alacritty/solarized_dark.toml
	.config/alacritty/solarized_light.toml
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
	.doom.d/config.el
	.doom.d/custom.el
	.doom.d/init.el
	.doom.d/modules/custom/org-man
	.doom.d/modules/custom/org-notmuch
	.doom.d/packages.el
	.gitconfig.ext
	.hgrc
	.lc.json
	.mutt/account_stephen
	.mutt/mailcap
	.mutt/mutt-solarized-dark-16.muttrc
	.mutt/vim-keys.rc
	.notmuch-config
	.profile
	.ssh/authorized_keys
	.ssh/config
	.vim
	.vimrc
	.xprofile
) # END LINKS

M4_ONLY=(
	.vim/vimcolor.vim
)

M4_LINKS=(
	.alacritty.toml
	bin/lc
	.config/alot/config
	.gitconfig
	.msmtprc
	.mbsyncrc
	.mutt/muttrc
	.tmux.conf
)

# Place files which have been removed from my dotfiles here. If we encounter
# them, and they are actually links to the corresponding paths in $DIR (or
# $EXT), then we delete the link. We are careful not to delete any file which
# isn't the expected link, that would be bad.
DELETE=(
	.spacemacs
	.spacemacs.d/snippets
)

create_symlink() {
	src="$DIR/$1"
	ovr="$EXT/$1"
	dst="$DST/$1"

	rm -f "$dst"
	if [ -e "$ovr" ]; then
		src="$ovr"
		echo -e "*LINK\t$1"
	else
		echo -e "LINK\t$1"
	fi
	mkdir -p "$(dirname "$dst")"
	ln -s "$src" "$dst"
}

maybe_delete() {
	src="$DIR/$1"
	ovr="$EXT/$1"
	dst="$DST/$1"

	if ! [ -h "$dst" ]; then
		return
	fi
	tgt="$(readlink "$dst")"
	if [ "$tgt" = "$src" ] || [ "$tgt" = "$ovr" ]; then
		echo -e "CLEAN\t$1"
		rm "$dst"
	fi
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

THEMELOC=$DST/.config/stephen-colortheme
if ! [ -f "$THEMELOC" ]; then
	mkdir -p "$(dirname "$THEMELOC")"
	echo -n light >"$THEMELOC"
fi
THEME="$(cat "$THEMELOC")"

M4_CONTEXT+=( -DTHEME="$THEME" )
M4_CONTEXT+=( -DMY_EMAIL=stephen@brennan.io )

# Add Distro name to M4 Context
DISTRO=""
[ -f /etc/os-release ] && DISTRO=$(sh -c "source /etc/os-release && echo \$NAME")
M4_CONTEXT+=( -DDISTRO="$DISTRO" )

[ -f "$EXT/libsetup.sh" ] && source "$EXT/libsetup.sh"

do_m4() {
	src="$DIR/$1.m4"
	dst="$DIR/$1"
	ovr="$EXT/$1.m4"
	if [ -f "$ovr" ]; then
		src="$ovr"
		dst="$EXT/$1"
		echo -e "*M4\t$1"
	else
		echo -e "M4\t$1"
	fi
	m4 "${M4_CONTEXT[@]}" "$src" > "$dst"
}
create_m4_symlink() {
	do_m4 "$1"
	create_symlink "$1"
}
