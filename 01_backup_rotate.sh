#!/bin/bash
set -euo pipefail
SOURCE_DIR="${1:-/var/log}"
BACKUP_DIR="${2:-/backup}"
RETENTION_DAYS=7

mkdir -p "$BACKUP_DIR"
DATE=$(date +%Y-%m-%d_%H%M)
ARCHIVE="$BACKUP_DIR/backup_$DATE.tar.gz"

echo "[INFO] Dang nen thu muc $SOURCE_DIR vao $ARCHIVE..."
tar -czf "$ARCHIVE" "$SOURCE_DIR" 2>/dev/null || true

echo "[INFO] Xoa cac ban backup cu hon $RETENTION_DAYS ngay..."
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;
echo "[DONE] Hoan tat backup."
