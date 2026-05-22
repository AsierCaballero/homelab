# HomeLab Automation Setup Guide

## Prerrequisitos

- Docker Engine >= 24.x
- Docker Compose >= 2.20
- Git
- Make

## Instalación Rápida

```bash
# Clonar repositorio
git clone https://github.com/youruser/homelab.git
cd homelab

# Configurar variables de entorno
make setup

# Desplegar servicios
make deploy

# Verificar estado
make health
```

## Configuración

### Variables de Entorno

Editar `.env` con los valores adecuados:

| Variable | Descripción | Default |
|----------|-------------|---------|
| `DOMAIN` | Dominio base del HomeLab | `homelab.local` |
| `TZ` | Zona horaria | `UTC` |
| `BACKUP_RETENTION_DAYS` | Días de retención de backups | `30` |
| `GRAFANA_ADMIN_PASSWORD` | Password de Grafana | `changeme` |

### Servicios por Separado

Cada servicio tiene su propio `docker-compose.yml` en `services/<nombre>/`:

```bash
# Desplegar solo Portainer
docker compose -f services/portainer/docker-compose.yml up -d
```

## Comandos

| Comando | Descripción |
|---------|-------------|
| `make setup` | Configuración inicial |
| `make deploy` | Desplegar todos los servicios |
| `make stop` | Detener servicios |
| `make logs` | Ver logs en tiempo real |
| `make health` | Ejecutar health check |
| `make backup` | Realizar backup manual |
| `make restore` | Restaurar último backup |
| `make lint` | Validar docker-compose |

## VPN (Acceso Remoto)

```bash
# En el servidor
./scripts/setup-vpn.sh

# Generar config para un cliente
./scripts/setup-vpn.sh mi-dispositivo
```

## Monitoreo

- **Grafana**: `https://grafana.{DOMAIN}` (admin/changeme)
- **Prometheus**: `https://prometheus.{DOMAIN}`
- **Uptime Kuma**: `https://status.{DOMAIN}`

## Backups

Los backups se ejecutan automáticamente via cron (02:00 AM) e incluyen:
- Volúmenes de todos los contenedores
- Archivos de configuración
- Cifrado GPG de datos sensibles

## Actualización

```bash
git pull
make deploy
```
