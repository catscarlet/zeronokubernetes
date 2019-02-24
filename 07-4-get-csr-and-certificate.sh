#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/07-0-env-node.sh

echo '获取 csr'
kubectl get csr
sleep 1
echo '核准 csr'
kubectl get csr|grep 'Pending' | awk  '{print $1}' | xargs kubectl certificate approve || true
sleep 3
kubectl get csr
sleep 3
echo '获取 nodes'
kubectl get nodes

ls -l /etc/kubernetes/

ls -l /etc/kubernetes/ssl/*
