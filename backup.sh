#!/bin/bash

# =========================
# CONFIGURATION
# =========================
SOURCE_DIRS="$HOME/ashu/Scripts/backup-script/sample-data"
BACKUP_DIR="$HOME/ashu/Scripts/backup-script/backups"
RETENTION_DAYS=7
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_${DATE}.tar.gz"

# =========================
# FUNCTIONS
# =========================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

create_backup_dir() {
    mkdir -p "$BACKUP_DIR"
}

run_backup() {
    log "Starting backup of: $SOURCE_DIRS"
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIRS"
    log "Backup saved to: $BACKUP_DIR/$BACKUP_NAME"
}

cleanup_old_backups() {
    log "Deleting backups older than $RETENTION_DAYS days"
    find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +"$RETENTION_DAYS" -delete
    log "Cleanup completed"
}

main() {
    set -euo pipefail 

    create_backup_dir
    run_backup
    cleanup_old_backups
    log "Backup job finished successfully"
}

# =========================
# EXECUTION GUARD
# =========================
# Run main only if script is executed, not sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi

