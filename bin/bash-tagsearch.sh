# Defines the bash "tagsearch" extension. Allows you to pop open a search bar,
# search for tags, and open their definition in vim.
#
# Requires: fzf, vim, ccls, tagsearch_indexer (my special tool modifying ccls)
#
# Background:
#
# ccls is a language server for C/C++. I've found it to be the best for my
# purposes. It can index symbols and users of those symbols. However, being a
# language server, it can really only be used from inside an editor.  Further,
# searching for the definition of a symbol is not straightforward because the
# protocol requires you to lookup a definition by giving it a file location
# (e.g. "lookup the symbol on line 123, column 8 of file foo.c").  In the Linux
# kernel, I frequently want to lookup a symbol (or search them) but I don't know
# where it is used (let alone defined), so I can't use my editor to search for
# it.
#
# So, my system works like this:
# 1. Within the CCLS cache directory, place a ".index" file which is TSV,
#    containing the following columns:
#        shortname, qualname, filename, lineno, symbol_type
# 2. Use fzf to search through the index file, and launch vim for the selected
#    symbol definition.

if ! hash tagsearch_indexer >/dev/null 2>&1; then
	echo tagsearch: you have not installed the indexer, not sourcing config
	return 1
fi

# Configure where tags are indexed to (a global location rather than a local
# one). This should match up with settings in ~/.vimrc.
__tagsearch_ccls_base=~/ccls

# Utility function which searches for a compile_commands.json to find the root
# of a "project".
__tagsearch_find_project_root() {
	local dir="$1"
	while [ "$dir" != "/" ]; do
		if [ -f "$dir/compile_commands.json" ]; then
			__tagsearch_root="$dir"
			__tagsearch_cache="$__tagsearch_ccls_base/$(echo "$dir" | tr /: @)"
			__tagsearch_index="$__tagsearch_cache/.index"
			__tagsearch_rel=$(realpath --relative-to="$dir" "$1")
			return 0
		fi
		dir=$(realpath "$dir/..")
	done
	echo You are not in a project with a compile_commands.json
	return 1
}

# Search for a symbol with fzf, and then open its defining file in vim. This is
# a helper which will be used in user-facing commands.
__tagsearch() {
	__tagsearch_find_project_root "$PWD" || return 1
	if [ ! -d "$__tagsearch_cache" ]; then
		echo You do not have ccls indexing data.
		echo Either open vim and let ccls index, or \
			run ccls in standalone mode
		return 1
	fi
	if [ ! -f "$__tagsearch_index" ]; then
		echo You have not indexed symbols in this project
		return 1
	fi
	local entry=$(fzf -n1 --with-nth=1 \
			--preview-window=down:7:wrap \
			--preview="tagsearch-preview.sh {}" \
			<"$__tagsearch_index" | head -n 1)
	# Don't spawn vim if we got no file, just exit with error
	if [ -z "$entry" ]; then
		return 1
	fi
	local entry_arr
	IFS=$'\t' entry_arr=($entry)
	local relpath="$(realpath --relative-to="$PWD" "${entry_arr[2]}")"
	__tagsearch_cmd="vim \"$relpath\" +${entry_arr[3]}"
}

# Command "d" - run the search and then directly open vim.
d() {
	__tagsearch || return 1
	eval "$__tagsearch_cmd"
}

# Ctrl-] - run the search and paste the command into the command bar.
# I prefer this because I maintain a sqlite database of my command history, and
# if I just run the `d` command it's not that interesting. The Ctrl-] pastes
# the command into the buffer (and thus into history) making my command history
# more useful when I look back on it.
__tagsearch_ctrl_brkt() {
	__tagsearch || return 1
	# Plundered from fzf keybinding
	READLINE_LINE="$__tagsearch_cmd"
	if [ -z "$READLINE_POINT" ]; then
		echo "$READLINE_LINE"
	else
		READLINE_POINT=0x7fffffff
	fi
}
# Bind it.
bind -m emacs-standard -x '"\C-]": __tagsearch_ctrl_brkt'

# Run ccls in standalone to index the project!
dindex-ccls() {
	__tagsearch_find_project_root "$PWD" || return 1
	echo Running CCLS ...
	ccls \
		--index="$__tagsearch_root" \
		--log-file=/tmp/cc.log --log-file-append \
		--init "{\"cache\": {\"directory\": \"$__tagsearch_ccls_base\"}}"
}

# Index the ccls symbols for the project in the current directory.
dindex-symbols() {
	__tagsearch_find_project_root "$PWD" || return 1
	local tmp=$(mktemp -d)
	echo Indexing symbols in parallel into $tmp ...
	local procs=8
	trap "rm -r $tmp && echo Canceled && trap SIGINT && return 1" SIGINT
	find "$__tagsearch_cache" -name '*.blob' \
		| xargs --process-slot-var=PROCESS_ID -r -P $procs -L 255 \
		tagsearch_indexer "$tmp"
	echo Concatenating to final index $__tagsearch_index ...
	cat "$tmp"/* > "$__tagsearch_index"
	rm -r "$tmp"
	trap SIGINT
	echo Done!
	return 0
}

# Do full indexing
dindex() {
	dindex-ccls && dindex-symbols
}
