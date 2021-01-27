#!/bin/bash
set -e

MANIFEST_DIR="k8s"
NAMESPACE="test-rabbitmq"

echo "Listing Nodes"
kubectl get nodes

echo "Deleting RBAC"
kubectl delete -f $MANIFEST_DIR/rbac.yaml -n ${NAMESPACE}

echo "Deleting Configmap"
kubectl delete -f $MANIFEST_DIR/configmap.yaml -n ${NAMESPACE}

echo "Deleting Services"
kubectl delete -f $MANIFEST_DIR/services.yaml -n ${NAMESPACE}

echo "Deleting RabbitMQ Stateful Set"
kubectl delete -f $MANIFEST_DIR/statefulset.yaml -n ${NAMESPACE}

echo "Deleting Namespace: ${NAMESPACE}"
cat <<EOF | kubectl delete -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF