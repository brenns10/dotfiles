#! /usr/bin/python
# -*- coding: utf-8 -*-
#
# Author: Vegard Nossum <vegard.nossum@oracle.com>
#

import os
import sys
import re

pp_re = re.compile(r'^\s*#\s*(?P<directive>if|ifdef|ifndef|elif|else|endif)(?:\s+(?P<expr>.*))?\s*$')

all_colors = [
    '\033[37m',
    '\033[31m',
    '\033[32m',
    '\033[34m',
    '\033[35m',
    '\033[36m',
]

current_color = 0
def next_color():
    return (current_color + 1) % len(all_colors)

result = []
conditions = []
colors = [current_color]
for line in sys.stdin.read().splitlines():
    m = pp_re.match(line)
    if not m:
        result.append((conditions, colors, line))
        continue

    d = m.group('directive')
    e = m.group('expr')

    if d in ['if', 'ifdef', 'ifndef']:
        conditions = conditions + ['┓']
    elif d in ['elif', 'else']:
        conditions = conditions[:-1] + ['█']
    elif d in ['endif']:
        conditions = conditions[:-1] + ['┛']

    if d in ['if', 'ifdef', 'ifndef']:
        colors = colors + [(colors[-1] + 1) % len(all_colors)]

    result.append((conditions, colors, line))

    if d in ['if', 'ifdef', 'ifndef', 'elif', 'else']:
        conditions = conditions[:-1] + ['┃']
    elif d in ['endif']:
        conditions = conditions[:-1]

    if d in ['endif']:
        colors = colors[:-1]

w = 0
for conditions, colors, line in result:
    w = max(w, len(conditions))

for conditions, colors, line in result:
    print("%s%s %s%s" % (
        ''.join("%s%s" % (all_colors[color], condition) for condition, color in zip(conditions, colors[1:])),
        ' '  * (w - len(conditions)),
        all_colors[colors[-1]],
        line.replace('\t', ' ' * 8),
    ))
