#/bin/bash

TENANT=$1
NAME=$2


if [ -z "$TENANT" ]
then
      echo "Arg 1 must me the tenant/namespace name"
      exit 1
fi

if [ -z "$NAME" ]
then
      echo "Arg 2 must me the company name"
      exit 1
fi


echo "Deploy HPA for $TENANT and API nodes $NAME"

NAME=$NAME envsubst < hpa-apinodes.yaml > tmp-$TENANT-hpa-apinodes.yaml
kubectl create -n $TENANT -f tmp-$TENANT-hpa-apinodes.yaml
rm tmp-$TENANT-hpa-apinodes.yaml


echo "Deploy HPA for $TENANT and Worker nodes $NAME"

NAME=$NAME envsubst < hpa-workernodes.yaml > tmp-$TENANT-hpa-workernodes.yaml
kubectl create -n $TENANT -f tmp-$TENANT-hpa-workernodes.yaml
rm tmp-$TENANT-hpa-workernodes.yaml

