changequote(`<<<',`>>>')<<<#!/bin/bash
jq -j ".$1" <~/.lc.json | >>>ifelse(OS,mac,<<<pbcopy>>>,<<<xclip -selection c -i>>>)
