#!/bin/bash

echo ""

# Checking for variable
if [[ -z "$DEPLOY_ENV" ]]; then
    echo -n "Is application in production mode (Y/n): "
    read DEPLOY_ENV
    
    if [[ $DEPLOY_ENV != "n" ]]; then
        DEPLOY_ENV=prod
        echo "Deploying for Production mode..."
    else
        DEPLOY_ENV=dev
        echo "Deploying for Development mode..."
    fi
fi

# Add Ingress Nginx
echo Applying Ingress Nginx Controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.1/deploy/static/provider/cloud/deploy.yaml >/dev/null

# Add Rancher Local Path Provider
echo Applying Rancher Local Path Provider...
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.32/deploy/local-path-storage.yaml >/dev/null

# Wait for Ingress Nginx is Ready
echo Waiting for Ingress Nginx Controller is available...
kubectl wait --for="condition=Ready" pod --selector="app.kubernetes.io/name=ingress-nginx" -n ingress-nginx --timeout=60s >/dev/null

# Add Custom Manifests
echo Applying Custom Manifests...
kubectl apply -k k8s/overlays/$DEPLOY_ENV >/dev/null

echo $'\nDone!\n'