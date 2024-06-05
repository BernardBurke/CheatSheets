#!/bin/bash

if [[ "$1" == "" ]]; then
  echo "Usage: $0 <Rumble URL>"
  exit 1
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
ffmpeg -i "$filename_clean.mp4" -vn -acodec copy "$filename_clean.$audio_ext"

echo "Extracted these $filename_clean.mp4 and $filename_clean.$audio_ext "

