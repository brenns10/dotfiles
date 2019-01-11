changequote(`<<<',`>>>')
<<<
#set message_cachedir=~/.cache/mutt/messages
set header_cache=~/.cache/mutt/headers
set editor="vim"
set my_name = "Stephen Brennan"
set sort=reverse-threads
set sort_aux=last-date-received
set edit_headers = yes
set charset = UTF-8
set use_from=yes
#set display_filter = ~/bin/muttdate

set folder=~/mail

>>>ifelse(OS,mac,<<<
set spoolfile=+yelp/INBOX
source ~/.mutt/account_yelp
>>>,<<<
set spoolfile=+stephen/INBOX
source ~/.mutt/account_stephen
>>>)<<<

folder-hook stephen/* source ~/.mutt/account_stephen
folder-hook yelp/* source ~/.mutt/account_yelp

# lists
lists kernelnewbies@kernelnewbies.org
lists multipathtcp@ietf.org
lists mptcp-dev@listes.uclouvain.be
lists mptcp@lists.01.org

# Useful customizations

# View first message on startup, always
push <first-entry>

# Use vim keys
source ~/.mutt/vim-keys.rc

# To compensate for lack of message browsing, use h and l to move among
# messages within the pager
bind pager h previous-undeleted
bind pager l next-undeleted

# To compensate for lack of "h" to see headers, use "H" for that
bind pager H display-toggle-weed
set pager_format="%4C %Z %[!%b %e at %I:%M %p]  %.20n  %s%* -- (%P)"

# Diff colors
color body cyan default "^(> ?)*diff \-.*"
color body cyan default "^(> ?)*index [a-f0-9].*"
color body cyan default "^(> ?)*\-\-\- .*"
color body cyan default "^(> ?)*[\+]{3} .*"
color body green default "^(> ?)*[\+][^\+]+.*"
color body red  default "^(> ?)*\-[^\-]+.*"
color body yellow default "^(> ?)*@@ .*"
>>>
