changequote(<<<,>>>)undefine(format, include)
[push]
	default = simple
[user]
	email = MY_EMAIL
	name = Stephen Brennan
[core]
	autocrlf = input
	editor = nvim
	pager = delta
[interactive]
	diffFilter = delta --color-only
[delta]
	navigate = true
	light = true
[alias]
	st = status
	ci = commit
	cm = commit -m
	com = commit
	df = diff
	co = checkout
	cb = checkout -b
	desc = "describe --abbrev=0 --exclude='*bug*' --exclude='*#dev*' --exclude='*#rc*' --exclude='*[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9]*'"
	fastcherry = "-c merge.renameLimit=1 cherry-pick"
	lol = "log --oneline"
[color]
	ui = auto
[format]
	# Include git-notes(1) in patch text after the break (---)
	notes = true
	# Generate cover letter when there's more than one patch
	coverLetter = auto
	# Generate cover letter using the branch description
	coverFromDescription = message
[sendemail "upstream"]
	smtpserver = /usr/bin/msmtp
	tocmd ="`pwd`/scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nol"
	cccmd ="`pwd`/scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nom"
[sendemail]
	smtpserver = /usr/bin/msmtp
	# This can be specified multiple times.
	# body is supposed to be equivalent to (bodycc, sob, misc-by)
	# But I have had a lot of trouble with these.
	suppresscc = bodycc
	suppresscc = sob
	suppresscc = misc-by
	suppresscc = author
	suppresscc = body
[rebase]
	autosquash = true
[am]
	threeWay = true
# Notes allow me to annotate commits. Then, git format-patch --notes will
# transfer these notes to the portion of the commit after the "---". Thus, I can
# maintain notes to go into the final patch email. (this is the same as branch
# descriptions for --cover-from-description=message)
[notes]
	# For some reason you need to explicitly tell git that it should copy
	# the notes from the old ref to the new one.
	rewriteRef = "refs/notes/commits"
	# If there are somehow multiple notes, concat them all.
	rewriteMode = "concatenate"
# These default to true, but be sure anyway
[notes.rewrite]
	amend = true
	rebase = true
[merge]
	conflictstyle = diff3
[diff]
	colorMoved = default
[filter "lfs"]
	process = git-lfs filter-process
	required = true
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
[tar.bz2]
	command = bzip2
[include]
	path = ~/.gitconfig.ext
