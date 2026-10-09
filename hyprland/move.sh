#!/bin/sh
# Super+Shift+arrows/HJKL: Hyprland refuses to movewindow a fullscreen or
# maximized window ("Can't move fullscreen window"). Such a window fills its
# monitor, so send it to the monitor in that direction instead; it stays
# maximized there. Other windows move as usual.
set -u

if hyprctl activewindow -j | grep -q '"fullscreen": [12]'; then
    hyprctl dispatch "hl.dsp.window.move({ monitor = \"$1\" })" >/dev/null
else
    hyprctl dispatch "hl.dsp.window.move({ direction = \"$1\" })" >/dev/null
fi
