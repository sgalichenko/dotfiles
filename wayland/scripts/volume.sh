#!/bin/sh
# Volume keys and the bar's volume module: change the default sink, then show
# the level as a mako progress bar that replaces itself instead of stacking.
# Usage: volume.sh up|down|mute
set -eu

sink=@DEFAULT_AUDIO_SINK@
case ${1:-} in
	up)   wpctl set-mute "$sink" 0; wpctl set-volume -l 1.2 "$sink" 5%+ ;;
	down) wpctl set-volume "$sink" 5%- ;;
	mute) wpctl set-mute "$sink" toggle ;;
	*)    echo "usage: $0 up|down|mute" >&2; exit 2 ;;
esac

# "Volume: 0.45" or "Volume: 0.45 [MUTED]"
set -- $(wpctl get-volume "$sink")
pct=$(awk -v v="$2" 'BEGIN { printf "%d", v * 100 + 0.5 }')
bar=$pct
if [ "${3:-}" = "[MUTED]" ]; then
	icon=$(printf '\363\260\235\237') label="muted" bar=0  # nf-md-volume_off
elif [ "$pct" -lt 34 ]; then
	icon=$(printf '\363\260\225\277') label="$pct%"  # nf-md-volume_low
elif [ "$pct" -lt 67 ]; then
	icon=$(printf '\363\260\226\200') label="$pct%"  # nf-md-volume_medium
else
	icon=$(printf '\363\260\225\276') label="$pct%"  # nf-md-volume_high
fi

# Reuse the last notification's id so repeated presses update one popup
idfile=${XDG_RUNTIME_DIR:-/tmp}/volume-osd.id
id=$(cat "$idfile" 2>/dev/null || echo 0)
notify-send -e -p -r "$id" -c osd -h "int:value:$bar" "$icon  Volume  $label" > "$idfile"
