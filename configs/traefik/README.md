# Traefik Reverse Proxy

## Descripción

Traefik es un reverse proxy moderno que descubre automáticamente los servicios via Docker y gestiona
certificados SSL con Let's Encrypt.

## Configuración

### traefik.yml

Configuración principal del proxy:

- EntryPoints: web (80) y websecure (443)
- Redirección automática HTTP → HTTPS
- Provider Docker para service discovery
- Resolver Let's Encrypt con HTTP challenge

### config.yml

Middlewares compartidos:

- **auth**: Basic Auth para dashboards sensibles

## Uso

```bash
docker compose up -d traefik
```

Los servicios se exponen automáticamente añadiendo labels Docker:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.mi-servicio.rule=Host(`midominio.local`)"
```

## Seguridad

- El archivo `acme.json` contiene los certificados SSL y debe tener permisos `600`
- El dashboard de Traefik está protegido con Basic Auth
- Todos los servicios internos se comunican via la red `homelab`
