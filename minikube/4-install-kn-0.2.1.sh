curl -L https://github.com/knative/serving/releases/download/v0.2.1/release.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | kubectl apply --filename -

# check if everything is up and running
kubectl get pods --namespace knative-serving --watch