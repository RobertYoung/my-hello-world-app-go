# My Hello World App

## Overview

> Write a simple hello world application in any one of these languages: Python, Ruby, Go. Build the application within a Docker container and then load balance the application within minikube. You are not required to automate the installation of minikube on the host machine.

## Prerequisites

- [Go](https://golang.org/doc/install)
- [Docker](https://docs.docker.com/v17.09/engine/installation/) 
- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)

## Endpoints

|  Route    | Description                               |
|-----------|-------------------------------------------|
| /health   | Health check for the application          |
| /echo     | Returns basic information on the host     |


## Commands

Builds and deploys the application to Minikube:

```sh
make deploy
```

Other commands:

```
> make help

    Choose a command to run in my-hello-world-app-go:

      install             Install missing dependencies. Runs `go get` internally. e.g; make install get=github.com/foo/bar
      start               Start in development mode
      stop                Stop development mode.
      compile             Compile the binary.
      exec                Run given command, wrapped with custom GOPATH. e.g; make exec run="go test ./..."
      clean               Clean build files. Runs `go clean` internally.
      test                Run the unit tests
      deploy              Builds and deploys the application to Minikube
      minikube-validate   Checks whether minikube is running
      minikube-start      Start minikube using kubernetes version 1.16.4
      k8s-set-minikube    Sets the kubernetes context to minikube and the hello-world namespace
```

## Things to Try

When you've got the application running, navigate to the `/echo` route and view the hostname, which is the name of the pod.

```sh
# replace the hostname and delete the pod
kubectl delete --namespace hello-world pod {HOSTNAME}
```

Reload the application, and it will assign you a healthy pod.

## TODO

1. Implement static analysis tools, such as [golint](https://github.com/golang/lint)
1. Deploy to [EKS](https://aws.amazon.com/eks/)
1. Implement a more advanced web framework, such as [Revel](http://revel.github.io/)
1. Package the application using [helm](https://github.com/helm/helm)