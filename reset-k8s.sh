#!/bin/bash
echo "###### Start k8s cluster reset #########"
sudo kubeadm reset 
sleep 10

echo "###### delete .kube  ######"
rm -rf $HOME/.kube
rm -rf /root/.kube

echo "######rm reggistry ######"
nerdctl -n k8s.io rm -f registry

