#!/usr/bin/env bash
#
# Pick a Remmina connection profile with rofi and open it.

set -uo pipefail

profile_dir="$HOME/.local/share/remmina"

# name=<label> lines map a display name back to the .remmina file holding it.
mapfile -t names < <(grep -h '^name=' "$profile_dir"/*.remmina 2>/dev/null | cut -d= -f2- | sort -u)

if [[ ${#names[@]} -eq 0 ]]; then
    rofi -e "No Remmina profiles found in $profile_dir"
    exit 1
fi

server=$(printf '%s\n' "${names[@]}" | rofi -dmenu -i -p 'Select machine')

# rofi exits non-zero when cancelled. Check it immediately: the original
# script read $? after a later grep, so it was testing the wrong command and
# cancelling the menu re-looped instead of exiting.
rofi_exit=$?
[[ $rofi_exit -ne 0 || -z $server ]] && exit 0

# -F matches the name literally and -x requires the whole line, so profile
# names containing regex characters or being a prefix of another still work.
file=$(grep -lFx "name=$server" "$profile_dir"/*.remmina 2>/dev/null | head -1)

if [[ -z $file ]]; then
    rofi -e "No profile file found for '$server'"
    exit 1
fi

exec remmina -c "$file"
