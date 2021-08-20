#/bin/bash


kubectl create ns keel

../tls-ingress/deploy-tls-if-needed.sh keel

kubectl create secret generic -n keel gcr-cred --from-file gcr-cred.json

kubectl apply -f keel.yaml
