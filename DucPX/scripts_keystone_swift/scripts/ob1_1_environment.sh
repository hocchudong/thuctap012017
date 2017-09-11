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
	address $OBJECT1_MGNT_IP
	netmask $NETMASK

# EXT NETWORK
auto ens38
iface ens38 inet static
	address $OBJECT1_EXT_IP
	netmask $NETMASK
	gateway $GATEWAY
	dns-nameservers 8.8.8.8

# TENANT NETWORK
auto ens39
iface ens39 inet static
	address $OBJECT1_TENANT_IP
	netmask $NETMASK
EOF

notification "Configuring hostname in OBJECT1 node"
sleep 3
echo "$HOST_OBJECT1" > /etc/hostname
hostname -F /etc/hostname

notification "Configuring for file /etc/hosts"
sleep 3
iphost=/etc/hosts
test -f $iphost.orig || cp $iphost $iphost.orig
rm $iphost
touch $iphost
cat << EOF >> $iphost
127.0.0.1       localhost	$HOST_CTL
$CTL_MGNT_IP    $HOST_CTL
$OBJECT1_MGNT_IP   $HOST_OBJECT1
$OBJECT2_MGNT_IP   $HOST_OBJECT2
EOF

notification "Enable the OpenStack PIKE repository"
apt-get install software-properties-common -y
add-apt-repository cloud-archive:pike -y

sleep 5
notification "Upgrade the packages for server"
apt -y update && apt -y dist-upgrade

sleep 5
notification "Reboot Server"
sleep 3
init 6
#
        