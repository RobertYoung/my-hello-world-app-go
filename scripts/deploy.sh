#/bin/bash

# exit on error
set -e

# variables
PROJECT_NAME="my-hello-world-app-go"

# check if minikube is running
minikube_status=$(minikube status)
running_status=$(grep -o "Running" <<<"$minikube_status" | wc -l)
configured_status=$(grep -o "Configured" <<<"$minikube_status" | wc -l)

if [ $running_status != "3" ] || [ $configured_status != "1" ]; then
    echo "Minikube is not running"
    minikube status
    exit 1
fi

# use docker in minikubes vm
eval $(minikube docker-env)

# build docker image
docker build -t $PROJECT_NAME .

# set the minikube cluster and use the hello-world namespace
kubectl config set-context minikube --namespace hello-world

# apply changes to the k8s cluster
kubectl apply -f k8s.yaml

# view the service on your host (should open up in your default browser)
minikube service --namespace='hello-world' my-hello-world-app-go

echo "It may take a few seconds to load"

exit 0