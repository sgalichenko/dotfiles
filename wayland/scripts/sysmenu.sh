#!/bin/sh
# Power menu (Super+Escape, and the bar's power button).
~/.config/wayland/menu sysmenu || exit 0
choice=$(printf '%s\n' lock logout suspend reboot poweroff |
	fuzzel --dmenu --lines 5 --width 20) || exit 0

case $choice in
	lock)     loginctl lock-session ;;
	logout)   ~/.config/wayland/wm exit ;;
	suspend)  systemctl suspend ;;
	reboot)   systemctl reboot ;;
	poweroff) systemctl poweroff ;;
esac
