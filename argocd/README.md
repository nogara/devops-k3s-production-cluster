# ArgoCD Installation

This folder contains all the necessary files to install and configure ArgoCD on a Kubernetes cluster.

## Prerequisites

- Kubernetes cluster running
- `kubectl` configured to access the cluster
- Sealed Secrets controller installed
- Helm 3.x installed

## Installation

Run the installation script:

```bash
./install.sh
```

This script will:

1. Create the `argocd` namespace (if it doesn't exist)
2. Add the ArgoCD Helm repository
3. Install ArgoCD using Helm with custom values
4. Install ArgoCD Image Updater
5. Configure ECR authentication for automatic image updates
6. Set up Git write-back configuration

## Important Configuration Notes

### ArgoCD Values Configuration

⚠️ **Important**: The `values-argocd.yaml` file in this repository contains only partial secret keys for security reasons.

**Before running the installation, you must:**

1. Update `values-argocd.yaml` with the complete secret keys
2. Create a `secrets.yaml` file with all necessary secret values (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION) for ECR authentication.
3. Create a `repo-mobilebrain-manifests-secrets.yaml` file with the necessary credentials for accessing your Git repositories, using the same structure as `repo-mobilebrain-manifests-sealed-secrets.yaml`. The information necessary is the GitHub app ID, installation ID and private key

### ECR Authentication

The installation configures ArgoCD Image Updater to authenticate with AWS ECR:

- Update `secrets.yaml` with your AWS credentials
- Ensure your AWS credentials have the following ECR permissions:
  - `ecr:GetAuthorizationToken`
  - `ecr:BatchCheckLayerAvailability`
  - `ecr:GetDownloadUrlForLayer`
  - `ecr:BatchGetImage`

## Files Overview

| File                               | Description                                      |
| ---------------------------------- | ------------------------------------------------ |
| `install.sh`                       | Main installation script                         |
| `values-argocd.yaml`               | ArgoCD Helm chart values (⚠️ incomplete secrets) |
| `argocd-image-updater-config.yaml` | ECR registry configuration for Image Updater     |
| `argocd-image-updater-patch.yaml`  | Deployment patch for ECR authentication          |
| `sealed-secrets.yaml`              | Sealed Secrets configuration                     |
| `argocd-traefik-ingressroute.yaml` | Traefik ingress configuration                    |

## Post-Installation

After installation, ArgoCD will be available at the configured ingress URL.

### Default Access

- Username: `admin`
- Password: Retrieved using `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

## Notifications

This repo includes a basic ArgoCD Notifications configuration to send messages to Slack.

Files added:

- `argocd-notifications-cm.yaml` - ConfigMap that defines the Slack service, templates and triggers for sync success and failures.
- `argocd-notifications-secret.yaml` - Secret containing `slack-webhook` (replace with your webhook or use SealedSecrets in production).

To enable notifications:

1. Apply the ConfigMap and Secret in the `argocd` namespace:

```bash
kubectl apply -f argocd/argocd-notifications-cm.yaml -n argocd
kubectl apply -f argocd/argocd-notifications-secret.yaml -n argocd
```

2. Annotate an ArgoCD Application to receive notifications. Example:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  annotations:
    notifications.argoproj.io/subscribe.slack: "app-sync,app-sync-failed"
spec: ...
```

Notes:

- The `slack-webhook` secret in `argocd-notifications-secret.yaml` is a placeholder; replace it with your real webhook URL or use SealedSecrets.
- You can override the channel per-application using the annotation `notifications.slack.channel: "#other-channel"`.
