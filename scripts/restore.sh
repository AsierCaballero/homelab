#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="${BACKUP_DIR:-$PROJECT_DIR/backups}"

usage() {
    echo "Usage: $0 [--file <backup.tar.gz>] [--latest]"
    echo "  --file <path>  Restore from specific backup file"
    echo "  --latest       Restore from most recent backup"
    exit 1
}

restore_volumes() {
    local backup_file="$1"
    local temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT

    echo "[RESTORE] Extracting backup: $backup_file"
    tar xzf "$backup_file" -C "$temp_dir"

    for vol_backup in "$temp_dir"/*_volumes.tar.gz; do
        [ -f "$vol_backup" ] || continue
        local container_name=$(basename "$vol_backup" _volumes.tar.gz)
        echo "[RESTORE] Restoring volumes for container: $container_name"

        docker compose -f "$PROJECT_DIR/docker-compose.yml" up -d "$container_name" 2>/dev/null || true
        docker cp "$vol_backup" "${container_name}:/tmp/volumes_restore.tar.gz" 2>/dev/null || true
        docker exec "$container_name" tar xzf "/tmp/volumes_restore.tar.gz" -C / 2>/dev/null || true
    done

    echo "[RESTORE] Volumes restored successfully"
}

main() {
    local backup_file=""

    while [ $# -gt 0 ]; do
        case "$1" in
            --file) backup_file="$2"; shift 2 ;;
            --latest) backup_file=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -1) ; shift ;;
            *) usage ;;
        esac
    done

    if [ -z "$backup_file" ]; then
        echo "[RESTORE] No backup file specified"
        usage
    fi

    if [ ! -f "$backup_file" ]; then
        echo "[RESTORE] ERROR: File not found: $backup_file"
        exit 1
    fi

    echo "[RESTORE] === Restore started ==="
    restore_volumes "$backup_file"
    echo "[RESTORE] === Restore completed ==="
}

main "$@"
