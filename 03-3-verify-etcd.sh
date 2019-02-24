#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/03-0-env-create-etcd-cluster.sh

for ip in ${NODE_IPS}; do
    ETCDCTL_API=3 ${PREFIX_PATH}/bin/etcdctl \
    --endpoints=https://${ip}:2379  \
    --cacert=/etc/kubernetes/ssl/ca.pem \
    --cert=/etc/etcd/ssl/etcd.pem \
    --key=/etc/etcd/ssl/etcd-key.pem \
    endpoint health || true; done
