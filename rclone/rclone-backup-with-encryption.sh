#!/bin/bash
set -euo pipefail

# Pfade auf der Synology
CONFIG_DIR="/volume2/docker/rclone-config"
LOG_DIR="/volume2/docker/rclone-logs"
DATA_DIR="/volume2/docker/rclone-testdata"

# Docker Image
IMAGE="rclone/rclone:latest"

# Log-Verzeichnis sicherstellen
mkdir -p "$LOG_DIR"

# Timestamp für die Logdatei
timestamp="$(date +"%Y-%m-%d-%H-%M-%S")"

# Logdatei auf dem Host
LOG_FILE_HOST="$LOG_DIR/rclone-plain-$timestamp.log"

# Pfad zur Logdatei im Container
LOG_FILE_CONT="/logs/$(basename "$LOG_FILE_HOST")"

echo "Starte rclone Sync MIT Verschlüsselung..."
echo "Logfile: $LOG_FILE_HOST"

# Docker-Container starten und Exit-Code prüfen
if ! docker run --rm --restart=no \
  -v "$CONFIG_DIR":/config/rclone \
  -v "$LOG_DIR":/logs \
  -v "$DATA_DIR":/data \
  "$IMAGE" \
  sync /data pcloud-crypt:backup-test-crypt \
    --config /config/rclone/rclone.conf \
    --log-file "$LOG_FILE_CONT" \
    --log-level INFO
then
  rc=$?
  echo "rclone / docker ist mit Exit-Code $rc beendet."
  echo "Details stehen im Log: $LOG_FILE_HOST"
  exit "$rc"
else
  echo "rclone Sync ohne Verschlüsselung erfolgreich (Exit-Code 0)."
fi
