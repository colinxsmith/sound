#!/bin/bash
cd ~/Music
curl $(curl https://planetradio.co.uk/jazz-fm/schedule/ | sed -n "s|https://down|\nhttps://down|gp" | sed -n "/somethin_else.*3\":\"$/s/mp3.*/mp3/p") > j3hour.mp3
while [ $(ls -l j3hour.mp3|awk '{print $5;}') = 0 ]
do
  echo sleeping
  sleep 3600
  curl $(curl https://planetradio.co.uk/jazz-fm/schedule/ | sed -n "s|https://down|\nhttps://down|gp" | sed -n "/somethin_else.*3\":\"$/s/mp3.*/mp3/p") > j3hour.mp3
done
rm -rf jez.mp3
ffmpeg -ss 7200 -i j3hour.mp3 jez.mp3
