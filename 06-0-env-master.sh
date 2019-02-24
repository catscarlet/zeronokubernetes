#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/00-0-env-global.sh

#export MASTER_IP=172.16.3.29  # 替换为当前部署的 master 机器 IP
