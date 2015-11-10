#!/bin/sh

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Create a bootstrap master
kubectl create -f ${DIR}/redis-master.yaml

# Create a service to track the sentinels
kubectl create -f ${DIR}/redis-sentinel-service.yaml

# Create a replication controller for redis servers
kubectl create -f ${DIR}/redis-controller.yaml

# Create a replication controller for redis sentinels
kubectl create -f ${DIR}/redis-sentinel-controller.yaml

# Scale both replication controllers
kubectl scale rc redis --replicas=3
kubectl scale rc redis-sentinel --replicas=3

# Delete the original master pod
kubectl delete pods redis-master