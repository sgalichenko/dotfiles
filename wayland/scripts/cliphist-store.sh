#!/bin/sh
# What wl-paste --watch runs for each copy under Hyprland and niri: saves it
# to cliphist's history (Super+V), unless `clip -s` marked it a secret just
# before copying. Ubuntu's cliphist (0.4) can't tell a secret by itself, and
# wl-copy can't offer the password-manager hint that newer ones look for.
# Usage: wl-paste --type text|image --watch cliphist-store.sh
mark=${XDG_RUNTIME_DIR:-/tmp}/clip-secret

# Only a copy with data in it: clearing the clipboard runs this too
[ "${CLIPBOARD_STATE:-data}" = data ] || exit 0

# Both watchers (text and image) see the copy, so the mark isn't removed
# when one of them reads it; it only counts for 2 s, long enough for the copy
# that set it to land and too short to catch a later one
if [ -e "$mark" ] && [ $(($(date +%s) - $(stat -c %Y "$mark"))) -le 2 ]; then
	cat >/dev/null
	exit 0
fi

exec cliphist store
