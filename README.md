# Dotfiles

This repository contains my dotfiles. I usually keep the repository in
`~/.dotfiles`. The shell script `symlink.sh` should create all the necessary
symlinks. Should work on Mac and Linux equally well.

![terminal preview](term.png)

## How it works

`setup` contains an array called `LINKS`. This should contain paths within this
repository, which should map directly to files in the home directory. For
example, if `.bashrc` is in the array, a symlink will be created such that
`~/.bashrc` points to the `.bashrc` in this repo. This will work with paths that
contain subdirectories as well.

This is great, unless you need to customize something about the dotfiles based
on the environment. For instance, some dotfiles need to be different on Mac vs
Linux. For this purpose, we also have `M4_LINKS`. M4 is a macro utility which is
POSIX standard, present on most Linux and Mac machines without any issues. In
this case, when `.bashrc` is in `M4_LINKS`, the script will first run M4 to
create `.bashrc` from `.bashrc.m4`, and then do the same symlinking as above.

The M4 context contains `OS`, which may be `mac` or `linux`. It can easily be
extended by modifying the `setup` script.

## Environment

I've maintained these dotfiles for a fairly long time now, and they support some
very particular work environments.

### Operating System

I work mainly in Arch Linux, using KDE Plasma as my desktop environment. I also
use Mac OS (macOS? whatever they're styling it these days) for work, and many of
these dotfiles apply on that machine.

### Editing

I use Vim for quick editing - email, configuration files, small code files. I
use Emacs + Spacemacs for large projects where more functionality is required
(Latex + previewing, large codebases with tags + completion, etc).

### Languages

I regularly use C, Python, and Go. I also edit a fair amount of shell scripts
and the occasional JS + HTML + CSS combination.

Outside of programming, I heavily use LaTeX, Markdown, and restructured Text.

### Git

My git config has a few shortcuts, and the email/editor settings are most
important.

### Email

Most of my email is routed into a central Google Inbox account. I like HTML
based email and I use it plenty.

However, one of my email accounts serves as a development, text-mode email
account as well. I synchronize my email folders to my local machines via IMAP
with `mbsync`, and I use `msmtp` as my standard `sendmail` utility. I can send
emails via `get send-email`, and view and compose emails with `mutt`.

### SSH

I need to manage several personal computers from a distance, and a few
non-personal computers as well. Each computer I own has a separate ssh key, and
the authorized keys file enables communication between all of them.

## Setup

### Required Prereqs

Without these this whole exercise would probably be pointless.

- `git` is pretty required
- `bash` too

### Optional Prereqs

You'll probably want at least some of these tools, because they are kinda why I
have my configuration version controlled.

- If you use Arch, `archey3` is supported. Install it to get a nice startup
  screen on all your terminals.
- For email, mutt is the mail user agent. My email setup also depends on mbsync
  and msmtp. The password keychain script depends on python, and the `keyring`
  library (`pip install --user keyring`). To insert the password into the
  keyring, simply use:

        $ imap-pass -s EMAIL_ADDRESS

- If you use Ruby, `rbenv` is supported. You'll want to do:

        $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

- `emacs` + `spacemacs`

        $ git clone git@github.com:syl20bnr/spacemacs.git .emacs.d

- If you want to use mercurial, make sure you have `hg-git` installed.
- Similarly, Gnus is an Emacs-based mail client. I never use it, but I have it
  configured in `.spacemacs`. The passwords are stored in a standard `.authinfo`
  file.

### Install

Simply clone this repo right into `~/.dotfiles`, and then run the symlink
script. Running the symlink script **will clobber** anything that preexisted,
and it **will not ask before doing so**. If you're looking to try out parts of
my dotfiles, be sure to selectively comment out things that you don't want
clobbered.

    $ git clone https://github.com/brenns10/dotfiles.git ~/.dotfiles
    $ cd ~/.dotfiles
    $ ./symlink.sh

### Post Install

Some things will want to be run for the first time in order to be fully
configured, or need a logout/login to take full effect.

- Emacs will need to run in order to download and install a bunch of packages.
- The ssh-agent won't be running until you log out and back in.

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
