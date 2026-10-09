#!/bin/sh
# A left click on a notification (mako's on-button-left): its default action,
# as a plain click would run it, which for a web page in Firefox (Teams, say)
# switches to its tab, then the focus on the window that sent it. mako does
# hand the app an activation token to take the focus itself, but Firefox
# doesn't get it past niri, so this focuses it instead.
# Usage: notify-click.sh ID   (mako's $id)
id=$1
n=$(makoctl list | jq -c --argjson id "$id" '.data[0][] | select(.id.data == $id)')

# Not every notification has a default action; it's dismissed either way
makoctl invoke -n "$id" default 2>/dev/null
makoctl dismiss -n "$id" 2>/dev/null
[ -n "$n" ] || exit 0

# Give Firefox a moment to switch tabs, so the window's title is the tab's
sleep 0.2
printf '%s' "$n" | ~/.config/wayland/notify-focus.sh
