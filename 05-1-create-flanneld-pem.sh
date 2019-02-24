#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/05-0-env-flannel.sh

mkdir -p ${TEMPDIR_ALL_SIDE}/flannel/ssl

cat > ${TEMPDIR_ALL_SIDE}/flannel/ssl/flanneld-csr.json <<EOF
{
  "CN": "flanneld",
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
  -profile=kubernetes ${TEMPDIR_ALL_SIDE}/flannel/ssl/flanneld-csr.json | cfssljson -bare ${TEMPDIR_ALL_SIDE}/flannel/ssl/flanneld

cp ${TEMPDIR_ALL_SIDE}/flannel/ssl/flanneld*.pem /etc/flanneld/ssl

ls -l /etc/flanneld/ssl
