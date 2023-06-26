# create two temporary files
TMP1=$(mktemp) 
TMP2=$(mktemp)
# pull the json matching $1 - I've found the &q= to not be very reliable, so we grab 500 chunks here
wget -q "https://www.sbs.com.au/api/video_feed/f/Bgtm9B/sbs-section-programs?form=json&q=$1&range=1-500" -O $TMP1 
# use json query to match the id, title and subtitles
jq  -r '.entries[] | .displayTitles.double.title, .displayTitles.double.subtitle, .id' $TMP1    > $TMP2
# then loop through the results for title episode and the full link
while IFS= read title; read episode; read link
do 
	# only if the title string matches the passed parameter 1, build a yt-dlp call with the link in context
	if fgrep -qix -- "$title" <<< "$1"; then
		echo yt-dlp -o \"${title} ${episode}.mp4\" http://www.sbs.com.au/ondemand/video/${link##*/}
	fi
done<$TMP2

