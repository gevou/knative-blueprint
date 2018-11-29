export SERVICE_ACCOUNT_TOKEN="knative-blueprint-362545fa46d6.json"

# clean-up existing token and serviceaccount
kubectl delete secret registry
kubectl delete serviceaccount build

# create new ones
knctl basic-auth-secret create -s registry --gcr -u _json_key -p "$(cat ${SERVICE_ACCOUNT_TOKEN})" || exit 1
knctl service-account create --service-account build -s registry
