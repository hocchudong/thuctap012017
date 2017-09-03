#!/bin/bash -ex
#

source variable.cfg
source function.sh

###############################################################################
notification "Installing CRUDINI"
sleep 3

apt update
apt install crudini -y


###############################################################################
notification "Install python client"
sleep 3

apt install python-openstackclient -y


###############################################################################
notification "Install and config NTP"
sleep 3

apt install chrony -y
ntpfile=/etc/chrony/chrony.conf
cp $ntpfile $ntpfile.orig
sed -i 's/pool 2.debian.pool.ntp.org offline iburst/ \
server controller iburst/g' $ntpfile
# restart chrony after config
service chrony restart

