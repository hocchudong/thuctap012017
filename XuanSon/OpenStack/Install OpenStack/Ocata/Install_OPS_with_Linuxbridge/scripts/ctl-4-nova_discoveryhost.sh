#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf

source /root/admin-openrc
openstack hypervisor list
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
openstack hypervisor list

