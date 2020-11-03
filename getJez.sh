#!/bin/bash
cd ~/Music
curl $(curl https://planetradio.co.uk/jazz-fm/schedule/ | sed -n "s|https://down|\nhttps://down|gp" | sed -n "/somethin_else.*3\":\"$/s/mp3.*/mp3/p") > j3hour.mp3
rm -rf jez.mp3
ffmpeg -ss 7200 -i j3hour.mp3 jez.mp3
