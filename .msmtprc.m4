changequote(`<<<',`>>>')
<<<
defaults
auth on
tls on
>>>
tls_trust_file ifelse(OS,mac,/usr/local/etc/openssl/cert.pem,/etc/ssl/certs/ca-certificates.crt)
<<<
logfile ~/.msmtp.log

# stephen
account stephen
host smtp.zoho.com
port 587
from stephen@brennan.io
user stephen@brennan.io
passwordeval "imap-pass -g stephen@brennan.io"

# yelp
account yelp
host smtp.gmail.com
port 587
user sbrennan@yelp.com
from sbrennan@yelp.com
passwordeval "imap-pass -g sbrennan@yelp.com"

account default : stephen
>>>
