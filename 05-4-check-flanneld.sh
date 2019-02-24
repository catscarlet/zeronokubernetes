#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/05-0-env-flannel.sh

journalctl -u flanneld --no-pager -l

#echo 'Lease acquired?'
#journalctl -u flanneld |grep 'Lease acquired'

ifconfig flannel.1
