# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 1.x     | :white_check_mark: |

## Reporting a Vulnerability

Open an issue for security-related concerns. Response time is typically within 48 hours.

## Security Practices

- All secrets are stored in `.env` (gitignored)
- TLS termination handled by Traefik with Let's Encrypt
- Container images are pinned to specific versions
- Regular security scanning via Trivy in CI
- WireGuard for VPN access to internal services
- GPG encryption for backups
- Minimal exposed ports (only 80/443 via Traefik)
