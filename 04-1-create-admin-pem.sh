#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/04-0-env-kubectl.sh

mkdir -p ${TEMPDIR_MASTER_SIDE}/kubectl/ssl/

cat > ${TEMPDIR_MASTER_SIDE}/kubectl/ssl/kubectl-csr.json << EOF
{
  "CN": "admin",
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
      "O": "system:masters",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
  -ca-key=/etc/kubernetes/ssl/ca-key.pem \
  -config=/etc/kubernetes/ssl/ca-config.json \
  -profile=kubernetes ${TEMPDIR_MASTER_SIDE}/kubectl/ssl/kubectl-csr.json | cfssljson -bare ${TEMPDIR_MASTER_SIDE}/kubectl/ssl/kubectl

cp ${TEMPDIR_MASTER_SIDE}/kubectl/ssl/kubectl*.pem /etc/kubernetes/ssl/

ls -l /etc/kubernetes/ssl/
