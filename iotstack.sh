#!/bin/bash

# Define the base directory
BASE_DIR="/iotstackdata"

# Check if base directory exists, if not create it
if [ ! -d "$BASE_DIR" ]; then
  echo "Creating $BASE_DIR..."
  mkdir -p "$BASE_DIR"
  # Set the permissions to 777
  chmod 777 "$BASE_DIR"
fi

# Define directories to create
declare -a DIRS=(
  "$BASE_DIR/grafana/data"
  "$BASE_DIR/grafana/config"
  "$BASE_DIR/grafana/logos"
  "$BASE_DIR/telegraf"
  "$BASE_DIR/mosquitto/config"
  "$BASE_DIR/mosquitto/data"
  "$BASE_DIR/mosquitto/log"
  "$BASE_DIR/letsencrypt"
  "$BASE_DIR/nginx-proxy-manager/data"
)

# Loop over directories and create them if they do not exist
for dir in "${DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Creating $dir..."
    mkdir -p "$dir"
    # Set the permissions to 777
    chmod 777 "$dir"
  fi
done

# Copy initial configuration files from the current directory
echo "Copying initial configuration files..."
cp -r ./iotstackdata/* $BASE_DIR/
# Set the permissions for the copied files to 777
find $BASE_DIR -type f -exec chmod 777 {} \;

# Start Docker Compose services
echo "Starting Docker Compose services..."
docker stack deploy

# wait for Grafana to start
sleep 30

# Create the InfluxDB data source
curl -X POST -H "Content-Type: application/json" -d '{
    "name": "InfluxDB",
    "type": "influxdb",
    "url": "http://influxdb:8086",
    "access": "proxy",
    "database": "profec",
    "user": "myuser",
    "secureJsonData": {
        "token": "mytoken"
    },
    "jsonData": {
        "version": "Flux",
        "organization": "myorg"
    }
}' http://admin:admin@grafana:3000/api/datasources
