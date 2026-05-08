# WireGuard VPN

## Descripción
VPN ligera y rápida para acceso remoto seguro a los servicios del HomeLab.

## Topología

```
[Internet] ──┬── [Servidor Homelab (10.0.0.1)]
             │       ├── Portainer (172.20.0.x:9000)
             │       ├── AdGuard  (172.20.0.3:53)
             │       └── Grafana  (172.20.0.x:3000)
             │
             └── [Clientes VPN (10.0.0.0/24)]
                     ├── Teléfono (10.0.0.2)
                     ├── Laptop   (10.0.0.3)
                     └── Tablet   (10.0.0.4)
```

## Instalación

```bash
# En el servidor
./scripts/setup-vpn.sh

# Generar configuración para cliente
./scripts/setup-vpn.sh mi-telefono
```

## Configuración de cliente

1. Transferir `configs/wireguard/<nombre>.conf` al cliente
2. Importar en la app de WireGuard
3. Activar conexión

## Firewall

Asegurar que el puerto `51820/UDP` está abierto en el router/firewall del servidor.

## Seguridad

- Claves efímeras (Perfect Forward Secrecy)
- Sin logs de tráfico
- Kill switch automático en clientes
- Rotación periódica de claves recomendada
