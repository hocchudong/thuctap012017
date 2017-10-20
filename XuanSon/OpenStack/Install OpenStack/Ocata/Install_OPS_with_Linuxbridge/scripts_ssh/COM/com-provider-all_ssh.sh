#!/bin/bash

#Author Son Do Xuan


IP=$1
NAME_SCRIPTS=COM

scp -i mykey -r ../$NAME_SCRIPTS root@$IP:
ssh -t -t -i mykey root@$IP <<EOF
cd $NAME_SCRIPTS
source com-provider-all.sh
EOF