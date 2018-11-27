# start once to build core containers so that we can mount temp for storage
echo "Starting minikube..."
minikube start --memory=9192 --cpus=4 --disk-size=40g\
  --kubernetes-version=v1.12.2 \
  --vm-driver=hyperkit \
  --bootstrapper=kubeadm \
  --extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook" 
  # --docker-opt="--data-root /tmp"
