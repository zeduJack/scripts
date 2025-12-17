#!/bin/bash
set -euo pipefail

CONFIG_DIR="/volume2/docker/rclone-config"
LOG_DIR="/volume2/docker/rclone-logs"
IMAGE="rclone/rclone:latest"
REMOTE_ROOT="pcloud:Synology-Backup/photo"

mkdir -p "$LOG_DIR"
timestamp="$(date +"%Y-%m-%d-%H-%M-%S")"
LOG_FILE_HOST="$LOG_DIR/rclone-cleanup-$timestamp.log"

echo "Starte Cleanup (Top-Level only, DRY-RUN)"
echo "Remote: $REMOTE_ROOT"
echo "Logfile: $LOG_FILE_HOST"

docker run --rm --restart=no \
  --entrypoint /bin/sh \
  -v "$CONFIG_DIR":/config/rclone \
  -v "$LOG_DIR":/logs \
  "$IMAGE" \
  -c '
    set -e

    # 1) Alle Kandidaten finden
    # 2) Sortieren (kürzere Pfade zuerst)
    # 3) "Top-Level only": wenn ein Pfad bereits Parent eines anderen ist, wird der tiefere ignoriert
    rclone lsf "'"$REMOTE_ROOT"'" \
      --config /config/rclone/rclone.conf \
      --dirs-only \
      --recursive | \
    grep -E "(^|/)(@eaDir|\.@__thumb|#recycle)/$" | \
    sort | \
    awk "
      {
        # Wenn wir schon einen Parent behalten haben, und der aktuelle Pfad damit beginnt => skip
        for (i=1; i<=keepCount; i++) {
          if (index(\$0, keep[i]) == 1) next
        }
        keep[++keepCount] = \$0
        print
      }
    " | \
    while read -r dir; do
      echo "→ purge '"$REMOTE_ROOT"'/$dir"
      rclone purge "'"$REMOTE_ROOT"'/$dir" \
        --config /config/rclone/rclone.conf 
    done
  ' | tee "$LOG_FILE_HOST"
