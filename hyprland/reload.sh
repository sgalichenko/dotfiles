#!/bin/sh
# Super+Shift+R: hyprctl reload only rereads hyprland.lua, and silently.
# Also restart the bar and idle daemon so their configs apply, then say so.
set -u

hyprctl reload >/dev/null
~/.config/wayland/wm bar
pkill -x hypridle; ~/.config/wayland/wm spawn hypridle
makoctl reload
errors=$(hyprctl configerrors)
case $errors in
''|*'no errors'*) notify-send -t 2000 Hyprland 'Config reloaded' ;;
*) notify-send -u critical 'Hyprland config errors' "$errors" ;;
esac
