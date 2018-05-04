#! /bin/bash

source config.sh
source functions.sh

cat << EOF | mysql -u root -p$MYSQL_PASS
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'welcome123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'welcome123';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'welcome123';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'welcome123';

EOF
. admin-openrc
echocolor "Prepare for nova"
sleep 3
openstack user create --domain default --password $NOVA_PASS nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
openstack user create --domain default --password $PLACEMENT_PASS placement
openstack role add --project service --user placement admin

openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
echocolor "Install Nova node controller"
sleep 3
apt-get install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler nova-placement-api -y
echocolor "Cau hinh Nova"
sleep 3

novaconf=/etc/nova/nova.conf
cp $novaconf $novaconf.orig
ops_del $novaconf api_database connection
ops_add $novaconf api_database connection mysql+pymysql://nova:$NOVA_DBPASS@controller/nova_api
ops_add $novaconf database connection mysql+pymysql://nova:$NOVA_DBPASS@controller/nova
ops_add $novaconf DEFAULT transport_url rabbit://openstack:$RABBIT_PASS@controller
ops_add $novaconf DEFAULT my_ip $CTL_MGNT_IP
ops_add $novaconf DEFAULT use_neutron True
ops_add $novaconf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
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
ops_add $novaconf vnc enabled true
ops_add $novaconf vnc vncserver_listen \$my_ip
ops_add $novaconf vnc vncserver_proxyclient_address \$my_ip
ops_add $novaconf glance api_servers http://controller:9292
ops_del $novaconf oslo_concurrency lock_path
ops_add $novaconf oslo_concurrency lock_path /var/lib/nova/tmp
ops_del $novaconf DEFAULT log_dir
ops_del $novaconf placement os_region_name
ops_add $novaconf placement os_region_name RegionOne
ops_add $novaconf placement project_domain_name Default
ops_add $novaconf placement project_name service
ops_add $novaconf placement auth_type password
ops_add $novaconf placement user_domain_name Default
ops_add $novaconf placement auth_url http://controller:35357/v3
ops_add $novaconf placement username placement
ops_add $novaconf placement password $PLACEMENT_PASS

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
nova-manage cell_v2 list_cells
service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

echocolorbg "Hoan thanh cai dat project Nova tren controller node"
