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

## 🚀 Usage

### Linux / macOS

Pending Change.

------------------------------------------------------------------------

### 🪟 Windows (Drag & Drop)

Drag & drop your video onto the .bat.

The script runs ffprobe to detect the video duration.

It calculates the exact bitrate budget so the final file ≤ 8 MB.

FFmpeg does a 2-pass encode for better quality.

Output: video_discord.webm in the same folder.

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
