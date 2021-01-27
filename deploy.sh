#!/bin/bash
set -e

MANIFEST_DIR="k8s"
NAMESPACE="test-rabbitmq"

echo "Listing Nodes"
kubectl get nodes

echo "Creating Namespace: ${NAMESPACE}"
kubectl create ns ${NAMESPACE}

echo "Deploying RBAC"
kubectl apply -f $MANIFEST_DIR/rbac.yaml -n ${NAMESPACE}

echo "Deploying Configmap for setting rabbitmq.conf"
kubectl apply -f $MANIFEST_DIR/configmap.yaml -n ${NAMESPACE}

echo "Deploying Services"
kubectl apply -f $MANIFEST_DIR/services.yaml -n ${NAMESPACE}

echo "Deploying RabbitMQ Stateful Set"
kubectl apply -f $MANIFEST_DIR/statefulset.yaml -n ${NAMESPACE}