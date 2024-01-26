#!/bin/bash
# Arrays and functions necessary for doing the setup symlinking.
# These live in a separate shell script so I can source them when I
# reload configs for dark / light mode.

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXT="$DIR/ext"
DST="$HOME"

LINKS=(
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
	bin/myrpmbuild
	bin/newmirrors
	bin/paste
	bin/post-email-hook
	bin/ssh-list-async
	bin/synchronize_namedqueries.py
	bin/syncmail
	bin/urlc
	bin/urls
	bin/viewchain
	bin/wait-for-internet
	bin/widevine-update
	bin/yank
	.config/afew/config
	.config/alacritty/solarized-dark.toml
	.config/alacritty/solarized-light.toml
	.config/alot/themes/solarized-dark
	.config/alot/themes/solarized-light
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
	.lc.json
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
	.notmuch-config
	.tmux.conf
)

# Place files which have been removed from my dotfiles here. If we encounter
# them, and they are actually links to the corresponding paths in $DIR (or
# $EXT), then we delete the link. We are careful not to delete any file which
# isn't the expected link, that would be bad.
DELETE=(
	.archey3.cfg
	bin/mutt-notmuch-py
	bin/sbrennan-setup
	.config/aerc/accounts.conf
	.config/aerc/aerc.conf
	.config/aerc/binds.conf
	.config/alacritty/solarized_dark.toml
	.config/alacritty/solarized_light.toml
	.config/alot/themes/solarized_dark
	.config/alot/themes/solarized_light
	.hgrc
	.mutt/account_stephen
	.mutt/mailcap
	.mutt/mutt-solarized-dark-16.muttrc
	.mutt/muttrc
	.mutt/vim-keys.rc
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
	M4_CONTEXT+=( -DR_OS_R=linux )
elif [[ "$unamestr" == 'Darwin' ]]; then
	M4_CONTEXT+=( -DX_OS_X=mac )
else
	M4_CONTEXT+=( -DX_OS_X=unknown )
fi

THEMELOC=$DST/.config/stephen-colortheme
if ! [ -f "$THEMELOC" ]; then
	mkdir -p "$(dirname "$THEMELOC")"
	echo -n light >"$THEMELOC"
fi
THEME="$(cat "$THEMELOC")"

M4_CONTEXT+=( -DX_THEME_X="$THEME" )
M4_CONTEXT+=( -DX_MY_EMAIL_X=stephen@brennan.io )

# Add Distro name to M4 Context
DISTRO=""
[ -f /etc/os-release ] && DISTRO=$(sh -c "source /etc/os-release && echo \$NAME")
M4_CONTEXT+=( -DX_DISTRO_X="$DISTRO" )

M4_CONTEXT+=( -DX_USER_X="$USER" )

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
	cat "$DIR/preamble.m4" "$src" | m4 -P "${M4_CONTEXT[@]}" > "$dst"
}
do_m4_diff() {
	pre="$DIR/$1.m4"
	post="$DIR/$1"
	if [ -f "$EXT/$1.m4" ]; then
		pre="$EXT/$1.m4"
		post="$EXT/$1"
	fi
	if cmp -s "$pre" "$post"; then
		echo "ERROR: IDENTICAL $pre AND $post"
		return
	fi
	echo diff -u "$pre" "$post"
	diff --color=auto -u "$pre" "$post"
}
create_m4_symlink() {
	do_m4 "$1"
	create_symlink "$1"
}
