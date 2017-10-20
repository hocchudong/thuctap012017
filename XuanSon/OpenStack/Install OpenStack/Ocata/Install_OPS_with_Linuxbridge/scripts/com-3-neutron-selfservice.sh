#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.sh

# Install the components Neutron
echocolor "Install the components Neutron"
sleep 3

apt install neutron-linuxbridge-agent -y

# Configure the common component
echocolor "Configure the common component"
sleep 3

neutronfile=/etc/neutron/neutron.conf
neutronfilebak=/etc/neutron/neutron.conf.bak
cp $neutronfile $neutronfilebak
egrep -v "^$|^#" $neutronfilebak > $neutronfile

ops_del $neutronfile database connection
ops_add $neutronfile DEFAULT \
	transport_url rabbit://openstack:$RABBIT_PASS@controller

ops_add $neutronfile DEFAULT auth_strategy keystone
ops_add $neutronfile keystone_authtoken \
	auth_uri http://controller:5000
ops_add $neutronfile keystone_authtoken \
	auth_url http://controller:35357
ops_add $neutronfile keystone_authtoken \
	memcached_servers controller:11211
ops_add $neutronfile keystone_authtoken \
	auth_type password
ops_add $neutronfile keystone_authtoken \
	project_domain_name default
ops_add $neutronfile keystone_authtoken \
	user_domain_name default
ops_add $neutronfile keystone_authtoken \
	project_name service
ops_add $neutronfile keystone_authtoken \
	username neutron
ops_add $neutronfile keystone_authtoken \
	password $NEUTRON_PASS


#Configure the Linux bridge agent
echocolor "Configure the Linux bridge agent"
sleep 3
linuxbridgefile=/etc/neutron/plugins/ml2/linuxbridge_agent.ini
linuxbridgefilebak=/etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak
cp $linuxbridgefile $linuxbridgefilebak
egrep -v "^$|^#" $linuxbridgefilebak > $linuxbridgefile

ops_add $linuxbridgefile linux_bridge physical_interface_mappings provider:$COM_EXT_IF
ops_add $linuxbridgefile vxlan enable_vxlan true
ops_add $linuxbridgefile vxlan local_ip $COM_MGNT_IP
ops_add $linuxbridgefile securitygroup enable_security_group true
ops_add $linuxbridgefile securitygroup \
	firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
	
# Configure the Compute service to use the Networking service
echocolor "Configure the Compute service to use the Networking service"
sleep 3
novafile=/etc/nova/nova.conf

ops_add $novafile neutron url http://controller:9696
ops_add $novafile neutron auth_url http://controller:35357
ops_add $novafile neutron auth_type password
ops_add $novafile neutron project_domain_name default
ops_add $novafile neutron user_domain_name default
ops_add $novafile neutron region_name RegionOne
ops_add $novafile neutron project_name service
ops_add $novafile neutron username neutron
ops_add $novafile neutron password $NEUTRON_PASS
ops_add $novafile neutron service_metadata_proxy true
ops_add $novafile neutron metadata_proxy_shared_secret $METADATA_SECRET	
	
# Finalize installation
echocolor "Finalize installation"
sleep 3
service nova-compute restart
service neutron-linuxbridge-agent restart