#!/usr/bin/bash
sed -n "/jazzhigh.aac$/p" newjazzfm.m3u > oldurl
oldurl=$(cat oldurl)
oldpart=$(cat oldurl | awk -F- '{ print $3"-"$4; }' | sed "s/\..*//")
curl -L www.radiofeeds.net/playlists/bauer.pls?station=jazzhigh-aac | sed -n "s/File1=//;s/?.*//p" > url
url=$(cat url) 
part=$(cat url | awk -F- '{ print $3"-"$4; }' | sed "s/\..*//")
echo OLD $oldurl $oldpart
echo NEW $url $part
echo -n CHANGED\  
cat oldurl | sed "s/$oldpart/$part/"
sed -i "s/$oldpart/$part/" *.m3u
