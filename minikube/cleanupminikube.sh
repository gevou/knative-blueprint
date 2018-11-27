#clean-up
minikube delete
if [ -d "~/.minikube" ]; then
  rm -fr ~/.minikube
fi
