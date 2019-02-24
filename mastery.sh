#!/bin/bash

set -euo pipefail

source ./00-0-env-global.sh

STARTTIME=`date +%s`

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e ${GREEN}"---------- Mastery!!! ----------"${NC}
echo ''

echo -e ${GREEN}'Mastery-初始化环境'${NC}
for item in ${NODE_IPS[@]};do
    # 不会异步退出，耗时长
    echo -e ${GREEN}'Mastery-初始化环境: '${item}${NC}
    time ssh root@${item} "cd ${PREFIX_PATH}; ./x01.sh;"
done
echo -e ${GREEN}'Mastery-初始化环境完成'${NC}
echo ''
sleep 1

echo -e ${GREEN}'Mastery-生成 kubernetes 证书: '${MASTER_IP}${NC}
time ssh root@${MASTER_IP} "cd ${PREFIX_PATH}; ./x02.sh;"
echo -e ${GREEN}'Mastery-生成 kubernetes 证书完成'${NC}
echo ''
sleep 1

echo -e ${GREEN}'Mastery-etcd-使能（异步）'${NC}
for item in ${NODE_IPS[@]};do
    echo -e ${GREEN}'Mastery-etcd-使能: '${item}${NC}
    # etcd 启动后会等待其他节点，等不到会失败报错
    time ssh root@${item} "cd ${PREFIX_PATH}; ./x03.sh;" &
    sleep 1
done
wait
echo -e ${GREEN}'Mastery-etcd-使能完成'${NC}
echo ''
sleep 10

echo -e ${GREEN}'Mastery-生成并部署 kubeconfig: '${MASTER_IP}${NC}
time ssh root@${MASTER_IP} "cd ${PREFIX_PATH}; ./x04.sh;"
echo -e ${GREEN}'Mastery-生成并部署 kubeconfig 完成'${NC}
echo ''
sleep 1

echo -e ${GREEN}'Mastery-flannel使能'${NC}
for item in ${NODE_IPS[@]};do
    echo -e ${GREEN}'Mastery-flannel使能: '${item}${NC}
    time ssh root@${item} "cd ${PREFIX_PATH}; ./x05.sh;"
    sleep 1
done
echo -e ${GREEN}'Mastery-flannel 使能 完成'${NC}
echo ''
sleep 1

echo -e ${GREEN}'Mastery-Master 安装 kube-apiserver，kube-controller-manager，kube-scheduler-systemd: '${MASTER_IP}${NC}
time ssh root@${MASTER_IP} "cd ${PREFIX_PATH}; ./x06.sh;"
echo -e ${GREEN}'Mastery-Master 安装 kube-apiserver，kube-controller-manager，kube-scheduler-systemd 完成'${MASTER_IP}${NC}
echo ''
sleep 1

echo -e ${GREEN}'Mastery-节点安装 kubelet、kube-proxy'${NC}
for item in ${NODE_IP_ARRAY[@]};do
    echo -e ${GREEN}'Mastery-节点安装 kubelet、kube-proxy: '${item}${NC}
    time ssh root@${item} "cd ${PREFIX_PATH}; ./x07.sh;"
    sleep 1
done
echo -e ${GREEN}'Mastery-节点安装 kubelet、kube-proxy 完成'${NC}
echo ''
sleep 1

echo -e ${GREEN}'Mastery-状态检查'${NC}
./07-9-check-node-status.sh

ENDTIME=`date +%s`
SPENTTIME=$(($ENDTIME-$STARTTIME))
echo ''
echo -e ${GREEN}"Finished. Used time: $SPENTTIME seconds"${NC}
echo ''
echo -e ${GREEN}"---------- Mastery End!!! ----------"${NC}
echo ''
