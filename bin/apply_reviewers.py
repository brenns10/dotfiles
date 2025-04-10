#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to prepare a patch series for upstream submission.

Normally you can find the proper reviewers for a series
scripts/get_maintainer.pl. However, this has the problem that it will not
consider the other messages in the patch; especially the cover letter.

Ideally, everyone who receives one message from the series would be at least
CC'd on the other messages. This script gets all the maintainers and combines
them as such:

    The maintainer gets added to the To of each patch. The others (lists, etc)
    get added as Cc.

    The cover letter gets the combined To addresses from each patch.

    For the full series, we define a set of recipients. Then, for each patch,
    we add in missing recipients to the Cc.

For cover letters, adapt some of my git flow as well, by taking "Subject:" lines
from the branch description and putting them into the real subject. Also remove
the UEKBUILD stuff so that it doesn't leak out.

"""
import argparse
import email
import email.message
import pathlib
import re
import subprocess
import sys

from typing import Iterable
from typing import List
from typing import Set
from typing import Tuple


def run_checkpatch(
    tree: pathlib.Path,
    patches: List[pathlib.Path],
) -> None:
    """
    Run checkpatch.pl on the series, outputting any errors.
    """
    print("Running checkpatch...")
    proc = subprocess.run(
        ["scripts/checkpatch.pl", "--terse"] + [str(p) for p in patches],
        cwd=tree,
        check=False,
    )
    if proc.returncode:
        print("WARNING: see checkpatch errors above before submission")
    else:
        print("SUCCESS!")


def get_reviewers(
    tree: pathlib.Path,
    patch: pathlib.Path,
    to_list: List[str],
    cc_list: List[str],
) -> Tuple[Set[str], Set[str]]:
    """Return output of get_maintainer.pl organized as to/cc addresses."""
    # Cover letters don't have any reviewers, we need to determine later.
    if "0000-" in patch.name:
        return set(), set()
    proc = subprocess.run(
        ["scripts/get_maintainer.pl", str(patch)],
        cwd=tree,
        capture_output=True,
        check=True,
        encoding="utf-8",
    )
    with open(patch) as patch_file:
        message = email.message_from_file(patch_file)
    to_addrs = set(message.get_all("To", [])) | set(to_list)
    cc_addrs = set(message.get_all("Cc", [])) | set(cc_list)
    for line in proc.stdout.strip().split("\n"):
        line = line.strip()
        match = re.fullmatch(r"(.*?) \((.*)\)", line)
        assert match
        if "maintainer" in match.group(2) or "supporter" in match.group(2):
            to_addrs.add(match.group(1))
            print(f"MAINTAINER: {match.group(1)}")
        else:
            cc_addrs.add(match.group(1))
            print(f"          : {match.group(1)}")
    return to_addrs, cc_addrs


def set_header_all(
    message: email.message.Message,
    header: str,
    values: Iterable[str],
):
    """Set a list of values for header, overwriting previous"""
    del message[header]
    for value in values:
        message[header] = value


def process_cover_letter(patch: pathlib.Path) -> None:
    """
    Given a cover letter, do the following transforms:

    1. If the message body contains "Subject:" line, then use it in the patch
       description.
    2. Remove UEKBUILD lines.
    """
    with open(patch) as f:
        lines = list(f)
    blank = lines.index("\n")

    realsub = -1
    for i in range(blank):
        if lines[i].startswith("Subject:"):
            realsub = i

    sub = -1
    if lines[blank + 1].startswith("Subject:"):
        sub = blank + 1
    if sub == -1 or realsub == -1:
        print("  Could not find patch subject in cover letter")
    else:
        print("  Using subject from cover letter")
        lines[realsub] = lines[realsub].replace(
            "*** SUBJECT HERE ***", lines[sub][9:-1])
        del lines[sub]
        if lines[sub] == "\n":
            # generally there's a blank line after subject, delete it too
            del lines[sub]

    to_del = []
    for i in range(blank, len(lines)):
        if lines[i].startswith("UEKBUILD:"):
            to_del.append(i)
    if to_del:
        print("  Deleting {} UEKBUILD lines".format(len(to_del)))
        for i in reversed(to_del):
            del lines[i]
    with open(patch, "w") as f:
        f.write("".join(lines))


def apply_reviewers(
    tree_: str,
    patches_: List[str],
    to_list: List[str],
    cc_list: List[str],
) -> None:
    """Get all reviewers and apply them to each patch file."""
    tree = pathlib.Path(tree_).resolve()
    patches = [pathlib.Path(s).resolve() for s in sorted(patches_)]

    if patches and "0000-" in patches[0].name:
        cover_letter = patches[0]
        print(cover_letter.name)  # make me less nervous it was skipped
        process_cover_letter(cover_letter)
        patches = patches[1:]
    else:
        cover_letter = None

    all_reviewers: Set[str] = set()
    all_to: Set[str] = set()
    reviewer_data = []

    print("Step 1: Identifying maintainers and Ccs on each patch")
    for patch in patches:
        print(patch.name)
        to_addrs, cc_addrs = get_reviewers(tree, patch, to_list, cc_list)
        if not to_addrs:
            print(f"error: patch {patch.name} has no maintainer, using akpm...")
            to_addrs = {"Andrew Morton <akpm@linux-foundation.org>"}
        # print("  To: " + ", ".join(to_addrs))
        # print("  Cc: " + ", ".join(cc_addrs))
        all_reviewers |= to_addrs
        all_reviewers |= cc_addrs
        all_to |= to_addrs
        reviewer_data.append(to_addrs)

    if cover_letter:
        patches.insert(0, cover_letter)
        reviewer_data.insert(0, all_to)

    print("\nStep 2: Merging across all patches. Here are the real To/CC!")
    for patch, to_addrs in zip(patches, reviewer_data):
        print(patch.name)
        with open(patch) as patch_file:
            message = email.message_from_file(patch_file)
        set_header_all(message, "To", to_addrs)
        for to_addr in sorted(to_addrs):
            print(f"    To: {to_addr}")
        set_header_all(message, "Cc", all_reviewers - to_addrs)
        with open(patch, "w") as patch_file:
            patch_file.write(str(message))

    print("Shared Cc list:")
    for cc in all_reviewers:
        print(f"    Cc: {cc}")
    run_checkpatch(tree, patches)


def main():
    parser = argparse.ArgumentParser(description="Find and add reviewers to patch")
    parser.add_argument("tree", help="git tree for tools and history")
    parser.add_argument("patches", nargs="+", help="patch emails")
    parser.add_argument("--add-to", action="append", default=[],
                        help="additional To addrs for all patch")
    parser.add_argument("--add-cc", action="append", default=[],
                        help="additional Cc addrs for all patches")
    parser.add_argument("--no-cc-me", action="store_false", dest="cc_me",
                        help="Don't automatically Cc me")
    args = parser.parse_args()
    if args.cc_me:
        args.add_cc.append("Stephen Brennan <stephen.s.brennan@oracle.com>")
    apply_reviewers(args.tree, args.patches, args.add_to, args.add_cc)


if __name__ == '__main__':
    main()
