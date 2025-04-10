# ~/.profile - this contains environment variable definitions for my session.
# Typically only sourced once, in a login shell. Environment variables for the
# desktop environment are set in ~/.config/environment.d/
#echo sourcing ~/.profile

export GOPATH=$HOME/go
export PATH=$HOME/bin:$GOPATH/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export ALTERNATE_EDITOR=""
export BROWSER=firefox
export PAGER=less
export LESS="-FRq --mouse"
