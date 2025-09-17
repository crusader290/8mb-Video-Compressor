#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <video file>"
  exit 1
fi

input="$1"
basename="${input%.*}"

echo "Input file: $input"

# --- Get duration in seconds using ffprobe ---
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input")
duration=${duration%.*} # round to integer

echo "Duration: $duration seconds"

# --- Calculate target bitrate (video+audio) in kbps ---
# 8 MB = 8192 KB -> 8192*8 = 65536 kilobits
total_bitrate=$((65536 / duration))

# Allocate ~90% to video, 10% to audio
video_bitrate=$((total_bitrate * 9 / 10))
audio_bitrate=$((total_bitrate - video_bitrate))

echo "Target total bitrate: ${total_bitrate} kbps"
echo "Video bitrate: ${video_bitrate} kbps"
echo "Audio bitrate: ${audio_bitrate} kbps"

# --- Run two-pass encode ---
ffmpeg -y -i "$input" -c:v libvpx-vp9 -b:v ${video_bitrate}k -pass 1 -an -f null /dev/null
ffmpeg -y -i "$input" -c:v libvpx-vp9 -b:v ${video_bitrate}k -pass 2 -c:a libopus -b:a ${audio_bitrate}k "${basename}_discord.webm"

echo "✅ Done! Output saved as ${basename}_discord.webm"
