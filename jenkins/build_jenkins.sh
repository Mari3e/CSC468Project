#!/bin/bash

cd /local/repository/jenkins
ip_address=$(kubectl get nodes -o wide | grep master | awk '{print $6}')
sed -i "s/KUBEHEAD/${ip_address}/g" /local/repository/jenkins/casc.yaml
docker build -t $(cat /opt/keys/headnode):5000/jenkins:jcasc .
docker push $(cat /opt/keys/headnode):5000/jenkins:jcasc
