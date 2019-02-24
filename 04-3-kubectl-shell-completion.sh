#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/02-0-env.sh

echo '# Kubectl shell completion'
#kubectl completion bash > /root/.kube/completion.bash.inc
kubectl completion bash > /etc/bash_completion.d/completion.bash.inc
