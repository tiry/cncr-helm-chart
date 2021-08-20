#/bin/bash

echo "Deploy Monitoring" 

# https://cloud.google.com/community/tutorials/visualizing-metrics-with-grafana

helm3 upgrade -i grafana grafana \
     --repo https://grafana.github.io/helm-charts \
	 --version 6.1.15 \
     -n nx-monitoring --create-namespace \
	 -f monitoring/values.yaml


# get the password	  
# kubectl get secret --namespace nx-monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# use port forwarding
# export POD_NAME=$(kubectl get pods --namespace nx-monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
#kubectl --namespace nx-monitoring port-forward $POD_NAME 3000