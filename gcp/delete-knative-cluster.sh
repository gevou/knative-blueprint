# Parameters
export CLUSTER_NAME=knative
export CLUSTER_ZONE=us-west1-c

gcloud container clusters delete $CLUSTER_NAME --zone $CLUSTER_ZONE