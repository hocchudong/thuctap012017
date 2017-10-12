#!/bin/bash

#Author Son Do Xuan

source function.sh
source config.sh

# Install crudini
echocolor "Install crudini"
sleep 3
apt-get install -y crudini

# Update and upgrade for COMPUTE
echocolor "Update and upgrade COMPUTE"
sleep 3
apt-get update -y && apt-get upgrade -y

# Install and config NTP
echocolor "Install NTP"
sleep 3

apt-get install chrony -y
ntpfile=/etc/chrony/chrony.conf

sed -i 's/pool 2.debian.pool.ntp.org offline iburst/ \
server controller iburst/g' $ntpfile

service chrony restart




