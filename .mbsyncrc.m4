# https://bloerg.net/2013/10/09/syncing-mails-with-mbsync-instead-of-offlineimap.html
IMAPAccount stephen
Host imap.zoho.com
User stephen@brennan.io
PassCmd "~/bin/imap-pass -g stephen@brennan.io"
SSLType IMAPS
CertificateFile m4_ifelse(X_DISTRO_X,Oracle Linux Server,/etc/ssl/certs/ca-bundle.crt,/etc/ssl/certs/ca-certificates.crt)

IMAPStore stephen-remote
Account stephen

MaildirStore stephen-local
Path ~/mail/stephen/
Inbox ~/mail/stephen/INBOX

Channel stephen
Far :stephen-remote:
Near :stephen-local:
Patterns *
Create Both
Expunge Both
SyncState *
