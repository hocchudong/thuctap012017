#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf

# Create database for Glance
echocolor "Create database for Glance"
sleep 3

cat << EOF | mysql
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY '$GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY '$GLANCE_DBPASS';
EOF

# Login openstack with admin user
echocolor "Login openstack with admin user"
sleep 3

export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

# Create the service credentials
echocolor "Create the service credentials"
sleep 3

openstack user create --domain default --password $GLANCE_PASS glance
openstack role add --project service --user glance admin
openstack service create --name glance \
  --description "OpenStack Image" image
openstack endpoint create --region RegionOne \
  image public http://controller:9292
openstack endpoint create --region RegionOne \
  image internal http://controller:9292
openstack endpoint create --region RegionOne \
  image admin http://controller:9292


# Install and configure components
echocolor "Install and configure components"
sleep 3

apt-get install -y glance

## Config /etc/glance/glance-api.conf file
glanceapifile=/etc/glance/glance-api.conf

ops_add $glanceapifile database \
	connection mysql+pymysql://glance:$GLANCE_DBPASS@controller/glance

ops_add $glanceapifile keystone_authtoken \
	auth_uri http://controller:5000
  
ops_add $glanceapifile keystone_authtoken \
	auth_url http://controller:35357

ops_add $glanceapifile keystone_authtoken \
	memcached_servers controller:11211
  
ops_add $glanceapifile keystone_authtoken \
	auth_type password
  
ops_add $glanceapifile keystone_authtoken \
	project_domain_name default

ops_add $glanceapifile keystone_authtoken \
	user_domain_name default

ops_add $glanceapifile keystone_authtoken \
	project_name service
	
ops_add $glanceapifile keystone_authtoken \
	username glance

ops_add $glanceapifile keystone_authtoken \
	password $GLANCE_PASS

ops_add $glanceapifile paste_deploy \
	flavor keystone	

ops_add $glanceapifile glance_store \
	stores file,http
	
ops_add $glanceapifile glance_store \
	default_store file
	
ops_add $glanceapifile glance_store \
	filesystem_store_datadir /var/lib/glance/images/
	
	
# Config /etc/glance/glance-registry.conf file
glanceregistryfile=/etc/glance/glance-registry.conf

ops_add $glanceregistryfile database \
connection mysql+pymysql://glance:$GLANCE_DBPASS@controller/glance

ops_add $glanceregistryfile keystone_authtoken \
	auth_uri http://controller:5000

ops_add $glanceregistryfile keystone_authtoken \
	auth_url http://controller:35357
	
ops_add $glanceregistryfile keystone_authtoken \
	memcached_servers controller:11211
	
ops_add $glanceregistryfile keystone_authtoken \
	auth_type password	
	
ops_add $glanceregistryfile keystone_authtoken \
	project_domain_name default

ops_add $glanceregistryfile keystone_authtoken \
	user_domain_name default
	
ops_add $glanceregistryfile keystone_authtoken \
	project_name service

ops_add $glanceregistryfile keystone_authtoken \
	username glance

ops_add $glanceregistryfile keystone_authtoken \
	password $GLANCE_PASS

ops_add $glanceregistryfile paste_deploy \
	flavor keystone
  

# Populate the Image service database 
echocolor "Populate the Image service database"
sleep 3
  
su -s /bin/sh -c "glance-manage db_sync" glance
  

# Restart the Image services
echocolor "Restart the Image services"
sleep 3

service glance-registry restart
service glance-api restart 
  
# Upload image to Glance
echocolor "Upload image to Glance"
sleep 3

source /root/admin-openrc

apt-get install -y wget
cd /root
wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img

openstack image create "cirros" \
  --file cirros-0.3.5-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public
  
openstack image list

  

  
  
  
  
  
  




