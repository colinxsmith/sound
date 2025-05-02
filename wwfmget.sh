#!/usr/bin/sh
if [ $(uname -n) != new64 ]; then export MPD_HOST=new64.local; fi
uname -n
echo $MPD_HOST
echo $(mpc playlist | grep Worldw | awk -F: '{ print $2; }')
cd
sound/youGet.sh "$(mpc playlist | grep Worldw | awk -F: '{ print $2; }')"
