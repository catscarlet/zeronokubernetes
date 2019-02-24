#!/bin/bash

set -euo pipefail

kubectl apply -f my-php-test-deployment.yml
kubectl apply -f my-php-test-service.yml
