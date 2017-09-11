#!/bin/bash -ex

source variable.cfg
source function.sh

##################################################################
notification "Create Rings and ditribute them"
sleep 3

# Create account-ring
cd /etc/swift

swift-ring-builder account.builder create 10 3 1

swift-ring-builder account.builder add \
--region 1 --zone 1 --ip $OBJECT1_MGNT_IP --port 6202 --device $SDB --weight 10

swift-ring-builder account.builder add \
--region 1 --zone 1 --ip $OBJECT1_MGNT_IP --port 6202 --device $SDC --weight 10

swift-ring-builder account.builder add \
--region 1 --zone 1 --ip $OBJECT2_MGNT_IP --port 6202 --device $SDB --weight 10

swift-ring-builder account.builder add \
--region 1 --zone 1 --ip $OBJECT2_MGNT_IP --port 6202 --device $SDC --weight 10

swift-ring-builder account.builder rebalance

# Create container-ring
cd /etc/swift

swift-ring-builder container.builder create 10 3 1

swift-ring-builder container.builder add \
--region 1 --zone 1 --ip $OBJECT1_MGNT_IP --port 6201 --device $SDB --weight 10

swift-ring-builder container.builder add \
--region 1 --zone 1 --ip $OBJECT1_MGNT_IP --port 6201 --device $SDC --weight 10

swift-ring-builder container.builder add \
--region 1 --zone 1 --ip $OBJECT2_MGNT_IP --port 6201 --device $SDB --weight 10

swift-ring-builder container.builder add \
--region 1 --zone 1 --ip $OBJECT2_MGNT_IP --port 6201 --device $SDC --weight 10

swift-ring-builder container.builder rebalance

# Create object-ring
cd /etc/swift

swift-ring-builder object.builder create 10 3 1

swift-ring-builder object.builder add \
--region 1 --zone 1 --ip $OBJECT1_MGNT_IP --port 6200 --device $SDB --weight 10

swift-ring-builder object.builder add \
--region 1 --zone 1 --ip $OBJECT1_MGNT_IP --port 6200 --device $SDC --weight 10

swift-ring-builder object.builder add \
--region 1 --zone 1 --ip $OBJECT2_MGNT_IP --port 6200 --device $SDB --weight 10

swift-ring-builder object.builder add \
--region 1 --zone 1 --ip $OBJECT2_MGNT_IP --port 6200 --device $SDC --weight 10

swift-ring-builder object.builder rebalance

notification "Typing password of root user to distribute ring when system request"
sleep 3

scp /etc/swift/account.ring.gz /etc/swift/container.ring.gz /etc/swift/object.ring.gz root@$OBJECT1_MGNT_IP:/etc/swift
scp /etc/swift/account.ring.gz /etc/swift/container.ring.gz /etc/swift/object.ring.gz root@$OBJECT2_MGNT_IP:/etc/swift