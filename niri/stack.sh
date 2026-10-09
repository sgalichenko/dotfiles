#!/bin/sh
# Super+Shift+Enter: a terminal stacked at the bottom of the focused window's
# column, in ~0.1 s.
# Usage: stack.sh COMMAND [ARG...]   (run in the new terminal)
#
# niri always opens a window as a new column to the right of the focused one;
# config.kdl opens ghostty.stacked windows without focus, so the view doesn't
# scroll there. This waits for the window, pulls it into the focused column,
# and only then focuses it, so it never shows up anywhere but in the stack.
#
# Fast because:
# - the window comes from the Ghostty config.kdl starts with niri (class
#   ghostty.stacked, no windows of its own), asked over D-Bus: ~60 ms to a
#   window, where a fresh ghostty takes ~350 and `ghostty +new-window` ~160.
#   busctl, not gdbus, which takes 35 ms longer to start. Ghostty making the
#   window is most of what's left: ~85 ms of the ~100 this takes.
# - it talks to niri's socket with socat (3 ms a request, `niri msg` 11) and
#   learns of the window from niri's event stream rather than polling.
set -eu

class=ghostty.stacked
ipc() { socat -t5 - "UNIX-CONNECT:$NIRI_SOCKET"; }

# Every window before, to tell the new one apart, and which one is focused
before=$(echo '"Windows"' | ipc)

# Watch for the new window: in the stream's opening list of windows if it
# opened before the stream started, else in the event for it. Prints
# "ID stack" if it sits right of the focused window's column, on its
# workspace, else "ID focus" (that window was floating, or nothing was).
fifo=${XDG_RUNTIME_DIR:-/tmp}/niri-stack.$$
mkfifo "$fifo"
trap 'rm -f "$fifo"' EXIT
# (socat complains of a broken pipe when jq stops reading after the first)
{ echo '"EventStream"'; sleep 5; } | ipc 2>/dev/null | jq -nr --argjson before "$before" '
	$before.Ok.Windows as $w | ($w | map(.id)) as $ids
	| ($w | map(select(.is_focused))[0].layout.pos_in_scrolling_layout // null) as $pos
	| ($w | map(select(.is_focused))[0].workspace_id // null) as $ws
	| first(inputs
		| if .WindowsChanged then .WindowsChanged.windows[]
		  elif .WindowOpenedOrChanged then .WindowOpenedOrChanged.window
		  else empty end
		| select(.id as $id | $ids | index($id) | not))
	| "\(.id) \(if $pos != null and .workspace_id == $ws
		and .layout.pos_in_scrolling_layout[0] == $pos[0] + 1 then "stack" else "focus" end)"
' >"$fifo" &

if ! busctl --user call -- "$class" /ghostty/stacked org.gtk.Actions Activate 'sava{sv}' \
	new-window-command 1 as $(($# + 2)) "--working-directory=$PWD" -e "$@" 0 >/dev/null 2>&1; then
	# That Ghostty isn't running (it quit or crashed): start it again with this
	# window. Slow this once, as it starts up.
	niri msg action spawn -- ghostty --class="$class" --gtk-single-instance=true \
		--quit-after-last-window-closed=false -e "$@" >/dev/null
fi

# Nothing within 5 s (the stream ends): leave the window wherever niri put it
read -r id how <"$fifo" || exit 0
case $how in
stack) printf '{"Action":{"ConsumeWindowIntoColumn":{}}}\n{"Action":{"FocusWindow":{"id":%s}}}\n' "$id" | ipc >/dev/null ;;
*) printf '{"Action":{"FocusWindow":{"id":%s}}}\n' "$id" | ipc >/dev/null ;;
esac
