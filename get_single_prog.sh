#!/usr/bin/bash
file=${1:-label8.mp3}
time=${2:-20250928-2100}
interval=${3:-3600}
echo Jazz-$time.mp3
curl -L https://la.hellorayo.co.uk/jazz/Jazz-$time.mp3 > ~/Music/mp3/$file
ls -l ~/Music/mp3/$file
which_go=0
while [ $(ls -l ~/Music/mp3/$file | awk '{print $5}') == '0' ]
do 
  which_go=$(($which_go + 1))
  echo Attempt $which_go $interval $(date)
  sleep $interval
  curl -L https://la.hellorayo.co.uk/jazz/Jazz-$time.mp3 > ~/Music/mp3/$file
done
mpc --wait update
id3v2 -c "$(date +%a\ %d-%m-%Y) $(uname -a)" ~/Music/mp3/$file
id3v2 -l ~/Music/mp3/$file
mpc add mp3/$file
