#!/bin/sh
# Super+Shift+Up/Down: move the window within its column, and from the top or
# bottom of the column on to the monitor above or below, as Left/Right's
# move-column-*-or-to-monitor-* do sideways. niri has no such action for
# up and down.
# Usage: move.sh up|down
#
# One request to niri's socket with socat, as resize.sh does: this repeats
# while the keys are held, and `niri msg` takes ~11 ms a call to socat's 3.
set -eu

ipc() { socat -t1 - "UNIX-CONNECT:$NIRI_SOCKET"; }

# Whether the focused window is at the end of its column the way it's moving:
# the top for up, the bottom for down. A floating window (no column) just moves.
edge=$(echo '"Windows"' | ipc | jq -r --arg dir "$1" '
	.Ok.Windows as $w | ($w | map(select(.is_focused))[0]) as $f
	| ($f.layout.pos_in_scrolling_layout // null) as $pos
	| if $pos == null then false
	  elif $dir == "up" then $pos[1] == 1
	  else $pos[1] == ($w | map(select(.workspace_id == $f.workspace_id
		and .layout.pos_in_scrolling_layout[0] == $pos[0])) | length) end')

case $1 in up) dir=Up ;; *) dir=Down ;; esac
if [ "$edge" = true ]; then action=MoveWindowToMonitor$dir; else action=MoveWindow$dir; fi
printf '{"Action":{"%s":{}}}\n' "$action" | ipc >/dev/null
