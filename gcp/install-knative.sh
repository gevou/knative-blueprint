# This script assumes that 
# 1. a gcp account is already setup
# 2. A service account token has been created and downloaded in json format
# 3. The appropriate APIs are already enabled for this account:
#   cloud APIs, container, container Registry
#

# Parameters
export PROJECT=knative-blueprint
export CLUSTER_NAME=knative
export CLUSTER_ZONE=us-west1-c
export GCLOUD_CONFIGURATION=knative-blueprint
export SERVICE_ACCOUNT_TOKEN="knative-blueprint-362545fa46d6.json"

echo -e "\n\e[36mActivating GCP account and configuration...\e[39m"
# Activate the service account
gcloud auth activate-service-account --key-file $SERVICE_ACCOUNT_TOKEN || exit 1

# Activate the gcp configuration
gcloud config configurations activate $GCLOUD_CONFIGURATION || exit 1

echo -e "\n\e[36mConfiguring kubectl...\e[39m"
# Configure kubectl to point to the correct cluster
time gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT || exit 1

# Grant cluster-admin permissions to current user
time kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user=$(gcloud config get-value core/account) || exit 1

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
