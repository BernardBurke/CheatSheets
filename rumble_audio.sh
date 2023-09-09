if [[ "$1" == "" ]]; then
	echo "provide a rumble url"
	exit 1
fi

TMP1=$(mktemp) 
TMP2=$(mktemp)

yt-dlp --list-formats "$1" > $TMP1

#if grep -q mp4-480p $TMP1; then
#        FORMAT=mp4-480p
#elif grep -q mp4-360p-0 $TMP1; then
#	FORMAT=mp4-360p-0
#else
#	echo "formats available"
#	cat $TMP1
#	exit 1
#fi

read -p "Output Filename: " ANS

yt-dlp -S '+size,+br' -o $ANS.mp4 "$1" 

ffmpeg -i $ANS.mp4 -vn -acodec copy "$ANS.aac"
	
