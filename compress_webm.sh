#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <video file>"
  exit 1
fi

input="$1"
basename="${input%.*}"

echo "Input file: $input"

# --- Get duration in seconds using ffprobe ---
duration=$(ffprobe -v error -show_entries format=duration \
          -of default=noprint_wrappers=1:nokey=1 "$input")

# Round duration to integer
duration=${duration%.*}
[ -z "$duration" ] && duration=1
[ "$duration" -lt 1 ] && duration=1

echo "Duration: $duration seconds"

# --- Calculate target video bitrate (kbps) ---
# 8 MB = 8192 KB -> 8192*8 = 65536 kilobits
# Apply ~3% margin -> 63500 instead of 65536
# Subtract 128 kbps reserved for audio
video_bitrate=$((63500 / duration - 128))
[ "$video_bitrate" -lt 50 ] && video_bitrate=50

audio_bitrate=128

echo "Video bitrate: ${video_bitrate} kbps"
echo "Audio bitrate: ${audio_bitrate} kbps"

# --- Adaptive resolution based on bitrate ---
scale_filter=""
if [ "$video_bitrate" -lt 400 ]; then
  echo "Bitrate very low, downscaling to 360p..."
  scale_filter="-vf scale=-1:360"
elif [ "$video_bitrate" -lt 900 ]; then
  echo "Bitrate low, downscaling to 480p..."
  scale_filter="-vf scale=-1:480"
else
  echo "Bitrate sufficient, keeping original resolution."
fi

# --- Run two-pass encode with hard size cap ---
ffmpeg -hide_banner -loglevel warning -y -i "$input" \
  -c:v libvpx-vp9 -b:v ${video_bitrate}k $scale_filter \
  -pass 1 -an -f null /dev/null

ffmpeg -hide_banner -loglevel warning -y -i "$input" \
  -c:v libvpx-vp9 -b:v ${video_bitrate}k $scale_filter \
  -pass 2 -c:a libopus -b:a ${audio_bitrate}k -fs 8M "${basename}_discord.webm"

# --- Cleanup temp files ---
rm -f ffmpeg2pass-0.log ffmpeg2pass-0.log.mbtree

echo "✅ Done! Output saved as ${basename}_discord.webm"
