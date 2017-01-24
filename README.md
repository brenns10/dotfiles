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

## Note on bashrc vs bash_profile

I use the file `profile` for everything that should happen to set up a login
session, and I ensure that it is run whenever I log in via desktop environment,
TTY, or SSH.

I use the file `bashrc` for everything that should happen to set up bash for a
shell session in which I will by typing commands manually.

When I run an interactive login shell (e.g. SSH or TTY login), this is run *in
addition* to the `profile`.

Some examples:
- Log into DE: `profile` is run (`.xprofile` is linked to it)
    - Then run interactive shell: `bashrc` is run. Settings from `profile` are
      inherited.
- Log in via TTY: `bash_profile` is run, which sources `profile` and then
  `bashrc`
- Log in via SSH: `bash_profile` is run, (similar to above)

The only exception is Mac OS X. Although `profile` is run when you log in, the
Terminal app runs Bash as a login shell, meaning that `profile` will run a
second time. To avoid this, use iTerm :)
