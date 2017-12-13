#!/bin/bash
# Author Son Do Xuan

source ../function.sh
source ../config.sh

# Function create database for Keystone
keystone_create_db () {
	echocolor "Create database for Keystone"
	sleep 3

	cat << EOF | mysql
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY '$KEYSTONE_DBPASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY '$KEYSTONE_DBPASS';
EOF
}

# Function install components of Keystone
keystone_install () {
	echocolor "Install and configure components of Keystone"
	sleep 3
	apt install keystone apache2 libapache2-mod-wsgi -y
}

# Function configure components of Keystone
keystone_config () {
	keystonefile=/etc/keystone/keystone.conf
	keystonefilebak=/etc/keystone/keystone.conf.bak
	cp $keystonefile  $keystonefilebak
	egrep -v "^#|^$" $keystonefilebak > $keystonefile

	ops_add $keystonefile database \
	connection mysql+pymysql://keystone:$KEYSTONE_DBPASS@$HOST_CTL/keystone

	ops_add $keystonefile token provider fernet
}

# Function populate the Identity service database
keystone_populate_db () {
	su -s /bin/sh -c "keystone-manage db_sync" keystone
}

# Function initialize Fernet key repositories
keystone_initialize_key () {
	keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
	keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
}
	
# Function bootstrap the Identity service
keystone_bootstrap () {
	keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
	  --bootstrap-admin-url http://$HOST_CTL:35357/v3/ \
	  --bootstrap-internal-url http://$HOST_CTL:5000/v3/ \
	  --bootstrap-public-url http://$HOST_CTL:5000/v3/ \
	  --bootstrap-region-id RegionOne
}
	
# Function configure the Apache HTTP server
keystone_config_apache () {
	echocolor "Configure the Apache HTTP server"
	sleep 3
	echo "ServerName $HOST_CTL" >> /etc/apache2/apache2.conf
}

# Function finalize the installation
keystone_finalize_install () {
	echocolor "Finalize the installation"
	sleep 3
	service apache2 restart
}

# Function create domain, projects, users and roles
keystone_create_domain_project_user_role () {
	export OS_USERNAME=admin
	export OS_PASSWORD=$ADMIN_PASS
	export OS_PROJECT_NAME=admin
	export OS_USER_DOMAIN_NAME=Default
	export OS_PROJECT_DOMAIN_NAME=Default
	export OS_AUTH_URL=http://$HOST_CTL:35357/v3
	export OS_IDENTITY_API_VERSION=3
	
	echocolor "Create domain, projects, users and roles"
	sleep 3

	openstack project create --domain default \
	  --description "Service Project" service
	  
	openstack project create --domain default \
	  --description "Demo Project" demo

	openstack user create --domain default \
	  --password $DEMO_PASS demo

	openstack role create user

	openstack role add --project demo --user demo user
}

# Function create OpenStack client environment scripts
keystone_create_opsclient_scripts () {
	echocolor "Create OpenStack client environment scripts" 
	sleep 3

	cat << EOF > /root/admin-openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_AUTH_URL=http://$HOST_CTL:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

	chmod +x /root/admin-openrc


	cat << EOF > /root/demo-openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=$DEMO_PASS
export OS_AUTH_URL=http://$HOST_CTL:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

	chmod +x /root/demo-openrc
}

# Function verifying keystone
keystone_verify () {
	echocolor "Verifying keystone"
	sleep 3
	source /root/admin-openrc
	openstack token issue
}

#######################
###Execute functions###
#######################

# Create database for Keystone
keystone_create_db

# Install components of Keystone
keystone_install

# Configure components of Keystone
keystone_config

# Populate the Identity service database
keystone_populate_db

# Initialize Fernet key repositories
keystone_initialize_key

# Bootstrap the Identity service
keystone_bootstrap

# Configure the Apache HTTP server
keystone_config_apache

# Finalize the installation
keystone_finalize_install

# Create domain, projects, users and roles
keystone_create_domain_project_user_role

# Create OpenStack client environment scripts
keystone_create_opsclient_scripts

# Verifying keystone
keystone_verify