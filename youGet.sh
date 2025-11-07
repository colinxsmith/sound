#!/bin/sh
PATH=$PATH:/usr/local/bin
fmt=m4a
trixie64=trixie64
getter=$(echo $1|sed "s/ /_/g")
use=$2
tester=$(echo $getter | sed -n "/-/p")
echo $getter,$tester
if [ $getter != "$tester" ]; then getter="$getter - $getter"; fi
getter=$(echo $getter|sed "s/-$/- no title/")
getter=$(echo $getter|sed "s/_/ /g")
echo after $getter

echo $HOME
cd


#yt-dlp -x --audio-format $fmt https://www.youtube.com/playlist?list=OLAK5uy_lcT87h1eIuzRBRkZZZ-lil10-Xt7uood4
#https://youtu.be/xuE8wNYdQV4?si=O-M028DDaQ0Z4soo
music=$(echo $getter | sed "s|https://you.*/||;s/?.*//")
echo music $music

echo yt-dlp -x --default-search "ytsearch" --audio-format $fmt "$music" -v --fixup --prefer-ffmpeg
yt-dlp -x --default-search "ytsearch" --audio-format $fmt "$music" -v 


for i in *.$fmt
do
newname=$(echo $i | sed "s/ /_/g;s/\:/_/g;s/_\[$music.*.$fmt/.$fmt/;s/ft\./ft/")
newname=$(echo "$newname"|sed "s/—/-/g")
newname=$(echo "$newname"|sed "s/\[.*\]//;s/(.*)//")
newname=$(echo "$newname"|sed "s/_\././")
newname=$(echo "$newname"|sed "s/_\././")

echo $newname
echo cp "$i" $HOME/Music/$newname
cp "$i" $HOME/Music/$newname
done

echo rm $HOME/*.$fmt
rm $HOME/*.$fmt

cd Music
i=$newname
ffmpeg -i "$i" -ab 320k "${i%.m4a}.mp3"
mpc --wait update 

tt=$(ls -l --time-style +%s "${i%.m4a}.mp3"|awk '{print $6}')
echo $tt
art=$(echo "${i%.m4a}.mp3" |awk -F "-" '{print $1}'|sed "s/_/ /g")
tit=$(echo "${i%.m4a}.mp3" |awk -F "-" '{print $2}'|sed "s/_/ /g;s/\.mp3//g")
id3v2 -A "BBC Recording" -a "$art" -t "$tit" "${i%.m4a}.mp3"
if [ $use ]; then echo use "${i%.m4a}.mp3" with "$music";id3v2 -t "$(echo $music | awk -F "-" '{ print $2 }')" -a "$(echo $music | awk -F "-" '{ print $1 }')" "${i%.m4a}.mp3"; fi
id3v2 -c "$(date +%a\ %d-%m-%Y) $(uname -a)" "${i%.m4a}.mp3"
id3v2 -l "${i%.m4a}.mp3"
#edit here to correct action on ubuntu
if [ $(uname -n) != $trixie64 ]; then
  scp  "${i%.m4a}.mp3" pi@$trixie64.local:~/Music/mp3
  export MPD_HOST=$trixie64.local
fi
cp "${i%.m4a}.mp3" mp3
mpc --wait update
mpc add mp3/"${i%.m4a}.mp3"
rm "${i%.m4a}.m4a"

