#/bin/bash

# variables
PROJECT_NAME="my-hello-world-app-go"
COLOUR_BLUE='\033[0;34m'
COLOUR_NO='\033[0m'

# check if minikube is running
minikube_status=$(minikube status)

if [ "$?" -ne 0 ]; then
    echo "Minikube is not running"
    echo "Try: ${COLOUR_BLUE}minikube start --kubernetes-version 1.16.4${COLOUR_NO}"
    exit 1
fi

set -e

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