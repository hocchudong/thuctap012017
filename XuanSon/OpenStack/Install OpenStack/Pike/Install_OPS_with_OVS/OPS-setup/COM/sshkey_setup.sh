#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

apt-get install fping -y
fping $COM_EXT_IP
if [ $? != "0" ]
then
	echocolor "Node Compute not known"
	exit 1;
fi

apt-get install sshpass -y
ssh-keygen -t rsa -N "" -f mykey
sshpass -p $COM_PASS ssh-copy-id -i mykey.pub root@$COM_EXT_IP

ssh -i mykey root@$COM_EXT_IP <<EOF
# Update and upgrade for COMPUTE
echo -e "\e[32mUpdate and Update COMPUTE \e[0m"
sleep 3
apt-get update -y && apt-get upgrade -y

# OpenStack packages (python-openstackclient)
echo -e "\e[32mInstall OpenStack client \e[0m"
sleep 3
apt-get install software-properties-common -y
add-apt-repository cloud-archive:pike -y
apt-get update -y && apt-get dist-upgrade -y

apt-get install python-openstackclient -y
EOF