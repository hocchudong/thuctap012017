#! /bin/bash

source config.sh
source functions.sh
echocolor "Cai dat dashboard"
sleep 3
apt-get install openstack-dashboard -y
setting=/etc/openstack-dashboard/local_settings.py
cp $setting $setting.orig
#set -i 's/OPENSTACK_HOST = "127.0.0.1"/OPENSTACK_HOST = "controller"/g' $setting
#set -i 's/ALLOWED_HOSTS = '*'/ALLOWED_HOSTS = ['*']/g' $setting
#set -i 's/\'LOCATION\': \'127.0.0.1:11211\'/\'LOCATION\': \'controller:11211\'/g' $setting


#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
#OPENSTACK_KEYSTONE_DEFAULT_ROLE
#sed TIME_ZONE = "TIME_ZONE"
#chown www-data:www-data /var/lib/openstack-dashboard/secret_key 