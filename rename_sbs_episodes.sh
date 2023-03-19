read -p "Are you in the right direcory $PWD" -n 1 ANS
echo ""
if [[ $ANS != "y" ]]; then
	exit 1
fi

OUTFILE=/tmp/$$_rename.sh

for f in *.mp4; do 
	NEWNAME="$(echo $f | sed -e 's/Ep/E/g')"
	echo "mv -i \"${f}\" \"${NEWNAME}\"" >> $OUTFILE
done;

echo "Results in $OUTFILE"
