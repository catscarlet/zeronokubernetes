#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/06-0-env-master.sh

#systemctl status kube-apiserver.service --no-pager -l
#systemctl status kube-controller-manager.service --no-pager -l
#systemctl status kube-scheduler.service --no-pager -l

kubectl get componentstatuses
