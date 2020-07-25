#!/bin/bash
end=${1:-aac}
station=${2:-radio_three}

#bbc_6music
#bbc_1xtra
#bbc_radio_fourfm
#bbc_radio_one
#bbc_radio_two
#bbc_radio_three

time=${4:-90}
Day=${3:-Mon}

time=$((time*60))

~/sound/musicproc.sh
#cp ~/sound/streams.txt ~/Music/playlists/stations.m3u
rm ~/Music/prog$Day*.$end
cat ~/Music/playlists/stations.m3u

j=0
for i in `sed -n "/$station/p" ~/Music/playlists/*.m3u`
do
j=$((j+1))
echo ffmpeg -i $i -t $time - ab 320k ~/Music/prog$Day$j.$end
ffmpeg -i $i   -t $time -ab 320k ~/Music/prog$Day$j.$end
if [ $j -eq 1 ]
then
	break
fi
done

if [ -f ~/Music/keep/prog$Day$j.mp3 ]
then
        mv ~/Music/keep/prog$Day$j.mp3 ~/Music
fi

ffmpeg -i ~/Music/prog$Day$j.$end  -ab 320k ~/Music/keep/prog$Day$j.mp3
