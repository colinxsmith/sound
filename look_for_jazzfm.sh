#!/usr/bin/bash
sed -n "/jazzhigh.aac$/p" newjazzfm.m3u > oldurl
oldurl=$(cat oldurl)
oldpart=$(cat oldurl | awk -F- '{ print $3"-"$4; }' | sed "s/\..*//")
file=$(curl -L www.radiofeeds.net/playlists/bauer.pls?station=jazz.mp3 | sed -n "s/File1=//p")
echo -e "Need to get file:\e[34m $file \e[0m"
codeback=$(curl -LIs $file -o /dev/null -w "%{http_code}\n")
echo $codeback
if [ $codeback != '200' ]
then
	echo -e "\e[31m Sound file:$file is not available \e[0m "
#	exit 12
fi
curl -L www.radiofeeds.net/playlists/bauer.pls?station=jazzhigh-aac | sed -n "s/File1=//p" > url
curl -L www.radiofeeds.net/playlists/bauer.pls?station=jazz-mp3 | sed -n "s/File1=//p" > url3
url=$(cat url) 
url3=$(cat url3) 
part=$(cat url | awk -F- '{ print $3"-"$4; }' | sed "s/\..*//")
if [ x$part = "x" ]; then exit 555; fi
echo OLD $oldurl $oldpart
echo NEW $url $part
echo -n CHANGED\  
cat oldurl | sed "s/$oldpart/$part/"
sed -i "s/$oldpart/$part/" *.m3u
