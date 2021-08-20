#/bin/bash

TENANT=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

present=`kubectl get Issuer letsencrypt-prod -n $TENANT --ignore-not-found | wc -l`

if [ $present = "2" ]; then
  echo "TLS resources already deployed"
else 
  echo "Deploying TLS related resources in Namespace $TENANT"

  echo "Deploying letsencrypt issuers"
  kubectl create -n $TENANT -f $DIR/letsencrypt-prod-issuer.yaml
  kubectl create -n $TENANT -f $DIR/letsencrypt-staging-issuer.yaml

  echo "Deploying wildcard"
  $DIR/create-tls-secret-from-pem.sh $TENANT
fi
