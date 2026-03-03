# HomeLab Automation

Infrastructure-as-Code para un HomeLab personal con servicios autogestionados, backups automatizados, VPN, monitoreo y CI/CD.

## Stack

- **Orquestación**: Docker Compose + Traefik
- **Servicios**: Portainer, AdGuard Home, Uptime Kuma
- **Backups**: Scripts bash automatizados con rotación y cifrado
- **VPN**: WireGuard
- **Monitoreo**: Prometheus + Grafana + cAdvisor
- **Config Management**: Ansible
- **CI/CD**: GitHub Actions

## Requisitos

- Docker Engine >= 24.x
- Docker Compose >= 2.20
- Make
- WireGuard (opcional)
- Ansible (opcional, para gestión multi-servidor)

## Uso rápido

```bash
make setup
make deploy
make health
```
