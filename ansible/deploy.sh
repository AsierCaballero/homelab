#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")/ansible"

usage() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  setup     Run initial server setup playbook"
    echo "  deploy    Deploy all services"
    echo "  update    Update services to latest versions"
    echo "  check     Dry-run deploy playbook"
    exit 1
}

check_ansible() {
    if ! command -v ansible-playbook &>/dev/null; then
        echo "ERROR: ansible-playbook not found. Install Ansible first."
        exit 1
    fi
}

case "${1:-help}" in
    setup)
        check_ansible
        ansible-playbook -i "$ANSIBLE_DIR/inventory.yml" "$ANSIBLE_DIR/playbooks/setup-server.yml"
        ;;
    deploy)
        check_ansible
        ansible-playbook -i "$ANSIBLE_DIR/inventory.yml" "$ANSIBLE_DIR/playbooks/deploy-services.yml"
        ;;
    update)
        check_ansible
        ansible-playbook -i "$ANSIBLE_DIR/inventory.yml" "$ANSIBLE_DIR/playbooks/deploy-services.yml" -e "docker_pull=always"
        ;;
    check)
        check_ansible
        ansible-playbook -i "$ANSIBLE_DIR/inventory.yml" "$ANSIBLE_DIR/playbooks/deploy-services.yml" --check --diff
        ;;
    *)
        usage
        ;;
esac
