#!/bin/bash

set -euo pipefail

export PREFIX_PATH="/root/kubernetes"
export PATH=${PREFIX_PATH}/bin:$PATH

export TEMPDIR_ALL_SIDE="${PREFIX_PATH}/temp-all-side/"
export TEMPDIR_MASTER_SIDE="${PREFIX_PATH}/temp-master-side/"
export TEMPDIR_NODE_SIDE="${PREFIX_PATH}/temp-node-side/"

pushd ${PREFIX_PATH} > /dev/null

# TLS Bootstrapping 使用的 Token，可以使用命令 head -c 16 /dev/urandom | od -An -t x | tr -d ' ' 生成
export BOOTSTRAP_TOKEN="27a765f2aebaf0ae01fec4fba276282a"

# 建议用 未用的网段 来定义服务网段和 Pod 网段
# 服务网段 (Service CIDR），部署前路由不可达，部署后集群内使用 IP:Port 可达
export SERVICE_CIDR="172.29.0.0/16"
# POD 网段 (Cluster CIDR），部署前路由不可达，**部署后**路由可达 (flanneld 保证)
export CLUSTER_CIDR="172.30.0.0/16"
# 服务端口范围 (NodePort Range)
export NODE_PORT_RANGE="8400-9000"

# flanneld 网络配置前缀
export FLANNEL_ETCD_PREFIX="/kubernetes/network"
# kubernetes 服务 IP (预分配，一般是 SERVICE_CIDR 中第一个IP)
export CLUSTER_KUBERNETES_SVC_IP="172.29.0.1"
# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配)
export CLUSTER_DNS_SVC_IP="172.29.0.2"
# 集群 DNS 域名
export CLUSTER_DNS_DOMAIN="cluster.local."

# function
# function join_by { local IFS="$1"; shift; echo "$*"; }

#
#export MASTER_IP=192.168.124.100 # 替换为 kubernetes master 集群任一机器 IP
#export ALL_IPS_ARRAY=(192.168.124.101 192.168.124.102 192.168.124.103 192.168.124.100)
#export NODE_ONLY_IPS_ARRAY=(192.168.124.101 192.168.124.102 192.168.124.103)

#export MASTER_IP=192.168.233.50
#export NODE_IP_ARRAY=(192.168.233.51 192.168.233.52 192.168.233.53)
#export ALL_IPS_ARRAY=(192.168.233.50 192.168.233.51 192.168.233.52 192.168.233.53)

export MASTER_IP_ARRAY=(`cat 'list-master.list'`)
export MASTER_IP=${MASTER_IP_ARRAY[0]}
export NODE_IP_ARRAY=(`cat 'list-nodes.list'`)
export ALL_IPS_ARRAY=(${MASTER_IP_ARRAY[@]} ${NODE_IP_ARRAY[@]})

#
export PRIVATE_NETWORK_INTERFACE="ens33"

export KUBE_APISERVER="https://${MASTER_IP}:6443"
export SELFS_IP=`ifconfig ${PRIVATE_NETWORK_INTERFACE} | grep 'inet ' | cut -d: -f2 | awk '{print $2}'` # 当前部署的机器 IP
export NODE_NAME=etcd-${SELFS_IP} # 当前部署的机器名称(随便定义，只要能区分不同机器即可)
# etcd 集群所有机器 IP
export NODE_IPS="${ALL_IPS_ARRAY[@]}"
# etcd 集群间通信的IP和端口
ETCD_NODES_TMP=''
# etcd 集群服务地址列表
ETCD_ENDPOINTS_TMP=''

len=${#ALL_IPS_ARRAY[@]}
for ((i=0;i<$len;i++));do
    ETCD_NODES_TMP="${ETCD_NODES_TMP}etcd-${ALL_IPS_ARRAY[$i]}=https://${ALL_IPS_ARRAY[$i]}:2380"
    ETCD_ENDPOINTS_TMP="${ETCD_ENDPOINTS_TMP}https://${ALL_IPS_ARRAY[$i]}:2379"
	if [ $[i+1] -lt $len ]; then
        ETCD_NODES_TMP=${ETCD_NODES_TMP}','
        ETCD_ENDPOINTS_TMP=${ETCD_ENDPOINTS_TMP}','
    fi
done
export ETCD_NODES=$ETCD_NODES_TMP
export ETCD_ENDPOINTS=$ETCD_ENDPOINTS_TMP

#export
popd > /dev/null
