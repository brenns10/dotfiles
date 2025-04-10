# ~/.bash_profile - for login shells
#echo sourcing ~/.bash_profile

# Load our profile.
[[ -r ~/.profile ]] && . ~/.profile

# When interactive, run bashrc.
[[ -n "$PS1" ]] && [[ -r ~/.bashrc ]] && . ~/.bashrc
