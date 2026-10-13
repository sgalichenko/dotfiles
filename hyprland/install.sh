#!/bin/sh
# Installs Hyprland on Ubuntu 24.04 next to GNOME. Run with sudo. The packages
# it shares with niri, and the PPA both come from, are wayland/install.sh's,
# which this runs first.
#
# Left out: xdg-desktop-portal-hyprland, which needs pipewire >= 1.1.82 (24.04
# has 1.0.5). xdg-desktop-portal-wlr stands in for screen sharing (whole
# monitors only) and screenshots; file pickers and the other portals come
# from xdg-desktop-portal-gtk.
set -eu

[ "$(id -u)" = 0 ] || { echo "run with sudo" >&2; exit 1; }

sh "$(dirname "$0")/../wayland/install.sh"

apt-get install -y --no-install-recommends \
	hyprland hyprsunset xdg-desktop-portal-wlr
