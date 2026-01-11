# GoPro Video Merge

Dieses Projekt enthält zwei Skripte (Bash & PowerShell), die automatisch eine `inputs.txt`-Datei für `ffmpeg` erzeugen. Damit kannst du GoPro-Videos eines bestimmten Tages chronologisch korrekt zusammenführen.

---

## 📁 Struktur

- `generate-inputs-for-gopro-merge.ps1.sh` → **Bash-Skript für macOS/Linux**
- `Generate-Inputs-For-Gopro-Merge.ps1` → **PowerShell-Skript für Windows/macOS**

---

## 🗓 Eingestelltes Datum

Beide Skripte sind fest auf das Datum **`2024-09-26`** eingestellt. Du kannst das im jeweiligen Script ändern, um Videos eines anderen Tages zu verarbeiten.

---

## ⚙️ Verwendung

### 🔧 Bash (macOS / Linux)

```bash
./Generate-Inputs-For-Gopro-Merge.ps1
./generate-inputs-for-gopro-merge.sh
```
### Videos zusammenführen
```bash
ffmpeg -f concat -safe 0 -i inputs.txt -c copy full_video.mp4
```

### Videos komprimieren mit H.265
```bash
ffmpeg -i full_video.mp4 -vcodec libx265 -crf 23 compressed_video.mp4
```
