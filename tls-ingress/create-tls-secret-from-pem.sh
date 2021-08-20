#/bin/bash

TENANT=$1

# get absolute path for cert files
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

kubectl create secret tls static-wildcard-tls -n $TENANT \
  --cert=$DIR/wildcard-cert-chain.pem \
  --key=$DIR/wildcard-key.pem

