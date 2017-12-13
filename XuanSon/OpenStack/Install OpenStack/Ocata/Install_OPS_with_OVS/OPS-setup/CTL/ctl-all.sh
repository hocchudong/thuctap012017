#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

if [ $network_model = "provider" -o $network_model = "selfservice" ]
then
	echo -e "\e[32mScripts start install \e[0m"
else
	echo -e "\e[31mConfiguring network_model variable was incorrect in file config.sh, network_model=\e[0m\e[1;43;31mprovider\e[0m \e[31mor\e[0m \e[1;43;31mselfservice\e[0m"
	exit 1;
fi

source ../function.sh
source ../config.sh

echocolor "IP address"
source ctl-0-ipaddr.sh

echocolor "Environment"
source ctl-1-environment.sh

echocolor "Keystone"
source ctl-2-keystone.sh

echocolor "Glance"
source ctl-3-glance.sh

echocolor "Nova"
source ctl-4-nova.sh

if [ $network_model = "provider" ]
then
	echocolor "Neutron"
	source ctl-5-neutron-provider.sh

	echocolor "Horizon"
	source ctl-6-horizon.sh provider
elif [ $network_model = "selfservice" ]
then
	echocolor "Neutron"
	source ctl-5-neutron-selfservice.sh

	echocolor "Horizon"
	source ctl-6-horizon.sh selfservice
fi

echocolor "Create Network and Flavor"
source ctl-7-create_network.sh

