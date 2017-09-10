#!/bin/bash -ex

source variable.cfg
source function.sh

###########################################################
notification "Finally step"
sleep 1

# Download file configure of swift
curl -o /etc/swift/swift.conf \
https://git.openstack.org/cgit/openstack/swift/plain/etc/swift.conf-sample?h=stable/newton

swiftfile=/etc/swift/swift.conf

edit_file $swiftfile swift-hash swift_hash_path_suffix $HASH_PATH_SUFFIX
edit_file $swiftfile swift-hash swift_hash_path_prefix $HASH_PATH_PREFIX

edit_file $swiftfile storage-policy:0 name Policy-0
edit_file $swiftfile storage-policy:0 default yes

notification "Typing password of root user to distribute ring when system request"
sleep 3

scp /etc/swift/swift.conf root@$OBJECT1_MGNT_IP:/etc/swift/
scp /etc/swift/swift.conf root@$OBJECT2_MGNT_IP:/etc/swift/

chown -R root:swift /etc/swift
service memcached restart
service swift-proxy restart