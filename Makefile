include .env

# Project variables
PROJECTNAME:="my-hello-world-app-go"
K8S_NAMESPACE:="hello-world"

# Go related variables.
GOBASE:=$(shell pwd)
GOPATH:="$(GOBASE)/vendor:$(GOBASE)"
GOBIN:=$(GOBASE)/bin
GOFILES:=$(wildcard *.go)

# Redirect error output to a file, so we can show it in development mode.
STDERR=/tmp/.$(PROJECTNAME)-stderr.txt

# PID file will keep the process id of the server
PID=/tmp/.$(PROJECTNAME).pid

# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

## install: Install missing dependencies. Runs `go get` internally. e.g; make install get=github.com/foo/bar
install: go-get

## start: Start in development mode
start: compile start-server

## stop: Stop development mode.
stop: stop-server

## compile: Compile the binary.
compile:
	@-touch $(STDERR)
	@-rm $(STDERR)
	@-$(MAKE) -s go-compile 2> $(STDERR)
	@cat $(STDERR) | sed -e '1s/.*/\nError:\n/'  | sed 's/make\[.*/ /' | sed "/^/s/^/     /" 1>&2

## exec: Run given command, wrapped with custom GOPATH. e.g; make exec run="go test ./..."
exec:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) $(run)

## clean: Clean build files. Runs `go clean` internally.
clean:
	@-$(MAKE) go-clean

## test: Run the unit tests
test: go-get-test go-test

## deploy: Builds and deploys the application to Minikube
deploy: minikube-deploy

## minikube-validate: Checks whether minikube is running
minikube-validate:
	@minikube status 2&> /dev/null || (echo "Minikube is not running"; exit 1);
	@echo "Minikube is running"

## minikube-start: Start minikube using kubernetes version 1.16.4
minikube-start:
	@minikube start --kubernetes-version 1.16.4

start-server: stop-server
	@echo "  >  $(PROJECTNAME) is available on port $(PORT)"
	@-$(GOBIN)/$(PROJECTNAME) 2>&1 & echo $$! > $(PID)
	@cat $(PID) | sed "/^/s/^/  \>  PID: /"

stop-server:
	@-touch $(PID)
	@-kill `cat $(PID)` 2> /dev/null || true
	@-rm $(PID)

restart-server: stop-server start-server

go-compile: go-clean go-get go-build

go-build:
	@echo "  >  Building binary..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go build -o $(GOBIN)/$(PROJECTNAME) $(GOFILES)

go-generate:
	@echo "  >  Generating dependency files..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go generate $(generate)

go-get:
	@echo "  >  Checking if there is any missing dependencies..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go get $(get)

go-get-test:
	@-$(MAKE) go-get get=-t

go-install:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go install $(GOFILES)

go-test:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go test

go-clean:
	@echo "  >  Cleaning build cache"
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go clean

minikube-deploy: minikube-validate
	# use docker in minikubes vm
	@eval $$(minikube docker-env); \
	make docker-build k8s-set-minikube k8s-deploy minikube-service
	echo "It may take a few seconds to load"

minikube-service:
	# view the service on your host (should open up in your default browser)
	@minikube service --namespace=$(K8S_NAMESPACE) $(PROJECTNAME)

docker-build:
	# build docker image
	@docker build -t $(PROJECTNAME) .

## k8s-set-minikube: Sets the kubernetes context to minikube and the hello-world namespace
k8s-set-minikube:
	# set the minikube cluster and use the hello-world namespace
	@kubectl config set-context minikube --namespace $(K8S_NAMESPACE)

k8s-deploy:
	# apply changes to the k8s cluster
	@kubectl apply -f k8s.yaml

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command to run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo