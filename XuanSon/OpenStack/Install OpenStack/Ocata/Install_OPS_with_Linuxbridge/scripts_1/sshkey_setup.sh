#!/bin/bash

#Author Son Do Xuan

source function.sh

IP=$1
PATH_SCRIPT=$2

ssh-keygen -t rsa -N "" -f mykey
ssh-copy-id -i mykey.pub root@$IP

scp -r $PATH_SCRIPT root@$IP:


