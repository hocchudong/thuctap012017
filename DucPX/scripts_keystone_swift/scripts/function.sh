#!/bin/bash -ex

# Defind function echo color on the screen
function notification {
	echo "$(tput setaf 3)#### $1 #### $(tput sgr0)";
}

# Function to edit configure files in openstack
function edit_file {
	crudini --set $1 $2 $3 $4
}

# syntax:
###						config_file $path_file_variable [section] [parameter] [value]
# example:
###						filekeystone=/etc/keystone/keystone.conf
###						config_file $filekeystone DEFAULT rpc_backend rabbit



# Function to delete a line in configure file
function del_line {
	crudini --del $1 $2 $3
}

# syntax:
###						del_line $path_file_variable [section] [parameter]
# example:
###						filekeystone=/etc/keystone/keystone.conf
###						del_line $filekeystone DEFAULT rpc_backend