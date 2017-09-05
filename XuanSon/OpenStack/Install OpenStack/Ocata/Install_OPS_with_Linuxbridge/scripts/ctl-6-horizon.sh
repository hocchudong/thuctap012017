#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf

# Install the packages
echocolor "Install the packages"
sleep 3
apt install openstack-dashboard -y

# Edit the /etc/openstack-dashboard/local_settings.py file
echocolor "Edit the /etc/openstack-dashboard/local_settings.py file"
sleep 3

horizonfile=/etc/openstack-dashboard/local_settings.py
horizonfilebak=/etc/openstack-dashboard/local_settings.py.bak
cp $horizonfile $horizonfilebak
egrep -v "^$|^#" $horizonfilebak > $horizonfile

sed -i 's/OPENSTACK_HOST = "127.0.0.1"/OPENSTACK_HOST = "controller"/g' $horizonfile

echo "SESSION_ENGINE = 'django.contrib.sessions.backends.cache'" >> $horizonfile
sed -i "s/'LOCATION': '127.0.0.1:11211',/'LOCATION': 'controller:11211',/g" $horizonfile
sed -i 's/OPENSTACK_KEYSTONE_URL = "http:\/\/%s:5000\/v2.0" % OPENSTACK_HOST/OPENSTACK_KEYSTONE_URL = "http:\/\/%s:5000\/v3" % OPENSTACK_HOST/g' $horizonfile

echo "OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True" >> $horizonfile
cat << EOF >> $horizonfile
OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}
EOF

echo 'OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"' >> $horizonfile
sed -i 's/OPENSTACK_KEYSTONE_DEFAULT_ROLE = "_member_"/OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"/g' $horizonfile

sed -i "s/'enable_router': True,/'enable_router': False,/g" $horizonfile
sed -i "s/'enable_quotas': True,/'enable_quotas': False,/g" $horizonfile
sed -i "s/'enable_ipv6': True,/'enable_ipv6': False,/g" $horizonfile
sed -i "s/'enable_ha_router': False,/'enable_ha_router': False,/g" $horizonfile
sed -i "s/'enable_lb': True,/'enable_lb': False,/g" $horizonfile
sed -i "s/'enable_firewall': True,/'enable_firewall': False,/g" $horizonfile
sed -i "s/'enable_vpn': True,/'enable_vpn': False,/g" $horizonfile
sed -i "s/'enable_fip_topology_check': True,/'enable_fip_topology_check': False,/g" $horizonfile

echo 'TIME_ZONE = "Asia/Ho_Chi_Minh"' >> $horizonfile

chown -R www-data:www-data /var/lib/openstack-dashboard

# Finalize installation
echocolor "Finalize installation"
sleep 3
service apache2 reload


    
    
   
    
    
    
    
    




