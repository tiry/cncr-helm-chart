#/bin/bash

echo "Inject asynchronous works 20x30s"

curl -k -H 'Content-Type:application/json+nxrequest' \
-X POST -d '{"params":{"nbWork":"20","duration":"30"},"context":{}}' \
-u Administrator:Administrator \
https://$1.multitenant.nuxeo.com/nuxeo/api/v1/automation/Workload.Simulate

echo "wait for 1 minute"

sleep 60

echo "Inject more asynchronous works"

curl -k -H 'Content-Type:application/json+nxrequest' \
-X POST -d '{"params":{"nbWork":"30","duration":"30"},"context":{}}' \
-u Administrator:Administrator \
https://$1.multitenant.nuxeo.com/nuxeo/api/v1/automation/Workload.Simulate

