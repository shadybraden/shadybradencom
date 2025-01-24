#!/bin/bash

# this is for converting a text file into each html page.
# take a file (challenges.md in this dir) and put the challenge then points on alternating lines
# then the output goes into this same directory

# Input file name
input_file="challenges.md"
# Initialize variables
counter=1
# Read the challenges.md file line by line
while IFS= read -r line1 && IFS= read -r line2; do
    # Create a unique md file name for each pair of lines
    output_file="${counter}.md"
    # Start creating the md content
    echo "---" > "$output_file"
    echo "draft: false" >> "$output_file"
    echo "tags:" >> "$output_file"
    echo "- challenge" >> "$output_file"
    echo "title: ${line1}" >> "$output_file"
    echo "---" >> "$output_file"
    echo "${line2}" >> "$output_file"
    echo "" >> "$output_file"
    echo "[Back](https://shadybraden.com/jetlag) " >> "$output_file"
    # Increment the counter
    ((counter++))
done < "$input_file"
# Output message
echo "md files have been generated."
