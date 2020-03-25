changequote(`<<<',`>>>')
<<<
#set message_cachedir=~/.cache/mutt/messages
set header_cache=~/.cache/mutt/headers
set mailcap_path=~/.mutt/mailcap
set editor="vim"
set my_name = "Stephen Brennan"
set sort=reverse-threads
set sort_browser=reverse-date
set strict_threads=yes
set sort_aux=last-date-received
set edit_headers = yes
set charset = UTF-8
set use_from=yes
auto_view text/html
# auto collapse mail
folder-hook . "push _"
#set display_filter = ~/bin/muttdate

set folder=~/mail

# load both configs to get mailboxes
source ~/.mutt/account_stephen
source ~/.mutt/account_yelp

# but have the correct default
>>>ifelse(OS,mac,<<<
set spoolfile=+yelp/INBOX
source ~/.mutt/account_yelp
>>>,<<<
set spoolfile=+stephen/INBOX
source ~/.mutt/account_stephen
>>>)<<<

# switch sender and account details on folder change
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
# Use solarized colors
source ~/.mutt/mutt-solarized-dark-16.muttrc

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

# Use the sidebar!
# Unset for small terminal windows
set sidebar_width=30
set sidebar_visible=yes
set sidebar_sort_method=path
set sidebar_short_path = no
set sidebar_divider_char = ' '
color sidebar_divider default color0
color sidebar_new yellow default
bind index '[' sidebar-prev
bind index ']' sidebar-next
bind index '#' sidebar-open
bind pager '[' sidebar-prev
bind pager ']' sidebar-next
bind pager '#' sidebar-open

# Continue showing messages even when browsing message.
# Unset this for small terminal windows.
set pager_index_lines=20

# Status Bar -----------------------------------------
set status_chars  = " *%A"
set status_format = "───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───"

# Behavior
set timeout = 3          # idle time before scanning
set mail_check = 0       # minimum time between scans>>
unset mark_old           # read/new is good enough for me
set beep_new             # bell on new mails

bind index <tab>    sync-mailbox
bind index <space>  collapse-thread
bind index R group-reply
bind index r reply
bind pager R group-reply
bind pager r reply

bind index - collapse-thread
bind index _ collapse-all

set uncollapse_jump                        # don't collapse on an unread message
set date_format = "%a, %b %d %H:%M"
set index_format = "[%Z]  %D  %-20.20F  %s"

set pager_stop             # don't go to next message automatically
set menu_scroll            # scroll in menus
set tilde                  # show tildes like in vim
unset markers              # no ugly plus signs

macro index S "<enter-command>unset wait_key<enter><shell-escape>~/bin/mutt-notmuch-py ~/mail/temporary/search<enter><change-folder-readonly>+temporary/search<enter>" "search mail (using notmuch)"

macro index,pager ,f "<save-message>=yelp/Finished<enter>y"

mailboxes =temporary/search
>>>
