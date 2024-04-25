TMP1=$(mktemp)
grep -Po  '(?<=href=")[^"]*' "$1" | grep -i syd 

