#!/bin/bash
set -euo pipefail
if [[ $EUID -ne 0 ]]; then echo "Phai chay bang root!"; exit 1; fi

LOG_FILE="/var/log/secure"
MAX_ATTEMPTS=5

echo "[INFO] Quet log tim IP SSH/Telnet that bai qua $MAX_ATTEMPTS lan..."
BAD_IPS=$(grep "Failed password" "$LOG_FILE" 2>/dev/null | awk '{print $(NF-3)}' | sort | uniq -c | awk -v limit="$MAX_ATTEMPTS" '$1 >= limit {print $2}' || true)

for IP in $BAD_IPS; do
    if ! firewall-cmd --list-rich-rules | grep -q "$IP"; then
        echo "[ACTION] Dang block IP: $IP"
        firewall-cmd --add-rich-rule="rule family='ipv4' source address='$IP' reject" --permanent
    fi
done
firewall-cmd --reload
echo "[DONE] Cap nhat Firewall hoan tat."
