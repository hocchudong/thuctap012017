#!/bin/bash -ex

source variable.cfg
source function.sh

## Edit file config network
ifaces=/etc/network/interfaces # path file config
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Assign IP for Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto ens33
iface ens33 inet static
	address $CTL_MGNT_IP
	netmask $NETMASK

# EXT NETWORK
auto ens38
iface ens38 inet static
	address $CTL_EXT_IP
	netmask $NETMASK
	gateway $GATEWAY
	dns-nameservers 8.8.8.8

# TENANT NETWORK
auto ens39
iface ens39 inet static
	address 10.10.20.61
	netmask $NETMASK
EOF

echocolor "Configuring hostname in CONTROLLER node"
sleep 3
echo "$HOST_CTL" > /etc/hostname
hostname -F /etc/hostname

echocolor "Configuring for file /etc/hosts"
sleep 3
iphost=/etc/hosts
test -f $iphost.orig || cp $iphost $iphost.orig
rm $iphost
touch $iphost
cat << EOF >> $iphost
127.0.0.1       localhost $HOST_CTL
$CTL_MGNT_IP    $HOST_CTL
$COM1_MGNT_IP   $HOST_COM1
EOF

echocolor "Enable the OpenStack OCATA repository"
apt-get install software-properties-common -y
add-apt-repository cloud-archive:ocata -y

sleep 5
echocolor "Upgrade the packages for server"
apt-get -y update && apt-get -y dist-upgrade

sleep 5
echocolor "Reboot Server"

#sleep 5
init 6
#
        