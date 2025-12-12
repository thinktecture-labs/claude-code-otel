#!/bin/bash

# Start the .NET Aspire Dashboard as a standalone OTEL collector/viewer
# Dashboard UI: http://localhost:18888
# OTLP endpoint: localhost:4317 (gRPC)

docker run --rm -it -d \
    -p 18888:18888 \
    -p 4317:18889 \
    -e ASPIRE_DASHBOARD_UNSECURED_ALLOW_ANONYMOUS=true \
    --name claude-dashboard \
    mcr.microsoft.com/dotnet/aspire-dashboard:latest

echo ""
echo "Aspire Dashboard started!"
echo "  Dashboard UI: http://localhost:18888"
echo "  OTLP endpoint: localhost:4317 (gRPC)"
echo ""
echo "To stop: docker stop claude-dashboard"
