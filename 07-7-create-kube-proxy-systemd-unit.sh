#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/07-0-env-node.sh

## cat > kube-proxy.config.yaml.template <<EOF
## apiVersion: kubeproxy.config.k8s.io/v1alpha1
## bindAddress: ##NODE_IP##
## clientConnection:
##   kubeconfig: /etc/kubernetes/kube-proxy.kubeconfig
## clusterCIDR: ${CLUSTER_CIDR}
## healthzBindAddress: ##NODE_IP##:10256
## hostnameOverride: ##NODE_NAME##
## kind: KubeProxyConfiguration
## metricsBindAddress: ##NODE_IP##:10249
## mode: "ipvs"
## EOF

cat > ${TEMPDIR_NODE_SIDE}/kube-proxy.service <<EOF
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target

[Service]
WorkingDirectory=/var/lib/kube-proxy
ExecStart=${PREFIX_PATH}/bin/kube-proxy \\
  --bind-address=${SELFS_IP} \\
  --hostname-override=${SELFS_IP} \\
  --cluster-cidr=${CLUSTER_CIDR} \\
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \\
  --logtostderr=true \\
  --v=2
Restart=no
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

cp ${TEMPDIR_NODE_SIDE}/kube-proxy.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable kube-proxy
systemctl restart kube-proxy
#systemctl status kube-proxy --no-pager -l
