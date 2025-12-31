
helm repo add dex https://charts.dexidp.io

kubectl apply -f dex-sealed-secrets.yaml

helm upgrade --install dex dex/dex -n auth --create-namespace -f values.yaml

kubectl apply -f ingressroute.yaml
kubectl apply -f rbac.yaml
kubectl apply -f sealed-secrets.yaml