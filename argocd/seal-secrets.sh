#!/bin/bash

# Script to seal ArgoCD secrets using kubeseal

set -e

echo "Sealing ArgoCD secrets..."

# Seal the main secrets
kubeseal -f secrets.yaml -w sealed-secrets.yaml

# Seal the repo secrets
kubeseal -f repo-mobilebrain-manifests-secrets.yaml -w repo-mobilebrain-manifests-sealed-secrets.yaml

# Seal the notifications secret
kubeseal -f argocd-notifications-secret.yaml -w argocd-notifications-sealed-secrets.yaml

echo "All secrets sealed successfully."