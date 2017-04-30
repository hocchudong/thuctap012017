#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf

# Create database for Keystone
echocolor "Create database for Keystone"

cat << EOF | mysql
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY '$KEYSTONE_DBPASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY '$KEYSTONE_DBPASS';
EOF

# Install and configure components of Keystone
echocolor "Install and configure components of Keystone"
sleep 3
apt-get install -y keystone
keystonefile=/etc/keystone/keystone.conf

#
ops_del $keystonefile database connection
ops_add $keystonefile database \
connection mysql+pymysql://keystone:$KEYSTONE_DBPASS@controller/keystone

ops_add $keystonefile database token provider fernet

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne


# Configure the Apache HTTP server
echocolor "Configure the Apache HTTP server"
sleep 3
echo "ServerName $HOST_CTL" >> /etc/apache2/apache2.conf

# Finalize the installation  
service apache2 restart
rm -f /var/lib/keystone/keystone.db
  
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
  

openstack project create --domain default \
  --description "Service Project" service
  
openstack project create --domain default \
  --description "Demo Project" demo

openstack user create --domain default \
  --password $DEMO_PASS demo

openstack role create user

openstack role add --project demo --user demo user

# Create OpenStack client environment scripts
echocolor "Create OpenStack client environment scripts" 
sleep 3

cat << EOF > admin-openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

chmod +x admin-openrc
cat admin-openrc >> .profile

cat << EOF > demo-openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=$DEMO_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

chmod +x demo-openrc


# Verifying keystone
echocolor "Verifying keystone"
openstack token issue


  
  
  
  



