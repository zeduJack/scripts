#!/bin/bash
set -euo pipefail

CONFIG_DIR="/volume2/docker/rclone-config"
LOG_DIR="/volume2/docker/rclone-logs"
DATA_DIR="/volume2/photo"
IMAGE="rclone/rclone:latest"

mkdir -p "$LOG_DIR"
timestamp="$(date +"%Y-%m-%d-%H-%M-%S")"
LOG_FILE_HOST="$LOG_DIR/rclone-plain-$timestamp.log"
LOG_FILE_CONT="/logs/$(basename "$LOG_FILE_HOST")"

echo "Starte rclone Sync OHNE Verschlüsselung..."
echo "Logfile: $LOG_FILE_HOST"

docker run --rm --restart=no \
  -v "$CONFIG_DIR":/config/rclone \
  -v "$LOG_DIR":/logs \
  -v "$DATA_DIR":/data \
  "$IMAGE" \
  sync /data pcloud:Synology-Backup/photo \
    --config /config/rclone/rclone.conf \
    --log-file "$LOG_FILE_CONT" \
    --exclude "**/@eaDir/**" \
    --exclude "**/.@__thumb/**" \
    --exclude "**/#recycle/**" \
    --exclude "@eaDir/**" \
    --exclude ".@__thumb/**" \
    --exclude "#recycle/**" \
    --log-level INFO

rc=$?
if [ "$rc" -ne 0 ]; then
  echo "rclone / docker ist mit Exit-Code $rc beendet."
  echo "Details stehen im Log: $LOG_FILE_HOST"
  exit "$rc"
fi

echo "rclone Sync ohne Verschlüsselung erfolgreich (Exit-Code 0)."
