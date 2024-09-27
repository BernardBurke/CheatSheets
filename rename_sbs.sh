#!/bin/bash

for file in *.mp4 *.mkv *.avi; do
  if [[ $file =~ (.*)_(S)([0-9]+)_(Ep)([0-9]+)(\..*) ]]; then 
    new_name="${BASH_REMATCH[1]}$(printf "%02d" ${BASH_REMATCH[2]})_${BASH_REMATCH[3]}$(printf "%02d" ${BASH_REMATCH[4]})${BASH_REMATCH[5]}"
    mv -i "$file" "$new_name"
  fi
done

