#!/bin/bash
set -e
if [[ -z "$1" ]]; then
    action="deploy"
fi

if [ "$1" = "deploy"  ]; then
    action="deploy"
elif [ "$1" = "deployssl"  ]; then
    action="deployssl"
else
    echo "Choose deploy OR deployssl"
    exit 0
fi
echo "Action : ${action}"

MANIFEST_DIR="k8s"
NAMESPACE="test-rabbitmq"

echo "Listing Nodes"
kubectl get nodes

echo "Creating Namespace: ${NAMESPACE}"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF

echo "Deploying RBAC"
kubectl apply -f $MANIFEST_DIR/rbac.yaml -n ${NAMESPACE}

if [ "$action" = "deploy"  ]; then
    echo "Deploying Configmap for setting rabbitmq.conf"
    kubectl apply -f $MANIFEST_DIR/configmap.yaml -n ${NAMESPACE}
    echo "Deploying Services"
    kubectl apply -f $MANIFEST_DIR/services.yaml -n ${NAMESPACE}
    echo "Deploying RabbitMQ Stateful Set"
    kubectl apply -f $MANIFEST_DIR/statefulset.yaml -n ${NAMESPACE}
else
    echo "Deploying Configmap for setting rabbitmq.conf with SSL"
    kubectl apply -f $MANIFEST_DIR/configmap_ssl.yaml -n ${NAMESPACE}
    echo "Deploying Services with SSL"
    kubectl apply -f $MANIFEST_DIR/services_ssl.yaml -n ${NAMESPACE}
    echo "Deploying RabbitMQ Stateful Set with SSL"
    kubectl apply -f $MANIFEST_DIR/statefulset.yaml_ssl -n ${NAMESPACE}
fi