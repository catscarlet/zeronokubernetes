#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/03-0-env-create-etcd-cluster.sh

mkdir -p ${TEMPDIR_ALL_SIDE}/etcd/ssl/

cat > ${TEMPDIR_ALL_SIDE}/etcd/ssl/etcd-csr.json <<EOF
{
  "CN": "etcd",
  "hosts": [
    "127.0.0.1",
    "${SELFS_IP}"
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
  -profile=kubernetes ${TEMPDIR_ALL_SIDE}/etcd/ssl/etcd-csr.json | cfssljson -bare ${TEMPDIR_ALL_SIDE}/etcd/ssl/etcd

#ls -l ${TEMPDIR_ALL_SIDE}/ssl/etcd//*

mkdir -p /etc/etcd/ssl
cp ${TEMPDIR_ALL_SIDE}/etcd/ssl/etcd*.pem /etc/etcd/ssl
ls -l /etc/etcd/ssl
