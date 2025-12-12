# Claude Code OpenTelemetry Monitoring

Monitor your Claude Code usage, costs, and productivity with real-time dashboards. Track how much you're spending, how effectively you're using the AI assistant, and gain insights into your development workflow.

## Why Monitor Claude Code?

Claude Code is a powerful AI coding assistant, but without visibility into your usage, you might be:

- **Overspending** without realizing which models or tasks consume the most tokens
- **Missing optimization opportunities** like cache utilization that can significantly reduce costs
- **Unable to quantify productivity gains** from AI-assisted development
- **Lacking insights** into how you interact with the AI over time

This project provides two dashboard options to give you full observability into your Claude Code sessions.

## What Gets Tracked?

### Cost & Token Metrics
- **Total API Cost** - Real-time spending in USD with per-model breakdown
- **Token Usage** - Input, output, cache read, and cache creation tokens
- **Cost per 1K Output Tokens** - Efficiency metric to track spending trends
- **Cache Efficiency** - Percentage of input served from cache (higher = cheaper)
- **Cost per Commit** - Average API cost per git commit made
- **Cost per 100 LOC** - Average API cost per 100 lines of code accepted

### Productivity Metrics
- **Sessions** - Count of unique Claude Code sessions
- **Commits Made** - Git commits created via Claude Code
- **Lines of Code** - Code accepted from Claude suggestions
- **Active Time (CLI)** - Time Claude spent processing your requests
- **Active Time (You)** - Time you spent interacting with Claude
- **Productivity Ratio** - CLI time / User time (higher means Claude did more autonomous work)
- **Peak Leverage** - Highest productivity ratio achieved

### Time Series Analysis
- Token consumption rates over time by type and model
- Cost accumulation trends
- Activity patterns (CLI vs user time)

## Quick Start

### Option 1: Aspire Dashboard (Simple)

Best for: Quick setup, viewing logs and basic metrics, single-container deployment.

```bash
# Start the Aspire dashboard
./start-aspire-dashboard.sh

# Start Claude Code in this directory (picks up .claude/settings.json)
claude

# Stop dashboard when done
docker stop claude-dashboard
```

**Access:**
- Dashboard UI: http://localhost:18888
- OTLP endpoint: `localhost:4317` (gRPC)

### Option 2: Grafana Stack (Full Featured)

Best for: Rich visualizations, historical data, alerting, production use.

```bash
# Start the Grafana stack (Grafana + Prometheus + Loki + OTEL Collector)
./start-grafana-stack.sh

# Start Claude Code in this directory (picks up .claude/settings.json)
claude

# Stop stack when done
docker compose -f grafana/docker-compose.yml down
```

**Access:**
- Grafana UI: http://localhost:18888 (admin/admin or anonymous access)
- Prometheus: http://localhost:9090
- Loki: http://localhost:3100 (logs backend)
- OTLP endpoint: `localhost:4317` (gRPC) or `localhost:4318` (HTTP)

The Grafana dashboard opens automatically as the home page with all metrics and logs pre-configured.

## Dashboard Comparison

| Feature                    | Aspire Dashboard | Grafana Stack                     |
|----------------------------|------------------|-----------------------------------|
| Setup complexity           | Single container | Four containers (compose)         |
| Metrics visualization      | Basic            | Rich dashboards, graphs, gauges   |
| Logs viewing               | Yes              | Yes (Loki)                        |
| Pre-built Claude dashboard | No               | Yes (metrics + logs)              |
| Custom queries             | Limited          | Full PromQL + LogQL support       |
| Alerting                   | No               | Yes (Grafana alerting)            |
| Data retention             | In-memory        | Persistent (Prometheus + Loki)    |

## Grafana Dashboard Panels

The pre-configured dashboard provides a comprehensive view of your Claude Code usage:

### Top Row - Key Stats

| Panel            | Description                                                                    |
|------------------|--------------------------------------------------------------------------------|
| Sessions         | Total unique Claude Code sessions tracked                                      |
| Commits Made     | Git commits created via Claude Code                                            |
| Lines of Code    | Lines accepted from Claude suggestions                                         |
| Total Cost       | Cumulative API cost in USD (color-coded: green < $10, yellow < $50, red > $50) |
| Active Time (You)| Time you spent interacting with Claude                                         |
| Active Time (CLI)| Time Claude spent processing requests                                          |

### Token Metrics Row

| Panel          | Description                                    |
|----------------|------------------------------------------------|
| Input Tokens   | Tokens sent to Claude (your prompts + context) |
| Output Tokens  | Tokens generated by Claude (responses)         |
| Cache Read     | Tokens served from cache (saves money!)        |
| Cache Creation | Tokens written to cache for future use         |

### Efficiency & Productivity Row

| Panel              | Description                                        |
|--------------------|----------------------------------------------------|
| Cache Efficiency   | Gauge showing % of input from cache (target: >80%) |
| Cost per 1K Output | Average cost efficiency metric                     |
| Productivity Ratio | Gauge showing CLI/User time ratio                  |
| Peak Leverage      | Highest productivity ratio achieved                |
| Cost per Commit    | Average API cost per git commit made               |
| Cost per 100 LOC   | Average API cost per 100 lines of code accepted    |

### Distribution Charts

| Panel                    | Description                              |
|--------------------------|------------------------------------------|
| Tokens by Type           | Donut chart breaking down token usage    |
| Tokens by Model          | Donut chart showing which models you use |
| Active Time Distribution | CLI vs User time comparison              |
| Cost by Model            | Bar gauge showing spend per model        |

### Time Series (Bottom)

| Panel                 | Description                        |
|-----------------------|------------------------------------|
| Token Usage Over Time | Rate of token consumption by type  |
| Token Usage by Model  | Rate of token consumption by model |
| Cost Over Time        | Cost accumulation rate ($/5min)    |
| Active Time Over Time | CLI and User activity rates        |

### Logs Panel

| Panel            | Description                                             |
|------------------|---------------------------------------------------------|
| Claude Code Logs | Live streaming logs from Claude Code sessions via Loki  |

The logs panel displays structured logs from your Claude Code sessions with automatic JSON parsing, allowing you to:
- View real-time log output as you interact with Claude
- Search and filter logs using LogQL queries (e.g., `{exporter="OTLP"} |= "error"`)
- Extract structured fields from JSON logs with `| json`
- Correlate log events with metric spikes
- Debug issues by examining detailed session activity

## Configuration

### How It Works

The `.claude/settings.json` file in this directory configures Claude Code to export telemetry via OpenTelemetry (OTLP). When you run `claude` from this directory, it automatically picks up these settings.

### Environment Variables

| Variable                               | Value                       | Description                      |
|----------------------------------------|-----------------------------|----------------------------------|
| `CLAUDE_CODE_ENABLE_TELEMETRY`         | `1`                         | Enable telemetry export          |
| `OTEL_EXPORTER_OTLP_ENDPOINT`          | `http://localhost:4317`     | OTLP collector endpoint          |
| `OTEL_EXPORTER_OTLP_PROTOCOL`          | `grpc`                      | Use gRPC protocol                |
| `OTEL_METRICS_EXPORTER`                | `otlp`                      | Export metrics via OTLP          |
| `OTEL_METRIC_EXPORT_INTERVAL`          | `10000`                     | Metric export interval (10s)     |
| `OTEL_METRICS_INCLUDE_SESSION_ID`      | `1`                         | Include session ID in metrics    |
| `OTEL_SERVICE_NAME`                    | `claude-code`               | Service name for telemetry       |

### Using in Other Projects

To monitor Claude Code in a different directory, either:

1. **Copy the settings file:**
   ```bash
   cp -r .claude /path/to/your/project/
   ```

2. **Or set environment variables globally** in your shell profile:
   ```bash
   export CLAUDE_CODE_ENABLE_TELEMETRY=1
   export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
   # ... other variables
   ```

## Architecture

### Aspire Dashboard

Simple single-container setup that receives OTLP data directly:

```
Claude Code  ──OTLP──▶  Aspire Dashboard (logs + metrics)
                              │
                              ▼
                        localhost:18888
```

### Grafana Stack

Full observability stack with persistent storage for metrics and logs:

```
                                              ┌──────────────┐
                                         ┌───▶│  Prometheus  │───┐
                                         │    │    :9090     │   │
Claude Code  ──OTLP──▶  OTEL Collector ──┤    └──────────────┘   ├──▶  Grafana
                           :4317         │                       │      :18888
                                         │    ┌──────────────┐   │
                                         └───▶│     Loki     │───┘
                                              │    :3100     │
                                              └──────────────┘
```

**Components:**
- **OTEL Collector** - Receives OTLP data, routes metrics to Prometheus and logs to Loki
- **Prometheus** - Stores metrics, provides PromQL queries
- **Loki** - Stores logs, provides LogQL queries
- **Grafana** - Unified dashboard for metrics and logs

## Troubleshooting

### No data appearing in dashboards

1. **Check Claude Code is exporting telemetry:**
   ```bash
   # Look for OTEL-related output when starting claude
   claude --debug
   ```

2. **Verify the collector is receiving data:**
   ```bash
   # For Grafana stack, check collector logs
   docker logs claude-otel-collector
   ```

3. **Check Prometheus targets (Grafana stack):**
   - Open http://localhost:9090/targets
   - Verify `otel-collector` target is UP

4. **Check Loki is receiving logs:**
   ```bash
   # Check Loki logs
   docker logs claude-loki

   # Query Loki directly
   curl -s "http://localhost:3100/loki/api/v1/labels" | jq
   ```

### No logs appearing

1. **Verify the OTEL Collector is forwarding logs:**
   ```bash
   docker logs claude-otel-collector | grep -i loki
   ```

2. **Check Loki is healthy:**
   ```bash
   curl -s http://localhost:3100/ready
   ```

3. **Query logs directly:**
   ```bash
   curl -G -s "http://localhost:3100/loki/api/v1/query_range" \
     --data-urlencode 'query={exporter="OTLP"}' | jq
   ```

### Metrics are delayed

- Metrics are exported every 10 seconds by default (`OTEL_METRIC_EXPORT_INTERVAL`)
- Prometheus scrapes every 15 seconds
- Grafana dashboard refreshes every 30 seconds
- Total latency: up to ~55 seconds for new metrics to appear

### Container won't start

```bash
# Check if ports are already in use
lsof -i :18888
lsof -i :4317

# Stop conflicting containers
docker stop claude-dashboard claude-grafana
```

## Resources

- [Claude Code Monitoring Documentation](https://docs.anthropic.com/en/docs/claude-code/monitoring)
- [Aspire Dashboard Standalone](https://learn.microsoft.com/en-us/dotnet/aspire/fundamentals/dashboard/standalone)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Grafana Loki Documentation](https://grafana.com/docs/loki/latest/)
- [LogQL Query Language](https://grafana.com/docs/loki/latest/logql/)
- [Grafana Dashboard JSON](https://gist.github.com/yangchuansheng/dfd65826920eeb76f19a019db2827d62) (dashboard source)
