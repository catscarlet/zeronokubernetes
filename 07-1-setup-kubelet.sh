#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/07-0-env-node.sh

# 这俩在master上运行就行了
#kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap
#kubectl create clusterrolebinding kubelet-nodes --clusterrole=system:node --group=system:nodes
