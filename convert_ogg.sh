#!/bin/bash

# A simple for loop to process all .ogg files in the current directory
for file in *.ogg; do
    # Check if the file exists to avoid errors if no .ogg files are found
    if [ -f "$file" ]; then
        # Get the filename without the extension
        filename=$(basename -- "$file" .ogg)

        # Use ffmpeg to convert the file to MP3 with LAME
        # The -ab flag sets the audio bitrate. 128k is a good balance of quality and size.
        # -acodec libmp3lame specifies the LAME encoder.
        ffmpeg -i "$file" -ab 128k -acodec libmp3lame "${filename}.mp3"
    fi
done

echo "Conversion complete."
