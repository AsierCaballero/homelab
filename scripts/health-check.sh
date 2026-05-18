#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/.env"
DOCKER_COMPOSE="$PROJECT_DIR/docker-compose.yml"
MONITORING_COMPOSE="$PROJECT_DIR/docker-compose.monitoring.yml"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

print_status() {
    local status=$1
    local message=$2
    case $status in
        PASS) echo -e "  ${GREEN}✓${NC} $message"; ((PASS++)) ;;
        FAIL) echo -e "  ${RED}✗${NC} $message"; ((FAIL++)) ;;
        WARN) echo -e "  ${YELLOW}⚠${NC} $message"; ((WARN++)) ;;
    esac
}

check_docker() {
    echo "--- Docker ---"
    if docker info &>/dev/null; then
        print_status PASS "Docker daemon is running"
    else
        print_status FAIL "Docker daemon is not running"
        return
    fi

    local compose_files=("$DOCKER_COMPOSE")
    [ -f "$MONITORING_COMPOSE" ] && compose_files+=("$MONITORING_COMPOSE")

    for compose in "${compose_files[@]}"; do
        local project_name=$(basename "$(dirname "$compose")")
        if [ "$project_name" = "." ]; then project_name="homelab"; fi

        if docker compose -f "$compose" config &>/dev/null; then
            print_status PASS "Compose file valid: $(basename $compose)"
        else
            print_status FAIL "Compose file invalid: $(basename $compose)"
        fi
    done
}

check_containers() {
    echo "--- Containers ---"
    local compose_files=("$DOCKER_COMPOSE")
    [ -f "$MONITORING_COMPOSE" ] && compose_files+=("$MONITORING_COMPOSE")

    for compose in "${compose_files[@]}"; do
        while IFS= read -r service; do
            [ -z "$service" ] && continue
            local container_name="${service}_1"
            if docker ps --format '{{.Names}}' | grep -q "$container_name"; then
                local status=$(docker inspect "$container_name" --format '{{.State.Status}}' 2>/dev/null)
                if [ "$status" = "running" ]; then
                    local health=$(docker inspect "$container_name" --format '{{.State.Health.Status}}' 2>/dev/null)
                    if [ "$health" = "healthy" ] || [ -z "$health" ] || [ "$health" = "<nil>" ]; then
                        print_status PASS "Container $service is running"
                    else
                        print_status WARN "Container $service is $status (health: $health)"
                    fi
                else
                    print_status FAIL "Container $service is $status"
                fi
            else
                print_status WARN "Container $service is not running"
            fi
        done < <(docker compose -f "$compose" config --services 2>/dev/null)
    done
}

check_resources() {
    echo "--- System Resources ---"
    local cpu=$(ps -A -o %cpu | awk '{s+=$1} END {print int(s)}')
    if [ "$cpu" -lt 80 ]; then
        print_status PASS "CPU usage: $cpu%"
    else
        print_status WARN "High CPU usage: $cpu%"
    fi

    local mem_used=$(vm_stat 2>/dev/null | awk '/Pages active/ {print $3}' | sed 's/\.//' || echo "0")
    local mem_free=$(vm_stat 2>/dev/null | awk '/Pages free/ {print $3}' | sed 's/\.//' || echo "0")
    local mem_total=$((mem_used + mem_free))
    if [ "$mem_total" -gt 0 ]; then
        local mem_pct=$((mem_used * 100 / mem_total))
        if [ "$mem_pct" -lt 85 ]; then
            print_status PASS "Memory usage: $mem_pct%"
        else
            print_status WARN "High memory usage: $mem_pct%"
        fi
    fi

    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$disk_usage" -lt 80 ]; then
        print_status PASS "Disk usage: $disk_usage%"
    elif [ "$disk_usage" -lt 95 ]; then
        print_status WARN "Disk usage: $disk_usage%"
    else
        print_status FAIL "Critical disk usage: $disk_usage%"
    fi
}

check_network() {
    echo "--- Network ---"
    if docker network inspect homelab &>/dev/null; then
        print_status PASS "Docker network 'homelab' exists"
    else
        print_status FAIL "Docker network 'homelab' does not exist"
    fi

    local interfaces=$(ifconfig -l 2>/dev/null || echo "")
    if echo "$interfaces" | grep -q "utun\|wg"; then
        print_status PASS "VPN interface detected"
    else
        print_status WARN "No VPN interface detected"
    fi
}

check_backups() {
    echo "--- Backups ---"
    local backup_dir="${BACKUP_DIR:-$PROJECT_DIR/backups}"
    if [ -d "$backup_dir" ]; then
        local recent=$(find "$backup_dir" -name "*.tar.gz" -mtime -1 2>/dev/null | head -1)
        if [ -n "$recent" ]; then
            print_status PASS "Recent backup found: $(basename "$recent")"
        else
            local any=$(find "$backup_dir" -name "*.tar.gz" 2>/dev/null | head -1)
            if [ -n "$any" ]; then
                print_status WARN "Backups exist but none from today"
            else
                print_status WARN "No backups found"
            fi
        fi
    else
        print_status WARN "Backup directory does not exist"
    fi
}

main() {
    echo "================================"
    echo " HomeLab Health Check"
    echo " $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================"
    echo

    check_docker
    echo
    check_containers
    echo
    check_resources
    echo
    check_network
    echo
    check_backups
    echo
    echo "--- Summary ---"
    echo "  Passed: $PASS"
    echo "  Failed: $FAIL"
    echo "  Warnings: $WARN"
    echo "================================"

    [ "$FAIL" -eq 0 ]
}

main "$@"
