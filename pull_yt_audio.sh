#! /bin/bash
#
# Pull a video from youtube of rumble and extract the audio file
TEMPORARY_DIR=/tmp/
TEMPORARY_FILE="${TEMPORARY_DIR/$$}"

URL="$1"

if [[ "$URL" == *"youtube"*  ]]; then
    PULL_SYSTEM="yt-dlp"
else
    PULL_SYSTEM="pytube"
fi

if [[ ! -f "cookies.txt" ]]; then
    read -p "Proceed with no cookies(n)?" -n 1 ANS
    if [[ "$ANS"== ""]]; then
        exit 1
    else
        PULL_CMD="$PULL_SYSTEM --cookies cookies.txt"
    fi

    PULL_CMD="$PULL_SYSTEM --cookies cookies.txt"

fi



yt-dlp --cookies cookies.txt