#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

cat << EOF > /root/.ssh/config
Host *
	StrictHostKeyChecking no
	UserKnownHostsFile /dev/null
EOF

apt-get install fping -y
fping $CTL_EXT_IP
if [ $? != "0" ]
then
	echocolor "Node Controller not known"
	exit 1;
fi

apt-get install sshpass -y
ssh-keygen -t rsa -N "" -f mykey
sshpass -p $CTL_PASS ssh-copy-id -i mykey.pub root@$CTL_EXT_IP

ssh -i mykey root@$CTL_EXT_IP <<EOF
# Update and upgrade for Controller
echo -e "\e[32mUpdate and Update controller \e[0m"
sleep 3
apt-get update -y&& apt-get upgrade -y

# OpenStack packages (python-openstackclient)
echo -e "\e[32mInstall OpenStack client \e[0m"
sleep 3
apt-get install software-properties-common -y
add-apt-repository cloud-archive:pike -y
apt-get update -y && apt-get dist-upgrade -y

apt-get install python-openstackclient -y
EOF