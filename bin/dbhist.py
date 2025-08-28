#!/usr/bin/env python3
"""
Return null-terminated commands from history.
"""
import os
import sqlite3
import sys

HISTDB = os.path.expanduser('~/.bash_db_hist.sqlite')
conn = sqlite3.connect(HISTDB)
for row in conn.execute(sys.argv[1]):
    if len(row) > 1:
        print(f'{row[0]}\t{row[1]}\0', end='')
    else:
        print(f'{row[0]}\0', end='')
