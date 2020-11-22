#!/bin/bash
cd ~/Music
stamp=$(date +%m%dT01)
now=$(date +%s)
#stamp=1116T01
all=$(wget -O - https://planetradio.co.uk/jazz-fm/shows/somethin-else-with-jez-nelson/ |  sed -n "s|https://downl|\nhttps://downl|gp"|sed -n "/^http/p"|sed "s/mp3.*/mp3/")
echo $all
latest=no
for i in $all
do
  latest=$i
  break
done
last=$(date +%s -d $(echo $latest|awk -F- '{print $4;}'|sed "s/T.*//"))
dayspast=$(echo $now-$last | awk -F- '{a=($1-$2)/24/3600;print int(a);}')
echo $dayspast
found=$(echo $latest|sed -n "/$stamp/p")
echo Latest: $latest, found: $found
curl $(curl -L https://planetradio.co.uk/jazz-fm/schedule/ | sed -n "s|https://down|\nhttps://down|gp" | sed -n "/somethin_else.*3\":\"$/s/mp3.*/mp3/p") > j3hour.mp3
ls -l j3hour.mp3
if [ $(ls -l j3hour.mp3|awk '{print $5;}') -lt 10 ]
then
	echo Not in schedule 
	if [ $dayspast -lt 3 ]
	then
		echo dayspast $dayspast ok
		curl $latest > j3hour.mp3
	fi
fi
while [ $(ls -l j3hour.mp3|awk '{print $5;}') -lt 10 ]
do
  echo sleeping
  sleep 3600
  echo $(date), try to get from schedule
  curl $(curl -L https://planetradio.co.uk/jazz-fm/schedule/ | sed -n "s|https://down|\nhttps://down|gp" | sed -n "/somethin_else.*3\":\"$/s/mp3.*/mp3/p") > j3hour.mp3
  ls -l j3hour.mp3
done
if [ $(ls -l j3hour.mp3|awk '{print $5;}') -gt 10 ]
then
  echo $(date), update jez.mp3
  rm -rf jez.mp3
  ffmpeg -ss 7200 -i j3hour.mp3 jez.mp3
fi
echo Finished, $(date)
