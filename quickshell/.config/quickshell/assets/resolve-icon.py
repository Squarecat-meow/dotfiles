#!/usr/bin/env python3
"""Resolve icon names to file paths using GTK icon theme."""
import sys
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

theme = Gtk.IconTheme.get_default()

for line in sys.stdin:
    name = line.strip()
    if not name:
        print("")
        continue
    # 원본 이름으로 시도
    info = theme.lookup_icon(name, 48, 0)
    if not info:
        # -symbolic 제거 후 재시도
        base = name.replace("-symbolic", "")
        info = theme.lookup_icon(base, 48, 0)
    print(info.get_filename() if info else "")
    sys.stdout.flush()
