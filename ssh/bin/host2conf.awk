BEGIN {
  n = 0
}

# Stop parsing after the next Host or Match block (if target was found)
($1 == "Host" || $1 == "Match") && found {
  exit
}

# Start capturing if this Host matches the target
$1 == "Host" && index($0, HOST) {
  found = 1
  next
}

# Collect settings for the matching Host
found {
  keys[n] = $1
  sub($1, "")       # Remove the key to isolate the value
  gsub(/^[ \t]+/, "")  # Trim leading spaces
  values[n++] = $0
  width = (length($1) > width) ? length($1) : width
  file = FILENAME
}

END {
  printf " \n\033[1;38;5;151m Defined in\033[0m\033[1;38;5;143m %s \033[0m\n", file
  printf " \n"
  for (i = 0; i < n; i++)
    printf "\033[1;38;5;151m %-" width "s \033[1;38;5;73m %s \033[0m\n", keys[i], values[i]
}
