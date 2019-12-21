#!/bin/sh
PATH=$PATH:/usr/local/bin
fmt=m4a
echo $HOME
cd


#youtube-dl -x --audio-format $fmt https://www.youtube.com/playlist?list=OLAK5uy_lcT87h1eIuzRBRkZZZ-lil10-Xt7uood4
echo youtube-dl -x --audio-format $fmt "$1"
youtube-dl -x --audio-format $fmt "$1"

echo youtube-dl -x --audio-format $fmt "$2"
youtube-dl -x --audio-format $fmt "$2"

echo youtube-dl -x --audio-format $fmt "$3"
youtube-dl -x --audio-format $fmt "$3"

for i in *.$fmt
do
echo cp "$i" $HOME/Music/$(echo $i | sed "s/ /_/g;s/-[A-Z,a-z,0-9].*.$fmt/.$fmt/;s/ft\./ft/")
cp "$i" $HOME/Music/$(echo $i | sed "s/ /_/g;s/-[A-Z,a-z,0-9].*.$fmt/.$fmt/;s/ft\./ft/")
done

echo rm $HOME/*.$fmt
rm $HOME/*.$fmt
