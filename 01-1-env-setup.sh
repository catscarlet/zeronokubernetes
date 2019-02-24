#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/00-0-env-global.sh

echo '# 二进制文件解压'
mkdir -p ${PREFIX_PATH}
mkdir -p ${TEMPDIR_ALL_SIDE}
mkdir -p ${TEMPDIR_MASTER_SIDE}
mkdir -p ${TEMPDIR_NODE_SIDE}

tar zxf bin_all_side.tgz --keep-newer-files
tar zxf bin_master_side.tgz --keep-newer-files
tar zxf bin_node_side.tgz --keep-newer-files

mkdir -p /etc/kubernetes/ssl
mkdir -p /var/lib/etcd
mkdir -p /etc/flanneld/ssl
mkdir -p /var/lib/kubelet
mkdir -p /var/lib/kube-proxy

echo '# Docker.service 更新'
systemctl stop docker
cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service_backup_at_`date +'%Y%m%d%H%M'`

cat > ${TEMPDIR_ALL_SIDE}/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
EnvironmentFile=-/run/flannel/docker
ExecStart=/bin/bash -c "PATH=${PREFIX_PATH}/bin:\$PATH exec /usr/bin/dockerd -H fd:// \$DOCKER_NETWORK_OPTIONS"
ExecReload=/bin/kill -s HUP \$MAINPID
LimitNOFILE=infinity
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
RestartSec=5
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

cp ${TEMPDIR_ALL_SIDE}/docker.service /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker
systemctl start docker

echo '# PATH环境变量更新'
PATH=${PREFIX_PATH}/bin:$PATH
echo 'PATH='${PREFIX_PATH}'/bin:$PATH' >> ~/.bashrc

#source /root/.bash_profile
