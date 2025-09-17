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

rem Handle decimal durations safely
for /f "tokens=1 delims=." %%b in ("%duration%") do set duration=%%b

if "%duration%"=="" set duration=1
if %duration% LSS 1 set duration=1

echo Duration: %duration% seconds

rem --- Calculate target bitrate (video+audio) in kbps ---
set /a total_bitrate=63500/%duration%
if %total_bitrate% LSS 50 set /a total_bitrate=50

rem Allocate ~90%% to video, 10%% to audio
set /a video_bitrate=%total_bitrate%*9/10
set /a audio_bitrate=%total_bitrate%-%video_bitrate%

if %video_bitrate% LSS 50 set /a video_bitrate=50
if %audio_bitrate% LSS 16 set /a audio_bitrate=16

echo Target total bitrate: %total_bitrate% kbps
echo Video bitrate: %video_bitrate% kbps
echo Audio bitrate: %audio_bitrate% kbps

rem --- Adaptive resolution based on bitrate ---
set scale_filter=
if %video_bitrate% LSS 400 (
    echo Bitrate very low, downscaling to 360p...
    set scale_filter=-vf scale=-1:360
) else if %video_bitrate% LSS 900 (
    echo Bitrate low, downscaling to 480p...
    set scale_filter=-vf scale=-1:480
) else (
    echo Bitrate sufficient, keeping original resolution.
)

rem --- Run two-pass encode with hard size cap ---
ffmpeg -hide_banner -loglevel warning -y -i "%input%" -c:v libvpx-vp9 -b:v %video_bitrate%k %scale_filter% -pass 1 -an -f null NUL
ffmpeg -hide_banner -loglevel warning -y -i "%input%" -c:v libvpx-vp9 -b:v %video_bitrate%k %scale_filter% -pass 2 -c:a libopus -b:a %audio_bitrate%k -fs 8M "%basename%_discord.webm"

rem --- Cleanup temp log files ---
del ffmpeg2pass-0.log >nul 2>&1
del ffmpeg2pass-0.log.mbtree >nul 2>&1

echo.
echo ✅ Done! Output saved as %basename%_discord.webm
pause
