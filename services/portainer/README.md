# Portainer

## Descripción

Interfaz web para gestión visual de contenedores Docker, imágenes, volúmenes y redes.

## Configuración

- Acceso: `https://portainer.{DOMAIN}`
- Puerto interno: 9000
- Persistencia: `./data/portainer`

## Primer uso

1. Acceder a la URL del servicio
2. Crear usuario admin
3. Conectar al entorno Docker local

## Seguridad

- El acceso está protegido por Traefik
- Se recomienda cambiar la contraseña periódicamente
- El socket Docker se monta como read-only
