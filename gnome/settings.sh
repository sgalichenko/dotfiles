#!/bin/sh
# GNOME settings that dotter can't deploy as files. Idempotent: safe to rerun,
# and .dotter/post_deploy.sh runs it on every deploy with the gnome package.

command -v gsettings >/dev/null || exit 0

# Locate-pointer grabs Left Ctrl on X11 even while the feature is off. The
# grab sends the focused window a focus-out/focus-in, which tmux (focus-events
# on) takes as the key after the prefix, so Ctrl+A was cancelled at once.
gsettings set org.gnome.mutter locate-pointer-key ''
