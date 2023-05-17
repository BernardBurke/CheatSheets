TMP1=$(mktemp) 
TMP2=$(mktemp)
wget -q "https://www.sbs.com.au/api/video_feed/f/Bgtm9B/sbs-section-programs?form=json&q=$1&range=1-500" -O $TMP1 
jq '.entries[].displayTitles.double.title + "," +  .entries[].displayTitles.double.subtitle + "," +   .entries[].id' $TMP1 | grep -i "$1"   > $TMP2
sort -u $TMP2 > $TMP1
#exit
while IFS=, read  show episode link;
do 
	echo "# ${show} ${episode}"
	echo http://www.sbs.com.au/ondemand/video/${link##*/}
done<$TMP1

