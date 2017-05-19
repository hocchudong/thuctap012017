#! /bin/bash 

source functions.sh

cp env.sh env.sh.bak

echocolorbg "Install crudini: "
sleep 5
apt-get install crudini -y

echocolorbg "Nhap dia chi IP cau hinh: "
sleep 5

file=env.sh
echocolor "Nhap dia chi IP dai Management cho node controller: "
read CTL_MGNT_IP
ops_add $file ip_ctl CTL_MGNT_IP $CTL_MGNT_IP

echocolor "Nhap dia chi IP dai NAT cho node controller: "
read CTL_EXT_IP
ops_add $file ip_ctl CTL_EXT_IP $CTL_EXT_IP

echocolor "Nhap dia chi IP dai DATA cho node controller: "
read CTL_DATA_IP
ops_add $file ip_ctl CTL_DATA_IP $CTL_DATA_IP

echocolor "Nhap ten interface dai Management cho node controller: "
read CTL_MGNT_IF
ops_add $file ip_ctl CTL_MGNT_IF $CTL_MGNT_IF

echocolor "Nhap ten interface dai NAT cho node controller: "
read CTL_EXT_IF
ops_add $file ip_ctl CTL_EXT_IF $CTL_EXT_IF

echocolor "Nhap ten interface dai DATA cho node controller: "
read CTL_DATA_IF
ops_add $file ip_ctl CTL_DATA_IF $CTL_DATA_IF

echocolor "Nhap dia chi IP dai Management cho node compute1: "
read COM1_MGNT_IP
ops_add $file ip_com1 COM1_MGNT_IP $COM1_MGNT_IP

echocolor "Nhap dia chi IP dai NAT cho node compute1: "
read COM1_EXT_IP
ops_add $file ip_com1 COM1_EXT_IP $COM1_EXT_IP

echocolor "Nhap dia chi IP dai DATA cho node compute1: "
read COM1_DATA_IP
ops_add $file ip_com1 COM1_DATA_IP $COM1_DATA_IP

echocolor "Nhap ten interface dai Management cho node compute1: "
read COM1_MGNT_IF
ops_add $file ip_com1 COM1_MGNT_IF $COM1_MGNT_IF

echocolor "Nhap ten interface dai NAT cho node compute1: "
read COM1_EXT_IF
ops_add $file ip_com1 COM1_EXT_IF $COM1_EXT_IF

echocolor "Nhap ten interface dai DATA cho node compute1: "
read COM1_DATA_IF
ops_add $file ip_com1 COM1_DATA_IF $COM1_DATA_IF

echocolor "Nhap gateway va netmask cho dai NAT: "
echocolor "GATEWAY: "
read GATEWAY_IP_EXT
ops_add $file gateway_nat GATEWAY_IP_EXT $GATEWAY_IP_EXT

echocolor "NETMASK: "
read NETMASK_ADD_EXT
ops_add $file gateway_nat NETMASK_ADD_EXT $NETMASK_ADD_EXT

echocolor "Nhap gateway va netmask cho dai Management Network: "
echocolor "GATEWAY: "
read GATEWAY_IP_MGNT
ops_add $file gateway_mngt GATEWAY_IP_MGNT $GATEWAY_IP_MGNT
echocolor "SUBNETMASK (Vi du: 10.0.0.0/24):"
read SUBNETMASK_MGNT
ops_add $file gateway_mngt SUBNETMASK_MGNT $SUBNETMASK_MGNT
echocolor "NETMASK: "
read NETMASK_ADD_MGNT
ops_add $file gateway_mngt NETMASK_ADD_MGNT $NETMASK_ADD_MGNT

echocolor "Nhap gateway va netmask cho dai Data Network: "
echocolor "GATEWAY: "
read GATEWAY_IP_DATA
ops_add $file gateway_data GATEWAY_IP_DATA $GATEWAY_IP_DATA
echocolor "NETMASK: "
read NETMASK_ADD_DATA
ops_add $file gateway_data NETMASK_ADD_DATA $NETMASK_ADD_DATA

echocolor "Nhap default password : "
read DEFAULT_PASS
ops_add $file password DEFAULT_PASS $DEFAULT_PASS

echocolor "Nhap ten hostname node controller: "
read HOST_CTL
ops_add $file hostname HOST_CTL $HOST_CTL

echocolor "Nhap ten hostname node compute1: "
read HOST_COM1
ops_add $file hostname HOST_COM1 $HOST_COM1



echocolor "Nhap pool dia chi Floating IP: "
echocolor "Nhap dia chi bat dau dai IP: "
read START_IP_ADDRESS
ops_add $file floating_ip START_IP_ADDRESS $START_IP_ADDRESS

echocolor "Nhap dia chi ket thuc dai: "
read END_IP_ADDRESS
ops_add $file floating_ip END_IP_ADDRESS $END_IP_ADDRESS

echocolor "Nhap dia chi dns name-servers: "
read DNS_RESOLVER
ops_add $file floating_ip DNS_RESOLVER $DNS_RESOLVER

echocolor "Nhap dai dia chi cap phat Floating IP (CIDR): "
read PROVIDER_NETWORK_CIDR
ops_add $file floating_ip PROVIDER_NETWORK_CIDR $PROVIDER_NETWORK_CIDR


egrep -v "^\[" env.sh > config.sh
sed -i 's/ = /=/g' config.sh