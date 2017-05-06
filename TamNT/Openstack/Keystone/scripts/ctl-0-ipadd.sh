#! /bin/bash

source config.sh
source functions.sh

echocolorbg "Cau hinh IP va hostname : "
sleep 5
echocolor "Cau hinh hostname: "
sleep 3
echo "$HOST_CTL" > /etc/hostname

echo > /etc/hosts
cat << EOF > /etc/hosts
127.0.0.1       localhost 

$CTL_MGNT_IP    $HOST_CTL

$COM1_MGNT_IP   $HOST_COM1

EOF

sleep 5

echocolor "Cau hinh IP: "
sleep 3

cp /etc/network/interfaces /etc/network/interfaces.orig

cat << EOF > /etc/network/interfaces

#Dat IP cho controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto $CTL_MGNT_IF
iface $CTL_MGNT_IF inet static
address $CTL_MGNT_IP
netmask $NETMASK_ADD_MGNT


# NAT NETWORK
auto $CTL_EXT_IF
iface $CTL_EXT_IF inet static
address $CTL_EXT_IP
netmask $NETMASK_ADD_EXT
gateway $GATEWAY_IP_EXT
dns-nameservers 8.8.8.8

# DATA NETWORK
auto $CTL_DATA_IF
iface $CTL_DATA_IF inet static
address $CTL_DATA_IP
netmask $NETMASK_ADD_DATA

EOF


echocolorbg "Rebooting controller"
sleep 5

init 6
