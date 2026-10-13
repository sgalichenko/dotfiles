#!/bin/sh
# Installs what the Hyprland and niri sessions share on Ubuntu 24.04, next to
# GNOME: bar, launcher, notifications, lock, idle, polkit agent, input method,
# screenshots. Run with sudo. hyprland/install.sh runs this first, then adds
# Hyprland itself; niri/install.sh builds niri on top of it.
#
# 24.04 doesn't package Hyprland's tools, so they come from ppa:cppiber/hyprland.
# That PPA also ships newer pipewire, libinput, libxkbcommon, wayland-protocols
# and more, which GNOME uses too, so it's pinned to priority 1 (never chosen)
# except for the packages listed below. Of those, only libinput and
# libxkbcommon replace installed packages: Hyprland and its tools need
# libinput >= 1.30 and libxkbcommon >= 1.12.3, and niri builds against the
# same. Both keep their soname, so GNOME uses them as is.
#
# Satty (screenshot annotation) isn't packaged and its release binary needs a
# newer glibc than 24.04's, so it's built afterwards, as yourself, with
# wayland/satty/install.sh; libadwaita-1-dev is here for that build.
set -eu

[ "$(id -u)" = 0 ] || { echo "run with sudo" >&2; exit 1; }

add-apt-repository -y -n ppa:cppiber/hyprland

cat > /etc/apt/preferences.d/hyprland-ppa <<'PIN'
# Written by dotfiles/wayland/install.sh. Only these packages may come from the
# Hyprland PPA; everything else stays on Ubuntu's versions.
Package: *
Pin: release o=LP-PPA-cppiber-hyprland
Pin-Priority: 1

Package: hyprland hyprland-data hyprland-guiutils hyprlock hypridle hyprpolkitagent libhypr* libaquamarine* libxcb-errors* libudis86* libsdbus-c++* libdisplay-info* libinput* libxkbcommon* libxkbregistry* waybar libgtk-layer-shell* fuzzel hyprsunset
Pin: release o=LP-PPA-cppiber-hyprland
Pin-Priority: 990
PIN

apt-get update
apt-get install -y --no-install-recommends \
	hyprlock hypridle hyprpolkitagent \
	waybar fuzzel mako-notifier \
	grim slurp wl-clipboard brightnessctl playerctl xdg-desktop-portal-gtk \
	libadwaita-1-dev cliphist udiskie \
	gnome-calendar swayimg \
	fcitx5 fcitx5-mozc fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5
