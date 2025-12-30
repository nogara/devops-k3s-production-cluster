kubectl get namespace argocd >/dev/null 2>&1 || kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd \
  -n argocd \
  -f values-argocd.yaml

# seal the secrets
./seal-secrets.sh

kubectl apply -k .
