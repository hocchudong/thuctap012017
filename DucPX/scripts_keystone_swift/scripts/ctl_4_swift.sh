#!/bin/bash -ex
#
source variable.cfg
source function.sh

# Install and configure swift
# 
# Create user, endpoint and service for swift
notification "Create user, endpoints, service for swift"
sleep 3

source admin-openrc

openstack user create --domain default --password $SWIFT_PASS swift

openstack role add --project service --user swift admin

openstack service create --name swift --description "OpenStack Object Storage" object-store

openstack endpoint create --region RegionOne \
object-store public http://controller:8080/v1/AUTH_%\(tenant_id\)s

openstack endpoint create --region RegionOne \
object-store internal http://controller:8080/v1/AUTH_%\(tenant_id\)s

openstack endpoint create --region RegionOne \
object-store admin http://controller:8080/v1

# Install packets
notification "Installing packages for SWIFT"
sleep 3

apt-get install -y swift swift-proxy python-swiftclient \
python-keystoneclient python-keystonemiddleware \
memcached

mkdir /etc/swift

curl -o /etc/swift/proxy-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/newton

# Edit file config of swift
notification "Configuring SWIFT"
swiftfile=/etc/swift/proxy-server.conf

edit_file $swiftfile DEFAULT bind_port 8080
edit_file $swiftfile DEFAULT user swift
edit_file $swiftfile DEFAULT swift_dir /etc/swift

sed -i 's/pipeline = catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk tempurl ratelimit tempauth copy container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server/\
pipeline = catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server/g' $swiftfile

edit_file $swiftfile app:proxy-server account_autocreate True
edit_file $swiftfile app:proxy-server use egg:swift#proxy


edit_file $swiftfile filter:keystoneauth use egg:swift#keystoneauth

edit_file $swiftfile filter:keystoneauth operator_roles admin,user

edit_file $swiftfile filter:authtoken paste.filter_factory keystonemiddleware.auth_token:filter_factory
edit_file $swiftfile filter:authtoken auth_uri http://controller:5000
edit_file $swiftfile filter:authtoken auth_url http://controller:35357
edit_file $swiftfile filter:authtoken memcached_servers controller:11211
edit_file $swiftfile filter:authtoken auth_type password
edit_file $swiftfile filter:authtoken project_domain_name default
edit_file $swiftfile filter:authtoken user_domain_name default
edit_file $swiftfile filter:authtoken project_name service
edit_file $swiftfile filter:authtoken username swift
edit_file $swiftfile filter:authtoken password $SWIFT_PASS
edit_file $swiftfile filter:authtoken delay_auth_decision True

edit_file $swiftfile filter:cache use egg:swift#memcache
edit_file $swiftfile filter:cache memcache_servers controller:11211