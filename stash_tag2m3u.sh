#/!/bin/bash
# 
TMPFILE1=$(mktemp)
TEMPLATE=/home/ben/CheatSheets/stash_tag_template.sql 

cp -v $TEMPLATE $TMPFILE1

if [[ $1 == "" ]];  then
    TAG_STRING="Solid Gold"
else
    TAG_STRING="$1"
fi

sed -i -e  "s/Solid Gold/$TAG_STRING/g" "$TMPFILE1"

cat $TMPFILE1

export M3U_TAGGED=$HANDUNI/$$.m3u

sqlite3 < $TMPFILE1 > $M3U_TAGGED

mpv --screen=1 --playlist=$M3U_TAGGED --shuffle  
