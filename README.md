# Dotfiles

This repository contains my dotfiles. I usually keep the repository in
`~/.dotfiles`. The shell script `symlink.sh` should create all the necessary
symlinks. Should work on Mac and Linux equally well.

## Requirements

- `git` is pretty required
- `emacs` + `spacemacs`, since the editor is set to this

        $ git clone git@github.com:syl20bnr/spacemacs.git .emacs.d



## Optional

- If you want to use mercurial, make sure you have `hg-git` installed.
- If you use Arch, `archey3` is supported.
- If you use Ruby, `rbenv` is supported. You'll want to do:

        $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
