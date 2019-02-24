#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/04-0-env-kubectl.sh

echo 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER}

echo 设置客户端认证参数
kubectl config set-credentials admin \
  --client-certificate=/etc/kubernetes/ssl/kubectl.pem \
  --embed-certs=true \
  --client-key=/etc/kubernetes/ssl/kubectl-key.pem

echo 设置上下文参数
kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin

echo 设置默认上下文
kubectl config use-context kubernetes

ls -l ~/.kube/
