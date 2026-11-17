#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

file=${1:-prog.mp3}
time=${2:-20251005-0600}
sleeptime=${3:-300}
cover=${4:-$HOME/Pictures/poppy.jpeg}
embed_cover() {
    local audio_file="$1"
    local cover_img="${2:-${HOME}/Pictures/poppy.jpeg}"

    if [ ! -f "$audio_file" ]; then
        echo "Error: Audio file not found at $audio_file"
        return 1
    fi

    if [ ! -f "$cover_img" ]; then
        echo "Warning: Cover image not found at $cover_img"
        return 1
    fi

    local ext="${audio_file##*.}"
    local ext_lower="${ext,,}"
    local tmp_cover="${audio_file%.*}.cover.${ext}"
    local extra_flags=()

    if [ "$ext_lower" = "mp3" ]; then
        extra_flags=(-id3v2_version 3)
    elif [ "$ext_lower" != "m4a" ]; then
        echo "Warning: Unsupported audio format .$ext"
        return 1
    fi

    echo "$tmp_cover" "$cover_img"

    if ffmpeg -nostdin -loglevel error -y -i "$audio_file" -i "$cover_img" \
        -map 0:a -map 1:v -c copy "${extra_flags[@]}" \
        -disposition:v:0 attached_pic "$tmp_cover"; then
        mv "$tmp_cover" "$audio_file"
    else
        echo "Warning: Failed to attach cover art from $cover_img"
        rm -f "$tmp_cover"
        return 1
    fi
}


current_user=${USER:-$(whoami)}
url="https://la.hellorayo.co.uk/jazz/Jazz-${time}.mp3"
attempt=0

rm -f "$file"
touch "$file"

# Poll until a valid file (> 1000 bytes) is downloaded or 200 attempts expire
while [ "$(stat -c %s "$file" 2>/dev/null || echo 0)" -le 1000 ] && [ "$attempt" -lt 200 ]; do
    attempt=$((attempt + 1))
    echo "Attempt $attempt at $(date)"
    echo "curl -fL \"$url\" -o \"$file\""
    
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

# Embed cover art without re-encoding audio (if the image exists)
embed_cover "$file" "$cover"
ls -l "$file"

# Tag the downloaded MP3
tag_info="$(date +%d-%m-%Y) $(uname -m -o -s)"
id3v2 -c "$tag_info" "$file"
id3v2 --TCON "$tag_info" "$file"
id3v2 -l "$file"

# Distribute to remote hosts from Lenovo, or queue locally in MPD
if [ "$(hostname)" = "lenovo" ]; then
    scp -o BatchMode=yes "$file" "pi@trixie32.local:~/Music/mp3/"
    scp -o BatchMode=yes "$file" "pi@trixie64.local:~/Music/mp3/"
else
    mpc --wait update
    add="${file#*Music/}"
    mpc add "$add"
fi

