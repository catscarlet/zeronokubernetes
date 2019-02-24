#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/06-0-env-master.sh

mkdir -p ${TEMPDIR_MASTER_SIDE}/kubernetes-master/ssl/

cat > ${TEMPDIR_MASTER_SIDE}/kubernetes-master/ssl/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "${MASTER_IP}",
    "${CLUSTER_KUBERNETES_SVC_IP}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
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
  -profile=kubernetes ${TEMPDIR_MASTER_SIDE}/kubernetes-master/ssl/kubernetes-csr.json | cfssljson -bare ${TEMPDIR_MASTER_SIDE}/kubernetes-master/ssl/kubernetes

cp ${TEMPDIR_MASTER_SIDE}/kubernetes-master/ssl/kubernetes*.pem /etc/kubernetes/ssl/

ls -l /etc/kubernetes/ssl/
