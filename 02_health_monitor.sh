#!/bin/bash
set -euo pipefail
TELEGRAM_TOKEN="NHAP_TOKEN_CUA_BAN"
CHAT_ID="NHAP_CHAT_ID"

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
RAM_FREE=$(free -m | awk 'NR==2 {print $4}')
MESSAGE=""

if [ "$DISK_USAGE" -gt 85 ]; then MESSAGE="[CANH BAO] O cung / da dung ${DISK_USAGE}% "; fi
if [ "$RAM_FREE" -lt 500 ]; then MESSAGE="${MESSAGE} [CANH BAO] RAM trong duoi 500MB (${RAM_FREE}MB)"; fi

if [ -n "$MESSAGE" ] && [ "$TELEGRAM_TOKEN" != "NHAP_TOKEN_CUA_BAN" ]; then
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" -d text="$MESSAGE" > /dev/null
    echo "[INFO] Da gui canh bao Telegram."
else
    echo "[OK] He thong an toan hoac chua cau hinh bot."
fi
