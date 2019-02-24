#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/02-0-env.sh

for item in ${NODE_IPS[@]};do
    rsync -au --info=progress2 ${TEMPDIR_MASTER_SIDE}/ca/ssl/* root@${item}:/etc/kubernetes/ssl/
done
