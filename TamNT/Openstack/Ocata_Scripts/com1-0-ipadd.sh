#! /bin/bash

source config.sh
source functions.sh

echocolorbg "Cau hinh IP va hostname : "
sleep 5
echocolor "Cau hinh hostname: "
sleep 3
echo "$HOST_COM1" > /etc/hostname

echo > /etc/hosts
cat << EOF > /etc/hosts
127.0.0.1       localhost 

$CTL_MGNT_IP    $HOST_CTL

$COM1_MGNT_IP   $HOST_COM1

$CINDER_MGNT_IP    $HOST_CINDER
EOF

echocolor "Cau hinh IP: "
sleep 3
cp /etc/network/interfaces /etc/network/interfaces.orig
cat << EOF > /etc/network/interfaces

#Dat IP cho controller node
# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto $COM1_MGNT_IF
iface $COM1_MGNT_IF inet static
address $COM1_MGNT_IP
netmask $NETMASK_ADD_MGNT

# NAT NETWORK
auto $COM1_EXT_IF
iface $COM1_EXT_IF inet static
address $COM1_EXT_IP
netmask $NETMASK_ADD_EXT
gateway $GATEWAY_IP_EXT
dns-nameservers 8.8.8.8

# DATA NETWORK
auto $COM1_DATA_IF
iface $COM1_DATA_IF inet static
address $COM1_DATA_IP
netmask $NETMASK_ADD_DATA

EOF
echocolorbg "Rebooting compute1"
sleep 5
init 6
