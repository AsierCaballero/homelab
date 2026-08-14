# Architecture

## Overview

```text
 [Internet]
      |
 [Router/Firewall] (ports 80, 443, 51820/UDP)
      |
 [Traefik] (Reverse Proxy + SSL)
      |
      +-- [Portainer]   (Gestión Docker)
      +-- [AdGuard]     (DNS + Ad Blocking) :53
      +-- [Uptime Kuma] (Monitoreo servicios)
      +-- [Grafana]     (Visualización métricas)
           |
           +-- [Prometheus] (Métricas)
                +-- [cAdvisor]    (Contenedores)
                +-- [Node Exporter] (Sistema)
      |
 [WireGuard VPN] (Acceso remoto seguro)
```

## Network

| Red | Subnet | Uso |
| ----- | -------- | ----- |
| homelab | 172.20.0.0/16 | Comunicación entre servicios Docker |
| VPN | 10.0.0.0/24 | Acceso remoto de clientes |
| Host | 192.168.1.0/24 | Red local física |

## Stack

### Core

- **Traefik**: Reverse proxy con SSL automático (Let's Encrypt)
- **Portainer**: GUI para gestión de contenedores
- **AdGuard Home**: DNS server con bloqueo de anuncios
- **Uptime Kuma**: Monitor de uptime con notificaciones

### Monitoring

- **Prometheus**: Almacenamiento y consulta de métricas
- **cAdvisor**: Métricas de contenedores Docker
- **Node Exporter**: Métricas del sistema host
- **Grafana**: Dashboards y visualización

### Infrastructure

- **WireGuard**: VPN para acceso remoto seguro
- **Ansible**: Automatización de provisioning
- **GitHub Actions**: CI/CD pipeline

### Backup

- Scripts bash de backup/restore
- Cifrado GPG para datos sensibles
- Rotación automática con retención configurable

## Flujo de CI/CD

```text
Git Push → GitHub Actions
              ├── Validate (docker compose, shellcheck, ansible syntax)
              ├── Lint (YAML, Markdown)
              ├── Security (Trivy, TruffleHog)
              ├── Build (pull images, start, health check, test backup)
              └── Deploy (ansible-playbook)
```
