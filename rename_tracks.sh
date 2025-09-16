#!/bin/bash

# Check for the album name argument
if [[ -z "$1" ]]; then
    echo "Usage: $0 \"Album Name\""
    exit 1
fi

album_name="$1"

# === First Pass: Show the Changes ===

echo "This is a dry run. The following renames will be performed:"
echo "---------------------------------------------------------"

# Use a more forgiving regex that captures the track number at the end
# and is less strict about the preceding text.
# The () are for the capture groups. [0-9]+ for one or more digits.
# The .*? is a non-greedy match for anything between "Track" and the number.
# The \. is to match the literal period before the file extension.
regex="Track\ ([0-9]+)\.(.*)$"

find . -maxdepth 1 -type f -name "*.ogg" | while read -r file; do
    # Remove the './' prefix for cleaner matching
    filename=$(basename "$file")
    
    # Check if the filename matches the regex
    if [[ "$filename" =~ $regex ]]; then
        track_number="${BASH_REMATCH[1]}"
        file_extension="${BASH_REMATCH[2]}"
        
        # Format the new filename
        new_filename="${album_name}-Track${track_number}.${file_extension}"
        
        # Display the proposed change
        echo "   '${file}'  ->  '${new_filename}'"
    else
        echo "   '${file}' - does not match the expected pattern."
    fi
done

echo "---------------------------------------------------------"

# === Second Pass: Ask for Confirmation ===

read -p "Do you want to perform these renames? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Renaming files..."
    
    find . -maxdepth 1 -type f -name "*.ogg" | while read -r file; do
        filename=$(basename "$file")
        if [[ "$filename" =~ $regex ]]; then
            track_number="${BASH_REMATCH[1]}"
            file_extension="${BASH_REMATCH[2]}"
            
            new_filename="${album_name}-Track${track_number}.${file_extension}"
            
            # Use mv -v for verbose output during the rename
            mv -v "$file" "./$new_filename"
        fi
    done
    
    echo "Rename complete."
else
    echo "Rename cancelled."
    exit 0
fi
