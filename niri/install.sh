#!/bin/sh
# Builds niri and xwayland-satellite and installs them next to GNOME and
# Hyprland, and makes niri the session GDM preselects for you. Run as
# yourself, not root: it builds with your cargo and asks sudo for the apt and
# install steps.
#
# 24.04 packages neither. niri's build dependencies are the ones its wiki lists
# for 24.04; libinput-dev, libxkbcommon-dev and libdisplay-info-dev come from
# the Hyprland PPA (wayland/install.sh pins those), matching the libraries
# hyprlock and the rest already put in place. Everything else the session uses
# (waybar, fuzzel, mako, hypridle, hyprlock, hyprpolkitagent, fcitx5) comes
# from wayland/install.sh, run with sudo first; this adds only what niri needs
# on top. Hyprland itself isn't needed.
#
# niri runs X11 apps through xwayland-satellite, which it starts on demand
# from $PATH. It goes in /usr/local/bin rather than ~/.cargo/bin so it's found
# however niri is started.
set -eu

[ "$(id -u)" != 0 ] || { echo "run as yourself, not root" >&2; exit 1; }

niri=v26.04
satellite=v0.8.3

sudo apt-get install -y --no-install-recommends \
	gcc clang libudev-dev libgbm-dev libxkbcommon-dev libegl1-mesa-dev \
	libwayland-dev libinput-dev libdbus-1-dev libsystemd-dev libseat-dev \
	libpipewire-0.3-dev libpango1.0-dev libdisplay-info-dev \
	libxcb1-dev libxcb-cursor-dev xwayland \
	xdg-desktop-portal-gnome gnome-keyring wlsunset

src=$(mktemp -d)
trap 'rm -rf "$src"' EXIT

# Ubuntu's .pc files, which Homebrew's pkg-config doesn't search
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}

git clone -q --depth 1 --branch "$niri" https://github.com/YaLTeR/niri.git "$src/niri"
cargo build --release --locked --manifest-path "$src/niri/Cargo.toml"

git clone -q --depth 1 --branch "$satellite" https://github.com/Supreeeme/xwayland-satellite.git "$src/satellite"
cargo build --release --locked --manifest-path "$src/satellite/Cargo.toml"

# Where the niri wiki's packaging table puts them, under /usr/local; GDM
# only reads sessions from /usr/share
r=$src/niri/resources
sudo install -Dm755 "$src/niri/target/release/niri" "$r/niri-session" -t /usr/local/bin
sudo install -Dm755 "$src/satellite/target/release/xwayland-satellite" -t /usr/local/bin
sudo install -Dm644 "$r/niri.service" "$r/niri-shutdown.target" -t /usr/local/lib/systemd/user
sudo install -Dm644 "$r/niri.desktop" -t /usr/share/wayland-sessions
# Portals come from ~/.config/xdg-desktop-portal/niri-portals.conf (the
# wayland package), so niri's own copy isn't installed

# GDM preselects the session AccountsService remembers for the user; picking
# another one at login replaces it until this runs again
busctl call org.freedesktop.Accounts "/org/freedesktop/Accounts/User$(id -u)" \
	org.freedesktop.Accounts.User SetSession s niri

niri --version
command -v xwayland-satellite
