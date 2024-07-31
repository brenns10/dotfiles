#!/bin/bash
set -e

THEMELOC=$HOME/.config/stephen-colortheme
echo -n dark >"$THEMELOC"

MYDIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$MYDIR/../../../libsetup.sh"

for item in "${M4_LINKS[@]}"
do
	create_m4_symlink "$item"
done

for item in "${M4_ONLY[@]}"
do
	do_m4 "$item"
done

# alacritty (auto reloads)
# alot (reload not supported)
# tmux (manually reload)
tmux source-file ~/.config/tmux/tmuxcolors-dark.conf || true

# vim & emacs (manually reload)
pkill -USR1 -u $USER nvim || true
pkill -USR1 -u $USER emacs || true
