#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf

# Create database for Nova
echocolor "Create database for Nova"
sleep 3

cat << EOF | mysql
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';
EOF

# Set environment variable for user admin
source /root/admin-openrc

# Create infomation for Compute service
echocolor "Create infomation for Compute service"
sleep 3

## Create info for nova user
echocolor "Create info for nova user"
sleep 3

openstack user create --domain default --password $NOVA_DBPASS nova
openstack role add --project service --user nova admin
openstack service create --name nova \
  --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne \
  compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne \
  compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne \
  compute admin http://controller:8774/v2.1

## Create info for placement user
echocolor "Create info for placement user"
sleep 3

openstack user create --domain default --password $PLACEMENT_PASS placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778


# Install and configure components of Nova
echocolor "Install and configure components of Nova"
sleep 3
apt install nova-api nova-conductor nova-consoleauth \
  nova-novncproxy nova-scheduler nova-placement-api -y

## Config /etc/nova/nova.conf file
novafile=/etc/nova/nova.conf
novafilebak=/etc/nova/nova.conf.bak
cp $novafile $novafilebak
egrep -v "^$|^#" $novafilebak > $novafile

ops_del $novafile api_database connection
ops_add $novafile api_database \
	connection mysql+pymysql://nova:$NOVA_DBPASS@controller/nova_api

ops_add $novafile database \
	connection mysql+pymysql://nova:$NOVA_DBPASS@controller/nova

ops_add $novafile DEFAULT \
	transport_url rabbit://openstack:$RABBIT_PASS@controller

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
	password $NOVA_DBPASS

ops_add $novafile DEFAULT \
	my_ip $CTL_MGNT_IP
ops_add $novafile DEFAULT \
	use_neutron True
ops_add $novafile DEFAULT \
	firewall_driver nova.virt.firewall.NoopFirewallDriver

ops_add $novafile vnc \
	enabled true
ops_add $novafile vnc \
	vncserver_listen \$my_ip
ops_add $novafile vnc \
	vncserver_proxyclient_address \$my_ip

ops_add $novafile glance \
	api_servers http://controller:9292

ops_del $novafile oslo_concurrency lock_path
ops_add $novafile oslo_concurrency \
	lock_path /var/lib/nova/tmp
	
ops_del $novafile DEFAULT log_dir

ops_del $novafile placement os_region_name
ops_add $novafile placement os_region_name RegionOne
ops_add $novafile placement project_domain_name Default
ops_add $novafile placement project_name service
ops_add $novafile placement auth_type password
ops_add $novafile placement user_domain_name Default
ops_add $novafile placement auth_url http://controller:35357/v3
ops_add $novafile placement username placement
ops_add $novafile placement password $PLACEMENT_PASS


# Populate the nova-api database
echocolor "Populate the nova-api database"
sleep 3
su -s /bin/sh -c "nova-manage api_db sync" nova

# Register the cell0 database
echocolor "Register the cell0 database"
sleep 3
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
	
# Create the cell1 cell
echocolor "Create the cell1 cell"
sleep 3
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova

# Populate the nova database
echocolor "Populate the nova database"
sleep 3
su -s /bin/sh -c "nova-manage db sync" nova

# Verify nova cell0 and cell1 are registered correctly
echocolor "Verify nova cell0 and cell1 are registered correctly"
sleep 3
nova-manage cell_v2 list_cells

# Finalize installation
echocolor "Finalize installation"
sleep 3

service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart









