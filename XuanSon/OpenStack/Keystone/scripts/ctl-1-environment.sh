#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf

# update and upgrade for controller
echocolor "Update and Update controller"
sleep 3
apt-get -y update && apt-get -y upgrade

# Install crudini
echocolor "Install crudini"
sleep 3
apt-get install -y crudini


# Install and config NTP
echocolor "Install NTP"

sleep 3
apt-get install -y chrony
ntpfile=/etc/chrony/chrony.conf

sed -i 's/pool 2.debian.pool.ntp.org offline iburst/ \
server 0.asia.pool.ntp.org iburst \
server 1.asia.pool.ntp.org iburst \
server 2.asia.pool.ntp.org iburst/g' $ntpfile

echo "allow 10.10.10.0/24" >> $ntpfile

service chrony restart


# OpenStack packages (python-openStackclient)
sleep 3
apt-get install -y software-properties-common
add-apt-repository -y cloud-archive:ocata
apt-get -y update && apt-get -y dist-upgrade

sleep 3
apt-get install -y python-openstackclient


# Install SQL database (Mariadb)
echocolor "Install SQL database - Mariadb"
sleep 3
apt-get install mariadb-server python-pymysql -y -y

sqlfile=/etc/mysql/mariadb.conf.d/99-openstack.cnf
touch $sqlfile
cat << EOF >$sqlfile
[mysqld]
bind-address = $CTL_MGNT_IP
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF

service mysql restart

# Install Message queue (rabbitmq)
echocolor "Install Message queue (rabbitmq)"
sleep 3
apt-get install -y rabbitmq-server

rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# Install Memcached
echocolor "Install Memcached"
sleep 3
apt-get install -y memcached python-memcache
memcachefile=/etc/memcached.conf
sed -i 's|-l 127.0.0.1|'"-l $CTL_MGNT_IP"'|g' $memcachefile

service memcached restart





