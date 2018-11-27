
curl -L https://raw.githubusercontent.com/istio/istio/1.0.2/install/kubernetes/helm/istio/templates/crds.yaml \
  | kubectl apply -f -

# optional check that all crds have been created
kubectl get crds