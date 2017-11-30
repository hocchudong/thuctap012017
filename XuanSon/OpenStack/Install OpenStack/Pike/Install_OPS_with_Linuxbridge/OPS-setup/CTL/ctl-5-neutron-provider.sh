#!/bin/bash
# Author Son Do Xuan

source ../function.sh
source ../config.sh

# Function create database for Neutron
neutron_create_db () {
	echocolor "Create database for Neutron"
	sleep 3

	cat << EOF | mysql
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
IDENTIFIED BY '$NEUTRON_DBPASS';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
IDENTIFIED BY '$NEUTRON_DBPASS';
EOF
}

# Function create the neutron service credentials
neutron_create_info () {
	echocolor "Set environment variable for admin user"
	source /root/admin-openrc

	echocolor "Create the neutron service credentials"
	sleep 3

	openstack user create --domain default --password $NEUTRON_PASS neutron
	openstack role add --project service --user neutron admin
	openstack service create --name neutron \
	  --description "OpenStack Networking" network
	openstack endpoint create --region RegionOne \
	  network public http://$HOST_CTL:9696
	openstack endpoint create --region RegionOne \
	  network internal http://$HOST_CTL:9696
	openstack endpoint create --region RegionOne \
	  network admin http://$HOST_CTL:9696
}

# Function install the components
neutron_install () {
	echocolor "Install the components"
	sleep 3
	apt install neutron-server neutron-plugin-ml2 \
	  neutron-linuxbridge-agent neutron-dhcp-agent \
	  neutron-metadata-agent -y
}

# Function configure the server component
neutron_config_server_component () { 
	echocolor "Configure the server component"
	sleep 3
	neutronfile=/etc/neutron/neutron.conf
	neutronfilebak=/etc/neutron/neutron.conf.bak
	cp $neutronfile $neutronfilebak
	egrep -v "^$|^#" $neutronfilebak > $neutronfile

	ops_del $neutronfile database connection 
	ops_add $neutronfile database \
		connection mysql+pymysql://neutron:$NEUTRON_PASS@$HOST_CTL/neutron

	ops_del $neutronfile DEFAULT core_plugin
	ops_add $neutronfile DEFAULT \
		core_plugin ml2
	ops_add $neutronfile DEFAULT \
		service_plugins

	ops_add $neutronfile DEFAULT \
		transport_url rabbit://openstack:$NEUTRON_PASS@$HOST_CTL

	ops_add $neutronfile DEFAULT \
		auth_strategy keystone
	ops_add $neutronfile keystone_authtoken \
		auth_uri http://$HOST_CTL:5000
	ops_add $neutronfile keystone_authtoken \
		auth_url http://$HOST_CTL:35357
	ops_add $neutronfile keystone_authtoken \
		memcached_servers $HOST_CTL:11211
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

	ops_add $neutronfile DEFAULT \
		notify_nova_on_port_status_changes true
	ops_add $neutronfile DEFAULT \
		notify_nova_on_port_data_changes true
	ops_add $neutronfile nova \
		auth_url http://$HOST_CTL:35357
	ops_add $neutronfile nova \
		auth_type password
	ops_add $neutronfile nova \
		project_domain_name default
	ops_add $neutronfile nova \
		user_domain_name default
	ops_add $neutronfile nova \
		region_name RegionOne
	ops_add $neutronfile nova \
		project_name service
	ops_add $neutronfile nova \
		username nova
	ops_add $neutronfile nova \
		password $NOVA_PASS
}

# Function configure the Modular Layer 2 (ML2) plug-in
neutron_config_ml2 () {
	echocolor "Configure the Modular Layer 2 (ML2) plug-in"
	sleep 3
	ml2file=/etc/neutron/plugins/ml2/ml2_conf.ini
	ml2filebak=/etc/neutron/plugins/ml2/ml2_conf.ini.bak
	cp $ml2file $ml2filebak
	egrep -v "^$|^#" $ml2filebak > $ml2file

	ops_add $ml2file ml2 type_drivers flat,vlan
	ops_add $ml2file ml2 tenant_network_types
	ops_add $ml2file ml2 mechanism_drivers linuxbridge
	ops_add $ml2file ml2 extension_drivers port_security
	ops_add $ml2file ml2_type_flat flat_networks provider
	ops_add $ml2file ml2_type_vlan network_vlan_ranges provider
}

# Function configure the Linux bridge agent
neutron_config_linuxbridge () {
	echocolor "Configure the Linux bridge agent"
	sleep 3
	linuxbridgefile=/etc/neutron/plugins/ml2/linuxbridge_agent.ini
	linuxbridgefilebak=/etc/neutron/plugins/ml2/linuxbridge_agent.ini.bak
	cp $linuxbridgefile $linuxbridgefilebak
	egrep -v "^$|^#" $linuxbridgefilebak > $linuxbridgefile

	ops_add $linuxbridgefile linux_bridge physical_interface_mappings provider:$CTL_EXT_IF
	ops_add $linuxbridgefile vxlan enable_vxlan false
	ops_add $linuxbridgefile securitygroup enable_security_group true
	ops_add $linuxbridgefile securitygroup \
		firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
}

# Function configure the DHCP agent
neutron_config_dhcp () {
	echocolor "Configure the DHCP agent"
	sleep 3
	dhcpfile=/etc/neutron/dhcp_agent.ini
	dhcpfilebak=/etc/neutron/dhcp_agent.ini.bak
	cp $dhcpfile $dhcpfilebak
	egrep -v "^$|^#" $dhcpfilebak > $dhcpfile

	ops_add $dhcpfile DEFAULT interface_driver linuxbridge
	ops_add $dhcpfile DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
	ops_add $dhcpfile DEFAULT enable_isolated_metadata true
}

# Function configure the metadata agent
neutron_config_metadata () {
	echocolor "Configure the metadata agent"
	sleep 3
	metadatafile=/etc/neutron/metadata_agent.ini
	metadatafilebak=/etc/neutron/metadata_agent.ini.bak
	cp $metadatafile $metadatafilebak
	egrep -v "^$|^#" $metadatafilebak > $metadatafile

	ops_add $metadatafile DEFAULT nova_metadata_ip $HOST_CTL
	ops_add $metadatafile DEFAULT metadata_proxy_shared_secret $METADATA_SECRET
}

# Function configure the Compute service to use the Networking service
neutron_config_compute_use_network () {
	echocolor "Configure the Compute service to use the Networking service"
	sleep 3
	novafile=/etc/nova/nova.conf

	ops_add $novafile neutron url http://$HOST_CTL:9696
	ops_add $novafile neutron auth_url http://$HOST_CTL:35357
	ops_add $novafile neutron auth_type password
	ops_add $novafile neutron project_domain_name default
	ops_add $novafile neutron user_domain_name default
	ops_add $novafile neutron region_name RegionOne
	ops_add $novafile neutron project_name service
	ops_add $novafile neutron username neutron
	ops_add $novafile neutron password $NEUTRON_PASS
	ops_add $novafile neutron service_metadata_proxy true
	ops_add $novafile neutron metadata_proxy_shared_secret $METADATA_SECRET
}

# Function populate the database
neutron_populate_db () {
	echocolor "Populate the database"
	sleep 3
	su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
	  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
}

# Function restart installation
neutron_restart () {
	service nova-api restart
	service neutron-server restart
	service neutron-linuxbridge-agent restart
	service neutron-dhcp-agent restart
	service neutron-metadata-agent restart
}

#######################
###Execute functions###
#######################

# Create database for Neutron
neutron_create_db

# Create the neutron service credentials
neutron_create_info

# Install the components
neutron_install

# Configure the server component
neutron_config_server_component

# Configure the Modular Layer 2 (ML2) plug-in
neutron_config_ml2

# Configure the Linux bridge agent
neutron_config_linuxbridge

# Configure the DHCP agent
neutron_config_dhcp

# Configure the metadata agent
neutron_config_metadata

# Configure the Compute service to use the Networking service
neutron_config_compute_use_network

# Populate the database
neutron_populate_db

# Function restart installation
neutron_restart
