# Prometheous Grafana
# https://github.com/knative/docs/blob/master/serving/accessing-metrics.md
kubectl port-forward --namespace knative-monitoring $(kubectl get pods --namespace knative-monitoring --selector=app=grafana --output=jsonpath="{.items..metadata.name}") 3000

# Kibana logs
# https://github.com/knative/docs/blob/master/serving/accessing-logs.md
kubectl proxy
