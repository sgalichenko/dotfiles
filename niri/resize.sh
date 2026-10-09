#!/bin/sh
# Super+Alt+Up/Down: move the divider between stacked windows the way the
# arrow points. niri's set-window-height only grows or shrinks the focused
# window, which moves the divider below it, except for the bottom window of a
# stack, whose divider is above it: there Up has to grow it, not shrink it.
# A floating window grows and shrinks at its bottom edge, as before. A window
# alone in its column fills it, so there's nothing to move.
# Usage: resize.sh up|down
set -eu

step=50
ipc() { socat -t1 - "UNIX-CONNECT:$NIRI_SOCKET"; }

# The focused window's row in its column and how many rows that column has;
# rows is 0 for a floating window
set -- "$1" $(echo '"Windows"' | ipc | jq -r '
	.Ok.Windows as $w | ($w | map(select(.is_focused))[0]) as $f
	| ($f.layout.pos_in_scrolling_layout // [0, 0]) as [$col, $row]
	| if $col == 0 then "0 0" else
		"\($row) \($w | map(select(.workspace_id == $f.workspace_id
			and .layout.pos_in_scrolling_layout[0] == $col)) | length)" end')
dir=$1 row=$2 rows=$3

[ "$rows" != 1 ] || exit 0

# Up shrinks a window whose divider is below it, and grows the bottom one
change=$step
[ "$dir" = up ] && change=-$step
[ "$rows" -gt 1 ] && [ "$row" -eq "$rows" ] && change=$((-change))

printf '{"Action":{"SetWindowHeight":{"id":null,"change":{"AdjustFixed":%s}}}}\n' "$change" | ipc >/dev/null
