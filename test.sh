#!/bin/bash

##### K8s Stuff #####
namespace="test-rabbitmq"
pods[0]="rabbitmq-0"
pods[1]="rabbitmq-1"
pods[2]="rabbitmq-2"
pods[3]="rabbitmq-3"
pods[4]="rabbitmq-4"
size=${#pods[@]}
index=$(($RANDOM % $size))
echo "Chosen Pod ${array[$index]}"
##### K8s Stuff #####

sudo python3 -m pip install -r requirements.txt

##### Running Pub Sub #####
python3 asynchronous_publisher_example.py &> /dev/null
python3 asynchronous_consumer_example.py &> /dev/null
##### Running Pub Sub #####
pub_pid=$(ps -ef |grep asynchronous_publisher_example.py | head -1 | tr -s " " " " | cut -d " " -f2)
sub_pid=$(ps -ef |grep asynchronous_consumer_example.py | head -1 | tr -s " " " " | cut -d " " -f2)

##### Wait #####
sleep 10
##### Wait #####

##### Kill Random pod #####
kubectl delete pod ${array[$index]}  -n ${namespace}
##### Kill Random pod #####

##### Wait Some more #####
sleep 10
##### Wait Some more #####

##### Stop Pub Sub #####
kill -2 ${pub_pid}
sleep 2
kill -2 ${sub_pid}
##### Stop Pub Sub #####

sent_msg_count=$(cat sent.json|wc -l)
received_msg_count=$(cat received.json|wc -l)
echo -e "\nNumber of Sent Messages : ${sent_msg_count}"
echo -e "\nNumber of Received Messages : ${received_msg_count}"