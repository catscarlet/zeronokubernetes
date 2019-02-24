#!/bin/bash

echo "Master 安装 kube-apiserver，kube-controller-manager，kube-scheduler-systemd"
# 只在 Master 运行

set -euo pipefail

./06-0-env-master.sh
sleep 1
./06-1-create-kubernetes-pem.sh
sleep 1
./06-2-create-token.sh
sleep 1
./06-3-create-kube-apiserver-systemd-unit.sh
sleep 1
./06-4-create-kube-controller-manager-systemd-unit.sh
sleep 1
./06-5-create-kube-scheduler-systemd-unit.sh
sleep 1
./06-7-check-all-status.sh
sleep 1
./06-6-create-clusterrolebinding.sh
sleep 1
