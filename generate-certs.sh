#!/bin/bash

# Define the base directory
BASE_DIR="/iotstackdata/mosquitto/certs"

# Create base directory if it doesn't exist
mkdir -p "$BASE_DIR"

# Prompt user for the Common Name (CN)
read -p "Enter the Common Name (CN) for the certificates: " COMMON_NAME

# Generate CA certificate and private key
openssl req -new -x509 -days 365 -keyout "$BASE_DIR/ca.key" -out "$BASE_DIR/ca.crt" -subj "/CN=$COMMON_NAME"

# Generate server private key without a passphrase
openssl genpkey -algorithm RSA -out "$BASE_DIR/server.key" -pkeyopt rsa_keygen_bits:2048

# Generate server certificate signing request (CSR)
openssl req -new -key "$BASE_DIR/server.key" -out "$BASE_DIR/server.csr" -subj "/CN=$COMMON_NAME"

# Sign the server CSR with the CA certificate and key to obtain the server certificate
openssl x509 -req -in "$BASE_DIR/server.csr" -CA "$BASE_DIR/ca.crt" -CAkey "$BASE_DIR/ca.key" -CAcreateserial -out "$BASE_DIR/server.crt" -days 365 -sha256

echo "Certificate generation completed."
