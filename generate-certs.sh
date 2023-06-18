#!/bin/bash

# Define the base directory
BASE_DIR="/iotstackdata/mosquitto/certs"

# Create base directory if it doesn't exist
mkdir -p "$BASE_DIR"

# Prompt user for input
echo "Enter the Common Name (CN) for the CA certificate:"
read -r CA_CN

echo "Enter the Common Name (CN) for the server certificate:"
read -r SERVER_CN

# Generate CA certificate and private key
openssl req -new -x509 -days 365 -keyout "$BASE_DIR/ca.key" -out "$BASE_DIR/ca.crt" -subj "/CN=$CA_CN"

# Generate server certificate signing request (CSR) and private key
openssl req -new -sha256 -keyout "$BASE_DIR/server.key" -out "$BASE_DIR/server.csr" -subj "/CN=$SERVER_CN"

# Sign the server CSR with the CA certificate and key to obtain the server certificate
openssl x509 -req -in "$BASE_DIR/server.csr" -CA "$BASE_DIR/ca.crt" -CAkey "$BASE_DIR/ca.key" -CAcreateserial -out "$BASE_DIR/server.crt" -days 365 -sha256

echo "Certificate generation completed."
