#!/bin/bash

echo etcd 使能
# 需要在所有节点运行？

set -euo pipefail

./03-1-create-etcd-pem.sh
./03-2-create-etcd-systemd-unit.sh
./03-3-verify-etcd.sh
