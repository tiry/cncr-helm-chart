#/bin/bash

T=$1

echo "Deploy tenant $T"

echo "Create Namespace if needed"
kubectl create namespace $T --dry-run=client -o yaml | kubectl apply -f -

echo "Deploy TLS if needed $T"
./tls-ingress/deploy-tls-if-needed.sh $T

echo "Deploy CNCR Cluster:"

# preprocess values.yaml to replace some env variables
envsubst < tenants/$T-values.yaml > tmp-$T-values.yaml
envsubst < tenants/shared-values.yaml > $T-shared-values.yaml

#helm3 upgrade -i cncr cncr \

helm3 install cncr cncr \
     --debug \
     --version  3.0.0 \
     -n $T --create-namespace \
	 -f $T-shared-values.yaml \
	 -f tmp-$T-values.yaml \
	 --set clid=${NXCLID} \
      

# do some cleanup
rm tmp-$T-values.yaml
rm $T-shared-values.yaml

