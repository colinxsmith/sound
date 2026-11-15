#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

file=${1:-prog.mp3}
time=${2:-20251005-0600}
sleeptime=${3:-300}
url="https://la.hellorayo.co.uk/jazz/Jazz-${time}.mp3"
attempt=0

rm -f "$file"
touch "$file"

# Poll until a valid file (> 1000 bytes) is downloaded or 200 attempts expire
while [ "$(stat -c %s "$file" 2>/dev/null || echo 0)" -le 1000 ] && [ "$attempt" -lt 200 ]; do
    attempt=$((attempt + 1))
    echo "Attempt $attempt at $(date)"
    echo "curl -fL \"$url\" -o \"$file\""
    
    # -f prevents saving HTML 404/500 error pages as a valid MP3
    curl -fL "$url" -o "$file"
    
    if [ "$(stat -c %s "$file" 2>/dev/null || echo 0)" -le 1000 ]; then
        rm -f "$file"
        touch "$file"
        sleep "$sleeptime"
    fi
done

# Abort cleanly if the file never became available
if [ "$(stat -c %s "$file" 2>/dev/null || echo 0)" -le 1000 ]; then
    echo "Error: Failed to download valid MP3 from $url after $attempt attempts."
    rm -f "$file"
    exit 1
fi

ls -l "$file"

# Tag the downloaded MP3
tag_info="$(date +%d-%m-%Y) $(uname -m -o -s)"
id3v2 -c "$tag_info" "$file"
id3v2 --TCON "$tag_info" "$file"
id3v2 -l "$file"

# Distribute to Raspberry Pis from Lenovo, or queue locally in MPD
if [ "$(hostname)" = "lenovo" ]; then
    scp -o BatchMode=yes "$file" pi@trixie32.local:~/Music/mp3/
    scp -o BatchMode=yes "$file" pi@trixie64.local:~/Music/mp3/
else
    mpc --wait update
    add="${file#*Music/}"
    mpc add "$add"
fi

