# Put the Host URL into an environment variable.
export SERVICE_HOST=$(kubectl get route sampleapp \
  --output jsonpath="{.status.domain}")

# Put the IP address into an environment variable
export SERVICE_IP=$(kubectl get svc knative-ingressgateway --namespace istio-system \
  --output jsonpath="{.status.loadBalancer.ingress[*].ip}")

curl -H "Host: $SERVICE_HOST" http://$SERVICE_IP
