#!/usr/bin/env python3
"""
Synchronize notmuch namedqueries (savedqueries? whatever)
"""
import argparse
import json
import typing as t
from pathlib import Path

from notmuch import Database


CONFIG = Path('~/.config/notmuchqueries.json').expanduser()


def import_to_notmuch():
    if not CONFIG.is_file():
        raise ValueError(f'Config {CONFIG} does not exist')
    with CONFIG.open() as f:
        cfg_queries: t.Mapping[str, str] = json.load(f)
    db = Database(mode=Database.MODE.READ_WRITE)
    existing_queries: t.Mapping[str, str] = {
        k.replace('query.', ''): v for k, v in db.get_configs('query.')
    }
    for name, query in cfg_queries.items():
        db.set_config('query.' + name, query)
    queries_to_remove = set(existing_queries.keys()) - set(cfg_queries.keys())
    for name in queries_to_remove:
        db.set_config('query.' + name, '')


def export_from_notmuch():
    if not CONFIG.parent.is_dir():
        CONFIG.parent.mkdir(parents=True, exist_ok=True)
    db = Database()
    queries: t.Mapping[str, str] = {
        k.replace('query.', ''): v for k, v in db.get_configs('query.')
    }
    with CONFIG.open('w') as f:
        json.dump(queries, f, indent=4, sort_keys=True)


def main(args: argparse.Namespace) -> None:
    action: str = args.action
    if action == 'import':
        import_to_notmuch()
    elif action == 'export':
        export_from_notmuch()
    else:
        assert False, 'cannot happen'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='synchronize notmuch queries')
    parser.add_argument(
        'action', choices=('import', 'export'),
        help='should we import into notmuch, or export to the config file?',
    )
    args = parser.parse_args()
    main(args)
