#!/bin/sh
PATH=$PATH:/usr/local/bin
echo $HOME
cd


#youtube-dl -x --audio-format m4a https://www.youtube.com/playlist?list=OLAK5uy_lcT87h1eIuzRBRkZZZ-lil10-Xt7uood4
echo youtube-dl -x --audio-format m4a "$1"
youtube-dl -x --audio-format m4a "$1"

echo youtube-dl -x --audio-format m4a "$2"
youtube-dl -x --audio-format m4a "$2"

echo youtube-dl -x --audio-format m4a "$3"
youtube-dl -x --audio-format m4a "$3"

for i in *.m4a
do
echo cp "$i" $HOME/Music/$(echo $i | sed "s/ /_/g;s/-[A-Z,a-z,0-9].*.m4a/.m4a/;s/ft\./ft/")
cp "$i" $HOME/Music/$(echo $i | sed "s/ /_/g;s/-[A-Z,a-z,0-9].*.m4a/.m4a/;s/ft\./ft/")
done

echo rm $HOME/*.m4a
rm $HOME/*.m4a
