#! /bin/bash 

source config.sh
source functions.sh

echocolorbg "Update controller"
apt-get update && apt-get dist-upgrade -y

echocolorbg "Install crudini: "
sleep 5
apt-get install crudini -y

echocolorbg "Cau hinh moi truong chuan bi cho  cai dat openstack"
sleep 5

echocolor "Install va cau hinh chrony: "
sleep 3
apt-get install chrony -y
chronyconf=/etc/chrony/chrony.conf
cp $chronyconf $chronyconf.orig

sed -i 's/.debian./.asia./g' $chronyconf
sed -i 's/ offline minpoll 8/ iburst/g' $chronyconf

echo "allow $SUBNETMASK_MGNT" >> $chronyconf
service chrony restart


echocolor "Enable install openstack client"
sleep 3

apt-get install software-properties-common -y
add-apt-repository cloud-archive:ocata -y
apt-get update && apt-get dist-upgrade -y
apt-get install python-openstackclient -y


echocolor "Install SQL database "
sleep 3

apt-get install debconf-utils -y
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASS"
apt-get install mariadb-server python-pymysql -y

echocolor "Cau hinh Maria DB"
sleep 3

mysqlconf=/etc/mysql/mariadb.conf.d/99-openstack.cnf
touch $mysqlconf
cat << EOF > $mysqlconf

[mysqld]

bind-address = $CTL_MGNT_IP

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8

EOF

service mysql restart

echocolor "Install Rabbitmsq"
sleep 3

apt-get install rabbitmq-server -y
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

printf "\n \n"
echocolor "Install Memcache"
sleep 3
apt-get install memcached python-memcache -y

sed -i 's/-l 127.0.0.1/-l 0.0.0.0/g' /etc/memcached.conf

service memcached restart


echocolorbg "Hoan thanh setup moi truong cai dat openstack node controller! =]"
printf "\n \n"