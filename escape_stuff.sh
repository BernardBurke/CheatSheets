escape_stuff(){
	WITHOUT_BRACKETS="$(echo "$1" | sed "s/\[/\\\[/g" | sed "s/\]/\\\]/g")"
	echo "$WITHOUT_BRACKETS"
	#WITHOUT_SINGLE_QUOTES="$(echo "$WITHOUT_BRACKETS" | sed "s/\'/\\\'/g")" 
	#WITHOUT_RBRACKETS="$(echo "$WITHOUT_SINGLE_QUOTES" | sed "s/\(/\\\(/g" | sed "s/\)/\\\)/g")"
	#echo "$WITHOUT_SINGLE_QUOTES"
}

escape_stuff "$1"
#export ESCAPED_STUFF="$(escape_stuff "$1")"

