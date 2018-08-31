changequote(`<<<',`>>>')
<<<
# https://bloerg.net/2013/10/09/syncing-mails-with-mbsync-instead-of-offlineimap.html
IMAPAccount stephen
Host imap.zoho.com
User stephen@brennan.io
PassCmd "imap-pass -g stephen@brennan.io"
SSLType IMAPS
>>>CertificateFile ifelse(OS,mac,/usr/local/etc/openssl/cert.pem,/etc/ssl/certs/ca-certificates.crt)<<<

IMAPStore stephen-remote
Account stephen

MaildirStore stephen-local
Path ~/mail/
Inbox ~/mail/INBOX

Channel stephen
Master :stephen-remote:
Slave :stephen-local:
Patterns *
Create Both
Expunge None
SyncState *
>>>
