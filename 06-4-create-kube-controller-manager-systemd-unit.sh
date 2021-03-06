#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/06-0-env-master.sh

cat > ${TEMPDIR_MASTER_SIDE}/kube-controller-manager.service <<EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=${PREFIX_PATH}/bin/kube-controller-manager \\
  --address=127.0.0.1 \\
  --master=http://${MASTER_IP}:8080 \\
  --allocate-node-cidrs=true \\
  --service-cluster-ip-range=${SERVICE_CIDR} \\
  --cluster-cidr=${CLUSTER_CIDR} \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem \\
  --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem \\
  --root-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --leader-elect=true \\
  --v=2
Restart=no
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cp ${TEMPDIR_MASTER_SIDE}/kube-controller-manager.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl restart kube-controller-manager
#systemctl status kube-controller-manager --no-pager -l
