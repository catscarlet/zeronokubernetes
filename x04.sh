#!/bin/bash

echo 生成并部署 kubeconfig
# 只需在 Master 上运行，配置文件会分发到目的机上

set -euo pipefail

./04-1-create-admin-pem.sh
./04-2-create-kubectl-kubeconfig.sh
./04-3-kubectl-shell-completion.sh
./04-4-kube-conf-deploy.sh
