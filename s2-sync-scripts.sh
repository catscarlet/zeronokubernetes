#!/bin/bash

set -euo pipefail

source ./00-0-env-global.sh
GREEN='\033[0;32m'
NC='\033[0m' # No Color

len=${#NODE_IP_ARRAY[@]}
for ((i=0;i<$len;i++));do
    echo 'Sync to: '${NODE_IP_ARRAY[$i]}
    rsync -au --info=progress2 --exclude-from='kubernetes-deploy-exclude-file.list' * root@${NODE_IP_ARRAY[$i]}:${PREFIX_PATH}/
done

echo -e ${GREEN}' Sync files to nodes Finished'${NC}
