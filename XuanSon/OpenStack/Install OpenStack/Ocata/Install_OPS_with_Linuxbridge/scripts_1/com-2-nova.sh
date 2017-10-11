#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.sh

# Install nova-compute
echocolor "Install nova-compute"
sleep 3
apt install nova-compute -y

# Edit /etc/nova/nova.conf file
echocolor "Edit /etc/nova/nova.conf file"
sleep 3
novafile=/etc/nova/nova.conf
novafilebak=/etc/nova/nova.conf.bak
cp $novafile $novafilebak
egrep -v "^$|^#" $novafilebak > $novafile

ops_add $novafile DEFAULT \
	transport_url rabbit://openstack:$NOVA_DBPASS@controller

ops_add $novafile api \
	auth_strategy keystone

ops_add $novafile keystone_authtoken \
	auth_uri http://controller:5000
ops_add $novafile keystone_authtoken \
	auth_url http://controller:35357
ops_add $novafile keystone_authtoken \
	memcached_servers controller:11211
ops_add $novafile keystone_authtoken \
	auth_type password
ops_add $novafile keystone_authtoken \
	project_domain_name default
ops_add $novafile keystone_authtoken \
	user_domain_name default
ops_add $novafile keystone_authtoken \
	project_name service
ops_add $novafile keystone_authtoken \
	username nova
ops_add $novafile keystone_authtoken \
	password Welcome123

ops_add $novafile DEFAULT \
	my_ip $COM_MGNT_IP

ops_add $novafile DEFAULT \
	use_neutron True

ops_add $novafile DEFAULT \
	firewall_driver nova.virt.firewall.NoopFirewallDriver

ops_add $novafile vnc \
	enabled True
ops_add $novafile vnc \
	vncserver_listen 0.0.0.0
ops_add $novafile vnc \
	vncserver_proxyclient_address \$my_ip
ops_add $novafile vnc \
	novncproxy_base_url http://controller:6080/vnc_auto.html

ops_add $novafile glance \
	api_servers http://controller:9292

ops_del $novafile oslo_concurrency lock_path

ops_add $novafile oslo_concurrency \
	lock_path /var/lib/nova/tmp
	
ops_del $novafile DEFAULT log_dir

ops_del $novafile placement os_region_name
ops_add $novafile placement \
	os_region_name RegionOne
ops_add $novafile placement \
	project_domain_name Default
ops_add $novafile placement \
	project_name service
ops_add $novafile placement \
	auth_type password
ops_add $novafile placement \
	user_domain_name Default
ops_add $novafile placement \
	auth_url http://controller:35357/v3
ops_add $novafile placement \
	username placement
ops_add $novafile placement \
	password $PLACEMENT_PASS


# Finalize installation
echocolor "Finalize installation"
sleep 3
service nova-compute restart

	
