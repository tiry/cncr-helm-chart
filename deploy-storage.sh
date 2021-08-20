#/bin/bash

NS="nx-shared-storage"

if [ $1 = "PROD" ]
then
  echo "Deploy Storage in Production mode"

  echo "Deploy Elasticsearch"
  helm3 upgrade -i  nuxeo-es-master  elasticsearch \
    --repo https://helm.elastic.co  \
    --version 7.9.2 -n $NS \
    --create-namespace  -f storage/es-values.yaml -f storage/es-values-master.yaml 

  helm3 upgrade -i  nuxeo-es-data  elasticsearch \
    --repo https://helm.elastic.co  \
    --version 7.9.2 -n $NS \
    --create-namespace  -f storage/es-values.yaml -f storage/es-values-data.yaml 

  echo "Deploy MongoDB"
  helm3 upgrade -i  nuxeo-mongodb  mongodb \
    --repo https://charts.bitnami.com/bitnami  \
    --version 10.1.1 -n $NS \
    --set mongodb.architecture="replicaset" \
    --create-namespace -f storage/mongodb-values-prod.yaml 

  echo "Deploy Kafka"
  helm3 upgrade -i  nuxeo-kafka  kafka \
    --repo https://charts.bitnami.com/bitnami \
    --version=11.8.8  -n $NS \
    --create-namespace  -f storage/kafka-values-prod.yaml 

else

  echo "Deploy Storage in Dev mode"


  echo "Deploy Elasticsearch"
  helm3 upgrade -i  nuxeo-es-master  elasticsearch \
    --repo https://helm.elastic.co  \
    --version 7.9.2 -n $NS \
    --create-namespace  -f storage/es-values.yaml  

  echo "Deploy MongoDB"
  helm3 upgrade -i  nuxeo-mongodb  mongodb \
    --repo https://charts.bitnami.com/bitnami \
    --version 10.1.1 -n $NS \
    --set mongodb.architecture="replicaset" \
    --create-namespace -f storage/mongodb-values.yaml 

  echo "Deploy Kafka"
  helm3 upgrade -i  nuxeo-kafka  kafka \
    --repo https://charts.bitnami.com/bitnami \
    --version=11.8.8  -n $NS \
    --create-namespace  -f storage/kafka-values.yaml 

fi
