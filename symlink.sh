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

link .archey3.cfg archey3.cfg
link .bashrc bashrc
link .hgrc hgrc
link .profile profile
link .xprofile profile
link .zprofile zprofile
link .ssh/config ssh/config
link .ssh/authorized_keys ssh/authorized_keys
link .zshrc zshrc
link .gitconfig gitconfig
link .spacemacs spacemacs
link .spacemacs.d/snippets snippets
