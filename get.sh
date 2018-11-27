#!/bin/bash
~/sound/musicproc.sh
rm ~/Music/progMon*.aac
cat ~/Music/playlists/stations.m3u
j=0
for i in `cat ~/Music/playlists/stations.m3u`
do
j=$((j+1))
avconv -i $i  -codec: copy -t $((15*360)) ~/Music/progMon$j.aac
done
