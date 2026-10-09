#!/bin/sh
# Input method for the bar, as waybar JSON: fcitx5 with US, Mozc and Russian.
# Usage: ime.sh            print status, again on each change (waybar runs it
#                          for good: fcitx5 announces nothing when Alt+Shift
#                          switches, so this asks it 5 times a second)
#        ime.sh toggle     cycle US → Mozc → Russian (a click on it)
set -eu

if [ "${1:-}" = toggle ]; then
	case $(fcitx5-remote -n 2>/dev/null) in
	keyboard-us) exec fcitx5-remote -s mozc ;;
	mozc) exec fcitx5-remote -s keyboard-ru ;;
	*) exec fcitx5-remote -s keyboard-us ;;
	esac
fi

hint='Alt+Shift or click for the next'
# EN and RU as text at 11pt (a touch over the bar's 14px), Japanese as the
# hiragana glyph at the icons' size; the two read as the same height
status() {
	case $(fcitx5-remote -n 2>/dev/null || true) in
	mozc) printf '{"text":"<span size=\"large\">󱌴</span>","class":"ja","tooltip":"Mozc (Japanese)\\n%s"}\n' "$hint" ;;
	keyboard-ru) printf '{"text":"<span size=\"11264\">RU</span>","class":"ru","tooltip":"Russian\\n%s"}\n' "$hint" ;;
	keyboard-us) printf '{"text":"<span size=\"11264\">EN</span>","class":"en","tooltip":"US\\n%s"}\n' "$hint" ;;
	*) printf '{"text":"<span size=\"11264\">EN</span>","class":"off","tooltip":"fcitx5 not running"}\n' ;;
	esac
}

# Printed on each change, and every 5 s regardless: writing to a waybar that
# has gone (restarted) ends this, where waiting for a change would leave it
# running for good
last= n=0
while :; do
	now=$(status)
	if [ "$now" != "$last" ] || [ $((n += 1)) -ge 25 ]; then
		printf '%s\n' "$now"
		last=$now n=0
	fi
	sleep 0.2
done
