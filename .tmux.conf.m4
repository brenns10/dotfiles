# Stop using C-b and start using C-i
unbind C-b
set -g prefix C-j
bind C-j send-prefix

# Make sure set $TERM to advertise 256 colors support
# All terminals I use support it, so just set tmux-direct, but
# be sure to set the "terminal-features" properly anyway.
# Can't detect COLORTERM here
set -g default-terminal "tmux-256color"
set -as terminal-features ',*-direct:RGB'

# Environment variables to update at each connect:
# https://www.babushk.in/posts/renew-environment-tmux.html
# And see the .bashrc for tmux-refresh-env command.
set -g update-environment "SSH_AUTH_SOCK SSH_CONNECTION \
                           DISPLAY XDG_SESSION_ID"

# Tmux scroll copy mode!
set-option -g mouse on

# Move between panes easily
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# address vim mode switching delay (http://superuser.com/a/252717/65504)
set -s escape-time 0

# increase scrollback buffer size
set -g history-limit 50000

# tmux messages are displayed for 4 seconds
set -g display-time 4000

# refresh 'status-left' and 'status-right' more often
set -g status-interval 5

# emacs key bindings in tmux command prompt (prefix + :) are better than
# vi keys, even for vim users
set -g status-keys emacs

# Need vim keys for copy-mode
set-window-option -g mode-keys vi

# focus events enabled for terminals that support them
set -g focus-events on

# super useful when using "grouped sessions" and multi-monitor setup
setw -g aggressive-resize on

# source .tmux.conf as suggested in `man tmux`
bind R source-file '~/.tmux.conf'

# easier and faster switching between next/prev window
bind C-p previous-window
bind C-n next-window

## CLIPBOARD INTEGRATION
set -s set-clipboard external
set -as terminal-features ',alacritty*:clipboard'

source-file ~/.config/tmux/tmuxcolors-X_THEME_X.conf
