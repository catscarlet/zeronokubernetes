#!/bin/bash

echo "节点安装 kubelet、kube-proxy"
# 只需在 Node 上运行

set -euo pipefail

./07-1-setup-kubelet.sh
sleep 1
./07-2-create-kubelet-bootstrapping-kubeconfig.sh
sleep 1
./07-3-enable-kubelet.sh
sleep 1
./07-4-get-csr-and-certificate.sh
sleep 1
./07-5-create-kube-proxy-pem.sh
sleep 1
./07-6-create-kube-proxy-kubeconfig.sh
sleep 1
./07-7-create-kube-proxy-systemd-unit.sh
sleep 1
#./07-8-create-service-nginxds.sh
#./07-9-check-node-status.sh
#./07-a-check-node-port-nginx.sh
