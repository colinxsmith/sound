#!/bin/bash
for i in $(cat ~/sound/streams.txt); do curl -q $i |sed "/File1/d;s/File[0-9]=//"| sed -n "/http/p" ;done > ~/Music/playlists/stations.m3u
