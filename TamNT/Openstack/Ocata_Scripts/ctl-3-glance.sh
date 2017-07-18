#! /bin/bash

source config.sh
source functions.sh

echocolorbg "Chuan bi cai dat Glance"
sleep 3
echocolor "Tao database cho Glance"

cat << EOF | mysql -u root -p$MYSQL_PASS
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DBPASS';

EOF

echocolor "create the service credentials"
sleep 3

. admin-openrc
openstack user create --domain default --password $GLANCE_PASS glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image

echocolor "Create the Image service API endpoints:"
sleep 3

openstack endpoint create --region RegionOne image public http://$HOST_CTL:9292
openstack endpoint create --region RegionOne image internal http://$HOST_CTL:9292
openstack endpoint create --region RegionOne  image admin http://$HOST_CTL:9292

echocolorbg "Install and configure Glance"
sleep 3

echocolor "Install glance"
apt-get install glance -y

echocolor "Configure components"
sleep 3

glance_api=/etc/glance/glance-api.conf

ops_add $glance_api database connection mysql+pymysql://glance:$GLANCE_DBPASS@$HOST_CTL/glance
ops_add $glance_api keystone_authtoken auth_uri http://$HOST_CTL:5000
ops_add $glance_api keystone_authtoken auth_url http://$HOST_CTL:35357
ops_add $glance_api keystone_authtoken memcached_servers $HOST_CTL:11211
ops_add $glance_api keystone_authtoken auth_type password
ops_add $glance_api keystone_authtoken project_domain_name default
ops_add $glance_api keystone_authtoken user_domain_name default
ops_add $glance_api keystone_authtoken project_name service
ops_add $glance_api keystone_authtoken username glance
ops_add $glance_api keystone_authtoken password $GLANCE_PASS
ops_add $glance_api paste_deploy flavor keystone
ops_add $glance_api glance_store stores file,http
ops_add $glance_api glance_store default_store file
ops_add $glance_apii glance_store filesystem_store_datadir /var/lib/glance/images/

glance_registry=/etc/glance/glance-registry.conf
ops_add $glance_registry database connection mysql+pymysql://glance:$GLANCE_DBPASS@$HOST_CTL/glance
ops_add $glance_registry keystone_authtoken auth_uri http://$HOST_CTL:5000
ops_add $glance_registry keystone_authtoken auth_url http://$HOST_CTL:35357
ops_add $glance_registry keystone_authtoken memcached_servers $HOST_CTL:11211
ops_add $glance_registry keystone_authtoken auth_type password
ops_add $glance_registry keystone_authtoken project_domain_name default
ops_add $glance_registry keystone_authtoken user_domain_name default
ops_add $glance_registry keystone_authtoken project_name service
ops_add $glance_registry keystone_authtoken username glance
ops_add $glance_registry keystone_authtoken password $GLANCE_PASS
ops_add $glance_registry paste_deploy flavor keystone

su -s /bin/sh -c "glance-manage db_sync" glance

echocolor "Restart the Image services"
sleep 3
service glance-registry restart
service glance-api restart

echocolorbg "Xac nhan lai dich vu image service"
apt-get install wget -y
. admin-openrc
wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
openstack image create "cirros" --file cirros-0.3.5-x86_64-disk.img \
  --disk-format qcow2 --container-format bare --public
  
openstack image list

