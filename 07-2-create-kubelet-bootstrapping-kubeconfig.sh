#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/07-0-env-node.sh

echo 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=${TEMPDIR_NODE_SIDE}/bootstrap.kubeconfig

echo 设置客户端认证参数
kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=${TEMPDIR_NODE_SIDE}/bootstrap.kubeconfig

echo 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=${TEMPDIR_NODE_SIDE}/bootstrap.kubeconfig

echo 设置默认上下文
kubectl config use-context default --kubeconfig=${TEMPDIR_NODE_SIDE}/bootstrap.kubeconfig

cp ${TEMPDIR_NODE_SIDE}/bootstrap.kubeconfig /etc/kubernetes/

ls -l /etc/kubernetes/
