#!/bin/bash

# this is for converting a text file into each html page.
# take a file (pois.md in this dir) and put the target then points on alternating lines
# then the output goes into this same directory

# Input file name
input_file="target.md"
# Initialize variables
counter=1
# Read the pois.md file line by line
while IFS= read -r line1; do
    # Create a unique md file name for each pair of lines
    output_file="files/${counter}.md"
    # Start creating the md content
    echo "---" > "$output_file"
    echo "draft: false" >> "$output_file"
    echo "tags:" >> "$output_file"
    echo "- poi" >> "$output_file"
    echo "title: 'Target:'" >> "$output_file"
    echo "---" >> "$output_file"
    echo "## ${line1}" >> "$output_file"
    echo "[Back](/jetlag) " >> "$output_file"
    echo "made ${counter}"
    # Increment the counter
    ((counter++))
done < "$input_file"
# Output message
echo "md files have been generated."
