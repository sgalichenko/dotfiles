#!/bin/bash

confirm() {
    echo -e "Yes\nNo" | rofi -dmenu -i -format d -selected-row 1 -p "${1:-Confirm: }"
}

hibernate="Hibernate"
suspend="Suspend"
reboot="Reboot"
shutdown="Shutdown"


content="$hibernate\n$suspend\n$reboot\n$shutdown"

selection=$(echo -e $content | rofi -dmenu -i -markup-rows -p "Action: ")
case $selection in
    $hibernate)
        [[ $(confirm) = 1 ]] && (systemctl hibernate -i) ;;
    $suspend)
        [[ $(confirm) = 1 ]] && (systemctl suspend -i) ;;
    $reboot)
        [[ $(confirm) = 1 ]] && (systemctl reboot -i) ;;
    $shutdown)
        [[ $(confirm) = 1 ]] && (systemctl poweroff -i) ;;
esac
