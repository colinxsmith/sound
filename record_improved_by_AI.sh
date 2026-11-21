#!/usr/bin/env bash
set -euo pipefail

# BBC station pool IDs and stream slugs (avoids long URLs getting mangled)
declare -A station_pools=(
    [radio1]="pool_01505109/live/ww/bbc_radio_one"
    [radio1X]="pool_92079267/live/ww/bbc_1xtra"
    [radio1Dance]="pool_62063831/live/ww/bbc_radio_one_dance"
    [radio1Anthems]="pool_11351741/live/ww/bbc_radio_one_anthems"
    [radio2]="pool_74208725/live/ww/bbc_radio_two"
    [radio3]="pool_23461179/live/ww/bbc_radio_three"
    [radio4]="pool_55057080/live/ww/bbc_radio_fourfm"
    [radio4X]="pool_26173715/live/ww/bbc_radio_four_extra"
    [radio5]="pool_89021708/live/ww/bbc_radio_five_live"
    [radio6]="pool_81827798/live/ww/bbc_6music"
    [radio6Indie]="pool_07012008/live/ww/bbc_radio_six_indie_forever"
    [asianNetwork]="pool_22108647/live/ww/bbc_asian_network"
    [worldService]="pool_87948813/live/ww/bbc_world_service"
)

build_station_url() {
    local key="$1"
    local entry="${station_pools[$key]}"
    local slug="${entry##*/}"
    local host="as-hls-ww-live.akamaized.net"
    printf "http://%s/%s/%s.isml/%s-audio=320000.norewind.m3u8" "$host" "$entry" "$slug" "$slug"
}

# Handle --list / -l and --help / -h flags before recording
case "${1:-}" in
    -l|--list)
        echo "Available BBC station presets:"
        for key in $(printf "%s\n" "${!station_pools[@]}" | sort); do
            printf "  %-15s -> %s\n" "$key" "$(build_station_url "$key")"
        done
        exit 0
        ;;
    -h|--help)
        echo "Usage: $(basename "$0") [length] [output_file] [station_or_url] [cover_art]"
        echo "       $(basename "$0") --list"
        exit 0
        ;;
esac

# Defaults
length="${1:-02:00:00}"
username="${USER:-pi}"
server_ip="192.168.0.37"

# Build timestamp and default .m4a filename
now="$(date +%a-%d_%m_%Y_%T)_$(uname -m -n -s | tr ' ' '-')"
default_file="recordtr${now}.m4a"
file="${2:-$default_file}"

# Determine output format from extension (default to .m4a if none or unsupported)
ext="${file##*.}"
ext_lower="${ext,,}"

if [[ "$file" != *.* ]] || [[ "$ext_lower" != "mp3" && "$ext_lower" != "m4a" ]]; then
    file="${file%.*}.m4a"
    ext_lower="m4a"
fi

# Resolve station name or direct URL
station_input="${3:-radio6}"
station_input="${station_input#\$}"

if [[ -n "${station_pools[$station_input]+_}" ]]; then
    station_url="$(build_station_url "$station_input")"
else
    station_url="$station_input"
fi

# Guard against broken hostnames or unquoted $variables passed on the command line
if [[ "$station_url" != http://* && "$station_url" != https://* && ! -f "$station_url" ]]; then
    echo "Error: Invalid station or URL '$station_url'." >&2
    echo "Tip: Pass the station name without a '$' sign (e.g., radio6, not \$radio6)." >&2
    echo "Run '$(basename "$0") --list' to see valid station names." >&2
    exit 1
fi

# Cover art input (4th argument: accepts direct path or filename in ~/Pictures)
cover_input="${4:-ak.jpeg}"
if [[ -f "$cover_input" ]]; then
    cover_art="$cover_input"
else
    cover_art="/home/${username}/Pictures/${cover_input}"
fi

# Paths
sound_dir="/home/${username}/sound"
music_dir="/home/${username}/Music"
sound_file="${sound_dir}/${file}"
music_file="${music_dir}/${file}"

mkdir -p "$sound_dir" "$music_dir"

# Detect if running on the MPD server
is_server=false
if [[ " $(hostname -I) " == *" ${server_ip} "* ]]; then
    is_server=true
fi

echo "Timestamp: $now"
echo "Output:    $file (${ext_lower^^})"
echo "Stream:    $station_url"
echo "Cover Art: $([[ -f "$cover_art" ]] && echo "$cover_art" || echo "None (file not found)")"
echo "Mode:      $([[ "$is_server" == true ]] && echo "server place" || echo "not server place")"
echo "Start:     $(date)"

# Build FFmpeg inputs (with 15s network timeout and auto-reconnect for HLS)
ffmpeg_inputs=(
    -rw_timeout 15000000
    -reconnect 1
    -reconnect_streamed 1
    -reconnect_delay_max 5
    -to "$length"
    -i "$station_url"
)
ffmpeg_maps=(-map 0:a)

if [[ -f "$cover_art" ]]; then
    ffmpeg_inputs+=(-i "$cover_art")
    ffmpeg_maps+=(-map 1 -disposition:v:0 attached_pic)
fi

# Select container-specific codec and tagging flags
case "$ext_lower" in
    mp3)
        format_args=(-c:a libmp3lame -b:a 320k -c:v copy -id3v2_version 3 -write_id3v1 1)
        ;;
    m4a)
        format_args=(-c copy -bsf:a aac_adtstoasc -movflags +faststart)
        ;;
esac

# Record, tag metadata, and embed cover art in one pass
ffmpeg -hide_banner -loglevel warning -y \
    "${ffmpeg_inputs[@]}" \
    "${ffmpeg_maps[@]}" \
    "${format_args[@]}" \
    -metadata title="${file%.*} ${station_url} at ${now}" \
    -metadata album="$(uname -a)" \
    -metadata artist="Length: ${length}" \
    -metadata date="$(date +%Y)" \
    "$sound_file"

# Copy finished file to local Music folder
cp -p "$sound_file" "$music_file"

# Inspect ID3 tags if output is MP3 and id3v2 is installed
if [[ "$ext_lower" == "mp3" ]] && command -v id3v2 >/dev/null 2>&1; then
    id3v2 -l "$music_file"
fi

echo "End: $(date)"

# Transfer to server if running remotely, then update MPD
if [[ "$is_server" == false ]]; then
    scp "$sound_file" "pi@${server_ip}:/home/pi/Music/"
    export MPD_HOST="$server_ip"
fi

mpc --wait update
mpc add "$file"

