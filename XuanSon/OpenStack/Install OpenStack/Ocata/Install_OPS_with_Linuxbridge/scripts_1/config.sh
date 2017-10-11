#!/bin/bash

#Author Son Do Xuan


##########################################
#### set local variable  for scripts #####
##########################################

echocolor "Set local variable for scripts"
sleep 3

#  Ipaddress variable and Hostname variable
## Assigning IP for controller node
CTL_EXT_IP=192.168.2.71
CTL_EXT_NETMASK=255.255.255.0
CTL_EXT_IF=ens4
CTL_MGNT_IP=10.10.10.71
CTL_MGNT_NETMASK=255.255.255.0
CTL_MGNT_IF=ens5

## Assigning IP for Compute1 host
COM_EXT_IP=192.168.2.72
COM_EXT_NETMASK=255.255.255.0
COM_EXT_IF=ens4
COM_MGNT_IP=10.10.10.72
COM_MGNT_NETMASK=255.255.255.0
COM_MGNT_IF=ens5

## Gateway for EXT network
GATEWAY_EXT_IP=192.168.2.1

## Hostname variable
HOST_CTL=controller
HOST_COM=compute


# Password variable

DEFAULT_PASS="Welcome123"

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


