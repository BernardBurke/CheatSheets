IFS=$'\n'
for f in *; do
    #Skip directories
    [ -d "$f" ] && continue
    tags=($(id3v2 -l "$f" | sed -re 's/\s{2,}([^:])/\n\1/g' | egrep ':.+'))
    for l in ${tags[@]}; do
        [ -n "`echo $l | egrep '^Title'`" ] && TITLE="`echo $l | sed -re 's/^.*?: //'`"
        [ -n "`echo $l | egrep '^Artist'`" ] && ARTIST="`echo $l | sed -re 's/^.*?: //'`"
        [ -n "`echo $l | egrep '^Album'`" ] && ALBUM="`echo $l | sed -re 's/^.*?: //'`"
    done
    #mkdir -p "$ARTIST/$ALBUM"
    echo "$ARTIST/$ALBUM/$TITLE"
    #echo "$ARTIST/$ALBUM/$TITLE.$(echo $f | sed -re 's/.*\.([^.]*$)/\1/g')"
    #mv "$f" "$ARTIST/$ALBUM/$TITLE.$(echo $f | sed -re 's/.*\.([^.]*$)/\1/g')"
done
