#!/bin/bash -ex
#

source function.sh

notification "Upload file to swift system"

source demo-openrc
swift stat

notification "Create container1"
openstack container create container1

touch file1
notification "Upload file1"
openstack object create container1 file1