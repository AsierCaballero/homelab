# HomeLab Automation

Infrastructure-as-Code for a personal HomeLab with self-hosted services, automated backups, VPN, monitoring, logging, and CI/CD.

## Stack

| Category | Technologies |
|----------|-------------|
| Orchestration | Docker Compose + Traefik |
| Services | Portainer, AdGuard Home, Uptime Kuma |
| Backups | Bash scripts + GPG encryption + rotation |
| VPN | WireGuard |
| Monitoring | Prometheus + Grafana + cAdvisor + Node Exporter |
| Logging | Loki + Promtail |
| Config Mgmt | Ansible |
| CI/CD | GitHub Actions |

## Quick Start

```bash
git clone https://github.com/youruser/homelab.git && cd homelab
make setup       # Configure .env + create directories
make deploy      # Start all services
make health      # Verify everything is running
```

## Services

| Service | URL | Exposed Port |
|---------|-----|-------------|
| Traefik | traefik.{DOMAIN} | 80, 443 |
| Portainer | portainer.{DOMAIN} | 9000 |
| AdGuard | adguard.{DOMAIN} | 53 (DNS) |
| Uptime Kuma | status.{DOMAIN} | 3001 |
| Grafana | grafana.{DOMAIN} | 3000 |
| Prometheus | prometheus.{DOMAIN} | 9090 |

## Project Structure

```
homelab/
├── ansible/                 # Infrastructure automation
├── configs/                 # Service configurations
│   ├── traefik/
│   ├── prometheus/
│   ├── grafana/
│   ├── loki/
│   ├── promtail/
│   ├── adguard/
│   └── wireguard/
├── scripts/                 # Automation scripts
├── services/                # Standalone compose files
├── docs/                    # Documentation
├── docker-compose.yml       # Core services
├── docker-compose.monitoring.yml
├── docker-compose.logging.yml
└── Makefile
```

## Documentation

- [Architecture](docs/architecture.md)
- [Setup Guide](docs/setup.md)
- [Backup Strategy](docs/backup-strategy.md)
