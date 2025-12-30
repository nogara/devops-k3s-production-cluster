#!/bin/bash

# Script to seal Traefik secrets using kubeseal

set -e

echo "Sealing Traefik secrets..."

# Seal the Cloudflare DNS secrets
kubeseal -f cloudflare-dns-secrets.yaml -w cloudflare-dns-sealed-secrets.yaml

echo "All Traefik secrets sealed successfully."