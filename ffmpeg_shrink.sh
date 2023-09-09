#!/usr/bin/env bash

if [[ ! -f "$1" ]];  then
    echo "Usage: $0 vide_file_name"
    exit 0
fi

FILESPEC="$(basename $1)"
OUTPUT_FILE="${FILESPEC%.*}"
OUTPUT_PATH="/tmp/$OUTPUT_FILE.x265.mkv"

echo $OUTPUT_FILE
echo $OUTPUT_PATH


ffmpeg -i "$1" -c:v libx265 -vtag hvc1 -c:a copy "$OUTPUT_PATH"
