#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/07-0-env-node.sh

GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e ${GREEN}'kubectl get csr'${NC}
kubectl get csr
echo ''
echo -e ${GREEN}'kubectl get nodes'${NC}
kubectl get nodes
echo ''
echo -e ${GREEN}'kubectl get deploy'${NC}
kubectl get deploy
echo ''
echo -e ${GREEN}'kubectl get daemonsets'${NC}
kubectl get daemonsets
echo ''
echo -e ${GREEN}'kubectl get pods -o wide'${NC}
kubectl get pods -o wide
echo ''
echo -e ${GREEN}'kubectl get svc'${NC}
kubectl get svc
echo ''
