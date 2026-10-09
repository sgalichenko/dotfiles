{{#if dotter.packages.gnome}}
sh gnome/settings.sh
{{/if}}
{{#if dotter.packages.wayland}}
# Ubuntu's packages enable these for every graphical session, where niri
# (unlike Hyprland) reaches graphical-session.target: a second waybar on the
# default config, a mako that loses to config.kdl's, a hyprsunset that only
# works on Hyprland, and a second hypridle whose lock races ours and leaves a
# stuck hyprlock that blocks every later lock. Both compositors start their own.
systemctl --user mask waybar.service mako.service hyprsunset.service hypridle.service >/dev/null 2>&1 || true
# Copied, not symlinked: fcitx5 rewrites these on exit, replacing a symlink
mkdir -p ~/.config/fcitx5/conf
cp wayland/fcitx5/profile wayland/fcitx5/config ~/.config/fcitx5/
cp wayland/fcitx5/conf/classicui.conf ~/.config/fcitx5/conf/
# Mozc: 9 suggestions while typing, not 3. Binary protobuf; edit with mozc_tool
# --mode=config_dialog, then copy ~/.config/mozc/config1.db back here
mkdir -p ~/.config/mozc
cp wayland/mozc/config1.db ~/.config/mozc/
# The session bus only rescans its service files when told; without this a
# new override (wayland/dbus/org.gnome.Settings.service) waits for the next login
gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus \
  --method org.freedesktop.DBus.ReloadConfig >/dev/null 2>&1 || true
{{/if}}
