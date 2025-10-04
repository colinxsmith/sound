#!/usr/bin/bash
time=${2:-20251003-2100}
file=${1:-prog.mp3}
attempt=0
if [ -f $file ]; then rm $file; fi
touch $file
while [ $(ls -l $file | awk '{print $5}') == '0' ]; 
do 
  sleep 300; 
  attempt=$(($attempt + 1))
  echo Attempt $attempt
  echo -e "curl -L https://la.hellorayo.co.uk/jazz/Jazz-$time.mp3 > $file"
  curl -L https://la.hellorayo.co.uk/jazz/Jazz-$time.mp3 > $file;
done

ls -l $file
id3v2 -c "$(date +%d-%m-%Y) $(uname -m -o -s)" $file
id3v2 -l $file
