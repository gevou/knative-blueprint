# check build logs
# kubectl get build $(kubectl get revision sampleapp-00001 --output jsonpath="{.spec.buildName}") --output yaml

# check pod build logs
# kubectl logs sampleapp-00001-k7wkl -c build-step-build


# For Grafana:
# https://github.com/knative/docs/blob/master/serving/accessing-metrics.md
# kubectl port-forward --namespace knative-monitoring $(kubectl get pods --namespace knative-monitoring --selector=app=grafana --output=jsonpath="{.items..metadata.name}") 3000:3999
# navigate to: localhost:3999

# For wavescope:
# kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040
# navigate to: localhost:4040

# For all the below
# run: kubectl proxy
# then,

# Kibana
# http://localhost:8001/api/v1/namespaces/knative-monitoring/services/kibana-logging/proxy/app/kibana#/management/kibana/index

# zipkin
# http://localhost:8001/api/v1/namespaces/istio-system/services/zipkin:9411/proxy/zipkin/


