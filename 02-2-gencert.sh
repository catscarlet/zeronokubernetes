#!/bin/bash

set -euo pipefail

STUDYK8S_PATH=`dirname \`readlink -f $0\``

source $STUDYK8S_PATH/02-0-env.sh

cfssl gencert -initca ${TEMPDIR_MASTER_SIDE}/ca/ssl/ca-csr.json | cfssljson -bare ${TEMPDIR_MASTER_SIDE}/ca/ssl/ca

ls -l ${TEMPDIR_MASTER_SIDE}/ca/ssl/*
