#!/bin/sh
# The bar's network menu, dropped down under its icon in place of nm-applet's:
# wired connections, nearby Wi-Fi, the Wi-Fi switch and the connection editor.
# Picking an active connection takes it down; picking another brings it up,
# asking for the password of a Wi-Fi network not yet saved.
labels=$(mktemp) actions=$(mktemp)
trap 'rm -f "$labels" "$actions"' EXIT

item() {
	printf '%s\n' "$1" >>"$labels"
	printf '%s\n' "$2" >>"$actions"
}

# Saved wired connections, the active one ticked
nmcli -t -f NAME,TYPE,DEVICE connection show | while IFS=: read -r name type dev; do
	[ "$type" = 802-3-ethernet ] || continue
	if [ -n "$dev" ]; then
		item "󰈀  $name  " "down	$name"
	else
		item "󰈀  $name" "up	$name"
	fi
done

if [ "$(nmcli radio wifi)" = enabled ]; then
	# Strongest first, one line per SSID; the one in use ticked
	nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID device wifi list |
		sed 's/\\:/\x1f/g' | sort -t: -k1,1r -k2,2nr |
		while IFS=: read -r inuse signal security ssid; do
			ssid=$(printf '%s' "$ssid" | tr '\037' :)
			[ -n "$ssid" ] || continue
			grep -qxF "$ssid" "$actions.seen" 2>/dev/null && continue
			printf '%s\n' "$ssid" >>"$actions.seen"
			set -- 󰤯 󰤟 󰤢 󰤥 󰤨
			shift $((signal / 25))
			lock=; [ -n "$security" ] && lock=" 󰌾"
			if [ "$inuse" = '*' ]; then
				item "$1  $ssid$lock  " "down	$ssid"
			else
				item "$1  $ssid$lock" "wifi	$ssid	$security"
			fi
		done
	rm -f "$actions.seen"
	item "󰖪  Turn Wi-Fi off" "radio	off"
else
	item "󰖩  Turn Wi-Fi on" "radio	on"
fi
item "󰒓  Edit connections" "edit"

# Under the bar's right end, where the icon is
i=$(fuzzel --dmenu --index --anchor top-right --x-margin 8 --y-margin 4 \
	--width 36 --lines "$(wc -l <"$labels")" <"$labels") || exit 0

IFS='	' read -r action name security <<EOF
$(sed -n "$((i + 1))p" "$actions")
EOF

fail() { notify-send -a Network "$1" "$2"; exit 1; }

case $action in
up) nmcli connection up id "$name" >/dev/null 2>&1 || fail "Couldn't connect" "$name" ;;
down) nmcli connection down id "$name" >/dev/null 2>&1 || fail "Couldn't disconnect" "$name" ;;
radio) nmcli radio wifi "$name" ;;
edit) nm-connection-editor & ;;
wifi)
	# A saved network comes up with its stored password
	if nmcli -t -f NAME connection show | grep -qxF "$name"; then
		nmcli connection up id "$name" >/dev/null 2>&1 || fail "Couldn't connect" "$name"
	elif [ -n "$security" ]; then
		pass=$(fuzzel --dmenu --password --lines 0 --prompt "$name  " \
			--anchor top-right --x-margin 8 --y-margin 4 --width 36) || exit 0
		nmcli device wifi connect "$name" password "$pass" >/dev/null 2>&1 ||
			fail "Couldn't connect" "$name"
	else
		nmcli device wifi connect "$name" >/dev/null 2>&1 || fail "Couldn't connect" "$name"
	fi
	;;
esac
