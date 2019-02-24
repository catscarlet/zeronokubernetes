#!/bin/bash

set -euo pipefail

source ./00-0-env-global.sh
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e ${GREEN}'Test-导入镜像'${NC}
for item in ${NODE_IPS[@]};do
    echo '# 导入 php-www-data_20180717170240，on '${item}
    time ssh root@${item} "docker load -i ${PREFIX_PATH}/images/php-www-data_20180717170240.tgz"
done
echo -e ${GREEN}'Test-导入镜像完成'${NC}
echo ''
