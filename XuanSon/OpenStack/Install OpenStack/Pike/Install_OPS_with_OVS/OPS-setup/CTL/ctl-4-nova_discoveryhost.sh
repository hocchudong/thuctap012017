#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

source /root/admin-openrc
openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
openstack compute service list --service nova-compute