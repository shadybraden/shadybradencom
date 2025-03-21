#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 4 ]; then
  echo "Usage: $0 <date> <hex> <registration> <description>"
  # ./edit.sh DATE HEX REGISTRATION "DESCRIPTION"
  exit 1
fi

# Get the arguments
date=$1
hex=$2
registration=$3
description=$4

# Create the title
title="${date}-${hex}-${registration}"

# Parse the date
part1="${date:0:4}"
part2="${date:4:2}"
part3="${date:6:2}"
actual_date="$part1-$part2-$part3"


# Generate the markdown content
content=$(cat <<EOF

# $actual_date

## $title

https://globe.adsbexchange.com/?icao=$hex | $description

![image](/aircraft/$title.jpg)

---
EOF
)

# Check if index.md exists and is writable
if [ ! -f index.md ]; then
  echo "Error: index.md does not exist."
  exit 1
fi

if [ ! -w index.md ]; then
  echo "Error: index.md is not writable."
  exit 1
fi

# Debug: Display the content to be inserted
echo "Content to be inserted:"
echo "$content"

# Check the number of lines in the index.md file
line_count=$(wc -l < index.md)
echo "Line count in index.md: $line_count"

# If there are fewer than 8 lines, append the content to the end of the file
if [ "$line_count" -lt 8 ]; then
  echo "File has less than 8 lines. Appending content to the end."
  echo "$content" >> index.md
else
  # Create a temporary file for the insertion content
  tmpfile=$(mktemp)

  # Insert content into the temporary file at line 8 and beyond
  head -n 7 index.md > "$tmpfile"
  echo "$content" >> "$tmpfile"
  tail -n +8 index.md >> "$tmpfile"

  # Replace the original file with the new content
  mv "$tmpfile" index.md

  echo "Content inserted at line 8."
fi

echo "Content insertion complete."
