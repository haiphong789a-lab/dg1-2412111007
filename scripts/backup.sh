#!/bin/bash

# Kiểm tra tham số đầu vào
if [ -z "$1" ] || [ ! -d "$1" ]; then
    echo "Loi: Vui long truyen vao duong dan thu muc hop le."
    exit 1
fi

TARGET_DIR="$1"
DIR_NAME=$(basename "$TARGET_DIR")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/backup"
mkdir -p "$BACKUP_DIR"

DEST_FILE="$BACKUP_DIR/${DIR_NAME}_${TIMESTAMP}.tar.gz"
tar -czf "$DEST_FILE" "$TARGET_DIR"

# Ghi log vào thư mục logs của dự án
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/backup.log"
echo "$(date +"%Y-%m-%d %H:%M:%S") - Da sao luu: $DEST_FILE" >> "$LOG_FILE"

echo "Sao luu thanh cong: $DEST_FILE"
