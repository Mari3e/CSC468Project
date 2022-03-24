#!/bin/bash 
set -x

sudo apt-get update
sudo apt-get install -y nfs-kernel-server
sudo mkdir -p /opt/keys/flagdir
sudo chown nobody:nogroup /opt/keys
sudo chmod -R a+rwx /opt/keys

echo "/opt/keys 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/opt/keys 192.168.1.3(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports

sudo systemctl restart nfs-kernel-server

kubeadm init > /opt/keys/kube.log
sudo touch /opt/keys/kube_done
