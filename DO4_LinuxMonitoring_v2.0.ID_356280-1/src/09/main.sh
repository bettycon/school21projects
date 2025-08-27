#!/bin/bash
# System Metrics Exporter for Prometheus

METRICS_DIR="/home/user3/src/09"
METRICS_FILE="$METRICS_DIR/metrics.prom"
HTML_FILE="$METRICS_DIR/index.html"

# Create directory with correct permissions
mkdir -p "$METRICS_DIR"
chmod 755 "$METRICS_DIR"

echo "Starting System Metrics Exporter..."
echo "Metrics directory: $METRICS_DIR"
echo "Press Ctrl+C to stop"

while true; do
    # Generate metrics in Prometheus format
    (
        umask 022
        cat > "$METRICS_FILE" << PROM
# HELP system_cpu_load CPU load average (1 minute)
# TYPE system_cpu_load gauge
system_cpu_load $(awk '{print $1}' /proc/loadavg)

# HELP system_memory_total Total memory in bytes
# TYPE system_memory_total gauge
system_memory_total $(free -b | awk '/Mem:/ {print $2}')

# HELP system_memory_available Available memory in bytes  
# TYPE system_memory_available gauge
system_memory_available $(free -b | awk '/Mem:/ {print $7}')

# HELP system_disk_total Total disk space in bytes
# TYPE system_disk_total gauge
system_disk_total $(df -B1 / | awk 'NR==2 {print $2}')

# HELP system_disk_used Used disk space in bytes
# TYPE system_disk_used gauge
system_disk_used $(df -B1 / | awk 'NR==2 {print $3}')

# HELP system_disk_available Available disk space in bytes
# TYPE system_disk_available gauge
system_disk_available $(df -B1 / | awk 'NR==2 {print $4}')

# HELP system_metrics_timestamp Unix timestamp of metrics collection
# TYPE system_metrics_timestamp gauge
system_metrics_timestamp $(date +%s)
PROM
    )

    # Generate HTML page for viewing
    (
        umask 022
        cat > "$HTML_FILE" << HTML
<!DOCTYPE html>
<html>
<head>
    <title>System Metrics Exporter</title>
    <meta http-equiv="refresh" content="3">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        pre { background: #f4f4f4; padding: 10px; border-radius: 5px; }
        .metric { margin: 10px 0; padding: 10px; background: #f0f0f0; border-radius: 5px; }
        .timestamp { color: #666; font-size: 0.9em; }
    </style>
</head>
<body>
    <h1>System Metrics Exporter</h1>
    <div class="timestamp">Last updated: $(date)</div>
    
    <div class="metric">
        <strong>CPU Load (1min):</strong> $(awk '{print $1}' /proc/loadavg)
    </div>
    
    <div class="metric">
        <strong>Memory:</strong> Total: $(free -h | awk '/Mem:/ {print $2}'), 
        Available: $(free -h | awk '/Mem:/ {print $7}')
    </div>
    
    <div class="metric">
        <strong>Disk (/):</strong> Total: $(df -h / | awk 'NR==2 {print $2}'), 
        Used: $(df -h / | awk 'NR==2 {print $3}'), 
        Available: $(df -h / | awk 'NR==2 {print $4}')
    </div>
    
    <h2>Raw Prometheus Metrics:</h2>
    <pre>$(cat "$METRICS_FILE")</pre>
    
    <p><a href="/metrics.prom">Direct link to metrics (for Prometheus)</a></p>
</body>
</html>
HTML
    )

    echo "Metrics updated at $(date)"
    sleep 3
done
