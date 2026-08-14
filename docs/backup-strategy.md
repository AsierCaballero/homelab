# Backup Strategy

## Objetivo

Garantizar la recuperabilidad de todos los datos del HomeLab ante fallos del sistema.

## Frecuencia

| Tipo | Frecuencia | Retención | Destino |
| ------ | ----------- | ----------- | --------- |
| Volúmenes Docker | Diaria (02:00) | 30 días | Local |
| Configuraciones | Diaria (02:30) | 30 días | Local + Git |
| Base de datos | Semanal (domingo) | 90 días | Local |
| Full system | Mensual | 365 días | Externo |

## Componentes incluidos

- **Volúmenes Docker**: Portainer, AdGuard, Grafana, Prometheus, Uptime Kuma
- **Configuraciones**: Traefik, Compose, scripts, Ansible
- **Secretos**: .env cifrado con GPG

## Cifrado

Los backups se cifran con GPG simétrico usando la contraseña definida en `BACKUP_ENCRYPT_PASSWORD`.

```bash
# Descifrar backup
gpg --decrypt backup.enc > backup.tar.gz
```

## Restauración

```bash
# Ver backups disponibles
ls -lh backups/

# Restaurar el más reciente
make restore

# Restaurar uno específico
./scripts/restore.sh --file backups/homelab_backup_20260501_020000.tar.gz
```

## Automatización (cron)

```crontab
# Daily backup at 2 AM
0 2 * * * /home/homelab/scripts/backup.sh >> /home/homelab/backups/backup.log 2>&1
```
