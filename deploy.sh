#!/bin/bash
set -e

MANIFEST_DIR="k8s"

echo "Listing Nodes"
kubectl get nodes

echo "Deploying RBAC"
kubectl apply -f $MANIFEST_DIR/rbac.yaml

echo "Deploying Configmap for setting rabbitmq.conf"
kubectl apply -f $MANIFEST_DIR/configmap.yaml

echo "Deploying Services"
kubectl apply -f $MANIFEST_DIR/services.yaml

echo "Deploying RabbitMQ Stateful Set"
kubectl apply -f $MANIFEST_DIR/statefulset.yaml