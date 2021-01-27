#!/bin/bash

##### K8s Stuff #####
namespace="test-rabbitmq"
pods=($(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' -n ${namespace}))
size=${#pods[@]}
index=$(($RANDOM % $size))
pod_name=${pods[$index]}
echo "Chosen Pod ${pod_name}"
##### K8s Stuff #####

sudo python3 -m pip install -r requirements.txt

##### Running Pub Sub #####
python3 asynchronous_publisher_example.py&
python3 asynchronous_consumer_example.py&
##### Running Pub Sub #####
pub_pid=$(ps -ef |grep asynchronous_publisher_example.py | head -1 | tr -s " " " " | cut -d " " -f2)
sub_pid=$(ps -ef |grep asynchronous_consumer_example.py | head -1 | tr -s " " " " | cut -d " " -f2)

##### Wait #####
sleep 10
##### Wait #####

##### Kill Random pod #####
kubectl delete pod ${pod_name}  -n ${namespace}
##### Kill Random pod #####

##### Wait Some more #####
sleep 10
##### Wait Some more #####

##### Stop Pub Sub #####
echo "Killing Publisher"
kill -9 pub_pid
sleep 5
echo "Killing Subscriber"
kill -9 sub_pid
##### Stop Pub Sub #####

sent_msg_count=$(cat sent.json|wc -l)
received_msg_count=$(cat received.json|wc -l)
echo -e "\nNumber of Sent Messages : ${sent_msg_count}"
echo -e "\nNumber of Received Messages : ${received_msg_count}"