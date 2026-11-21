#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $(basename "$0") <audio_file> [picture_filename] [username]" >&2
    exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: ffmpeg is not installed." >&2
    exit 1
fi

target_file="$1"
picture="${2:-ak.jpeg}"
username="${3:-${USER:-pi}}"
picture_path="/home/${username}/Pictures/${picture}"

if [[ ! -f "$target_file" ]]; then
    echo "Error: Audio file '$target_file' not found." >&2
    exit 1
fi

if [[ ! -f "$picture_path" ]]; then
    echo "Error: Picture '$picture_path' not found." >&2
    exit 1
fi

target_dir="$(dirname "$target_file")"
extension="${target_file##*.}"
ext_lower="${extension,,}"
temp_file="$(mktemp "${target_dir}/.tmp_cover.XXXXXX.${extension}")"

cleanup() {
    rm -f "$temp_file"
}
trap cleanup EXIT

# Select container-specific flags for cover art
case "$ext_lower" in
    mp3)
        format_args=(-map 0 -map 1 -c copy -id3v2_version 3 -write_id3v1 1)
        ;;
    m4a|mp4)
        format_args=(-map 0:a -map 1 -c copy -disposition:v:0 attached_pic)
        ;;
    *)
        echo "Error: Unsupported file extension '.${extension}'. Use .mp3 or .m4a." >&2
        exit 1
        ;;
esac

ffmpeg -hide_banner -loglevel error -y \
    -i "$target_file" \
    -i "$picture_path" \
    "${format_args[@]}" \
    "$temp_file"

mv -f "$temp_file" "$target_file"

echo "Successfully updated '$target_file'"

