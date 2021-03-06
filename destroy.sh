#!/bin/bash
set -e

if [ "$1" = "nonssl"  ]; then
    action="nonssl"
elif [ "$1" = "ssl"  ]; then
    action="ssl"
else
    echo "Choose nonssl OR ssl"
    exit 0
fi
echo "Action : ${action}"

MANIFEST_DIR="k8s"
NAMESPACE="test-rabbitmq"

echo "Listing Nodes"
kubectl get nodes

echo "Deleting RBAC"
kubectl delete -f $MANIFEST_DIR/rbac.yaml -n ${NAMESPACE}

if [ "$action" = "nonssl"  ]; then
    echo "Deleting Configmap"
    kubectl delete -f $MANIFEST_DIR/configmap.yaml -n ${NAMESPACE}
    echo "Deleting Services"
    kubectl delete -f $MANIFEST_DIR/services.yaml -n ${NAMESPACE}
    echo "Deleting RabbitMQ Stateful Set"
    kubectl delete -f $MANIFEST_DIR/statefulset.yaml -n ${NAMESPACE}
else
    echo "Deploying Configmap for setting rabbitmq.conf with SSL"
    kubectl delete -f $MANIFEST_DIR/configmap_ssl.yaml -n ${NAMESPACE}
    echo "Deploying Services with SSL"
    kubectl delete -f $MANIFEST_DIR/services_ssl.yaml -n ${NAMESPACE}
    echo "Deploying RabbitMQ Stateful Set with SSL"
    kubectl delete -f $MANIFEST_DIR/statefulset.yaml_ssl -n ${NAMESPACE}
fi

echo "Deleting Namespace: ${NAMESPACE}"
cat <<EOF | kubectl delete -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF