#!/bin/bash
pic=/home/pi/Pictures/new`date +%H%M`.jpg
echo $pic
raspistill -vf -hf -w 1280 -h 720 -ex night -o $pic
