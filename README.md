# Dotfiles

This repository contains my dotfiles. I usually keep the repository in
`~/.dotfiles`. The shell script `setup` should do everything necessary to
install the dotfiles on your machine (Mac and Linux both work). It will not ask
permission, so be careful.

![terminal preview](term.png)

Some neat features:
- Email accessible via CLI, offline or online. Can send patches for review on
  mailing list with git send-email.
- Universal copy/paste (assuming you use this tmux + bin/yank command across
  your various remote hosts)
- ssh agent, works with Mac keyring on whatever the update that added it was
- Configuration can be different for Mac or Linux (or maybe other environment
  constraints).

## How this repo works

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

## Notes on my environment

I've maintained these dotfiles for a fairly long time now, and they support some
very particular work environments.


- I work mainly in Arch Linux, using KDE Plasma as my desktop environment. I
  also use Mac OS (macOS? whatever they're styling it these days) for work, and
  many of these dotfiles apply on that machine.

- On Linux, I typically use Konsole, but I have slowly been adopting xterm for
  its ease of configuration (the Xresources files configure it), and for its
  support of OSC 52 escape sequences for remote copy/paste. Konsole requires
  some manual configuration for the themes I want.

- On Mac, I use iTerm2. This also supports OSC 52. There's some manual
  configuration necessary, and it's sad.

- My main editor is Vim. I also have a configuration for Emacs (+Spacemacs) with
  vim keybindings, but I rarely use it.

- I prefer to use solarized dark color schemes, unless I am in the sun, in which
  case I need a light color scheme. So I keep both available.

- Most of my email is routed into a central Google Inbox account. I like HTML
  based email and I use it plenty.

  However, one of my email accounts serves as a development, text-mode email
  account as well. I synchronize my email folders to my local machines via IMAP
  with `mbsync`, and I use `msmtp` as my standard `sendmail` utility. I can send
  emails via `get send-email`, and view and compose emails with `mutt`.

  I also have work email setup to be text-mode. I drew upon some of the
  following resources to build a config:

  https://pbrisbin.com/posts/two_accounts_in_mutt/
  https://lukespear.co.uk/mutt-multiple-accounts-mbsync-notmuch-gpg-and-sub-minute-updates/

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

- `archey3` for a pretty terminal splash screen on Arch Linux
- Email
  - `mutt` for email browsing
  - `isync` for downloading email
  - `msmtp` for sending email
  - `python` with the `keyring` package installed. Easy to setup with
    `pip install --user keyring`. Then run `imap-pass -s EMAIL` and paste the
    email password into it.
  - git email packages may need to be installed if you intend to send patches
    out for review
- If you use Ruby, `rbenv` is supported. You'll want to do:

        $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

- `emacs` + `spacemacs`

        $ git clone git@github.com:syl20bnr/spacemacs.git .emacs.d

- If you want to use mercurial, make sure you have `hg-git` installed.
- Similarly, Gnus is an Emacs-based mail client. I never use it, but I have it
  configured in `.spacemacs`. The passwords are stored in a 'standard'
  `.authinfo` file.

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

The only exception is Mac OS X. Although `profile` is run when you log in, the
Terminal app runs Bash as a login shell, meaning that `profile` will run a
second time. To avoid this, use iTerm2 :)
