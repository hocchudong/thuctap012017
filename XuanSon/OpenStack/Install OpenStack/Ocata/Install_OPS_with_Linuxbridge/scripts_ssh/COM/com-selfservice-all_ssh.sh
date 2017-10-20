#!/bin/bash

#Author Son Do Xuan

IP=$1
NAME_SCRIPTS=COM

scp -i mykey -r ../$NAME_SCRIPTS root@$IP:
ssh -t -t -i mykey root@$IP "cd $NAME_SCRIPTS && source com-selfservice-all.sh"
source ../CTL/ctl-4-nova_discoveryhost.sh