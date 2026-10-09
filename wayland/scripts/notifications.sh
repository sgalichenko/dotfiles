#!/bin/sh
# Missed notifications (Super+N): mako's history, newest first, one line
# each, the unseen ones dotted. Picking one focuses the window that sent it,
# preferring one whose title has the summary in it (a Teams tab names the chat
# that way). With no such window it's shown again in full, in the replay
# category mako keeps out of its history, since long bodies get cut off here.
~/.config/wayland/menu notifications || exit 0
history=$(makoctl history | jq -c '.data[0]') || exit 0
[ "$(printf '%s' "$history" | jq length)" -gt 0 ] || {
	notify-send -a mako -c replay 'No missed notifications'
	exit 0
}

# A Nord yellow dot on the ones that timed out unseen (notify-watch.sh notes
# them) until they're picked here, green on the rest. fuzzel only colours
# icons, so the dots are SVGs in its icon column
missed=${XDG_RUNTIME_DIR:-/tmp}/notify-missed
[ -f "$missed" ] || : >"$missed"
sep=$(printf '\342\217\275')  # ⏽, U+23FD POWER ON SYMBOL
i=$(printf '%s' "$history" |
	jq -j --rawfile missed "$missed" --arg sep "$sep" --arg dots "$HOME/.config/fuzzel/dot-" '
		($missed | split("\n")) as $m | .[] |
		"\(.["app-name"].data) \($sep) \(.summary.data)  \(.body.data | gsub("\\s+"; " "))\u0000icon\u001f\($dots)\(if (.id.data | tostring) as $id | $m | any(. == $id) then "missed" else "read" end).svg\n"' |
	fuzzel --dmenu --index --config "$HOME/.config/fuzzel/notifications.ini" --prompt '󰂚  ') || exit 0
n=$(printf '%s' "$history" | jq -c --argjson i "$i" '.[$i]')
sed -i "/^$(printf '%s' "$n" | jq -r '.id.data')\$/d" "$missed"

if ! printf '%s' "$n" | ~/.config/wayland/notify-focus.sh; then
	printf '%s' "$n" | jq -r '.["app-name"].data, .summary.data, .body.data' | {
		IFS= read -r app
		IFS= read -r summary
		body=$(cat)
		notify-send -a "$app" -c replay "$summary" "$body"
	}
fi
