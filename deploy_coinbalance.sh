#!/bin/bash
set -x
namespaceStatus=$(kubectl get namespaces coinbalance -o json | jq .status.phase -r)

if [ $namespaceStatus == "Active" ]
then
    echo "Namespace coinbalance exists, need to clean up"
    kubectl delete namespaces coinbalance
fi

echo "Creating namespace coinbalance"
kubectl create namespace coinbalance
 
echo "Creating pods"
kubectl create -f ramcoin.yaml --namespace coinbalance

echo "Creating services"
kubectl create -f ramcoin-service.yaml --namespace coinbalance


kubectl get pods -n coinbalance
