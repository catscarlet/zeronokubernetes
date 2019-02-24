#!/bin/bash

set -euo pipefail

kubectl apply -f traefik-rbac.yaml
kubectl apply -f traefik-serviceaccount.yaml
kubectl apply -f traefik-daemonset.yaml
kubectl apply -f traefik-service.yaml
kubectl apply -f traefik-ingress.yaml

sleep 2
./get-namespace-kube-system.sh
