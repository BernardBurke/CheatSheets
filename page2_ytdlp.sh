if [[ ! -f "$1" ]]; then
	echo "file in parameter 1 $1 does not exist"
	exit 1
fi

if [[ "$2" == "" ]]; then
	echo "Search string defaulting to video"
	SEARCH_STRING="video"
else
	SEARCH_STRING="$2"
fi
grep -Po  '(?<=href=")[^"]*' "$1" | grep -i "$SEARCH_STRING" | sort -Ru

