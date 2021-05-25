#!/bin/bash
cd ~/Music
day=$(date +%w)

today=$(date +%s)
off=$(($(($((day))))*24*60*60))
before=$(($today-$off))

date --date=@$(($before)) +%Y%m%d

file=https://bauerod.sharp-stream.com/jazz/Jazz-$(date --date=@$(($before)) +%Y%m%d)-2200.mp3
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
  echo -e $(date), update jez.mp3 \\n
  rm -rf jez.mp3
  ffmpeg -ss 7200 -t 3430 -i j3hour.mp3 jez.mp3
fi
echo -e Finished, $(date) \\n
