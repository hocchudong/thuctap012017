#!/bin/bash
#Author Son Do Xuan

source function.sh
source config.sh

# Function install the components Neutron
neutron_install () {
	echocolor "Install the components Neutron"
	sleep 3

	apt install neutron-openvswitch-agent -y
}

# Function configure the common component
neutron_config_server_component () {
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
}

# Function configure the Open vSwitch agent
neutron_config_ovs () {
	echocolor "Configure the Open vSwitch agent"
	sleep 3
	ovsfile=/etc/neutron/plugins/ml2/openvswitch_agent.ini
	ovsfilebak=/etc/neutron/plugins/ml2/openvswitch_agent.ini.bak
	cp $ovsfile $ovsfilebak
	egrep -v "^$|^#" $ovsfilebak > $ovsfile

	ops_add $ovsfile agent tunnel_types vxlan
	ops_add $ovsfile agent l2_population True

	ops_add $ovsfile ovs bridge_mappings provider:br-provider
	ops_add $ovsfile ovs local_ip $COM_MGNT_IP
	
	ops_add $ovsfile securitygroup firewall_driver iptables_hybrid
}

# Function configure things relation
neutron_config_relation () {
	ovs-vsctl add-br br-provider
	ovs-vsctl add-port br-provider $COM_EXT_IF
	ip a flush $COM_EXT_IF
	ifconfig br-provider $COM_EXT_IP netmask $COM_EXT_NETMASK
	ip link set br-provider up
	ip r add default via $GATEWAY_EXT_IP
	echo "nameserver 8.8.8.8" > /etc/resolv.conf
	
	cat << EOF > /etc/network/interfaces
# loopback network interface
auto lo
iface lo inet loopback

# external network interface
# auto $COM_EXT_IF
# iface $COM_EXT_IF inet static
# address $COM_EXT_IP
# netmask $COM_EXT_NETMASK
# gateway $GATEWAY_EXT_IP
# dns-nameservers 8.8.8.8

auto br-provider
allow-ovs br-provider
iface br-provider inet static
    address $COM_EXT_IP
    netmask $COM_EXT_NETMASK
    gateway $GATEWAY_EXT_IP
    dns-nameservers 8.8.8.8
    ovs_type OVSBridge
    ovs_ports $COM_EXT_IF

allow-br-provider $COM_EXT_IF
iface $COM_EXT_IF inet manual
    ovs_bridge br-provider
    ovs_type OVSPort

# internal network interface
auto $COM_MGNT_IF
iface $COM_MGNT_IF inet static
address $COM_MGNT_IP
netmask $COM_MGNT_NETMASK
EOF
}

# Function configure the Compute service to use the Networking service
neutron_config_compute_use_network () {
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
}

# Function restart installation
neutron_restart () {
	echocolor "Finalize installation"
	sleep 3
	service nova-compute restart
	service neutron-openvswitch-agent restart
}

#######################
###Execute functions###
#######################

# Install the components Neutron
neutron_install

# Configure the common component
neutron_config_server_component

# Configure the Open vSwitch agent
neutron_config_ovs

# Configure things relation
neutron_config_relation
	
# Configure the Compute service to use the Networking service
neutron_config_compute_use_network
	
# Restart installation
neutron_restart