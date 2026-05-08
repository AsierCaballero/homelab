#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$PROJECT_DIR/configs/wireguard"
ENV_FILE="$PROJECT_DIR/.env"

load_env() {
    if [ -f "$ENV_FILE" ]; then
        export $(grep -v '^#' "$ENV_FILE" | xargs)
    fi
}

install_wireguard() {
    if command -v wg &>/dev/null; then
        echo "[VPN] WireGuard already installed"
        return
    fi

    echo "[VPN] Installing WireGuard..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y wireguard wireguard-tools
    elif command -v brew &>/dev/null; then
        brew install wireguard-tools
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y wireguard-tools
    else
        echo "[VPN] ERROR: Package manager not supported"
        exit 1
    fi
}

generate_keys() {
    if [ -f "$CONFIG_DIR/server.key" ]; then
        echo "[VPN] Server keys already exist"
        return
    fi

    echo "[VPN] Generating server keys..."
    mkdir -p "$CONFIG_DIR"
    wg genkey | tee "$CONFIG_DIR/server.key" | wg pubkey > "$CONFIG_DIR/server.pub"
    chmod 600 "$CONFIG_DIR/server.key"
    echo "[VPN] Server public key: $(cat $CONFIG_DIR/server.pub)"
}

generate_client_config() {
    local client_name="${1:-client}"
    local client_priv=$(wg genkey)
    local client_pub=$(echo "$client_priv" | wg pubkey)
    local server_pub=$(cat "$CONFIG_DIR/server.pub")
    local server_endpoint="${SERVER_ENDPOINT:-homelab.local}:${WIREGUARD_PORT:-51820}"
    local network="${WIREGUARD_NETWORK:-10.0.0.0/24}"
    local client_ip="${CLIENT_IP:-10.0.0.2}"

    cat > "$CONFIG_DIR/${client_name}.conf" << EOF
[Interface]
PrivateKey = $client_priv
Address = $client_ip/24
DNS = 172.20.0.3, 1.1.1.1

[Peer]
PublicKey = $server_pub
Endpoint = $server_endpoint
AllowedIPs = $network, 172.20.0.0/16
PersistentKeepalive = 25
EOF

    echo "[VPN] Client config generated: $CONFIG_DIR/${client_name}.conf"
    echo "[VPN] Add the following to the server config:"
    echo "  [Peer]"
    echo "  PublicKey = $client_pub"
    echo "  AllowedIPs = $client_ip/32"
}

main() {
    load_env
    install_wireguard
    generate_keys

    if [ $# -gt 0 ]; then
        generate_client_config "$1"
    else
        echo "[VPN] Usage: $0 [client-name]"
        echo "[VPN] Server setup complete. Add clients with: $0 my-phone"
    fi
}

main "$@"
