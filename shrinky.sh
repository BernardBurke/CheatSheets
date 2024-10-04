#!/bin/bash

# Check if required arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <input_file> <start_time_in_seconds> <duration>"
    exit 1
fi

input_file="$1"
start_time="$2"
duration="$3"

# Handle filenames with spaces by quoting them
output_file="$(echo "$input_file" | sed 's/\.[^.]*$//' )_smaller.mp4"

# Extract the specified segment
# Use -ss with seconds directly
ffmpeg_cmd="ffmpeg -i \"$input_file\" -ss $start_time -t $duration -c copy \"$output_file.temp\""
echo $ffmpeg_cmd
eval $ffmpeg_cmd

# Optimize for social media sharing
ffmpeg_cmd="ffmpeg -i \"$output_file.temp\" \
-c:v libx264 -crf 23 -preset medium -b:v 2M \
-c:a aac -b:a 128k \
-vf \"scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2\" \
\"$output_file\""
eval $ffmpeg_cmd

# Clean up temporary file
rm "$output_file.temp"
