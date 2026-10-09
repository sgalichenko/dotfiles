#!/bin/sh
# Brightness keys: step the laptop backlight 5%, then show the level as a mako
# progress bar like volume.sh's. Ubuntu's brightnessctl is built without
# logind and ships no udev rule, so it can't write the backlight as a user;
# logind's SetBrightness lets the active session do it without root.
# Usage: brightness.sh up|down
set -eu

dev=$(ls /sys/class/backlight | head -1)
[ -n "$dev" ] || exit 0
cur=$(cat "/sys/class/backlight/$dev/brightness")
max=$(cat "/sys/class/backlight/$dev/max_brightness")
step=$((max / 20))
case ${1:-} in
	up)   new=$((cur + step)) ;;
	down) new=$((cur - step)) ;;
	*)    echo "usage: $0 up|down" >&2; exit 2 ;;
esac
# Never all the way to 0: a black panel looks like a dead one
min=$((max / 100))
[ "$new" -gt "$max" ] && new=$max
[ "$new" -lt "$min" ] && new=$min

busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto \
	org.freedesktop.login1.Session SetBrightness ssu backlight "$dev" "$new"

pct=$(( (new * 100 + max / 2) / max ))
if [ "$pct" -lt 34 ]; then
	icon=$(printf '\363\260\203\236')  # nf-md-brightness_5
elif [ "$pct" -lt 67 ]; then
	icon=$(printf '\363\260\203\237')  # nf-md-brightness_6
else
	icon=$(printf '\363\260\203\240')  # nf-md-brightness_7
fi

# Reuse the last notification's id so repeated presses update one popup
idfile=${XDG_RUNTIME_DIR:-/tmp}/brightness-osd.id
id=$(cat "$idfile" 2>/dev/null || echo 0)
notify-send -e -p -r "$id" -c osd -h "int:value:$pct" "$icon  Brightness  $pct%" > "$idfile"
