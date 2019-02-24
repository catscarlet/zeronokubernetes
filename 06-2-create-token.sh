#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/06-0-env-master.sh

cat > ${TEMPDIR_MASTER_SIDE}/kubernetes-master/token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

cp ${TEMPDIR_MASTER_SIDE}/kubernetes-master/token.csv /etc/kubernetes/

ls -l /etc/kubernetes/
