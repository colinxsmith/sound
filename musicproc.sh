#!/bin/bash
for i in $(cat streams.txt); do curl -q $i |sed "s/File[0-9]=//"| sed -n "/http/p" ;done > ~/Music/playlists/stations.m3u
