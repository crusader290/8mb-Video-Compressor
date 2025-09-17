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

# --- Calculate target bitrate (video+audio) in kbps ---
total_bitrate=$((63500 / duration))
[ "$total_bitrate" -lt 50 ] && total_bitrate=50

# Allocate ~90% to video, 10% to audio
video_bitrate=$((total_bitrate * 9 / 10))
audio_bitrate=$((total_bitrate - video_bitrate))

[ "$video_bitrate" -lt 50 ] && video_bitrate=50
[ "$audio_bitrate" -lt 16 ] && audio_bitrate=16

echo "Target total bitrate: ${total_bitrate} kbps"
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
