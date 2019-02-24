#!/bin/bash

set -euo pipefail

source ./00-0-env-global.sh

ssh-keygen -f /root/.ssh/id_rsa -N ''

len=${#ALL_IPS_ARRAY[@]}
for ((i=0;i<$len;i++));do
    ssh-copy-id -o StrictHostKeychecking=no ${ALL_IPS_ARRAY[$i]}
done
