#!/bin/bash
MANIFEST_DIR="k8s"
helm_bin="/usr/local/bin/helm"
echo "Deploying Helm"
#### Install Helm ####
curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 /tmp/get_helm.sh
bash /tmp/get_helm.sh
${helm_bin} repo add stable https://charts.helm.sh/stable
${helm_bin} repo update
#### Install Helm ####

echo "Deploying prometheus"
echo "Creating Namespace: prometheus"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: prometheus
EOF

${helm_bin} upgrade --install prometheus \
    --namespace prometheus stable/prometheus \
    --version 10.3.1 -f ${MANIFEST_DIR}/prometheus.yaml

echo "Deploying Grafana"
echo "Creating Namespace: grafana"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: grafana
EOF
${helm_bin} upgrade --install grafana \
    --namespace grafana stable/grafana \
    --version 4.3.2 -f ${MANIFEST_DIR}/grafana.yaml

grafana_password=$(kubectl get secret -n grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo -e "\n\nLog into Grafana using user: admin & password: ${grafana_password}"