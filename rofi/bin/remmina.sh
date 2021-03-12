#!/usr/bin/env bash

kb_start="Control-Return"

args=(
    -dmenu
)

while true; do
    server=$(grep '^name=' ~/.local/share/remmina/* | awk -F= '{print $2}' | rofi "${args[@]}" 'Select machine:')
    file=$(grep -l $server ~/.local/share/remmina/*)
    rofi_exit=$?
    if [[ $rofi_exit -eq 1 ]]; then
        exit
    fi

    case "${rofi_exit}" in
    0) # default
        remmina -c "$file"
        exit;
        ;;
    esac

done
