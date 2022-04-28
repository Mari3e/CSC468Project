#!/bin/bash

# launch registry container on Kubernetes
cd /local/repository/registry
kubectl create -f registry.yaml 
kubectl create -f registry-service.yaml
