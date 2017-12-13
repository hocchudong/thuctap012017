#! /bin/bash

. config.sh

echocolor "Install packages:  "
yum install epel-release -y

yum install cobbler cobbler-web dnsmasq syslinux xinetd bind bind-utils dhcp debmirror pykickstart fence-agents-all -y

echocolor "Config components:  "
systemctl start cobblerd
systemctl enable cobblerd
systemctl start httpd
systemctl enable httpd

sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0

firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --add-port=69/tcp --permanent
firewall-cmd --add-port=69/udp --permanent
firewall-cmd --add-port=4011/udp --permanent
firewall-cmd --reload

cobbler=/etc/cobbler/settings
cp $cobbler $cobbler.orig
sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' $cobbler
sed -i 's/manage_dns: 0/manage_dns: 1/g' $cobbler
sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' $cobbler
sed -i 's|'"next_server: 127.0.0.1"'|'"next_server: $IP_ADD"'|' $cobbler
sed -i 's|'"server: 127.0.0.1"'|'"server: $IP_ADD"'|' $cobbler

dhcp=/etc/cobbler/dhcp.template
cp $dhcp $dhcp.orig
sed -i "s/subnet .*/subnet $SUBNET netmask $SUBNET_MASK{/g" $dhcp
sed -i "s/192.168.1.5/$GATEWAY/g" $dhcp
sed -i "s/255.255.255.0/$SUBNET_MASK/g" $dhcp
sed -i "s/192.168.1.1;/$DNS;/g" $dhcp
sed -i "s/192.168.1.100 192.168.1.254/$IP_START $IP_END/g" $dhcp

sed -i "s/dhcp-range.*/dhcp-range=$IP_START,$IP_END/g" /etc/cobbler/dnsmasq.template

sed -i "s/@dists/#@dists/g" /etc/debmirror.conf 
sed -i "s/@arches/#@arches/g" /etc/debmirror.conf 
systemctl enable rsyncd.service
systemctl restart rsyncd.service
systemctl restart cobblerd
systemctl restart xinetd
systemctl enable xinetd
cobbler get-loaders
cobbler check
cobbler sync

echocolor "Hoan thanh cai dat Cobbler, truy cap vao dia chi: https://$IP_ADD/cobbler_web dien user cobbler, password cobbler de su dung."