#!/bin/sh
# rofi's combi mode in fuzzel (Ctrl+Space): open windows first, most recently
# focused on top, then apps. Picking a window focuses it, picking an app runs it.
set -eu

~/.config/wayland/menu launcher || exit 0

tab=$(printf '\t')
win=$(printf '\363\260\226\257')  # nf-md-window_maximize
app=$(printf '\363\260\200\273')  # nf-md-apps

# w:id <tab> label, the window you're in last (see wm)
windows=$(~/.config/wayland/wm windows | jq -r --arg icon "$win" '
	.[] | "w:\(.id)\t\($icon)  \(.workspace)  \(.app)  \(.title)"')

# desktop id <tab> label, user entries shadowing system ones of the same id
apps=$(
	for d in "${XDG_DATA_HOME:-$HOME/.local/share}" $(echo "${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" | tr : ' '); do
		[ -d "$d/applications" ] && find "$d/applications" -name '*.desktop' 2>/dev/null
	done | xargs -d '\n' awk -v icon="$app" '
		FNR == 1 {
			if (name != "" && !skip && !(id in seen)) { seen[id]; print id "\t" icon "  " name }
			id = FILENAME; sub(/.*\/applications\//, "", id); gsub(/\//, "-", id)
			name = ""; skip = 0; main = 0
		}
		/^\[/ { main = ($0 == "[Desktop Entry]") }
		main && /^Name=/ && name == "" { name = substr($0, 6) }
		main && /^(NoDisplay|Hidden)=true/ { skip = 1 }
		main && /^Type=/ && $0 != "Type=Application" { skip = 1 }
		END { if (name != "" && !skip && !(id in seen)) print id "\t" icon "  " name }
	' | sort -t "$tab" -k2 -f
)

list=$(printf '%s\n%s\n' "$windows" "$apps" | sed '/^$/d')
# --no-sort keeps matches in list order, so windows stay above apps when searching
i=$(printf '%s\n' "$list" | cut -f2- | fuzzel --dmenu --index --no-sort) || exit 0

row=$(printf '%s\n' "$list" | sed -n "$((i + 1))p")
key=${row%%"$tab"*}
case $key in
	w:*) ~/.config/wayland/wm focus "${key#w:}" ;;
	*)   ~/.config/wayland/wm spawn "gtk-launch ${key%.desktop}" ;;
esac
