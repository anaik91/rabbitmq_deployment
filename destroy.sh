#!/bin/bash
set -e

MANIFEST_DIR="k8s"
NAMESPACE="test-rabbitmq"

echo "Listing Nodes"
kubectl get nodes

echo "Creating Namespace: ${NAMESPACE}"
cat <<EOF | kubectl delete -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF

echo "Deploying RBAC"
kubectl delete -f $MANIFEST_DIR/rbac.yaml -n ${NAMESPACE}

echo "Deploying Configmap for setting rabbitmq.conf"
kubectl delete -f $MANIFEST_DIR/configmap.yaml -n ${NAMESPACE}

echo "Deploying Services"
kubectl delete -f $MANIFEST_DIR/services.yaml -n ${NAMESPACE}

echo "Deploying RabbitMQ Stateful Set"
kubectl delete -f $MANIFEST_DIR/statefulset.yaml -n ${NAMESPACE}