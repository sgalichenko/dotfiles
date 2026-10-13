#!/bin/sh
# Sets up a fresh Ubuntu 24.04 desktop from this repo in one go: the tools,
# the dotfiles, and niri as the session GDM preselects. Hyprland is left out.
# Run as yourself from the clone; it asks for the sudo password once, up front,
# and needs nothing after that. Safe to run again.
#
#   sudo apt-get install -y git
#   git clone https://github.com/sgalichenko/dotfiles.git ~/dotfiles
#   ~/dotfiles/install.sh
#
# A .dotter/local.toml already there is kept; otherwise one is written with
# every package but hyprland and wezterm. Deploying uses --force, so files the
# dotfiles replace (Ubuntu's default ~/.zshrc, say) are overwritten.
set -eu

[ "$(id -u)" != 0 ] || { echo "run as yourself, not root" >&2; exit 1; }
cd "$(dirname "$0")"

# One password prompt, then keep sudo's timestamp fresh until this exits
sudo -v
while sudo -n true; do sleep 50; kill -0 $$ 2>/dev/null || exit; done 2>/dev/null &

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	build-essential curl git zip unzip zsh zsh-autosuggestions zsh-syntax-highlighting \
	rofi libreoffice

# Ghostty: Ubuntu doesn't package it; this is the .deb build its docs point to
command -v ghostty >/dev/null ||
	curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh | bash
# The default terminal: Ctrl+Alt+T and anything else that runs x-terminal-emulator
# (xdg-terminal-exec's choice is ghostty/xdg-terminals.list)
sudo update-alternatives --set x-terminal-emulator /usr/bin/ghostty

# Homebrew for the CLI tools, at the prefix .zprofile expects
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] ||
	NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install dotter tmux neovim yazi lazygit fzf ripgrep fd jq zoxide starship \
	eza bat git-delta hunk gum sevenzip
# sudo's secure_path lacks linuxbrew; this lets `sudo vi` (aliased to nvim) and sudoedit find it
sudo ln -sf /home/linuxbrew/.linuxbrew/bin/nvim /usr/local/bin/nvim

# gopass from its release .deb: Homebrew's would bring its own gnupg (and,
# through it, systemd), a second gpg-agent beside Ubuntu's; Ubuntu's gopass is 1.5
gopass=1.17.3
if ! gopass --version 2>/dev/null | grep -q "^gopass $gopass "; then
	deb=$(mktemp --suffix=.deb)
	curl -fsSL -o "$deb" "https://github.com/gopasspw/gopass/releases/download/v$gopass/gopass_${gopass}_linux_amd64.deb"
	sudo apt-get install -y "$deb"
	rm -f "$deb"
fi

# Rust through rustup, for niri, xwayland-satellite, Satty and bluetui, on the
# latest stable: their dependencies follow new rustc releases closely.
# .zprofile puts ~/.cargo/bin on PATH, so rustup leaves the shell files alone.
[ -x ~/.cargo/bin/rustup ] ||
	curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
PATH=$HOME/.cargo/bin:$PATH
rustup update stable
rustup default stable

command -v claude >/dev/null || [ -x ~/.local/bin/claude ] ||
	curl -fsSL https://claude.ai/install.sh | bash

# Firefox makes its profile on first start; start it headless once so there is one
profiles=~/snap/firefox/common/.mozilla/firefox
if command -v firefox >/dev/null && ! ls -d "$profiles"/*.default* >/dev/null 2>&1; then
	timeout 20 firefox --headless >/dev/null 2>&1 || true
fi
# The profile Firefox opens by default, from installs.ini
profile=$(sed -n 's/^Default=//p' "$profiles/installs.ini" 2>/dev/null | head -n1)
[ -n "$profile" ] || profile=$(cd "$profiles" 2>/dev/null && ls -d *.default* 2>/dev/null | head -n1)

if [ ! -f .dotter/local.toml ]; then
	packages='"zsh", "tmux", "ssh", "lazygit", "nvim", "rofi", "bin", "yazi", "ghostty", "gnome", "niri", "claude", "libreoffice"'
	[ -z "$profile" ] || packages="$packages, \"firefox\""
	{
		echo "# Packages enabled on this machine (written by install.sh)."
		echo "packages = [$packages]"
		if [ -n "$profile" ]; then
			echo
			echo "# The firefox package's targets: this machine's snap profile directory"
			echo "[files]"
			echo "\"firefox/userChrome.css\" = \"$profiles/$profile/chrome/userChrome.css\""
			echo "\"firefox/userContent.css\" = \"$profiles/$profile/chrome/userContent.css\""
		fi
	} > .dotter/local.toml
fi

# .zshrc sources it; it holds this machine's secrets, so it isn't tracked
touch ~/.env

dotter deploy --force

# The about:config switch userChrome.css needs
if [ -n "$profile" ] && ! grep -qs legacyUserProfileCustomizations "$profiles/$profile/user.js"; then
	echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$profiles/$profile/user.js"
fi

# The niri session: shared Wayland packages, then niri (also sets it as default)
sudo sh wayland/install.sh
niri/install.sh
wayland/satty/install.sh
command -v bluetui >/dev/null || cargo install --locked bluetui

ya pkg install

echo "Done. Log out and back in; GDM has niri preselected."
