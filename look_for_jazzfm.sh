#!/usr/bin/bash
curl -L www.radiofeeds.net/playlists/bauer.pls?station=jazzhigh-aac | sed -n "s/File1=//;s/?.*//p"
