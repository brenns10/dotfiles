changequote(`<<<',`>>>')
<<<
defaults
auth on
tls on
>>>
tls_trust_file ifelse(DISTRO,Oracle Linux Server,/etc/ssl/certs/ca-bundle.crt,/etc/ssl/certs/ca-certificates.crt)
<<<
logfile ~/.msmtp.log

# stephen
account stephen
host smtp.zoho.com
port 587
from stephen@brennan.io
user stephen@brennan.io
passwordeval "imap-pass -g stephen@brennan.io"

account default : stephen
>>>
