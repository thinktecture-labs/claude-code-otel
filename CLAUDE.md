# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository provides OpenTelemetry-based monitoring infrastructure for tracking Claude Code usage, costs, and productivity. It offers two dashboard options:
- **Aspire Dashboard** - Single-container setup for quick metrics/logs viewing
- **Grafana Stack** - Full observability with Prometheus, Loki, and pre-built dashboards

## Common Commands

### Start Aspire Dashboard (Simple)
```bash
./start-aspire-dashboard.sh
# Stop: docker stop claude-dashboard
```

### Start Grafana Stack (Full Featured)
```bash
./start-grafana-stack.sh
# Stop: docker compose -f grafana/docker-compose.yml down
```

### View Container Logs
```bash
docker logs claude-otel-collector
docker logs claude-loki
docker logs claude-prometheus
docker logs claude-grafana
```

## Architecture

### Grafana Stack Data Flow
```
Claude Code → OTLP (4317/4318) → OTEL Collector → Prometheus (metrics)
                                               → Loki (logs)
                                               → Grafana (18888)
```

### Key Components
- **OTEL Collector** (`otel-collector-config.yaml`) - Receives OTLP data, routes metrics to Prometheus and logs to Loki
- **Prometheus** (`prometheus.yml`) - Scrapes metrics from OTEL collector on port 8889
- **Loki** - Log aggregation with LogQL query support
- **Grafana** - Unified dashboard with pre-configured datasources

### Configuration Files
- `.claude/settings.json` - Claude Code telemetry environment variables
- `grafana/docker-compose.yml` - Docker Compose stack definition
- `grafana/otel-collector-config.yaml` - OTLP receiver, processors, and exporters
- `grafana/prometheus.yml` - Prometheus scrape config
- `grafana/provisioning/datasources/datasources.yml` - Grafana datasource definitions
- `grafana/dashboards/claude-code-metrics.json` - Pre-built Grafana dashboard

### Ports
| Service | Port |
|---------|------|
| Grafana | 18888 |
| OTLP gRPC | 4317 |
| OTLP HTTP | 4318 |
| Prometheus | 9090 |
| Loki | 3100 |
| OTEL Metrics Export | 8889 |
