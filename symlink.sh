#!/bin/sh

# Create symlinks for config repository.
DIR=$(pwd)

link() {
    homename=$1
    file=$2
    rm -f $HOME/$homename
    ln -s $DIR/$file $HOME/$homename
}

mkdir -p ~/.spacemacs.d/
mkdir -p ~/.mutt
mkdir -p ~/bin

link .archey3.cfg archey3.cfg
link .bashrc bashrc
link .bash_profile bash_profile
link .hgrc hgrc
link .profile profile
link .xprofile profile
link .ssh/config ssh/config
link .ssh/authorized_keys ssh/authorized_keys
link .gitconfig gitconfig
link .spacemacs spacemacs
link .spacemacs.d/snippets snippets
link .vimrc vimrc
link .vim vim
link .tmux.conf tmux.conf
link .mutt/muttrc muttrc
link bin/viewchain bin/viewchain
link bin/monitor-internet bin/monitor-internet
link bin/yank bin/yank
link bin/sbrennan-setup bin/sbrennan-setup
