# My Hello World App

## Overview

> Write a simple hello world application in any one of these languages: Python, Ruby, Go. Build the application within a Docker container and then load balance the application within minikube. You are not required to automate the installation of minikube on the host machine.

## Prerequisite

- [Go](https://golang.org/doc/install)
- [Docker](https://docs.docker.com/v17.09/engine/installation/) 
- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)

## Quick Run 

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

## Installation

1. `go install`
1. `go build`
1. `go test`
1. `go run`
