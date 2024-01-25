# Dotfiles

This repository contains my dotfiles. I usually keep the repository in
`~/dotfiles`, but it doesn't really matter exactly where. The shell script
`setup` should do everything necessary to symlink dotfiles into place.  It will
not ask permission, so be careful.

![terminal preview](term.png)

Some highlights, in no particular order:

- Receiving email to a maildir via mbsync, notmuch, afew. Read the mail using
  emacs/notmuch, mutt, or alot. Or maybe aerc? Idk, whatever supports maildirs.
- Sending mail using msmtp, which makes it easy to use any "sendmail" compatible
  application, including git send-email forp atches.
- Light mode / dark mode switching which affects terminal apps and KDE apps.
- Copy/paste (mostly) works through vim, tmux, & ssh via the OSC 52.
- Sqlite bash history, command statistics, use fzf to select previous command.
- I still can't get over how good Magit is.

## How this repo works

The `setup` script (actually, `libsetup.sh`) contains an array called `LINKS`.
`LINKS` is an array of paths: the corresponding path within `$HOME` is linked to
the file within this repo. For example, if `.bashrc` is in the array, a symlink
will be created such that `~/.bashrc` points to the `.bashrc` in this repo. This
will work with paths that contain subdirectories as well.

This is great, unless you need to customize something about the dotfiles based
on the environment. For instance, some dotfiles need to be different on Mac vs
Linux. For this purpose, we also have `M4_LINKS`. M4 is a macro utility which is
POSIX standard, present on most Linux and Mac machines without any issues. In
this case, when `.bashrc` is in `M4_LINKS`, the script will first run M4 to
create `.bashrc` from `.bashrc.m4`, and then do the same symlinking as above.

## Notes on my environment

I've maintained these dotfiles for a fairly long time now, and they support some
very particular work environments.

- I work mainly in Arch Linux, using KDE Plasma as my desktop environment. I
  also use Oracle Linux 9 for work, with KDE Plasma there as well.

- I generally use the Alacritty terminal. But I am a huge fan of the drop-down
  terminal Yakuake as well.

- I use both Emacs and Vim, even if it sounds odd! Emacs is what I might
  consider my IDE: I use it to integrate with Language Servers (clangd,
  python-lsp-server, rust-analyzer, etc), and git. I use it when I want to work
  on a project. Vim is my quick terminal editor. I actually don't want it to be
  feature rich, beyond decent syntax highlighting. I use it to make quick edits
  to configuration files, or browse and explore things.

- I prefer to use solarized color schemes. The light is currently what I prefer,
  but at night it's nice to switch into dark mode.

- My SSH config contains some fairly useful shortcuts for me. There is also a
  `~/.ssh/local` configuration file, which can be used to store things outside
  version control, if they are especially private or unique to one machine (e.g.
  my work machine).

## Setup

### Required Prereqs

Without these this whole exercise would probably be pointless.

- `git` is pretty required
- `bash`, tested with >=3.2 on mac
- `m4`, which ought to be standard on unixy systems

### Optional Prereqs

You'll probably want at least some of these tools, because they are kinda why I
have my configuration version controlled.

- Email
  - `isync` for downloading email
  - `msmtp` for sending email
  - `python` with the `keyring` package installed, e.g. `python-keyring` package
  - git email packages may need to be installed if you intend to send patches
    out for review
- `emacs`, ideally the latest with native-comp and tree-sitter.

### Install

Simply clone this repo right into `~/.dotfiles`, and then run the symlink
script. Running the symlink script **will clobber** anything that preexisted,
and it **will not ask before doing so**. If you're looking to try out parts of
my dotfiles, be sure to selectively comment out things that you don't want
clobbered.

    $ git clone https://github.com/brenns10/dotfiles.git ~/.dotfiles
    $ cd ~/.dotfiles
    $ ./setup

### Post Install

Some things will want to be run for the first time in order to be fully
configured, or need a logout/login to take full effect.

- Configure email password as mentioned in optional prereqs
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
