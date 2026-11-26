#!/bin/bash
if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    echo "Su dung: $0 <thu_muc_can_sao_luu>"
    exit 1
fi

SRC_DIR="${1%/}"
DIR_NAME=$(basename "$SRC_DIR")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/backup"
mkdir -p "$BACKUP_DIR"

DEST_FILE="$BACKUP_DIR/${DIR_NAME}_${TIMESTAMP}.tar.gz"
tar -czf "$DEST_FILE" "$SRC_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/backup.log"
echo "[$(date +"%Y-%m-%d %H:%M:%S")] Da sao luu $SRC_DIR toi $DEST_FILE" >> "$LOG_FILE"
echo "Backup thanh cong: $DEST_FILE"
