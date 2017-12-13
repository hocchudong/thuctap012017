#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

# Function create database for Glance
glance_create_db () {
	echocolor "Create database for Glance"
	sleep 3

	cat << EOF | mysql
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY '$GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY '$GLANCE_DBPASS';
EOF
}

# Function create the Glance service credentials
glance_create_service () {
	echocolor "Set variable environment for admin user"
	sleep 3
	source /root/admin-openrc

	echocolor "Create the service credentials"
	sleep 3

	openstack user create --domain default --password $GLANCE_PASS glance
	openstack role add --project service --user glance admin
	openstack service create --name glance \
	  --description "OpenStack Image" image
	openstack endpoint create --region RegionOne \
	  image public http://$HOST_CTL:9292
	openstack endpoint create --region RegionOne \
	  image internal http://$HOST_CTL:9292
	openstack endpoint create --region RegionOne \
	  image admin http://$HOST_CTL:9292
}

# Function install components of Glance
glance_install () {
	echocolor "Install and configure components of Glance"
	sleep 3

	apt-get install glance -y
}

# Function config /etc/glance/glance-api.conf file
glance_config_api () {
	glanceapifile=/etc/glance/glance-api.conf
	glanceapifilebak=/etc/glance/glance-api.conf.bak
	cp $glanceapifile $glanceapifilebak
	egrep -v "^#|^$"  $glanceapifilebak > $glanceapifile

	ops_add $glanceapifile database \
		connection mysql+pymysql://glance:$GLANCE_DBPASS@$HOST_CTL/glance

	ops_add $glanceapifile keystone_authtoken \
		auth_uri http://$HOST_CTL:5000
	  
	ops_add $glanceapifile keystone_authtoken \
		auth_url http://$HOST_CTL:35357

	ops_add $glanceapifile keystone_authtoken \
		memcached_servers $HOST_CTL:11211
	  
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
}

# Function config /etc/glance/glance-registry.conf file
glance_config_registry () {
	glanceregistryfile=/etc/glance/glance-registry.conf
	glanceregistryfilebak=/etc/glance/glance-registry.conf.bak
	cp $glanceregistryfile $glanceregistryfilebak
	egrep -v "^#|^$"  $glanceregistryfilebak > $glanceregistryfile

	ops_add $glanceregistryfile database \
	connection mysql+pymysql://glance:$GLANCE_DBPASS@$HOST_CTL/glance

	ops_add $glanceregistryfile keystone_authtoken \
		auth_uri http://$HOST_CTL:5000

	ops_add $glanceregistryfile keystone_authtoken \
		auth_url http://$HOST_CTL:35357
		
	ops_add $glanceregistryfile keystone_authtoken \
		memcached_servers $HOST_CTL:11211
		
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
}

# Function populate the Image service database
glance_populate_db () {
	echocolor "Populate the Image service database"
	sleep 3
	su -s /bin/sh -c "glance-manage db_sync" glance
}


# Function restart the Image services
glance_restart () {
	echocolor "Restart the Image services"
	sleep 3

	service glance-registry restart
	service glance-api restart 
}

# Function upload image to Glance
glance_upload_image () {
	echocolor "Upload image to Glance"
	sleep 3
	source /root/admin-openrc
	apt-get install wget -y
	wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img

	openstack image create "cirros" \
	  --file cirros-0.3.5-x86_64-disk.img \
	  --disk-format qcow2 --container-format bare \
	  --public
	  
	openstack image list
}

#######################
###Execute functions###
#######################

# Create database for Glance
glance_create_db

# Create the Glance service credentials
glance_create_service

# Install components of Glance
glance_install

# Config /etc/glance/glance-api.conf file
glance_config_api

# Config /etc/glance/glance-registry.conf file
glance_config_registry

# Populate the Image service database 
glance_populate_db

# Restart the Image services
glance_restart 
  
# Upload image to Glance
glance_upload_image