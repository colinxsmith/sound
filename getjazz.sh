#!/bin/sh
#Get any program from Jazz FM
#DATE is the start time of the program
DATE=${1:-20250323}
TIME=${2:-1700}
#both URLs work
URL1=hellorayo
URL2=planetradio
curl -L la.$URL1.co.uk/jazz/Jazz-$DATE-$TIME.mp3 > new.mp3
id3v2 -c "$(date +%d-%m-%Y) $(uname -m -o -s)" new.mp3
