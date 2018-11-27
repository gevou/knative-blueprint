curl -L https://raw.githubusercontent.com/knative/serving/v0.1.1/third_party/istio-0.8.0/istio.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | kubectl delete --filename -
