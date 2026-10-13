#!/bin/sh
# Super+Shift+P: arrange the monitors by dragging them in wdisplays, then keep
# the result. niri drops changes made at runtime on its next start, so once
# wdisplays closes this writes the layout to ~/.config/niri/outputs.kdl, which
# config.kdl includes. That file is this machine's, not tracked.
# Usage: displays.sh [--save]   (--save skips wdisplays)
set -eu

[ "${1:-}" = --save ] || wdisplays

# Monitors by make, model and serial, so the layout follows a monitor to any
# port; the laptop panel, which has no serial, by its connector
niri msg -j outputs | jq -r '
	.[] | select(.logical) |
	(if .serial then "\(.make) \(.model) \(.serial)" else .name end) as $name |
	.logical as $l |
	"output \($name | tojson) {",
	"    scale \($l.scale)",
	"    position x=\($l.x) y=\($l.y)",
	(if $l.transform != "Normal" then
		"    transform \($l.transform | ascii_downcase | sub("^flipped"; "flipped-") | tojson)"
	else empty end),
	"}", ""
' > ~/.config/niri/outputs.kdl.new
mv ~/.config/niri/outputs.kdl.new ~/.config/niri/outputs.kdl
