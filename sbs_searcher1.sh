TMP1=$(mktemp) 
TMP2=$(mktemp)
wget -q "https://www.sbs.com.au/api/video_feed/f/Bgtm9B/sbs-section-programs?form=json&q=$1&range=1-500" -O $TMP1 
#jq '.entries[] | .displayTitles.double.title, .displayTitles.double.subtitle, .id'
jq  -r '.entries[] | .displayTitles.double.title, .displayTitles.double.subtitle, .id' $TMP1    > $TMP2
#sort -u $TMP2 > $TMP1
#cat $TMP2
while IFS= read title; read episode; read link
do 
	if fgrep -qix -- "$title" <<< "$1"; then
		echo yt-dlp -o \"${title} ${episode}.mp4\" http://www.sbs.com.au/ondemand/video/${link##*/}
	fi
	#echo "${episode}"
	#echo http://www.sbs.com.au/ondemand/video/${link##*/}
done<$TMP2

