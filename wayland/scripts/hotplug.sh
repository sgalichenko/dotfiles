#!/bin/sh
# waybar stacks a fresh bar every time an output reconnects and never drops
# the old one. The HDMI monitor reconnects whenever it wakes from DPMS off, so
# each lock left one more bar. Restart waybar once a burst of adds settles.
# Hyprland reports added monitors on its event socket; niri's event stream
# has no output events, so there it's the kernel's DRM hotplug events instead.
set -u

if [ -n "${NIRI_SOCKET:-}" ]; then
	events() { udevadm monitor --udev --subsystem-match=drm; }
	added='UDEV*change*'
else
	events() { nc -U "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"; }
	added='monitoradded>>*'
fi

pending=
events | while read -r event; do
	case $event in
	$added)
		[ -n "$pending" ] && kill "$pending" 2>/dev/null
		{ sleep 2; ~/.config/wayland/wm bar; } &
		pending=$!
		;;
	esac
done
