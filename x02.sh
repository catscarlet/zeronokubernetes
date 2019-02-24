#!/bin/bash

echo 初始化证书
# 只需在 Master 上运行

set -euo pipefail

./02-1-create-ca.sh
./02-2-gencert.sh
./02-3-cert-deploy.sh
