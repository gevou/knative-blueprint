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

# Spin-up Knative cluster
echo -e "\n\e[36mSpinning-up a fresh k8s cluster...\e[39m"
 time gcloud container clusters create $CLUSTER_NAME \
  --zone=$CLUSTER_ZONE \
  --cluster-version=latest \
  --machine-type=n1-standard-2 \
  --enable-autoscaling --min-nodes=1 --max-nodes=3 \
  --enable-autorepair \
  --scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore \
  --enable-basic-auth \
  --issue-client-certificate \
  --enable-ip-alias \
  --metadata disable-legacy-endpoints=true \
  --num-nodes=2 || exit 1

