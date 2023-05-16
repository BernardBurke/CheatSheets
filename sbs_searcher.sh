wget -q "https://www.sbs.com.au/api/video_feed/f/Bgtm9B/sbs-section-programs?form=json&q='love hate'&range=1-100" -O sbs.json 
jq '.entries[].displayTitles.double.title + "!" + .entries[].displayTitles.double.subtitle + "!" + .entries[].id' sbs.json | sort -u
