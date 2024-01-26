jq -j ".$1" <~/.lc.json | m4_ifelse(X_OS_,mac,pbcopy,xclip -selection c -i)
