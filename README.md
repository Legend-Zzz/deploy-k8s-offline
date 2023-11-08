# deploy-k8s-offline
Deploy K8S cluster offline version 1.27.5 with ansible, certificate is valid for 200 years

Support: 
- debian 11/12
- ubuntu 20.04/22.04
- centos 7 or stream 8/9.

### usage
modify inventory:  .ansible/hihosts

then run
```
./deploy_k8s.sh run
```
