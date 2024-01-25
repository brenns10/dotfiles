[push]
	default = simple
[user]
	email = MY_EMAIL
	name = Stephen Brennan
[core]
	autocrlf = input
	editor = nvim
[alias]
	st = status
	ci = commit
	cm = commit -m
	com = commit
	df = diff
	co = checkout
	cb = checkout -b
	desc = "describe --abbrev=0 --exclude='*bug*' --exclude='*#dev*' --exclude='*#rc*'"
[color]
	ui = auto
[sendemail]
	smtpserver = /usr/bin/msmtp
[rebase]
	autosquash = true
