#!/bin/bash

# Start the Grafana + Prometheus + OTEL Collector stack for Claude Code metrics

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
echo "  - OTLP gRPC:  localhost:4317"
echo "  - OTLP HTTP:  localhost:4318"
echo ""
echo "To stop: docker compose -f $SCRIPT_DIR/grafana/docker-compose.yml down"
