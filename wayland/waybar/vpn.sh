#!/bin/sh
# VPN state for the bar, as waybar JSON. ~/bin/vpn asks swanctl, which needs
# root; strongSwan's routes in table 220 are readable by anyone and are there
# exactly while the tunnel is up.
# Usage: vpn.sh            print status
#        vpn.sh toggle     bring it up or down in a floating terminal
set -eu

routes=$(ip route show table 220 2>/dev/null)

if [ "${1:-}" = toggle ]; then
	if [ -n "$routes" ]; then cmd=down; else cmd=up; fi
	exec ~/bin/ghostty-popup --class=ghostty.floatingTerminal -e \
		zsh -lc "~/bin/vpn $cmd; printf '\nPress Enter to close'; read _"
fi

if [ -n "$routes" ]; then
	vip=$(printf '%s\n' "$routes" | sed -n 's/.* src \([0-9.]*\).*/\1/p' | head -1)
	nets=$(printf '%s\n' "$routes" | awk '{print $1}' | paste -sd ' ')
	printf '{"text":"<span size=\"large\">\363\260\246\235</span>","class":"up","tooltip":"VPN up  %s\\nrouting %s\\nclick to disconnect"}\n' "$vip" "$nets"
else
	printf '{"text":"<span size=\"large\">\363\260\246\236</span>","class":"down","tooltip":"VPN down\\nclick to connect"}\n'
fi
