#! /bin/bash

source config.sh
source functions.sh
echocolor "Cai dat Horizon"
sleep 3
apt-get install openstack-dashboard -y

horizonconf=/etc/openstack-dashboard/local_settings.py

sed -i 's/OPENSTACK_HOST = "127.0.0.1"/OPENSTACK_HOST = "controller"/g' $horizonconf 
sed -i 's/127.0.0.1/controller/g' $horizonconf 
sed -i 's/v2.0/v3/g' $horizonconf 
sed -i 's/#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = False/OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True/g' $horizonconf 
sed -i 's/#OPENSTACK_API_VERSIONS/OPENSTACK_API_VERSIONS/g' $horizonconf 
sed -i 's/#    "data-processing": 1.1,//g' $horizonconf 
sed -i 's/#    "identity": 3,/    "identity": 3,/g' $horizonconf 
sed -i 's/#    "image": 2,/    "image": 2,/g' $horizonconf 
sed -i 's/#    "volume": 2,/    "volume": 2,/g' $horizonconf 
sed -i 's/#    "compute": 2,/}/g' $horizonconf 
sed -i 's/#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = /OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = /g' $horizonconf 
sed -i 's/_member_/user/g' $horizonconf 
sed -i 's/UTC/Asia\/\Ho_Chi_Minh/g' $horizonconf 
echo "SESSION_ENGINE = 'django.contrib.sessions.backends.cache' " >> $horizonconf
service apache2 reload
chown -R www-data:www-data /var/lib/openstack-dashboard
echocolor "Hoan thanh cai dat Horizon! Tien hanh kiem tra tren trinh duyet: http://controller/horizon" 