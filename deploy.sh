#!/bin/bash

echo ""

PS3="Your option (1-2): "
echo "Select the Deploying Environment:"
select DEPLOY_ENV in Production Development; do
    case "$REPLY" in
        1)
            DEPLOY_ENV=prod
            break
            ;;
        2)
            DEPLOY_ENV=dev
            break
            ;;
        "custom")
            read DEPLOY_ENV
            break
            ;;
        *)
            echo "Invalid option. Please, try again."
            ;;
    esac
done

# Add Ingress Nginx
echo Applying Ingress Nginx Controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.1/deploy/static/provider/cloud/deploy.yaml >/dev/null

# Add Rancher Local Path Provider
echo Applying Rancher Local Path Provider...
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.32/deploy/local-path-storage.yaml >/dev/null

# Wait for Ingress Nginx is Ready
echo Waiting for Ingress Nginx Controller is available...
for (( ATTEMPT=1; ATTEMPT<=10; ATTEMPT+=1 )); do
    STATUS=$(kubectl get pod -A -l 'app.kubernetes.io/name=ingress-nginx' -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status }')

    if [[ $STATUS == "True" ]]; then
        echo Attempt $ATTEMPT: Ingress Nginx Controller is Available!
        break
    fi

    echo Attempt $ATTEMPT: Ingress Ngnix still is not available...
    sleep 5
done

if [[ $STATUS != "True" ]]; then
    echo Ingress Nginx Running is Failed. Please, try again.
    exit 1
fi

# Add Custom Manifests
echo Applying Custom Manifests...
kubectl apply -k k8s/overlays/$DEPLOY_ENV >/dev/null

echo $'\nDone!\n'