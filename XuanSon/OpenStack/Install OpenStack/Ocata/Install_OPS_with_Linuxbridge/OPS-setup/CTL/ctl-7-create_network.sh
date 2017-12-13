#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

echocolor "Create provider network, subnet and flavor"
openstack network create provider --project service --share \
	--description "Provider network" --external \
	--provider-network-type flat \
	--provider-physical-network provider

openstack subnet create sub-provider --subnet-range $CIDR_EXT \
	--dhcp --dns-nameserver 8.8.8.8 \
	--gateway $GATEWAY_EXT_IP \
	--description "Subnet for provider network" \
	--network provider

openstack flavor create small --ram 1024 --disk 1 --vcpus 1
