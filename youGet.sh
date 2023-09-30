#!/bin/sh
PATH=$PATH:/usr/local/bin
fmt=m4a
echo $HOME
cd


#yt-dlp -x --audio-format $fmt https://www.youtube.com/playlist?list=OLAK5uy_lcT87h1eIuzRBRkZZZ-lil10-Xt7uood4
#https://youtu.be/xuE8wNYdQV4?si=O-M028DDaQ0Z4soo
music=$(echo $1 | sed "s|https://you.*/||;s/?.*//")
echo music $music

echo yt-dlp -x --audio-format $fmt "$music" -v --fixup --prefer-ffmpeg
yt-dlp -x --audio-format $fmt "$music" -v 


for i in *.$fmt
do
newname=$(echo $i | sed "s/ /_/g;s/\:/_/g;s/_\[$music.*.$fmt/.$fmt/;s/ft\./ft/")
newname=$(echo $newname|sed "s/—/-/g")
echo cp "$i" $HOME/Music/$newname
cp "$i" $HOME/Music/$newname
done

echo rm $HOME/*.$fmt
rm $HOME/*.$fmt
