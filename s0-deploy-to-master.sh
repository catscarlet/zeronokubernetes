#!/bin/bash

set -euo pipefail

#export MASTER_IP_ARRAY=(`cat 'list-master.list'`)
#export MASTER_IP=${MASTER_IP_ARRAY[0]}

export MASTER_IP=172.16.52.100
echo Going to copy file to: ${MASTER_IP}
echo 目录
ssh root@${MASTER_IP} 'mkdir -p /root/kubernetes'
echo 复制
rsync -au --info=progress2 --exclude-from='deploy-to-esxi-exclude-file.list' * root@${MASTER_IP}:/root/kubernetes/
#echo 免密
#ssh root@192.168.124.100 '/root/kubernetes/ssh-nopasswd-copy.sh'
#echo 同步
#ssh root@192.168.124.100 'cd /root/kubernetes;./ssh-nopasswd-copy.sh;./sync-scripts.sh'
