# Logging Stack

Centralized log collection using Loki and Promtail.

## Services

| Service | Description | Port |
|---------|-------------|------|
| **Loki** | Log aggregation system (Grafana) | 3100 |
| **Promtail** | Log collector and shipper | 9080 |

## Usage

```bash
# Start logging stack
docker compose -f docker-compose.logging.yml up -d

# View logs from all containers in Grafana
# Add Loki datasource: http://loki:3100
```

## Log Sources

Promtail automatically discovers and collects logs from all running Docker containers using the Docker socket.

## Query Examples

In Grafana Explore, select Loki datasource and query:

```logql
# Filter by container name
{container="traefik"}

# Filter by service
{service="prometheus"}

# Filter by log level
{container="traefik"} |= "error"

# Time range filter
{container="nginx"} |= "500" |= "error"
```

## Retention

Logs are retained for 30 days by default. Configure `retention_period` in `configs/loki/loki-config.yml`.
