#!/bin/bash

# Start the Grafana + Prometheus + Loki + OTEL Collector stack for Claude Code monitoring

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Claude Code Grafana monitoring stack..."
docker compose -f "$SCRIPT_DIR/grafana/docker-compose.yml" up -d

echo ""
echo "Stack started successfully!"
echo ""
echo "Access points:"
echo "  - Grafana:    http://localhost:18888 (admin/admin or anonymous)"
echo "  - Prometheus: http://localhost:9090"
echo "  - Loki:       http://localhost:3100 (logs backend)"
echo "  - OTLP gRPC:  localhost:4317"
echo "  - OTLP HTTP:  localhost:4318"
echo ""
echo "The Grafana dashboard includes both metrics and logs from Claude Code."
echo ""
echo "To stop: docker compose -f $SCRIPT_DIR/grafana/docker-compose.yml down"
