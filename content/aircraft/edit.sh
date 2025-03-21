#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
  echo "Usage: ./edit.sh yyyymmdd-icao-registration-description"
  exit 1
fi

# Extract the date, hex, and description from the input argument
input=$1
IFS='-' read -r date hex title description <<< "$input"

# Get the current date if it's empty or invalid
year=$(date +"%Y")
month=$(date +"%m")
day=$(date +"%d")
actual_date=$year-$month-$day


# Prepare the formatted block of text
formatted_text="
# $actual_date

## $title

https://globe.adsbexchange.com/?icao=$hex | $description

![image](/folder/$date-$hex-$title.jpg)

---"
echo "$formatted_text"

# Make sure index.md exists before modifying
if [ ! -f "index.md" ]; then
  echo "index.md not found!"
  exit 1
fi

# Insert the formatted text at line 8 using a temporary file
awk -v formatted_text="$formatted_text" 'NR==8 {print formatted_text} {print}' index.md > temp.md && mv temp.md index.md

echo "Text added to index.md successfully."