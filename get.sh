#!/bin/bash
~/sound/musicproc.sh
rm ~/Music/progMon.aac
cat ~/Music/playlists/stations.m3u
for i in `sed -n "/radio3/p" ~/Music/playlists/stations.m3u`
do
avconv -i $i  -codec: copy -t $((15*360)) ~/Music/progMon.aac
exit
done
