#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.sh


# Config COMPUTE1 node
echocolor "Config COMPUTE node"
sleep 3
## Config hostname
echo "$HOST_COM" > /etc/hostname
hostnamectl set-hostname $HOST_COM

cat << EOF >/etc/hosts
127.0.0.1	localhost

$CTL_MGNT_IP	$HOST_CTL
$COM_MGNT_IP	$HOST_COM	
EOF


## IP address
cat << EOF > /etc/network/interfaces
# loopback network interface
auto lo
iface lo inet loopback

# external network interface
auto $COM_EXT_IF
iface $COM_EXT_IF inet static
address $COM_EXT_IP
netmask $COM_EXT_NETMASK
gateway $GATEWAY_EXT_IP
dns-nameservers 8.8.8.8

# internal network interface
auto $COM_MGNT_IF
iface $COM_MGNT_IF inet static
address $COM_MGNT_IP
netmask $COM_MGNT_NETMASK
EOF
 

ip a flush $COM_EXT_IF
ip a flush $COM_MGNT_IF
ip r del default
ifdown -a && ifup -a