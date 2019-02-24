#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/06-0-env-master.sh

cat > ${TEMPDIR_MASTER_SIDE}/kube-scheduler.service <<EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=${PREFIX_PATH}/bin/kube-scheduler \\
  --address=127.0.0.1 \\
  --master=http://${MASTER_IP}:8080 \\
  --leader-elect=true \\
  --v=2
Restart=no
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cp ${TEMPDIR_MASTER_SIDE}/kube-scheduler.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl restart kube-scheduler
#systemctl status kube-scheduler --no-pager -l
