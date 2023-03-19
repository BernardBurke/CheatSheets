while IFS= read -d '' -r f; do 
	trackId="$(grep -Po '(?<=wasabisys.com).*?(?=track.m3u)' "$f" | head -n 1 | sed -e 's/\\//g' )"; 
	echo "yt-dlp -o ${f}.m4a https://erocast.s3.us-east-2.wasabisys.com${trackId}track.m3u8"
done < <(find . -type f -not -name '*.*' -print0)
