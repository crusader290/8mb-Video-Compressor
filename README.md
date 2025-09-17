# Discord Video Compressor (WebM, \<8MB)

This project provides simple scripts to compress videos into **WebM
format** optimized for Discord's 8MB upload limit.\
It uses [FFmpeg](https://ffmpeg.org/) with VP9 + Opus encoding for
maximum compatibility and efficiency.

------------------------------------------------------------------------

## 📦 Requirements

-   [FFmpeg](https://ffmpeg.org/download.html) must be installed and
    added to your system PATH.
-   Works on both **Linux/macOS (Bash)** and **Windows (Batch)**.

------------------------------------------------------------------------

### 🐧 Linux / macOS

1. Save the script as `compress_webm.sh`.
2. Make it executable:
   ```bash
   chmod +x compress_webm.sh
   ```
3. Run the script from terminal with your video file as an argument:
   ```bash
   ./compress_webm.sh myvideo.mp4
   ```
4. The compressed file will be saved as `myvideo_discord.webm` in the same folder.

------------------------------------------------------------------------

### 🪟 Windows (Drag & Drop)

1. Save the script as `compress_webm_dragdrop.bat`.
2. Place the `.bat` file in the same folder as `ffmpeg.exe` and `ffprobe.exe` (or make sure FFmpeg is added to your PATH).
3. Drag and drop a video file onto the `.bat`.
4. The script will automatically compress it and save the output as `yourvideo_discord.webm` in the same folder.

------------------------------------------------------------------------

## ⚡ Advanced Notes

-   The script uses **two-pass VP9 encoding** with a CRF of `30`,
    targeting **8MB max size** (`-fs 8M`).
-   You can tweak `-crf` (quality) or resolution scaling
    (`-vf scale=-1:720`) if you want smaller files or better quality.

------------------------------------------------------------------------

## ✅ Example

**Input:** `myclip.mp4`\
**Output:** `myclip_discord.webm` (under 8 MB)

------------------------------------------------------------------------

## 🔧 Troubleshooting

-   If your file is still slightly above 8MB, lower quality by
    increasing `-crf` (e.g., `-crf 32`).\
-   If the video is very long, consider lowering resolution with
    `-vf scale=-1:720`.

------------------------------------------------------------------------

Enjoy smooth, Discord-friendly video uploads! 🎬
