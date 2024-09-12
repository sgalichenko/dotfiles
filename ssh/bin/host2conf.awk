# Search the input (and SSH config file) for a given HOST and print all the
# host's settings in a tabular form to standard output. The HOST must be
# provided as a global variable to the Awk process.

BEGIN {
	n = 0  # Explicitly initialise as a number instead of empty string
}

# Skip comments
#/^$/ || /^#/ {
#}

# A new host definition after we found our host terminates
($1 == "Host" || $1 == "Match") && did_find_host {
	exit
}

# Keep searching until we found our host
$1 == "Host" && $0 ~ HOST {
	did_find_host = 1
	next
}

# Accumulate all settings and their values for our host, ordered by their
# appearance in the input
did_find_host {
	keys[n] = $1
	width = max(length($1), width)  # Width of the widest key for padding
  $1="" # Clear the keys to get all left columns into values with $0
	values[n++] = $0
  file=FILENAME
}

END {
  printf " \n\033[1;38;5;143m %s \033[0m \n", file
  printf " \n"

	for (i = 0; i < n; ++i)
		printf "\033[1;38;5;151m %-"width"s \033[1;38;5;73m %s \033[0m \n", keys[i], values[i]
}

function max(a, b) {
	return a > b ? a : b
}
