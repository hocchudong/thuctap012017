#! /bin/bash

source config.sh
source functions.sh
echocolor "Cai dat Neutron"
sleep 3
apt install neutron-linuxbridge-agent -y
echocolor "Cau hinh Neutron"
sleep 3
neutronconf=/etc/neutron/neutron.conf
cp $neutronconf $neutronconf.orig 
ops_del $neutronconf database connection
ops_add $neutronconf DEFAULT transport_url rabbit://openstack:$RABBIT_PASS@controller
ops_add $neutronconf DEFAULT auth_strategy keystone
ops_add $neutronconf keystone_authtoken auth_uri http://controller:5000
ops_add $neutronconf keystone_authtoken auth_url http://controller:35357
ops_add $neutronconf keystone_authtoken memcached_servers controller:11211
ops_add $neutronconf keystone_authtoken auth_type password
ops_add $neutronconf keystone_authtoken project_domain_name default
ops_add $neutronconf keystone_authtoken user_domain_name default
ops_add $neutronconf keystone_authtoken project_name service
ops_add $neutronconf keystone_authtoken username neutron
ops_add $neutronconf keystone_authtoken password $NEUTRON_PASS

lbrconf=/etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp $lbrconf $lbrconf.orig
ops_add $lbrconf linux_bridge physical_interface_mappings provider:$COM1_EXT_IF
ops_add $lbrconf vxlan enable_vxlan true
ops_add $lbrconf vxlan local_ip $COM1_MGNT_IP
ops_add $lbrconf vxlan l2_population true
ops_add $lbrconf securitygroup enable_security_group true
ops_add $lbrconf securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

novaconf=/etc/nova/nova.conf
ops_add $novaconf neutron url http://controller:9696
ops_add $novaconf neutron auth_url http://controller:35357
ops_add $novaconf neutron auth_type password
ops_add $novaconf neutron project_domain_name default
ops_add $novaconf neutron user_domain_name default
ops_add $novaconf neutron region_name RegionOne
ops_add $novaconf neutron project_name service
ops_add $novaconf neutron username neutron
ops_add $novaconf neutron password $NEUTRON_PASS
echocolor "restart nova-compute"
sleep 3
service nova-compute restart
service neutron-linuxbridge-agent restart

echocolorbg "Hoan thanh setup project Neutron node compute"