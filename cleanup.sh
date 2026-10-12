#!/bin/bash

# Define the target directory
TARGET_DIR="$(pwd)/Music"

# Check if directory exists before proceeding
if [ -d "$TARGET_DIR" ]; then
    #find "$TARGET_DIR" -type f -iname "*.mp3" -mtime +30 -delete
    find "$TARGET_DIR" -type f -iname "Mon*.mp3" -mtime +30 -print -delete
    find "$TARGET_DIR" -type f -iname "Tue*.mp3" -mtime +30 -print -delete
    find "$TARGET_DIR" -type f -iname "Wed*.mp3" -mtime +30 -print -delete
    find "$TARGET_DIR" -type f -iname "Thu*.mp3" -mtime +30 -print -delete
    find "$TARGET_DIR" -type f -iname "Fri*.mp3" -mtime +30 -print -delete
    find "$TARGET_DIR" -type f -iname "Sat*.mp3" -mtime +30 -print -delete
    find "$TARGET_DIR" -type f -iname "Sun*.mp3" -mtime +30 -print -delete
else
    echo "Error: Directory $TARGET_DIR does not exist."
    exit 1
fi
