#!/bin/sh
# Clipboard history (Super+V): pick an entry and it's copied again.
# Escaping copies nothing, rather than an empty clipboard.
~/.config/wayland/menu clipboard || exit 0
entry=$(cliphist list | fuzzel --dmenu --prompt '󱣺  ') || exit 0
printf '%s\n' "$entry" | cliphist decode | wl-copy
