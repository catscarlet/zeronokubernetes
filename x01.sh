#!/bin/bash

echo 初始化环境
# 需要在所有节点运行

set -euo pipefail

./01-0-env.sh
./01-1-env-setup.sh
./01-2-image-load.sh
