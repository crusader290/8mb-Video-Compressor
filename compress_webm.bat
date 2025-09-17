@echo off
if "%~1"=="" (
    echo Drag and drop a video file onto this script to compress it for Discord.
    pause
    exit /b
)

set input=%~1
set basename=%~n1

echo Input file: %input%

rem --- Get duration in seconds using ffprobe ---
for /f "tokens=*" %%a in ('ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%input%"') do set duration=%%a

rem Round duration
set /a duration=%duration:.=%

echo Duration: %duration% seconds

rem --- Calculate target bitrate (video+audio) in kbps ---
rem 8 MB = 8192 KB -> 8192*8 = 65536 kilobits
set /a total_bitrate=65536/%duration%

rem Allocate ~90%% to video, 10%% to audio
set /a video_bitrate=%total_bitrate%*9/10
set /a audio_bitrate=%total_bitrate%-%video_bitrate%

echo Target total bitrate: %total_bitrate% kbps
echo Video bitrate: %video_bitrate% kbps
echo Audio bitrate: %audio_bitrate% kbps

rem --- Run two-pass encode ---
ffmpeg -y -i "%input%" -c:v libvpx-vp9 -b:v %video_bitrate%k -pass 1 -an -f null NUL
ffmpeg -y -i "%input%" -c:v libvpx-vp9 -b:v %video_bitrate%k -pass 2 -c:a libopus -b:a %audio_bitrate%k "%basename%_discord.webm"

echo.
echo ✅ Done! Output saved as %basename%_discord.webm
pause
