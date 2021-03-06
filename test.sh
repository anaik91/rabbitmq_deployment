#!/bin/bash

##### K8s Stuff #####
NAMESPACE="test-rabbitmq"
RABBITMQ_SVC="rabbitmq"
RABBITMQ_PORT="5672"
RABBITMQ_VHOST="%2F"

pods=($(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' -n ${NAMESPACE}))
size=${#pods[@]}
index=$(($RANDOM % $size))
pod_name=${pods[$index]}
echo "Chosen Pod ${pod_name}"
RABBITMQ_SVC_IP=$(kubectl get svc ${RABBITMQ_SVC} -n ${NAMESPACE} -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
##### K8s Stuff #####

sudo python3 -m pip install -r requirements.txt

##### Running Pub Sub #####
echo  "Invoking Publisher in Background"
python3 asynchronous_publisher.py ${RABBITMQ_SVC_IP} ${RABBITMQ_PORT} ${RABBITMQ_VHOST} &

echo  "Invoking Consumer in Background"
python3 asynchronous_consumer.py ${RABBITMQ_SVC_IP} ${RABBITMQ_PORT} ${RABBITMQ_VHOST} &
##### Running Pub Sub #####
pub_pid=$(ps -ef |grep asynchronous_publisher.py | head -1 | tr -s " " " " | cut -d " " -f2)
sub_pid=$(ps -ef |grep asynchronous_consumer.py | head -1 | tr -s " " " " | cut -d " " -f2)
echo "Publisher PID : ${pub_pid}"
echo "Subscriber PID : ${sub_pid}"
##### Wait #####
echo  "Sleeping for 30s"
sleep 30
##### Wait #####

##### Kill Random pod #####
echo  "Killing Pod : ${pod_name}"
kubectl delete pod ${pod_name}  -n ${NAMESPACE}
##### Kill Random pod #####

##### Wait Some more #####
sleep 20
##### Wait Some more #####

##### Stop Pub Sub #####
echo "Killing Publisher"
kill -9 $pub_pid
sleep 5
echo "Killing Subscriber"
kill -9 $sub_pid
##### Stop Pub Sub #####

sent_msg_count=$(cat sent.txt|wc -l)
received_msg_count=$(cat received.txt|wc -l)
echo -e "\nNumber of Sent Messages : ${sent_msg_count}"
echo -e "\nNumber of Received Messages : ${received_msg_count}"