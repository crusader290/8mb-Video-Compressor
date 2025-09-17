@echo off
set /p filename="Enter the video filename (e.g., video.mp4): "
set basename=%~nfilename%

rem First pass
ffmpeg -i "%filename%" -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 1 -an -f null NUL

rem Second pass
ffmpeg -i "%filename%" -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 2 -c:a libopus -fs 8M "%basename%_discord.webm"

echo Done! Output saved as %basename%_discord.webm
pause
