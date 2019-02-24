#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/03-0-env-create-etcd-cluster.sh

cat > ${TEMPDIR_ALL_SIDE}/etcd/etcd.service << EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=${PREFIX_PATH}/bin/etcd \\
  --name=${NODE_NAME} \\
  --cert-file=/etc/etcd/ssl/etcd.pem \\
  --key-file=/etc/etcd/ssl/etcd-key.pem \\
  --peer-cert-file=/etc/etcd/ssl/etcd.pem \\
  --peer-key-file=/etc/etcd/ssl/etcd-key.pem \\
  --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --initial-advertise-peer-urls=https://${SELFS_IP}:2380 \\
  --listen-peer-urls=https://${SELFS_IP}:2380 \\
  --listen-client-urls=https://${SELFS_IP}:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls=https://${SELFS_IP}:2379 \\
  --initial-cluster-token=etcd-cluster-0 \\
  --initial-cluster=${ETCD_NODES} \\
  --initial-cluster-state=new \\
  --data-dir=/var/lib/etcd
Restart=no
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

cp ${TEMPDIR_ALL_SIDE}/etcd/etcd.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable etcd
systemctl restart etcd
#systemctl status etcd --no-pager -l
