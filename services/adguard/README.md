# AdGuard Home

## Descripción

Servidor DNS con bloqueo de anuncios y rastreadores a nivel de red. Protege todos los dispositivos del HomeLab.

## Configuración

- Interfaz web: `https://adguard.{DOMAIN}`
- DNS: Puerto 53 (TCP/UDP)
- Puerto admin: 80 (interno)

## Instalación inicial

1. Acceder a `http://{IP_SERVIDOR}:8080/install.html` (primera vez)
2. Configurar interfaz de admin en `0.0.0.0:80`
3. Configurar upstream DNS (Cloudflare 1.1.1.1, Google 8.8.8.8)

## Listas de bloqueo recomendadas

| Lista | URL |
|-------|-----|
| StevenBlack | <https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts> |
| OISD Full | <https://big.oisd.nl/> |
| AdGuard DNS | <https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt> |

## Rendimiento

- Cache DNS: habilitado (4GB RAM recomendado para el servidor)
- Modo paralelo: consultas concurrentes a todos los upstreams
