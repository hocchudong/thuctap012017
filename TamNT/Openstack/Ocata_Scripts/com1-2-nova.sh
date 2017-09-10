#! /bin/bash

source config.sh
source functions.sh

echocolor "Cai dat Nova-compute"
sleep 3
apt-get install nova-compute -y
echocolor "Cau hinh Nova-compute"
sleep 3

novaconf=/etc/nova/nova.conf
cp $novaconf $novaconf.orig
ops_add $novaconf DEFAULT transport_url rabbit://openstack:$RABBIT_PASS@controller
ops_add $novaconf DEFAULT my_ip $COM1_MGNT_IP
ops_add $novaconf DEFAULT use_neutron True
ops_add $novaconf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
ops_del $novaconf DEFAULT log_dir
ops_add $novaconf api auth_strategy keystone
ops_add $novaconf keystone_authtoken auth_uri http://controller:5000
ops_add $novaconf keystone_authtoken auth_url http://controller:35357
ops_add $novaconf keystone_authtoken memcached_servers controller:11211
ops_add $novaconf keystone_authtoken auth_type password
ops_add $novaconf keystone_authtoken project_domain_name default
ops_add $novaconf keystone_authtoken user_domain_name default
ops_add $novaconf keystone_authtoken project_name service
ops_add $novaconf keystone_authtoken username nova
ops_add $novaconf keystone_authtoken password $NOVA_PASS
ops_add $novaconf vnc enabled True
ops_add $novaconf vnc vncserver_listen 0.0.0.0
ops_add $novaconf vnc vncserver_proxyclient_address \$my_ip
ops_add $novaconf vnc novncproxy_base_url http://controller:6080/vnc_auto.html
ops_add $novaconf glance api_servers http://controller:9292
ops_del $novaconf oslo_concurrency lock_path
ops_add $novaconf oslo_concurrency lock_path /var/lib/nova/tmp
ops_del $novaconf placement os_region_name
ops_add $novaconf placement os_region_name RegionOne
ops_add $novaconf placement project_domain_name Default
ops_add $novaconf placement project_name service
ops_add $novaconf placement auth_type password
ops_add $novaconf placement user_domain_name Default
ops_add $novaconf placement auth_url http://controller:35357/v3
ops_add $novaconf placement username placement
ops_add $novaconf placement password $PLACEMENT_PASS

service nova-compute restart
echocolorbg "Hoan thanh cai dat nova-compute node compute1"
