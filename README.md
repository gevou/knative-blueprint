# knative-blueprint
Playground for basic knative concepts

`/gcp` contains scripts for setting-up a cluster, installing knative and deploying a sample function to Google Cloud Platform
`/minikube` contains similar scripts for minikube 

The following files in the root folder are related to the sample app:
```
Dockerfile
app.js
package-lock.json
package.json
sampleapp-manifest.yaml
sampleapp-route.yaml
```

After the cluster is up and KNative environment is installed, the test app can be deployed with:
```
kubectl apply -f sampleapp-route.yaml
kubectl apply -f sampleapp-manifest.yaml
```

and then to test:
`./gcp/curl-service.sh`

### TODO
- Add sample for private github repo
- Ingress routing configuration and interservice calls
- Python app deploy
- green/blue or canary deployments 
- Add sample for pipeline
