#!/bin/sh
# Super+Shift+R: niri rereads config.kdl on save by itself, so this is for the
# rest: restart the bar and idle daemon so their configs apply, then say
# whether niri's config parses.
set -u

~/.config/wayland/wm bar
pkill -x hypridle; ~/.config/wayland/wm spawn hypridle
makoctl reload
if errors=$(niri validate 2>&1); then
	niri msg action load-config-file >/dev/null
	notify-send -t 2000 niri 'Config reloaded'
else
	notify-send -u critical 'niri config errors' "$errors"
fi
