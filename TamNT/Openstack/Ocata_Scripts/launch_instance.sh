#! /bin/bash

source config.sh
source functions.sh

. admin-openrc
echocolor "Create network:"
sleep 3
openstack network create  --share --external \
  --provider-physical-network provider \
  --provider-network-type flat provider 

openstack subnet create --network provider \
  --allocation-pool start=$START_IP_ADDRESS,end=$END_IP_ADDRESS \
  --dns-nameserver 8.8.8.8 --gateway $PROVIDER_NETWORK_GATEWAY \
  --subnet-range $PROVIDER_NETWORK_CIDR provider

openstack subnet create --network provider \
  --allocation-pool start=172.16.100.21,end=172.16.100.28 \
  --dns-nameserver $DNS_RESOLVER --gateway $PROVIDER_NETWORK_GATEWAY \
  --subnet-range $PROVIDER_NETWORK_CIDR provider

. demo-openrc
openstack network create selfservice

openstack subnet create --network selfservice \
  --dns-nameserver $DNS_RESOLVER --gateway 192.168.100.1 \
  --subnet-range 192.168.100.0/24 selfservice
echocolor "Create route"
sleep 3
openstack router create router
neutron router-interface-add router selfservice
neutron router-gateway-set router provider
. admin-openrc
ip netns
neutron router-port-list router
echocolor"create flavor"
sleep 3
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
. demo-openrc
openstack flavor list
openstack image list
openstack network list
echocolor "Launch instance"
sleep 3
openstack server create --flavor m1.nano --image cirros \
  --nic net-id=9b140fe8-d63c-4ce0-b7f4-7c82b7b0b2d7 selfservice-instance




