#!/bin/bash
# rotate-logs.sh - Rotate command history log if it exceeds size limit

LOG_FILE="$HOME/.claude/command_history.log"
MAX_SIZE_MB=10
MAX_SIZE_BYTES=$((MAX_SIZE_MB * 1024 * 1024))

# Check if log file exists
if [[ ! -f "$LOG_FILE" ]]; then
    exit 0
fi

# Get file size in bytes
FILE_SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null)

# Rotate if file exceeds max size
if [[ $FILE_SIZE -gt $MAX_SIZE_BYTES ]]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    mv "$LOG_FILE" "${LOG_FILE}.${TIMESTAMP}"
    echo "✓ Rotated command_history.log (${FILE_SIZE} bytes) to command_history.log.${TIMESTAMP}"

    # Keep only last 5 rotated logs
    ls -t "${LOG_FILE}".* 2>/dev/null | tail -n +6 | xargs -r rm
fi

exit 0
