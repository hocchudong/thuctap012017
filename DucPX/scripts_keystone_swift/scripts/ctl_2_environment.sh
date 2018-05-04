#!/bin/bash -ex
#

source variable.cfg
source function.sh

###############################################################################
notification "Installing CRUDINI"
sleep 3

apt update
apt install crudini -y


###############################################################################
notification "Install python client"
sleep 3

apt install python-openstackclient -y


###############################################################################
notification "Install and config NTP"
sleep 3

apt install chrony -y
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
notification "Install and Config RabbitMQ"
sleep 3

apt install rabbitmq-server -y
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"


###############################################################################
notification "Install and Config memcached "
sleep 3

apt install memcached python-memcache -y
memfile=/etc/memcached.conf
cp $memfile $memfile.orig
sed -i 's/-l 127.0.0.1/-l 0.0.0.0/g' $memfile
service memcached restart


###############################################################################
notification "Install MYSQL"
sleep 3

apt install mariadb-server python-pymysql -y

touch /etc/mysql/mariadb.conf.d/99-openstack.cnf
cat << EOF > /etc/mysql/mariadb.conf.d/99-openstack.cnf

[mysqld]
bind-address = 0.0.0.0

default-storage-engine = innodb
innodb_file_per_table = on
collation-server = utf8_general_ci
character-set-server = utf8
EOF

notification "Thiet lap mat khau tai khoan root cua mysql."
notification "Mat khau mac dinh cua script la $MYSQL_PASS"
notification "Ban hay nhap mat khau $MYSQL_PASS"
notification "Hoac co the thay doi trong file variable.cfg de dong bo mat khau"
sleep 5
mysql_secure_installation