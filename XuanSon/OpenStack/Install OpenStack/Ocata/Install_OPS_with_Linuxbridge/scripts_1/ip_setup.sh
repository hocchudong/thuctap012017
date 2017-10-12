#!/bin/bash

#Author Son Do Xuan

source function.sh

HOSTNAME=$1
EXT_IF=$2
EXT_IP=$3
EXT_NETMASK=$4
GATEWAY_EXT_IP=$5


# Config $HOSTNAME node
echocolor "Config $HOSTNAME node"
sleep 3
## Config hostname
echo "$HOSTNAME" > /etc/hostname
hostnamectl set-hostname $HOSTNAME


## IP address
cat << EOF > /etc/network/interfaces
# loopback network interface
auto lo
iface lo inet loopback

# external network interface
auto $EXT_IF
iface $EXT_IF inet static
address $EXT_IP
netmask $EXT_NETMASK
gateway $GATEWAY_EXT_IP
dns-nameservers 8.8.8.8

EOF
 
ip a flush $EXT_IF
ip r del default
ifdown -a && ifup -a


