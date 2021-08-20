#/bin/bash

echo "Deploy Grafana Ingress"

../tls-ingress/create-tls-secret-from-pem.sh nx-monitoring
kubectl create -n nx-monitoring -f ingress.yaml
