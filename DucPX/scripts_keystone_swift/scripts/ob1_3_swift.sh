#!/bin/bash -ex
#
source variable.cfg
source function.sh

# Install
notification "Installing packages"
sleep 3

apt install xfsprogs rsync -y

# Format disk
mkfs.xfs /dev/$SDB
mkfs.xfs /dev/$SDC

# Create directory
mkdir -p /srv/node/sdb
mkdir -p /srv/node/sdc

# Automatic mounting disk after reboot
ftab=/etc/fstab
cat <<EOF >> $ftab
/dev/$SDB /srv/node/sdb xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
/dev/$SDC /srv/node/sdc xfs noatime,nodiratime,nobarrier,logbufs=8 0 2

EOF

# Mount disk
mount /srv/node/sdb
mount /srv/node/sdc

# Create file rsync
notification "Configuring RSYNC"
sleep 3

rsyncfile=/etc/rsyncd.conf
touch $rsyncfile
cat <<EOF > $rsyncfile
uid = swift
gid = swift
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
address = $OBJECT1_MGNT_IP

[account]
max connections = 2
path = /srv/node/
read only = False
lock file = /var/lock/account.lock

[container]
max connections = 2
path = /srv/node/
read only = False
lock file = /var/lock/container.lock

[object]
max connections = 2
path = /srv/node/
read only = False
lock file = /var/lock/object.lock

EOF

# Edit file /etc/default/rsync
dfrsync=/etc/default/rsync
sed -i 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g' $dfrsync

service rsync start

# Install swift's component
notification "Installing swift's components"
sleep 3

apt install swift swift-account swift-container swift-object -y

# Download files
curl -o /etc/swift/account-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/account-server.conf-sample?h=stable/newton
curl -o /etc/swift/container-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/container-server.conf-sample?h=stable/newton
curl -o /etc/swift/object-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/object-server.conf-sample?h=stable/newton

# edit file account-server
notification "Configuring SWIFT"
sleep 3

accountfile=/etc/swift/account-server.conf

edit_file $accountfile DEFAULT bind_ip $OBJECT1_MGNT_IP
edit_file $accountfile DEFAULT bind_port 6202
edit_file $accountfile DEFAULT user swift
edit_file $accountfile DEFAULT swift_dir /etc/swift
edit_file $accountfile DEFAULT devices /srv/node
edit_file $accountfile DEFAULT mount_check True

edit_file $accountfile filter:recon use egg:swift#recon
edit_file $accountfile filter:recon recon_cache_path /var/cache/swift

# Edit container file
containerfile=/etc/swift/container-server.conf

edit_file $containerfile DEFAULT bind_ip $OBJECT1_MGNT_IP
edit_file $containerfile DEFAULT bind_port 6201
edit_file $containerfile DEFAULT user swift
edit_file $containerfile DEFAULT swift_dir /etc/swift
edit_file $containerfile DEFAULT devices /srv/node
edit_file $containerfile DEFAULT mount_check True

edit_file $containerfile filter:recon use egg:swift#recon
edit_file $containerfile filter:recon recon_cache_path /var/cache/swift

# Edit object file
objectfile=/etc/swift/object-server.conf

edit_file $objectfile DEFAULT bind_ip $OBJECT1_MGNT_IP
edit_file $objectfile DEFAULT bind_port 6200
edit_file $objectfile DEFAULT user swift
edit_file $objectfile DEFAULT swift_dir /etc/swift
edit_file $objectfile DEFAULT devices /srv/node
edit_file $objectfile DEFAULT mount_check True

edit_file $objectfile filter:recon use egg:swift#recon
edit_file $objectfile filter:recon recon_cache_path /var/cache/swift
edit_file $objectfile filter:recon recon_lock_path /var/lock

# grant pemission access
chown -R swift:swift /srv/node

# Create recon directory
mkdir -p /var/cache/swift
chown -R root:swift /var/cache/swift
chmod -R 775 /var/cache/swift

chown -R root:swift /var/cache/swift
chmod -R 775 /var/cache/swift
