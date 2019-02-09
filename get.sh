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
for i in `sed -n "/$station/p" ~/Music/playlists/stations.m3u`
do
j=$((j+1))
echo avconv -i $i   -t $time ~/Music/prog$Day$j.$end
avconv -i $i   -t $time ~/Music/prog$Day$j.$end
if [ $j -eq 1 ]
then
	break
fi
done

