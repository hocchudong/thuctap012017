#! /bin/bash 

source config.sh
source functions.sh

# create database for Keystone
echocolorbg "Tao database cho Keystone: "
sleep 3

cat << EOF | mysql -u root -p$KEYSTONE_DBPASS
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';

EOF

echocolorbg "Cai dat Keystone"
sleep 3

apt-get install keystone -y

echocolor "Cau hinh Keystone"
sleep 3

keystoneconf=/etc/keystone/keystone.conf
ops_del $keystoneconf database connection
ops_add $keystoneconf database connection mysql+pymysql://keystone:$KEYSTONE_DBPASS@$HOST_CTL/keystone
ops_add $keystoneconf token provider fernet

su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
  --bootstrap-admin-url http://$HOST_CTL:35357/v3/ \
  --bootstrap-internal-url http://$HOST_CTL:5000/v3/ \
  --bootstrap-public-url http://$HOST_CTL:5000/v3/ \
  --bootstrap-region-id RegionOne

echocolor "Cau hinh Apache2 server"
sleep 3
echo "ServerName $HOST_CTL" >> /etc/apache2/apache2.conf
service apache2 restart
rm -f /var/lib/keystone/keystone.db

echocolor "Tao file admin_openrc de thao tac voi Keystone thong qua Openstack client"
sleep 2

cat << EOF > admin_openrc
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_AUTH_URL=http://$HOST_CTL:35357/v3
export OS_IDENTITY_API_VERSION=3

EOF

chmod a+x admin_openrc
echocolorbg "Tao domains, projects, users, roles "
sleep 5
source admin_openrc
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password $DEMO_PASS demo
openstack role create user
openstack role add --project demo --user demo user

echocolor "Test keystone cap phat token"
source admin_openrc
openstack token issue


