#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/00-0-env-global.sh

#export SELFS_IP=`ifconfig ens160 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'` # 当前部署节点的 IP
