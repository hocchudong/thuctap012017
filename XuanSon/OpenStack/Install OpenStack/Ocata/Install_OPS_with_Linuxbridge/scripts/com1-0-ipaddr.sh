#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.cnf


# Config COMPUTE1 node
echocolor "Config COMPUTE1 node"
sleep 3
## Config hostname
echo "$HOST_COM1" > /etc/hostname

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
auto $COM1_EXT_IF
iface $COM1_EXT_IF inet static
address $COM1_EXT_IP
netmask $COM1_EXT_NETMASK
gateway $GATEWAY_EXT_IP
dns-nameservers 8.8.8.8

# internal network interface
auto $COM1_MGNT_IF
iface $COM1_MGNT_IF inet static
address $COM1_MGNT_IP
netmask $COM1_MGNT_NETMASK
EOF
 

# Reboot COMPUTE1
echocolor "Rebooting COMPUTE1"
sleep 3

init 6



