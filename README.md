# HomeLab Automation

Infrastructure-as-Code para un HomeLab personal con servicios autogestionados, backups automatizados, VPN, monitoreo y CI/CD.

## Stack

| Categoría | Tecnologías |
|-----------|-------------|
| Orquestación | Docker Compose + Traefik |
| Servicios | Portainer, AdGuard Home, Uptime Kuma |
| Backups | Bash scripts + GPG encryption + rotación |
| VPN | WireGuard |
| Monitoreo | Prometheus + Grafana + cAdvisor + Node Exporter |
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

## Project Structure

```
📦 homelab
├── 📂 .github/workflows/   # CI/CD pipeline
├── 📂 ansible/             # Infrastructure automation
├── 📂 configs/             # Service configurations
│   ├── traefik/
│   ├── prometheus/
│   ├── grafana/
│   ├── adguard/
│   └── wireguard/
├── 📂 scripts/             # Automation scripts
│   ├── backup.sh
│   ├── restore.sh
│   ├── deploy.sh
│   ├── health-check.sh
│   └── setup-vpn.sh
├── 📂 services/            # Standalone compose files
│   ├── portainer/
│   ├── traefik/
│   └── uptime-kuma/
├── 📂 docs/                # Documentation
├── 📂 backups/             # Encrypted backups
├── docker-compose.yml      # Core services
├── docker-compose.monitoring.yml
├── Makefile
└── .env.example
```

## Servicios

| Servicio | URL | Puerto expuesto |
|----------|-----|----------------|
| Traefik | traefik.{DOMAIN} | 80, 443 |
| Portainer | portainer.{DOMAIN} | 9000 |
| AdGuard | adguard.{DOMAIN} | 53 (DNS) |
| Uptime Kuma | status.{DOMAIN} | 3001 |
| Grafana | grafana.{DOMAIN} | 3000 |
| Prometheus | prometheus.{DOMAIN} | 9090 |
| Loki | — | 3100 (internal) |

## Documentación

- [Setup Guide](docs/setup.md) - Instalación y configuración
- [Architecture](docs/architecture.md) - Diseño del sistema
- [Backup Strategy](docs/backup-strategy.md) - Políticas de backup
- [Logging](docs/logging.md) - Stack de logging (Loki + Promtail)
