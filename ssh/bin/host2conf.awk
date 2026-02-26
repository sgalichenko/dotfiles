BEGIN {
  n     = 0
  width = 0
  found = 0
  file  = ""

  # Nord-flavored ANSI colors (can be overridden via -v on the command line)
  c_key   = "\033[1;38;5;151m"  # green-ish  – key names
  c_val   = "\033[1;38;5;73m"   # blue-ish   – values
  c_meta  = "\033[1;38;5;143m"  # yellow-ish – filename
  c_reset = "\033[0m"
}

# Stop parsing when the next Host or Match block starts (after target was found)
($1 == "Host" || $1 == "Match") && found {
  exit
}

# Start capturing when this Host line matches the target
$1 == "Host" && $0 ~ ("(^|[[:space:]])" HOST "([[:space:]]|$)") {
  found = 1
  file  = FILENAME
  next
}

# Collect settings for the matching Host block
found {
  key = $1

  # Remove the key using index() to avoid regex metacharacter issues
  val = substr($0, index($0, key) + length(key))

  # Trim leading whitespace from value
  gsub(/^[ \t]+/, "", val)

  keys[n]   = key
  values[n] = val
  n++

  # Track longest key for aligned output
  if (length(key) > width) width = length(key)
}

END {
  if (!found) {
    printf "Host '%s' not found.\n", HOST
    exit 1
  }

  printf " \n%s Defined in %s%s %s\n", c_key, c_reset, c_meta file c_reset, ""
  printf " \n"

  for (i = 0; i < n; i++)
    printf "%s %-" width "s %s %s %s\n", c_key, keys[i], c_reset, c_val values[i], c_reset
}
