#!/bin/bash

if [[ "$1" == "" ]]; then
  echo "Usage: $0 <Rumble URL>"
  exit 1
fi

# if the $1 is a file, then read the file and download the videos
if [[ -f "$1" ]]; then
  while IFS= read -r line; do
    bash $0 "$line"
  done < "$1"
  exit 0
fi

# Get video info in JSON format
video_info=$(yt-dlp -j "$1")

# Extract title and clean it
filename_clean=$(echo "$video_info" | jq -r '.title' | tr -dc '[:alnum:]_. -')

# Download the video
yt-dlp -S '+size,+br' -o "$filename_clean.mp4" "$1"

# Probe audio codec
audio_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$filename_clean.mp4")

# Determine audio extension
case "$audio_codec" in
  aac)  audio_ext="m4a" ;;
  opus) audio_ext="opus" ;;
  *)    audio_ext="aac" ;;  # Default to AAC if not recognized
esac

# Extract audio
ffmpeg -i "$filename_clean.mp4" -vn -acodec copy "$Poddle/rumble/$filename_clean.$audio_ext"

detox -v "$Poddle/rumble/$filename_clean.$audio_ext"
# Move video to /tmp
mv "$Poddle/rumble/$filename_clean.mp4" /tmp -v

echo "Extracted these $filename_clean.mp4 and $filename_clean.$audio_ext and moved the video to /tmp"

