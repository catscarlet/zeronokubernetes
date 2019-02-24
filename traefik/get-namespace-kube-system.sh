#!/bin/bash

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e ${GREEN}'kubectl --namespace=kube-system get nodes'${NC}
kubectl --namespace=kube-system get nodes
echo ''
echo -e ${GREEN}'kubectl --namespace=kube-system get pods -o wide'${NC}
kubectl --namespace=kube-system get pods -o wide
echo ''
echo -e ${GREEN}'kubectl --namespace=kube-system get svc'${NC}
kubectl --namespace=kube-system get svc
echo ''
echo -e ${GREEN}'kubectl --namespace=kube-system get deploy'${NC}
kubectl --namespace=kube-system get deploy
echo ''
echo -e ${GREEN}'kubectl --namespace=kube-system get daemonsets'${NC}
kubectl --namespace=kube-system get daemonsets
echo ''
#echo -e ${GREEN}'kubectl --namespace=kube-system get ingress'${NC}
#kubectl --namespace=kube-system get ingress
#echo ''
