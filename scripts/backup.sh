#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/.env"
BACKUP_DIR="${BACKUP_DIR:-$PROJECT_DIR/backups}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"
ENCRYPT_PASSWORD="${BACKUP_ENCRYPT_PASSWORD:-}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/homelab_backup_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/backup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

load_env() {
    if [ -f "$ENV_FILE" ]; then
        export $(grep -v '^#' "$ENV_FILE" | xargs)
    fi
}

check_dependencies() {
    local deps=("docker" "tar" "gzip")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            log "ERROR: $dep not found"
            exit 1
        fi
    done
}

backup_volumes() {
    log "Starting volume backup..."
    local running_containers=$(docker compose -f "$PROJECT_DIR/docker-compose.yml" ps -q 2>/dev/null || true)

    if [ -z "$running_containers" ]; then
        log "WARNING: No running containers found"
        return
    fi

    local temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT

    local volumes=$(docker compose -f "$PROJECT_DIR/docker-compose.yml" ps --format json 2>/dev/null | \
        python3 -c "import sys,json; [print(c['Name']) for c in json.load(sys.stdin)]" 2>/dev/null || \
        docker compose -f "$PROJECT_DIR/docker-compose.yml" ps --format "{{.Names}}" 2>/dev/null)

    for container in $volumes; do
        log "Backing up volumes from container: $container"
        local container_backup="$temp_dir/${container}_volumes.tar.gz"
        docker exec "$container" sh -c 'tar czf - /data /config 2>/dev/null || true' > "$container_backup" 2>/dev/null || true
    done

    tar czf "$BACKUP_FILE" -C "$temp_dir" . 2>/dev/null
    log "Volumes backup completed: $BACKUP_FILE"
}

backup_configs() {
    log "Backing up configuration files..."
    local config_backup="$BACKUP_DIR/configs_$TIMESTAMP.tar.gz"
    tar czf "$config_backup" \
        -C "$PROJECT_DIR" \
        --exclude='data' \
        --exclude='backups' \
        --exclude='.git' \
        --exclude='*.enc' \
        .
    log "Configs backup: $config_backup"

    if [ -n "$ENCRYPT_PASSWORD" ]; then
        log "Encrypting backup..."
        gpg --batch --yes --passphrase "$ENCRYPT_PASSWORD" \
            -c "$BACKUP_FILE" 2>/dev/null && \
        rm "$BACKUP_FILE" && \
        mv "${BACKUP_FILE}.gpg" "$BACKUP_FILE.enc" && \
        log "Backup encrypted successfully"
    fi
}

rotate_backups() {
    log "Rotating backups older than $RETENTION_DAYS days..."
    find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime "+$RETENTION_DAYS" -delete 2>/dev/null || true
    find "$BACKUP_DIR" -name "*.enc" -type f -mtime "+$RETENTION_DAYS" -delete 2>/dev/null || true
    log "Rotation completed"
}

cleanup_old_logs() {
    find "$BACKUP_DIR" -name "backup.log.*" -type f -mtime "+$RETENTION_DAYS" -delete 2>/dev/null || true
}

main() {
    mkdir -p "$BACKUP_DIR"
    load_env
    check_dependencies
    log "=== Backup started ==="

    backup_volumes
    backup_configs
    rotate_backups
    cleanup_old_logs

    log "=== Backup completed successfully ==="
}

main "$@"
