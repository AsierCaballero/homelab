# Uptime Kuma

## Descripción
Monitor de uptime para servicios del HomeLab. Notificaciones en tiempo real cuando un servicio falla.

## Configuración

- Panel: `https://status.{DOMAIN}`
- Puerto interno: 3001

## Monitores recomendados

| Servicio | URL/Tipo | Intervalo |
|----------|----------|-----------|
| Traefik | https://traefik.{DOMAIN} | 60s |
| Portainer | https://portainer.{DOMAIN} | 60s |
| AdGuard | https://adguard.{DOMAIN} | 60s |
| Ping gateway | Ping 172.20.0.1 | 30s |
| DNS | DNS lookup | 30s |

## Notificaciones

Soportados:
- Telegram
- Discord
- Email (SMTP)
- Webhook
- Pushover

## Backup

Los datos se almacenan en `./data/uptime-kuma`. Incluir en el backup diario.
