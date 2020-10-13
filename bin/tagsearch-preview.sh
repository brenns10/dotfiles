#!/bin/bash
# pv.sh: preview index data from ccls
# Creates a 7-row preview containing (a) qualified name, (b) file path, and
# (c) a preview of the file
IFS=$'\t' arr=($1)
name=${arr[0]}
bigname=${arr[1]}
filename=${arr[2]}
line=${arr[3]}
type_=${arr[4]}
relfilename=$(realpath --relative-to="$PWD" "$filename")
cat \
	 <(echo  "$bigname" | pygmentize -l c) \
	 <(echo $relfilename) \
	 <(sed -n "$(($line-2)),+4p" $filename | pygmentize -l c | nl -b a -v "$(($line-2))" )
