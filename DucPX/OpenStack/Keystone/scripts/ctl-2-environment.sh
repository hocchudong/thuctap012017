#!/bin/bash -ex
#

source variable.cfg
source function.sh

###############################################################################
echocolor "Installing CRUDINI"
sleep 3
apt-get update
apt-get install crudini -y


###############################################################################
echocolor "Install python client"
apt-get -y install python-openstackclient
sleep 5


###############################################################################
echocolor "Install and config NTP"
sleep 3
apt-get -y install chrony
ntpfile=/etc/chrony/chrony.conf
cp $ntpfile $ntpfile.orig
sed -i 's/pool 2.debian.pool.ntp.org offline iburst/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' $ntpfile
echo "allow 10.10.10.0/24" >> $ntpfile
# restart chrony after config
service chrony restart


###############################################################################
echocolor "Install and Config RabbitMQ"
sleep 3
apt-get -y install rabbitmq-server
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"


###############################################################################
echocolor "Install and Config memcached "
sleep 3
apt-get -y install memcached python-memcache
memfile=/etc/memcached.conf
cp $memfile $memfile.orig
sed -i 's|-l 127.0.0.1|'"-l $CTL_MGNT_IP"'|g' $memfile
service memcached restart


###############################################################################
echocolor "Install MYSQL"
sleep 3

apt-get -y install mariadb-server python-pymysql

echocolor "Configuring MYSQL"
sleep 5

touch /etc/mysql/mariadb.conf.d/99-openstack.cnf
cat << EOF > /etc/mysql/mariadb.conf.d/99-openstack.cnf

[mysqld]
bind-address = 10.10.10.61

default-storage-engine = innodb
innodb_file_per_table = on
collation-server = utf8_general_ci
character-set-server = utf8
EOF

echocolor "Thiet lap mat khau tai khoan root cua mysql."
echocolor "Mat khau mac dinh cua script la $MYSQL_PASS"
echocolor "Ban hay nhap mat khau $MYSQL_PASS"
echocolor "Hoac co the thay doi trong file variable.cfg de dong bo mat khau"
sleep 5
mysql_secure_installation