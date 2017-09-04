#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf

# Update and upgrade for controller
echocolor "Update and Update controller"
sleep 3
apt-get update -y&& apt-get upgrade -y

# Install crudini
echocolor "Install crudini"
sleep 3
apt-get install -y crudini


# Install and config NTP
echocolor "Install NTP"
sleep 3

apt-get install chrony -y
ntpfile=/etc/chrony/chrony.conf

sed -i 's/pool 2.debian.pool.ntp.org offline iburst/ \
server 0.asia.pool.ntp.org iburst \
server 1.asia.pool.ntp.org iburst \
server 2.asia.pool.ntp.org iburst/g' $ntpfile

echo "allow 10.10.10.0/24" >> $ntpfile

service chrony restart


# OpenStack packages (python-openstackclient)
echocolor "Install OpenStack client"
sleep 3
apt-get install software-properties-common -y
add-apt-repository cloud-archive:ocata -y
apt-get update -y && apt-get dist-upgrade -y

apt-get install python-openstackclient -y


# Install SQL database (Mariadb)
echocolor "Install SQL database - Mariadb"
sleep 3

apt-get install mariadb-server python-pymysql  -y

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

apt-get install rabbitmq-server -y
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# Install Memcached
echocolor "Install Memcached"
sleep 3

apt-get install memcached python-memcache -y
memcachefile=/etc/memcached.conf
sed -i 's|-l 127.0.0.1|'"-l $CTL_MGNT_IP"'|g' $memcachefile

service memcached restart





