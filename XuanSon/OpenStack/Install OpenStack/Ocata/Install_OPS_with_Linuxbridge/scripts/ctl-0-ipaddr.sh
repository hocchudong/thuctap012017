#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf


# Config CONTROLLER node
echocolor "Config CONTROLLER node"
sleep 3
## Config hostname
echo "$HOST_CTL" > /etc/hostname

cat << EOF >/etc/hosts
127.0.0.1	localhost

$CTL_MGNT_IP	$HOST_CTL
$COM1_MGNT_IP	$HOST_COM1	
EOF


## IP address
cat << EOF > /etc/network/interfaces
# loopback network interface
auto lo
iface lo inet loopback

# external network interface
auto $CTL_EXT_IF
iface $CTL_EXT_IF inet static
address $CTL_EXT_IP
netmask $CTL_EXT_NETMASK
gateway $GATEWAY_EXT_IP
dns-nameservers 8.8.8.8

# internal network interface
auto $CTL_MGNT_IF
iface $CTL_MGNT_IF inet static
address $CTL_MGNT_IP
netmask $COM1_MGNT_NETMASK
EOF
 

# Reboot controller
echocolor "Rebooting controller"
sleep 3

init 6



