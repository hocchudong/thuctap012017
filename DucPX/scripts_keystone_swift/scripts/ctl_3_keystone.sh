#!/bin/bash -ex
#
source variable.cfg
source function.sh

notification "Create Database for Keystone"

cat << EOF | mysql -uroot -p$MYSQL_PASS
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';
FLUSH PRIVILEGES;
EOF

notification "Install keystone"

apt install keystone apache2 libapache2-mod-wsgi -y

# Back-up file keystone.conf
filekeystone=/etc/keystone/keystone.conf
test -f $filekeystone.orig || cp $filekeystone $filekeystone.orig

# Config file /etc/keystone/keystone.conf
edit_file $filekeystone database \
connection mysql+pymysql://keystone:$KEYSTONE_DBPASS@$HOST_CTL/keystone

edit_file $filekeystone token provider fernet

#
su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
--bootstrap-admin-url http://controller:35357/v3/ \
--bootstrap-internal-url http://controller:5000/v3/ \
--bootstrap-public-url http://controller:5000/v3/ \
--bootstrap-region-id RegionOne

echo "ServerName $HOST_CTL" >>  /etc/apache2/apache2.conf

service apache2 restart

rm -f /var/lib/keystone/keystone.db

export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://$HOST_CTL:35357/v3
export OS_IDENTITY_API_VERSION=3

###  Create project service
openstack project create --domain default --description "Service Project" service

openstack project create --domain default --description "Demo Project" demo

openstack user create --domain default --password $DEMO_PASS demo

openstack role create user

openstack role add --project demo --user demo user

unset OS_TOKEN OS_URL

# Create environment file
cat << EOF > admin-openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_AUTH_URL=http://$HOST_CTL:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF

sleep 3
cp  admin-openrc /root/admin-openrc
source admin-openrc


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

cp  demo-openrc /root/demo-openrc

notification "Verifying keystone"
openstack token issue