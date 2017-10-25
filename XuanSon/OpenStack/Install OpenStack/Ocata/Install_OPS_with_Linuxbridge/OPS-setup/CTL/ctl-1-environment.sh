#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

# Install crudini
echocolor "Install crudini"
sleep 3
apt-get install -y crudini

# Function install and config NTP
install_ntp () {
	echocolor "Install NTP"
	sleep 3

	apt-get install chrony -y
	ntpfile=/etc/chrony/chrony.conf

	sed -i 's/pool 2.debian.pool.ntp.org offline iburst/ \
pool 2.debian.pool.ntp.org offline iburst \
server 0.asia.pool.ntp.org iburst \
server 1.asia.pool.ntp.org iburst/g' $ntpfile

	echo "allow $CIDR_MGNT" >> $ntpfile

	service chrony restart
}

# Function install mysql
install_sql () {
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
}

# Function install message queue
install_mq () {
	echocolor "Install Message queue (rabbitmq)"
	sleep 3

	apt-get install rabbitmq-server -y
	rabbitmqctl add_user openstack $RABBIT_PASS
	rabbitmqctl set_permissions openstack ".*" ".*" ".*"
}

# Function install Memcached
install_memcached () {
	echocolor "Install Memcached"
	sleep 3

	apt-get install memcached python-memcache -y
	memcachefile=/etc/memcached.conf
	sed -i 's|-l 127.0.0.1|'"-l $CTL_MGNT_IP"'|g' $memcachefile

	service memcached restart
} 

#######################
###Execute functions###
#######################

# Install and config NTP
install_ntp

# Install SQL database (Mariadb)
install_sql

# Install Message queue (rabbitmq)
install_mq

# Install Memcached
install_memcached
