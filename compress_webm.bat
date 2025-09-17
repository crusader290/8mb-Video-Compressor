@echo off
if "%~1"=="" (
    echo Drag and drop a video file onto this script to compress it for Discord.
    pause
    exit /b
)

set input=%~1
set basename=%~n1
set ext=%~x1

echo Input file: %input%
echo Output file: %basename%_discord.webm

rem First pass
ffmpeg -i "%input%" -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 1 -an -f null NUL

rem Second pass
ffmpeg -i "%input%" -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 2 -c:a libopus -fs 8M "%basename%_discord.webm"

echo.
echo ✅ Done! Output saved as %basename%_discord.webm
pause
