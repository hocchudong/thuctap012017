#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh
source ../folder-name_config.sh

source sshkey_setup.sh

if [ $network_model = "provider" -o $network_model = "selfservice" ]
then
	echo -e "\e[32mScripts start install \e[0m"
else
	echo -e "\e[31mConfig wrong network_model variable in file config.sh:\e[0m \e[1;43;31mprovider\e[0m \e[31mor\e[0m \e[1;43;31mselfservice\e[0m"
	exit 1;
fi

scp -i mykey -r ../../$FOLDER_ROOT_NAME root@$CTL_EXT_IP:
ssh -t -t -i mykey root@$CTL_EXT_IP "cd $FOLDER_ROOT_NAME/$CTL_FOLDER_NAME && source ctl-all.sh $network_model"
