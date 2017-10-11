#!/bin/bash

#Author Son Do Xuan


cat << EOF > config.sh
#!/bin/bash

#Author Son Do Xuan


EOF

##########################################
#### Set local variable  for scripts #####
##########################################

echocolor "Set local variable for scripts"
sleep 3

cat << EOF >> config.sh
##########################################
#### Set local variable  for scripts #####
##########################################

echocolor "Set local variable for scripts"
sleep 3

EOF


#  Ipaddress variable and Hostname variable
## Assigning IP for controller node
cat << EOF >> $ile_name
#  Ipaddress variable and Hostname variable
## Assigning IP for controller node
EOF

echocolor "Assigning IP EXT for controller node (IP_address NETMASK INTERFACE):"
read CTLEXTIP CTLEXTNETMASK CTLEXTIF
cat << EOF >> config.sh
CTL_EXT_IP=$CTLEXTIP 
CTL_EXT_NETMASK=$CTLEXTNETMASK
CTL_EXT_IF=$CTLEXTIF
EOF

echocolor "Assigning IP MGNT for controller node(IP_address NETMASK INTERFACE):"
read CTLMGNTIP CTLMGNTNETMASK CTLMGNTIF
cat << EOF >> config.sh
CTL_MGNT_IP=$CTLMGNTIP
CTL_MGNT_NETMASK=$CTLMGNTNETMASK
CTL_MGNT_IF=$CTLMGNTIF

EOF


## Assigning IP for Compute host
echocolor " Assigning IP EXT for Compute host(IP_address NETMASK INTERFACE):"
read COMEXTIP COMEXTNETMASK COMEXTIF
cat << EOF >> config.sh
## Assigning IP for Compute1 host
COM_EXT_IP=$COMEXTIP
COM_EXT_NETMASK=$COMEXTNETMASK
COM_EXT_IF=$COMEXTIF
EOF

echocolor " Assigning IP MGNT for Compute host(IP_address NETMASK INTERFACE):"
read COMMGNTIP COMMGNTNETMASK COMMGNTIF
cat << EOF >> config.sh
COM_MGNT_IP=$COMMGNTIP
COM_MGNT_NETMASK=$COMMGNTNETMASK
COM_MGNT_IF=$COMMGNTIF

EOF


## Gateway for EXT network
echocolor "Gateway for EXT network:"
read GATEWAYEXTIP
cat << EOF >> config.sh
## Gateway for EXT network
GATEWAY_EXT_IP=$GATEWAYEXTIP

EOF

## Hostname variable
echocolor "Hostname Controller:"
read HOSTCTL
cat << EOF >> config.sh
## Hostname variable
HOST_CTL=$HOSTCTL
EOF

echocolor "Hostname Compute:"
read HOSTCOM
cat << EOF >> config.sh
HOST_COM=$HOSTCOM


EOF


# Password variable
echocolor "Password variable:"
read default_pass
cat << EOF >> config.sh
# Password variable
DEFAULT_PASS=$default_pass

ADMIN_PASS=$DEFAULT_PASS
DEMO_PASS=$DEFAULT_PASS
RABBIT_PASS=$DEFAULT_PASS
KEYSTONE_DBPASS=$DEFAULT_PASS	
GLANCE_DBPASS=$DEFAULT_PASS	
GLANCE_PASS=$DEFAULT_PASS	
METADATA_SECRET=$DEFAULT_PASS	
NEUTRON_DBPASS=$DEFAULT_PASS	
NEUTRON_PASS=$DEFAULT_PASS	
NOVA_PASS=$DEFAULT_PASS	
NOVA_DBPASS=$DEFAULT_PASS	
PLACEMENT_PASS=$DEFAULT_PASS
EOF
	







