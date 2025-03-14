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

get_uploader() {

	youtube_url="$1"

	# Get video info in JSON format
	video_info=$(yt-dlp -j "$youtube_url")

	# Extract and print uploader
	uploader=$(echo "$video_info" | jq -r '.uploader')

	uploader=$(echo "$uploader" | sed -e 's/[ &[:punct:]]/_/g' -e 's/[^[:alnum:]_]//g') 

	if [[ -z "$uploader" ]]; then
		echo ""	
	else
		echo "$uploader"
	fi
}


# Get uploader
uploader=$(get_uploader "$1")


# Get video info in JSON format
video_info=$(yt-dlp -j "$1")


filename_clean=$(echo "$video_info" | jq -r '.title' | sed -e 's/[^[:alnum:]]/_/g')
filename_clean=$(echo "$video_info" | jq -r '.title' | sed -e 's/[^[:alnum:]]/_/g')
video_filename="${YTsmall}/${filename_clean}.mp4"
filename_clean="${YTsmall}/${uploader}/${filename_clean}"

if [[ ! -d "${YTsmall}/${uploader}" ]]; then
	mkdir "${YTsmall}/${uploader}"
fi

echo $filename_clean

# Download the video
yt-dlp -S '+size,+br' -o "$video_filename" "$1"

# Probe audio codec
audio_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$video_filename")

# Determine audio extension
case "$audio_codec" in
  aac)  audio_ext="m4a" ;;
  opus) audio_ext="opus" ;;
  *)    audio_ext="aac" ;;  # Default to AAC if not recognized
esac

# Extract audio
ffmpeg -i "$video_filename" -vn -acodec copy "$filename_clean.$audio_ext"


echo "Extracted these $filename_clean.mp4 and $filename_clean.$audio_ext "

detox -v "$filename_clean.$audio_ext"

