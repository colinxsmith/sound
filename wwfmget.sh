#!/usr/bin/sh
here=${1:-0}
station=${2:-Worldw}
if [ $here -eq 0 ]; then if [ $(uname -n) != trixie64 ]; then export MPD_HOST=trixie64.local; fi; fi
track=$(mpc playlist | grep -i "$station")
track=$(echo $track | awk -F: '{ print $2; }')
echo $track

uname -n
echo $MPD_HOST

cd
sound/youGet.sh "$track" 1
