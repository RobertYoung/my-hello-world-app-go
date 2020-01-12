# My Hello World App

## Overview

> Write a simple hello world application in any one of these languages: Python, Ruby, Go. Build the application within a Docker container and then load balance the application within minikube. You are not required to automate the installation of minikube on the host machine.

## Prerequisites

- [Go](https://golang.org/doc/install)
- [Docker](https://docs.docker.com/v17.09/engine/installation/) 
- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)

## Quick Run 

### Locally
```sh
# install dependencies
go install 

# build and start server
go run main.go

# test the server is running
curl localhost:8080
curl localhost:8080/health
curl localhost:8080/echo
```

### Minikube

```sh
# builds and deploys the application to minikube
./scripts/deploy.sh
```

## Go

```sh
# install go dependencies
go install

# compile application
go build

# run unit tests
go test

# start application 
go run main.go
```

## Minikube + Docker

```sh
# start kubernetes cluster using minikube
minikube start --kubernetes-version 1.16.4

# Sets the docker env so we can build the docker images inside the minikube VM. This is for development only so we don't need to use an external registry
eval $(minikube docker-env)

# build docker image
docker build -t my-hello-world-app-go .

# run the application using the docker image
docker run -it --rm -p 8080:8080 my-hello-world-app-go
```

## Kubernetes

```sh
# set the minikube cluster and use the hello-world namespace
kubectl config set-context minikube --namespace hello-world

# apply changes to the k8s cluster
kubectl apply -f k8s.yaml

# verify changes
kubectl get all

# view the service on your host (should open up in your default browser)
minikube service --namespace='hello-world' my-hello-world-app-go
```

## Things to Try

When you've got the application running, navigate to the `/echo` route and view the hostname, which is the name of the pod.

```sh
# replace the hostname and delete the pod
kubectl delete --namespace hello-world pod {HOSTNAME}
```

Reload the application, and it will assign you a healthy pod.

## TODO

1. golint
1. deploy to EKS