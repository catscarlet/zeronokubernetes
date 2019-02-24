#!/bin/bash

echo flannel使能
# 需要在所有节点运行？

set -euo pipefail

./05-0-env-flannel.sh
./05-1-create-flanneld-pem.sh
./05-2-flanned-pot-to-etcd.sh
./05-3-create-flannel-systemd-unit.sh
