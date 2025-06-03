#!/bin/bash

day=$(date +%Y-%m-%d)
time=$(date +%H:%M:%S)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"





log() {
    echo "$1"
    if [ "$LOG_ENABLED" = true ]; then
        echo "$1" >> "$LOG_FILE"
    fi
}

cleanup() {
log "Compressing files $(find "$LOG_DIR" -type f -name '*.log' -mtime +1)"
find "$LOG_DIR" -type f -name "*.log" -mtime +1 -exec gzip {} +

log "Deleting files $(find "$LOG_DIR" -type f -name '*.log.gz' -mtime +7)"
find "$LOG_DIR" -type f -name "*.log.gz" -mtime +7 -exec rm {} +
exit 0
}

trap cleanup EXIT SIGINT SIGTERM

if [ -n "$1" ]; then
    case $1 in
        --log)
            LOG_DIR="$SCRIPT_DIR/../logs"
            LOG_FILE="$SCRIPT_DIR/../logs/app.log"
            LOG_ENABLED=true
            mkdir -p ${LOG_DIR}
            ;;
        -*)
            echo "Invalid Argument"
            exit 1
            ;;
        *)
            echo "Invalid Argument"
            exit 1
            ;;
    esac
        
fi


log "===== System Health Report (${day} ${time}) ====="
log ""
log "--- CPU Usage ---"
log "$(top -b -n 1 | sed -n '3p' | awk '{print "User: "$2, "System: "$4, "Idle: "$8}')"
log ""
log "--- Memory Usage ---"
log "$(free -h | awk '/^Mem:/ {print "Total: "$2, "Used: "$3, "Available: "$7}')"
log ""
log "--- Disk Usage ---"
log "$(df -h /)"
log ""
log "--- Network Status ---"
if getent hosts google.com >/dev/null; then
    log "Online"
else
    log "Offline"
fi
log ""

