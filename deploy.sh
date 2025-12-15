#!/bin/bash

echo ""

# Add Ingress Nginx
echo Applying Ingress Nginx Controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.1/deploy/static/provider/cloud/deploy.yaml >/dev/null

# Add Rancher Local Path Provider
echo Applying Rancher Local Path Provider...
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.32/deploy/local-path-storage.yaml >/dev/null

# Wait for Ingress Nginx is Ready
echo Waiting for Ingress Nginx Controller is available...
kubectl wait --for="condition=Ready" pod --selector="app.kubernetes.io/name=ingress-nginx" -n ingress-nginx --timeout=120s >/dev/null

# Add Custom Manifests
echo Applying Custom Manifests...
kubectl apply -f k8s/ >/dev/null

echo $'\nDone!\n'