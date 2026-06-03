[![CI](https://img.shields.io/badge/CI-passing-brightgreen)]()
[![License](https://img.shields.io/badge/license-MIT-blue)]()
[![Ansible](https://img.shields.io/badge/Ansible-8.x-red)]()
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED)]()

# Homelab Automation

Infrastructure-as-Code for my personal home server -- self-hosted services, automated backups, a WireGuard VPN, monitoring dashboards, and CI/CD pipelines orchestrated through GitHub Actions.

## What's in the stack

| Category | What I use |
|----------|-----------|
| Orchestration | Docker Compose + Traefik (reverse proxy with automatic TLS) |
| Management UI | Portainer |
| DNS/Ad-blocking | AdGuard Home |
| Uptime monitoring | Uptime Kuma |
| Backups | Bash scripts + GPG encryption + rotation policies |
| VPN | WireGuard |
| Monitoring | Prometheus + Grafana + cAdvisor + Node Exporter |
| Logging | Loki + Promtail |
| Config management | Ansible |
| CI/CD | GitHub Actions |

## Quick start

```bash
git clone https://github.com/AsierCaballero/homelab.git && cd homelab
make setup       # copies .env.example, creates required directories
make deploy      # spins up all core services
make health      # checks that everything is actually running
```

If you want the monitoring stack or logging alongside:

```bash
make up-monitoring   # Prometheus, Grafana, cAdvisor, Node Exporter
make up-logging      # Loki + Promtail
```

## Project layout

```
homelab/
├── .github/workflows/    # CI/CD pipeline definitions
├── ansible/              # automation playbooks for provisioning
├── configs/              # service configs
│   ├── traefik/
│   ├── prometheus/
│   ├── grafana/
│   ├── adguard/
│   └── wireguard/
├── scripts/              # utility scripts
│   ├── backup.sh
│   ├── restore.sh
│   ├── deploy.sh
│   ├── health-check.sh
│   └── setup-vpn.sh
├── services/             # standalone compose files
│   ├── portainer/
│   ├── traefik/
│   └── uptime-kuma/
├── docs/                 # documentation
├── backups/              # encrypted backup destination
├── docker-compose.yml
├── docker-compose.monitoring.yml
├── docker-compose.logging.yml
├── Makefile
└── .env.example
```

## Services and endpoints

| Service | URL (internal) | Exposed port(s) |
|---------|---------------|----------------|
| Traefik | traefik.{DOMAIN} | 80, 443 |
| Portainer | portainer.{DOMAIN} | 9000 |
| AdGuard Home | adguard.{DOMAIN} | 53 (DNS) |
| Uptime Kuma | status.{DOMAIN} | 3001 |
| Grafana | grafana.{DOMAIN} | 3000 |
| Prometheus | prometheus.{DOMAIN} | 9090 |
| Loki | -- | 3100 (internal only) |

Most of these sit behind Traefik so you only need port 443 open to the outside (plus 51820 for WireGuard). The monitoring ports stay internal unless you explicitly expose them.

## Documentation

- [Setup Guide](docs/setup.md) -- step-by-step installation
- [Architecture](docs/architecture.md) -- system design and decisions
- [Backup Strategy](docs/backup-strategy.md) -- rotation, encryption, restore flow
- [Logging](docs/logging.md) -- Loki + Promtail setup and query cheatsheet
