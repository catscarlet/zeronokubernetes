#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/05-0-env-flannel.sh

echo "Pod 子网段列表互通检测（需根据上一条的结果修改）"

ping 172.30.11.0 -c 4
#ping 172.30.20.2 -c 4
#ping 172.30.21.3 -c 4
