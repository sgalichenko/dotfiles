#!/bin/sh
# Focus the window that sent a notification, given as mako lists it (one entry
# of `makoctl list` or `makoctl history`) on stdin, preferring one whose title
# has the summary in it (a Teams tab names the chat that way). Fails when no
# window matches. Used by notifications.sh (Super+N) and notify-click.sh.
n=$(cat)

# Apps tag notifications with their desktop entry, which is also their window
# class or app id (firefox_firefox for the snap); app-name covers the ones that don't
id=$(~/.config/wayland/wm windows | jq -r --argjson n "$n" '
	($n["desktop-entry"].data | ascii_downcase) as $entry
	| ($n["app-name"].data | ascii_downcase) as $app
	| map(select((.app | ascii_downcase) as $c
		| ($entry != "" and $c == $entry) or ($app != "" and ($c | contains($app)))))
	# sort_by is stable, so ties keep the order from wm: most recent first, current last
	| sort_by(.title | contains($n.summary.data) | not)
	| .[0].id // empty')

[ -n "$id" ] && ~/.config/wayland/wm focus "$id"
