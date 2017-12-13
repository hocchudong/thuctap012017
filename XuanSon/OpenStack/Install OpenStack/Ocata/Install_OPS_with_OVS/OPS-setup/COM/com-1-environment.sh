#!/bin/bash
#Author Son Do Xuan

source ../function.sh
source ../config.sh

# Install crudini
echocolor "Install crudini"
sleep 3
apt-get install -y crudini

# Function install and config NTP
install_ntp () {
	echocolor "Install NTP"
	sleep 3

	apt-get install chrony -y
	ntpfile=/etc/chrony/chrony.conf

	sed -i 's|'"pool 2.debian.pool.ntp.org offline iburst"'| \
	'"server $HOST_CTL iburst"'|g' $ntpfile

	service chrony restart
}

#######################
###Execute functions###
#######################

# Install and config NTP
install_ntp


