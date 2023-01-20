TMP=$(mktemp)
TMP1=$(mktemp)
wget -q "https://www.sbs.com.au/ondemand/tv-series/$1" -O $TMP
grep -Po  '(?<=href=")[^"]*' $TMP | grep -i "$1" | grep -i "season-" | grep "-ep"  > $TMP1
while read  episode; do
	episodeID="$(basename "$episode")"
	echo "https://www.sbs.com.au/ondemand/watch/$episodeID"
done < $TMP1

