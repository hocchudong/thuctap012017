#!/bin/bash

#Author Son Do Xuan

IP=$1
NAME_SCRIPTS=$2

scp -r $NAME_SCRIPTS root@$IP:
ssh -i mykey root@$IP <<EOF
cd $NAME_SCRIPTS

source function.sh
source config.sh

echocolor "IP address"
source com-0-ipaddr.sh

echocolor "Environment"
source com-1-environment.sh

echocolor "Nova"
source com-2-nova.sh

echocolor "Neutron"
source com-3-neutron-provider.sh

EOF



