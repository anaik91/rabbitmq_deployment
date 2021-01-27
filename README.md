# Rabbit MQ Cluster Deployment with Monitoring

## Prerequisites

* Kubernetes Cluster > .v.17
* kubeconfig is set to KUBECONFIG env or default locaton i.e (~/.kube/config)
* kubectl is installed

## Avaialable Actions
#### For Non SSL Setup
```
bash deploy.sh nonssl 
```
#### For SSL Setup
```
bash deploy.sh ssl 
```

#### For Deploying Monitoring (Prometheus & Grafana with Rabbitmq dashboard)
```
bash deploy_monitoring.sh
```

#### For testing the PUB & SUB
```
bash test.sh
```

#### For destorying the Rabbitmq Cluster
```
bash destroy.sh nonssl      # FOR NON_SSL
bash destroy.sh ssl         # FOR SSL
```