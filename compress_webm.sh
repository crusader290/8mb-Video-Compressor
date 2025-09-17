#!/bin/bash
echo "Enter the video filename (e.g., video.mp4):"
read filename

# Remove extension for output name
basename="${filename%.*}"

# First pass
ffmpeg -i "$filename" -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 1 -an -f null /dev/null

# Second pass
ffmpeg -i "$filename" -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 2 -c:a libopus -fs 8M "${basename}_discord.webm"

echo "✅ Done! Output saved as ${basename}_discord.webm"
