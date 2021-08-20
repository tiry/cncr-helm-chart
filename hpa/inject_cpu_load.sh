#/bin/bash


echo "Inject synchronous CPU load..."

seq 1 5 | xargs -n1 -P 5 
curl -k -H 'Content-Type:application/json+nxrequest' \
-X POST -d '{"params":{"duration":"60"},"context":{}}' \
-u Administrator:Administrator \
https://$1.multitenant.nuxeo.com/nuxeo/api/v1/automation/CPUWorkload.Simulate/@async

echo "Wait for 1 minute ..."

sleep 60

echo "Inject more synchronous CPU load..."

seq 1 10 | xargs -n1 -P 10 
curl -k -H 'Content-Type:application/json+nxrequest' \
-X POST -d '{"params":{"duration":"30"},"context":{}}' \
-u Administrator:Administrator \
https://$1.multitenant.nuxeo.com/nuxeo/api/v1/automation/CPUWorkload.Simulate/@async


