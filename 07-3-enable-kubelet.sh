#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/07-0-env-node.sh

## cat > kubelet-conf.yaml << EOF
## kind:                     KubeletConfiguration
## apiVersion:               kubelet.config.k8s.io/v1beta1
## KubeletConfiguration:
##     Address:              "${SELFS_IP}"
##     ClusterDNS:           "${CLUSTER_DNS_SVC_IP}"
##     ClusterDomain:        "${CLUSTER_DNS_DOMAIN}"
##     HairpinMode:          "promiscuous-bridge"
##     SerializeImagePulls:  false
## EOF

##  cat > ${TEMPDIR_NODE_SIDE}/kubelet.config.json << EOF
##  {
##      "kind": "KubeletConfiguration",
##      "apiVersion": "kubelet.config.k8s.io/v1beta1",
##      "authentication": {
##          "x509": {
##              "clientCAFile": "/etc/kubernetes/ssl/ca.pem"
##          },
##          "webhook": {
##              "enabled": true,
##              "cacheTTL": "2m0s"
##          },
##          "anonymous": {
##              "enabled": false
##          }
##      },
##      "authorization": {
##          "mode": "Webhook",
##          "webhook": {
##              "cacheAuthorizedTTL": "5m0s",
##              "cacheUnauthorizedTTL": "30s"
##          }
##      },
##      "address": "${SELFS_IP}",
##      "port": 10250,
##      "readOnlyPort": 0,
##      "cgroupDriver": "cgroupfs",
##      "hairpinMode": "promiscuous-bridge",
##      "serializeImagePulls": false,
##      "featureGates": {
##          "RotateKubeletClientCertificate": true,
##          "RotateKubeletServerCertificate": true
##      },
##      "clusterDomain": "${CLUSTER_DNS_DOMAIN}",
##      "clusterDNS": ["${CLUSTER_DNS_SVC_IP}"]
##  }
##  EOF

cat > ${TEMPDIR_NODE_SIDE}/kubelet.config.json << EOF
{
    "kind": "KubeletConfiguration",
    "apiVersion": "kubelet.config.k8s.io/v1beta1",
    "address": "${SELFS_IP}",
    "cgroupDriver": "cgroupfs",
    "hairpinMode": "promiscuous-bridge",
    "serializeImagePulls": false,
    "clusterDomain": "${CLUSTER_DNS_DOMAIN}",
    "clusterDNS": ["${CLUSTER_DNS_SVC_IP}"]
}
EOF

cat > ${TEMPDIR_NODE_SIDE}/kubelet.service <<EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
ExecStart=${PREFIX_PATH}/bin/kubelet \\
  --config=${TEMPDIR_NODE_SIDE}/kubelet.config.json \\
  --hostname-override=${SELFS_IP} \\
  --bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \\
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig \\
  --cert-dir=/etc/kubernetes/ssl \\
  --logtostderr=true \\
  --fail-swap-on=false \\
  --v=2
Restart=no
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

cp ${TEMPDIR_NODE_SIDE}/kubelet.service /etc/systemd/system/kubelet.service

systemctl daemon-reload
systemctl enable kubelet
systemctl restart kubelet
#systemctl status kubelet --no-pager -l
