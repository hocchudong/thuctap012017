#! /bin/bash

. config.sh
. functions.sh

. admin-openrc
openstack hypervisor list
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
openstack compute service list
nova-status upgrade check

echocolor "Hoan thanh update node compute1"
