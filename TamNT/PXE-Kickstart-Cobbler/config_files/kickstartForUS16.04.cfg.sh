# set language to use during installation
lang en_US
langsupport en_US

# set keyboard layout for the system
keyboard us

# install the system
install

# reboot the system after installation
reboot
# config repo source.list
url --url http://172.16.100.10/US/

# Sets up the authentication options for the system.
auth --useshadow --enablemd5

bootloader --location=mbr

zerombr yes

clearpart --all

# setup timezone
timezone Asia/Ho_Chi_Minh

# Set the system's root password
rootpw rootpassword123

# Creates a new user on the system
user ttp --fullname=ttp --password=ttppassword123
# create partition on the system with LVM
part pv.01 --size 1 --grow

volgroup ubuntu pv.01
logvol swap --fstype swap --name=swap --vgname=ubuntu --size 1024
logvol / --fstype ext4 --vgname=ubuntu --size=1 --grow --name=slash

# hack around Ubuntu kickstart bugs
preseed partman-lvm/confirm_nooverwrite boolean true
preseed partman-auto-lvm/no_boot boolean true

# Configures network information

#network --bootproto=dhcp --device=ens34 --active
network --bootproto=dhcp --device=ens33 --active

# Do not configure the X Window System
skipx

## Install packet for the system
%packages  --ignoremissing
@ ubuntu-server
openssh-server

## Run script after installation
%post
#apt-get update -y && apt-get upgrade -y
sed -i 's/172.16.100.10/vn.archive.ubuntu.com/g' /etc/apt/sources.list
sed -i 's/US/ubuntu/g' /etc/apt/sources.list
mkdir /root/test
%end