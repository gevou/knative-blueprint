knctl deploy --service sampleapp \
  --git-url https://github.com/gevou/knative-blueprint.git \
  --git-revision master \
  --image us.gcr.io/knative-blueprint/sampleapp:latest \
  --template buildpack