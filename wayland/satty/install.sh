#!/bin/sh
# Builds Satty into ~/.cargo/bin, patched to start on the S annotation size
# (it hardcodes M and has no setting for it). Run as yourself, not root.
# Not packaged for 24.04, and the release binary needs a newer glibc, so it's
# built; that needs libadwaita-1-dev and libgtk-4-dev (hyprland/install.sh).
set -eu

version=0.22.0
src=$(mktemp -d)
trap 'rm -rf "$src"' EXIT

curl -fsSL "https://static.crates.io/crates/satty/satty-$version.crate" | tar xz -C "$src" --strip-components=1

# The size toolbar's initial state, and Size's Default (used by the drawing style)
sed -i 's/new_stateful_with_target_value(&Size::Medium,/new_stateful_with_target_value(\&Size::Small,/' "$src/src/ui/toolbars.rs"
sed -i '/^pub enum Size {$/,/^}$/{/#\[default\]/d; s/^    Small = 0,$/    #[default]\n    Small = 0,/}' "$src/src/style.rs"
grep -q 'target_value(&Size::Small' "$src/src/ui/toolbars.rs"
grep -A1 '#\[default\]' "$src/src/style.rs" | grep -q 'Small = 0'

# Ubuntu's .pc files, which Homebrew's pkg-config doesn't search
PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH} \
	cargo install --locked --force --path "$src"
