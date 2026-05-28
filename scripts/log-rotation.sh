#!/bin/bash

# ============================================
# Log Rotation Script
# Runs daily via cron job
# ============================================

set -e

# Variables
LOG_DIR="/var/log"
BACKUP_DIR="/var/log/backup"
MAX_AGE=7
DATE=$(date +%Y-%m-%d)
APP_NAME="myapp"

# Function to log messages
log() {
    echo "[$DATE] $1"
}

# Function to create backup directory
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        log "Creating backup directory..."
        sudo mkdir -p $BACKUP_DIR
        log "Backup directory created!!"
    else
        log "Backup directory already exists!!"
    fi
}

# Function to rotate logs
rotate_logs() {
    log "Rotating logs..."

    for logfile in $LOG_DIR/*.log
    do
        if [ -f "$logfile" ]; then
            filename=$(basename $logfile)
            sudo mv $logfile $BACKUP_DIR/${filename}_$DATE
            sudo touch $logfile
            log "Rotated: $filename"
        fi
    done
}

# Function to cleanup old logs
cleanup_old_logs() {
    log "Cleaning logs older than $MAX_AGE days..."
    sudo find $BACKUP_DIR -type f -mtime +$MAX_AGE -delete
    log "Old logs cleaned!!"
}

# Function to show disk usage
show_disk_usage() {
    usage=$(df / | awk 'NR==2 {print $5}')
    log "Current disk usage: $usage"
}

# Main execution
log "========================================="
log "Log Rotation Started"
log "========================================="

show_disk_usage
create_backup_dir
rotate_logs
cleanup_old_logs
show_disk_usage

log "========================================="
log "Log Rotation Completed"
log "========================================="
