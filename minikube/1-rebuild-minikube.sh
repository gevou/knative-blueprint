#!/bin/sh

# Download minikube
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.30.0/minikube-darwin-amd64 && chmod +x minikube && sudo cp minikube /usr/local/bin/ && rm minikube

#clean-up 
minikube delete
if [ -d "~/.minikube" ]; then
  echo "Found existing .minikube folder"
  rm -fr ~/.minikube
fi

# start once to build core containers so that we can mount temp for storage
echo "Starting minikube..."
minikube start --memory=9192 --cpus=4 --disk-size=40g\
  --kubernetes-version=v1.12.2 \
  --vm-driver=hyperkit \
  --bootstrapper=kubeadm \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook" 

# Ensure all pods are up before step 2

# Note: in some cases I had to restart my machine for this to run. why?
# unkilled process? 
# leftovers in the filesystem?
# attempt to start with "minikube start" and different version of k8s messed-up config? 