#!/bin/bash
#Author Son Do Xuan

HOSTNAME=$1
IF=$2
IP=$3
NETMASK=$4
GATEWAY_IP=$5

echo -e "\e[31mConfig NIC of provider network\e[0m"

if [ $# -ne 5 ]
then
	echo -e "\e[31mEnter 5 parameters:\e[0m"
	echo -e "\e[32mHOSTNAME NIC_NAME IP_ADDRESS NETMASK GATEWAY\e[0m"
	echo -e "\e[32mExample: source ip_setup.sh controller ens4 192.168.2.71 255.255.255.0 192.168.2.1\e[0m"
	exit 1;
else
	echo -e "\e[32mScripts start install \e[0m"
fi

# Config $HOSTNAME node
echo -e "\e[32mConfig $HOSTNAME node \e[0m"
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
auto $IF
iface $IF inet static
address $IP
netmask $NETMASK
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8
EOF
 
ip a flush $EXT_IF
ip r del default
ifdown -a && ifup -a