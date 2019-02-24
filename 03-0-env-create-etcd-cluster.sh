#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/00-0-env-global.sh

#export SELFS_IP=`ifconfig ens160 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'` # 当前部署的机器 IP
#export NODE_NAME=etcd-`hostname`-${SELFS_IP} # 当前部署的机器名称(随便定义，只要能区分不同机器即可)
#export NODE_IPS="172.16.3.24 172.16.3.29" # etcd 集群所有机器 IP

# etcd 集群间通信的IP和端口
#export ETCD_NODES=etcd-ubuntu-docker-24=https://172.16.3.24:2380,etcd-ubuntu-docker-29=https://172.16.3.29:2380
