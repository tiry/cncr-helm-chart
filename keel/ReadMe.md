
## Why Keel

The goal is to experiement with a tool that can automate the redeployment when a docker image is updated.

This folder is about experienting with [keel.sh](https://keel.sh/).

Obviously a lot of other options exist for K8S native CD:

 - https://fluxcd.io/
 - https://argoproj.github.io/argo-cd/
 - https://werf.io/
  
I started with keel because it is a small and simple tool to solve a simple problem: 

 - triger K8S deployment update when image is updates
 - provide a dashboard

## Deploying

Deploy Keel on the K8S cluster

    kubectl create ns keel

    ../tls-ingress/deploy-tls-if-needed.sh keel

    kubectl create secret generic -n keel gcr-cred --from-file gcr-cred.json

    kubectl apply -f keel.yaml

## Access dashboard

    https://keel.multitenant.nuxeo.com/dashboard




