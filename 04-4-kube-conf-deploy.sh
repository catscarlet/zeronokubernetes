#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/02-0-env.sh

#cp ca* /etc/kubernetes/ssl

for item in ${NODE_IPS[@]};do
    rsync -au --info=progress2 /root/.kube root@${item}:/root/
    rsync -au --info=progress2 /etc/bash_completion.d/completion.bash.inc root@${item}:/etc/bash_completion.d/
    #ssh root@${item} 'printf "# Kubectl shell completion\nsource /root/.kube/completion.bash.inc\n" >> /root/.bashrc'
done
