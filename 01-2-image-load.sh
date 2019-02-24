#!/bin/bash

set -euo pipefail

echo '# 导入 pause-amd64:3.1'
docker load -i pause-amd64_3.1.tgz
echo '# Tag pause-amd64:3.1'
#docker tag daocloud.io/daocloud/google_containers_pause-amd64:3.1 k8s.gcr.io/pause-amd64:3.1
docker tag daocloud.io/daocloud/google_containers_pause-amd64:3.1 k8s.gcr.io/pause:3.1
echo '# 导入 traefik'
docker load -i traefik.tgz
## echo '# 导入 docker.io/nginx:1.12'
## docker load -i nginx_1.12.tgz
## echo '# 导入 k8s-dns-kube-dns-amd64_v1.14.10.tgz'
## docker load -i k8s-dns-kube-dns-amd64_v1.14.10.tgz
## echo '# 导入 kubernetes-dashboard-amd64_v1.8.3'
## docker load -i kubernetes-dashboard-amd64_v1.8.3.tgz
