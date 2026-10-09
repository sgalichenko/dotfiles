#!/bin/sh
# The clock's calendar popup. GNOME Calendar reopens at the size and
# maximized state it last closed with, overriding the compositor's popup
# rule, so both are reset to the popup's size first.
gsettings set org.gnome.calendar window-maximized false
gsettings set org.gnome.calendar window-size '(960, 640)'
# en_GB time conventions only for the calendar: weeks start on Monday.
# LC_ALL would override it, and .zshrc sets one if waybar is restarted from a shell
exec env -u LC_ALL LC_TIME=en_GB.UTF-8 gnome-calendar
