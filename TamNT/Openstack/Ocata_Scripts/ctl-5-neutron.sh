#! /bin/bash

source config.sh
source functions.sh

echocolor "Prepare for install Neutron"
cat << EOF | mysql -u root -p$MYSQL_PASS
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$NEUTRON_DBPASS';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$NEUTRON_DBPASS';
EOF

. admin-openrc
openstack user create --domain default --password $NEUTRON_PASS neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

echocolor "Install Neutron"
apt-get install neutron-server neutron-plugin-ml2 \
  neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
  neutron-metadata-agent -y

echocolor "Cau hinh Neutron option 2 ..."
neutronconf=/etc/neutron/neutron.conf
cp $neutronconf $neutronconf.orig
ops_del $neutronconf database connection
ops_add $neutronconf database connection mysql+pymysql://neutron:$NEUTRON_DBPASS@controller/neutron
ops_add $neutronconf DEFAULT service_plugins router
ops_add $neutronconf DEFAULT allow_overlapping_ips true
ops_add $neutronconf DEFAULT transport_url rabbit://openstack:$RABBIT_PASS@controller 
ops_add $neutronconf DEFAULT auth_strategy keystone
ops_add $neutronconf DEFAULT notify_nova_on_port_status_changes true
ops_add $neutronconf DEFAULT notify_nova_on_port_data_changes true
ops_add $neutronconf keystone_authtoken auth_uri http://controller:5000
ops_add $neutronconf keystone_authtoken auth_url http://controller:35357
ops_add $neutronconf keystone_authtoken memcached_servers controller:11211
ops_add $neutronconf keystone_authtoken auth_type password
ops_add $neutronconf keystone_authtoken project_domain_name default
ops_add $neutronconf keystone_authtoken user_domain_name default
ops_add $neutronconf keystone_authtoken project_name service
ops_add $neutronconf keystone_authtoken username neutron
ops_add $neutronconf keystone_authtoken password $NEUTRON_PASS 
ops_add $neutronconf nova auth_url http://controller:35357
ops_add $neutronconf nova auth_type password
ops_add $neutronconf nova project_domain_name default
ops_add $neutronconf nova user_domain_name default
ops_add $neutronconf nova region_name RegionOne
ops_add $neutronconf nova project_name service
ops_add $neutronconf nova username nova
ops_add $neutronconf nova password $NOVA_PASS

ml2conf=/etc/neutron/plugins/ml2/ml2_conf.ini
cp $ml2conf $ml2conf.orig
ops_add $ml2conf ml2 type_drivers flat,vlan,vxlan
ops_add $ml2conf ml2 tenant_network_types vxlan
ops_add $ml2conf ml2 mechanism_drivers linuxbridge,l2population
ops_add $ml2conf ml2 extension_drivers port_security
ops_add $ml2conf ml2_type_flat flat_networks provider
ops_add $ml2conf ml2_type_vxlan vni_ranges 1:1000
ops_add $ml2conf securitygroup enable_ipset true

lbrconf=/etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp $lbrconf $lbrconf.orig 
ops_add $lbrconf linux_bridge physical_interface_mappings provider:$CTL_EXT_IF
ops_add $lbrconf vxlan enable_vxlan true
ops_add $lbrconf vxlan local_ip $CTL_MGNT_IP
ops_add $lbrconf vxlan l2_population true
ops_add $lbrconf securitygroup enable_security_group true
ops_add $lbrconf securitygroup firewall_driver neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

l3_agent=/etc/neutron/l3_agent.ini
cp $l3_agent $l3_agent.orig
ops_add $l3_agent DEFAULT interface_driver linuxbridge
dhcp_agent=/etc/neutron/dhcp_agent.ini
ops_add $dhcp_agent DEFAULT interface_driver linuxbridge
ops_add $dhcp_agent DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
ops_add $dhcp_agent DEFAULT enable_isolated_metadata true

metaconf=/etc/neutron/metadata_agent.ini
cp $metaconf $metaconf.orig
ops_add $metaconf DEFAULT nova_metadata_ip controller
ops_add $metaconf DEFAULT metadata_proxy_shared_secret $METADATA_SECRET
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
ops_add $novaconf neutron service_metadata_proxy true
ops_add $novaconf neutron metadata_proxy_shared_secret $METADATA_SECRET
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
service nova-api restart 
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart
echocolor "verify project neutron"
. admin-openrc
openstack extension list --network
openstack network agent list
openstack network agent list
echocolorbg "Hoan thanh setup project Neutron node controller"
