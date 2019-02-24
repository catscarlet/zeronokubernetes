#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/05-0-env-flannel.sh

cat > ${TEMPDIR_ALL_SIDE}/flanneld.service << EOF
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
After=network-online.target
Wants=network-online.target
After=etcd.service
Before=docker.service

[Service]
Type=notify
ExecStart=${PREFIX_PATH}/bin/flanneld \\
  -etcd-cafile=/etc/kubernetes/ssl/ca.pem \\
  -etcd-certfile=/etc/flanneld/ssl/flanneld.pem \\
  -etcd-keyfile=/etc/flanneld/ssl/flanneld-key.pem \\
  -etcd-endpoints=${ETCD_ENDPOINTS} \\
  -etcd-prefix=${FLANNEL_ETCD_PREFIX} \\
  -iface=${PRIVATE_NETWORK_INTERFACE}
ExecStartPost=${PREFIX_PATH}/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
Restart=no

[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
EOF

cp ${TEMPDIR_ALL_SIDE}/flanneld.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable flanneld
systemctl restart flanneld
#systemctl status flanneld --no-pager -l
