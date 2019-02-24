#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/07-0-env-node.sh

mkdir -p ${TEMPDIR_NODE_SIDE}/kube-proxy/ssl/

cat > ${TEMPDIR_NODE_SIDE}/kube-proxy/ssl/kube-proxy-csr.json << EOF
{
  "CN": "system:kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
  -ca-key=/etc/kubernetes/ssl/ca-key.pem \
  -config=/etc/kubernetes/ssl/ca-config.json \
  -profile=kubernetes ${TEMPDIR_NODE_SIDE}/kube-proxy/ssl/kube-proxy-csr.json | cfssljson -bare ${TEMPDIR_NODE_SIDE}/kube-proxy/ssl/kube-proxy

cp ${TEMPDIR_NODE_SIDE}/kube-proxy/ssl/kube-proxy*.pem /etc/kubernetes/ssl/

ls -l /etc/kubernetes/ssl/
