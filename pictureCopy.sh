#!/usr/bin/bash
picture=${3:-poppy.jpeg}
pi=${4:-pi}
ffmpeg -i $1 -i /home/$pi/Pictures/$picture -map 0 -map 1 -c copy -id3v2_version 3 -write_id3v1 1 $2
