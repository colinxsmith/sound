#!/usr/bin/env bash
set -euo pipefail

# Ensure at least the target audio file is provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $(basename "$0") <audio_file> [picture_filename] [username]" >&2
    exit 1
fi

# Verify ffmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: ffmpeg is not installed." >&2
    exit 1
fi

target_file="$1"
picture="${2:-poppy.jpeg}"
username="${3:-${USER:-pi}}"
picture_path="/home/${username}/Pictures/${picture}"

# Check that source files exist before running ffmpeg
if [[ ! -f "$target_file" ]]; then
    echo "Error: Audio file '$target_file' not found." >&2
    exit 1
fi

if [[ ! -f "$picture_path" ]]; then
    echo "Error: Picture '$picture_path' not found." >&2
    exit 1
fi

# Create a temporary file in the same directory so 'mv' is atomic
# Retain the original file extension so ffmpeg detects the container format
target_dir="$(dirname "$target_file")"
extension="${target_file##*.}"
temp_file="$(mktemp "${target_dir}/.tmp_cover.XXXXXX.${extension}")"

# Clean up the temporary file automatically if the script exits or fails
cleanup() {
    rm -f "$temp_file"
}
trap cleanup EXIT

# Embed cover art into the temporary file
ffmpeg -hide_banner -loglevel error -y \
    -i "$target_file" \
    -i "$picture_path" \
    -map 0 -map 1 \
    -c copy \
    -id3v2_version 3 \
    -write_id3v1 1 \
    "$temp_file"

# Atomically replace the original file only if ffmpeg succeeded
mv -f "$temp_file" "$target_file"

echo "Successfully updated '$target_file'"
