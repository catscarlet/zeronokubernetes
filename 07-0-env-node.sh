#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/00-0-env-global.sh

# 替换为 kubernetes master 集群任一机器 IP
#export MASTER_IP=172.16.3.29
#export KUBE_APISERVER="https://${MASTER_IP}:6443"
# 当前部署的节点 IP
#export SELFS_IP=`ifconfig ens160 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`
