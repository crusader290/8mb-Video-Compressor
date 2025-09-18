# Discord Video Compressor

This tool compresses videos into **WebM** format optimized for Discord’s 8 MB upload limit.  
It uses **two-pass VP9 encoding** with smart bitrate calculation, adaptive resolution scaling, and a hard 8 MB size cap.

---

## Features
- ✅ Automatically calculates bitrate based on video duration.  
- ✅ Allocates ~90% bitrate to video, 10% to audio.  
- ✅ Adaptive resolution scaling:
  - ≥900 kbps → Keep original resolution.  
  - 400–889 kbps → Downscale to **480p**.  
  - <400 kbps → Downscale to **360p**.
- ✅ Audio clamped at 128kbps.
- ✅ Two-pass encoding for higher quality.  
- ✅ Hard cap (`-fs 8M`) ensures files never exceed Discord’s 8 MB limit.  
- ✅ Temporary FFmpeg log files are cleaned up automatically.  

---

### 🪟 Windows (Drag & Drop)

1. Save the script as `compress_webm_dragdrop.bat`.  
2. Place the `.bat` file in the same folder as `ffmpeg.exe` and `ffprobe.exe` (or add FFmpeg to your PATH).  
3. Drag and drop a video file onto the `.bat`.  
4. The script will compress it and save the output as `yourvideo_discord.webm` in the same folder.  

---

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
4. The script will compress it and save the output as `myvideo_discord.webm` in the same folder.  

---

✅ With adaptive scaling, even long videos remain watchable, while short clips can stay in higher resolution — always fitting under **8 MB** for Discord uploads.
