#!/bin/bash

day=$(date +%Y-%m-%d)
time=$(date +%H:%M:%S)
LOG_FILE="./system-${day}.log"

log() {
    echo "$1"
    if [ "$LOG_ENABLED" = true ]; then
        echo "$1" >> "$LOG_FILE"
    fi
}

if [ -n "$1" ]; then
    case $1 in
        --log)
            LOG_ENABLED=true
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

