# ~/.profile - sets session environment variables
# sourced by ~/.bash_profile and ~/.xprofile

# Variables
export GOPATH=$HOME/go
export PATH=$HOME/bin:$GOPATH/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export ALTERNATE_EDITOR=""
export BROWSER=firefox
export PAGER=less
export LESS="-FRq --mouse"
export SSH_AUTH_SOCK=$HOME/ssh-agent.sock

# Start SSH agent if not running.
ssh-add -l &> /dev/null
RESULT=$?
if [ "$RESULT" -eq 2 ]; then
    rm "$SSH_AUTH_SOCK"
    ssh-agent -a "$SSH_AUTH_SOCK"
fi
