#!/bin/sh

cd Music


youtube-dl -x --audio-format m4a https://www.youtube.com/playlist?list=OLAK5uy_lcT87h1eIuzRBRkZZZ-lil10-Xt7uood4

for i in *.m4a
do
mv "$i" $(echo $i | sed "s/ /_/g;s/-[A-Z,a-z,0-9].*.m4a/.m4a/;s/ft\./ft/")
done
