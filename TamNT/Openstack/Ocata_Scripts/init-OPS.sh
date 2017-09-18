#! /bin/bash

source config.sh
source functions.sh

. admin-openrc
echocolor "Create network:"
sleep 3
openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider 

openstack subnet create --network provider --allocation-pool start=192.168.101.200,end=192.168.101.220 \
  --dns-nameserver 8.8.8.8 --gateway 192.168.101.1 --subnet-range 192.168.101.0/24 provider

. demo-openrc
openstack network create selfservice

openstack subnet create --network selfservice \
  --dns-nameserver $DNS_RESOLVER --gateway 10.0.1.1 \
  --subnet-range 10.0.1.0/24 selfservice
echocolor "Create route"
sleep 3
openstack router create router
neutron router-interface-add router selfservice
neutron router-gateway-set router provider
. admin-openrc
ip netns
neutron router-port-list router
echocolor "create flavor"
sleep 3
openstack flavor create --id 0 --vcpus 1 --ram 128 --disk 1 m1.nano
. demo-openrc
openstack flavor list
openstack image list
openstack network list