changequote(`<<<',`>>>')
<<<
theme = solarized_>>>THEME<<<
#handle_mouse = True
initial_command = "namedqueries"
prefer_plaintext = True

[accounts]
  [[stephen]]
    realname = Stephen Brennan
    address = stephen@brennan.io
    alias_regexp = stephen\+.+@brennan.io
    sendmail_command = msmtp -a stephen -t
    sent_box = maildir://~/mail/stephen/Sent
>>>
