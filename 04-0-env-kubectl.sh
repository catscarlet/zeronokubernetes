#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/00-0-env-global.sh

# export MASTER_IP=172.16.3.29 # 替换为 kubernetes master 集群任一机器 IP
# export KUBE_APISERVER="https://${MASTER_IP}:6443"
