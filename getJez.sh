#!/bin/bash
cd ~/Music
day=$(date +%w)

today=$(date +%s)
off=$(($(($((day))))*24*60*60))
before=$(($today-$off))
base=bauerod.sharp-stream.com
base=la.planetradio.co.uk
start=2200
secsoff=-3600

date --date=@$(($before)) +%Y%m%d

file=https://$base/jazz/Jazz-$(date --date=@$(($before)) +%Y%m%d)-$start.mp3
echo $file

curl -L $file > j3hour.mp3

while [ $(ls -l j3hour.mp3|awk '{print $5;}') -lt 200 ]
do
  echo -e sleeping \\n
  sleep 1800
  echo Retry
  curl -L $file > j3hour.mp3
  ls -l j3hour.mp3
done

if [ $(ls -l j3hour.mp3|awk '{print $5;}') -ge 200 ]
then
  ls -l j3hour.mp3
  echo -e $(date), update jez.mp3 \\n
  rm -rf jez.mp3
  ffmpeg -sseof $secsoff -i j3hour.mp3 jez.mp3
fi
echo -e Finished, $(date) \\n
