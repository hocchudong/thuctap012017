#! /bin/bash 

source config.sh
source functions.sh
echocolorbg "Update compute1"
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
sed -i 's/pool 2.debian.pool.ntp.org offline iburst/server controller iburst/g' $chronyconf
service chrony restart

echocolor "Enable install openstack client"
sleep 3
apt-get install software-properties-common -y
add-apt-repository cloud-archive:ocata -y
apt-get update && apt-get dist-upgrade -y
apt-get install python-openstackclient -y

echocolorbg "Hoan thanh setup moi truong cai dat openstack node compute1! =]"
printf "\n \n"
