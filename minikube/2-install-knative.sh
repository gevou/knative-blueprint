# Install Istio
echo -e "\n\e[36mInstalling Istio...\e[39m"
time kubectl apply --filename https://raw.githubusercontent.com/knative/serving/v0.2.1/third_party/istio-1.0.2/istio.yaml || exit 1

# Enable istio-injection 
time kubectl label namespace default istio-injection=enabled

echo -e "\e[36mWaiting for istio system pods to get ready...\e[39m"
time while true; do
  readyPods=$(kubectl get pods --namespace istio-system --no-headers | grep -c 'Running\|Completed')
  pendingPods=$(kubectl get pods --namespace istio-system --no-headers | grep -c -v 'Running\|Completed')
  echo -ne "ready: \e[32m${readyPods}\e[39m, pending: \e[31m${pendingPods}\e[39m  "\\r
  if (("${pendingPods}" == "0")); then
    break
  fi
  sleep 1
done

echo -e "\n\e[36mInstalling KNative...\e[39m"
# Install KNative
time kubectl apply --filename https://github.com/knative/serving/releases/download/v0.2.1/release.yaml || exit 1

echo -e "\e[36mWaiting for Knative system pods to get ready...\e[39m"
time while true; do
  readyServingPods=$(kubectl get pods --namespace knative-serving --no-headers | grep -c 'Running\|Completed')
  pendingServingPods=$(kubectl get pods --namespace knative-serving --no-headers | grep -c -v 'Running\|Completed')
  readyBuildPods=$(kubectl get pods --namespace knative-build --no-headers | grep -c 'Running\|Completed')
  pendingBuildPods=$(kubectl get pods --namespace knative-build --no-headers | grep -c -v 'Running\|Completed')
  echo -ne "KNative-serving ready: \e[32m${readyServingPods}\e[39m, \
pending: \e[31m${pendingServingPods}\e[39m \
:: KNative-build ready: \e[32m${readyBuildPods}\e[39m, \
pending: \e[31m${pendingBuildPods}\e[39m    "\\r
  if (("${pendingServingPods}" == "0")) && (("${pendingBuildPods}" == "0")); then
    break
  fi
  sleep 1
done

echo -e "\e[36mInstalling build templates...\e[39m"
kubectl apply -f https://raw.githubusercontent.com/knative/build-templates/master/kaniko/kaniko.yaml
kubectl apply -f https://raw.githubusercontent.com/knative/build-templates/master/buildpack/buildpack.yaml

echo -e "\n\e[36mKNative installed successfully!\e[39m"
