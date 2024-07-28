# this is borrowing from rumble_audio.sh to find the smallest youtube video
#!/bin/bash

if [[ "$1" == "" ]]; then
  echo "Usage: $0 <Youtube URL>"
  exit 1
fi

if [[ ! -d $YTsmall ]]; then
    echo "No directory $YTsmall"
    exit 1
fi

export BHCU=$YTsmall
echo "BHCU: $BHCU"
# Get video info in JSON format
video_info=$(yt-dlp -j "$1")

# Extract title and clean it
filename_clean=$(echo "$video_info" | jq -r '.title' | tr -dc '[:alnum:]_. -')

# Download the video
yt-dlp -S '+size,+br' -o "$YTsmall/$filename_clean.mp4" "$1"

echo "Extracted $filename_clean.mp4 "

