#!/bin/sh
# Records the notifications that timed out unseen, for the yellow dot in
# Super+N (notifications.sh): mako's history mixes them with the clicked and
# dismissed ones. NotificationClosed's reason is 1 for expired, 2 for
# dismissed (a click too), 3 when the app closed it itself.
missed=${XDG_RUNTIME_DIR:-/tmp}/notify-missed
: >"$missed"
busctl --user monitor --json=short \
	--match "type='signal',interface='org.freedesktop.Notifications',member='NotificationClosed'" |
	jq --unbuffered -r 'select(.payload.data[1] == 1) | .payload.data[0]' |
	# Reopened per id: the picker's sed -i swaps the file for a new one
	while read -r id; do echo "$id" >>"$missed"; done
