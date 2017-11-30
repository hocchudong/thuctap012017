# Cài đặt manila trên ubuntu 16.04 64-bit

# Mục lục
- [Mô hình cài đặt](#1)
- [1. Cài đặt và cấu hình trên node controller](#3)
- [2. Cài đặt trên node manila](#4)

<a name=1></a>
# Mô hình cài đặt
- Hướng dẫn được thực thiện trên hệ thống Openstack đã có được cài đặt theo hướng dẫn https://github.com/hocchudong/ghichep-OpenStack/blob/master/OpenStack-Pike/docs/install_basic.md

- Ở đây sẽ cài đặt thêm một node manila-share

	![](../images/manila_layout.png)
	
- địa chỉ ip của controller: `.190`
- địa chỉ ip của manila: `.195`

### Với manila ta có thể cấu hình trên một node hoặc nhiều node. Mình sẽ cài đặt trên nhiều node
- Các thành phần manila-api và manila-scheduler ta sẽ cài đặt trên node controller
- Và manila-share sẽ cài đặt trên một node riêng.

<a name=3></a>
## 1. Cài đặt và cấu hình trên node controller
- 1. Chỉnh sửa file `/etc/hosts`, thêm dòng cấu hình sau:

	```sh
	10.10.10.195	manila
	```
	
### 1.1 Tạo database, user manila, gán quyền và tạo endpoint API cho dịch vụ.
- 1. Đăng nhập vào mysql

	```sh
	mysql -u root -pWelcome123
	```
	
- 2. Tạo database manila

	```sh
	CREATE DATABASE manila;
	```
	
- 3. Cấp quyền truy cập vào cơ sở dữ liệu

	```sh
	GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'%' IDENTIFIED BY 'Welcome123';
	exit;
	```
	
- 4. Tạo user manila, gán quyền và tạo endpoint API cho dịch vụ.
- Khai báo credential để sử dụng CLI.

	```sh
	source admin
	```
	
- Tạo user `manila`

	```sh
	openstack user create --domain default --password Welcome123 manila
	```
	
- Thêm role admin cho user manila trên project service
	
	```sh
	openstack role add --project service --user manila admin
	```
	
- Tạo dịch vụ có tên share

	```sh
	openstack service create --name manila --description "OpenStack Shared File Systems" share
	
	openstack service create --name manilav2 --description "OpenStack Shared File Systems V2" sharev2
	```
	
- Tạo các endpoint cho dịch vụ manila

	```sh
	openstack endpoint create --region RegionOne \
  share public http://controller:8786/v1/%\(tenant_id\)s
	
	openstack endpoint create --region RegionOne \
  share internal http://controller:8786/v1/%\(tenant_id\)s
	
	openstack endpoint create --region RegionOne \
  share admin http://controller:8786/v1/%\(tenant_id\)s
	```
	
	- và 
	
	```sh
	openstack endpoint create --region RegionOne \
  sharev2 public http://controller:8786/v2/%\(tenant_id\)s
	
	openstack endpoint create --region RegionOne \
  sharev2 internal http://controller:8786/v2/%\(tenant_id\)s
	
	openstack endpoint create --region RegionOne \
  sharev2 admin http://controller:8786/v2/%\(tenant_id\)s
	```
	
### 1.2 Cài đặt và cấu hình cho dịch vụ manila
- 1. Cài đặt các gói cho manila

	```sh
	apt install -y manila-api manila-scheduler python-manilaclient
	```
	
- Sao lưu các file `/etc/manila/manila.conf` trước khi cấu hình

	```sh
	cp /etc/manila/manila.conf /etc/manila/manila.conf.orig
	```
	
- 2. Cấu hình
- Trong `[database] section, cấu hình truy cập database:

	```sh
	[database]
	...
	connection = mysql+pymysql://manila:Welcome123@controller/manila
	```
	
- Trong `[DEFAULT]` section, thêm hoặc chỉnh sửa các dòng cấu hình như sau

	```sh
	[DEFAULT]
	...
	transport_url = rabbit://openstack:Welcome123@controller
	
	default_share_type = default_share_type
	share_name_template = share-%s
	rootwrap_config = /etc/manila/rootwrap.conf
	api_paste_config = /etc/manila/api-paste.ini
	
	auth_strategy = keystone
	
	my_ip = 10.10.10.190
	```
	
- Trong `[keystone_authtoken]` section, thêm các dòng sau:

	```sh
	[keystone_authtoken]
	...
	memcached_servers = controller:11211
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	auth_type = password
	project_domain_id = default
	user_domain_id = default
	project_name = service
	username = manila
	password = Welcome123
	```
	
- Trong `[oslo_concurrency]` section

	```sh
	[oslo_concurrency]
	
	lock_path = /var/lock/manila
	```
	
- 3. Đồng bộ database cho manila

	```sh
	su -s /bin/sh -c "manila-manage db sync" manila
	```
	
- 4. Kết thúc cài đặt trên node controller
- restart các service

	```sh
	service manila-scheduler restart
	service manila-api restart
	```
	
<a name=4></a>
- Xóa database mặc định

	```sh
	rm -f /var/lib/manila/manila.sqlite
	```
	
## 2. Cài đặt trên node manila
### 2.1 Cài đặt môi trường

- 1. Cài đặt network. Dùng vi để sửa file `/etc/network/interfaces` có nội dung như sau:

	```sh
	auto ens3
	iface ens3 inet static
	address 10.10.10.195
	netmask 255.255.255.0

	auto ens4
	iface ens4 inet static
	address 172.16.69.195
	netmask 255.255.255.0
	gateway 172.16.69.1
	dns-nameservers 8.8.8.8
	```
	
- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

	```sh
	ifdown -a && ifup -a
	```
	
- Cấu hình hostname. Dùng vi sửa file `/etc/hostname` với tên là `manila`

	```sh
	manila
	```
	
- Sửa file `/etc/hosts` chứa nội dung như sau:

	```sh
	10.10.10.190	controller
	10.10.10.191	compute1
	10.10.10.192	block
	10.10.10.193	object1
	10.10.10.194	object2
	10.10.10.195	manila
	```
	
- 2. Cài đặt NTP service:
- Cài đặt các gói

	```sh
	apt install chrony -y
	```
	
- Sửa file `/etc/chrony/chrony.conf` và comment hoặc xóa tất cả dòng có chứa server và thêm dòng sau:

	```sh
	server controller iburst
	```
	
- Restart NTP service:

	```sh
	service chrony restart
	```
	
- Kiểm tra lại hoạt động của NTP bằng lệnh dưới

	```sh
	~# chronyc sources
	210 Number of sources = 1
	MS Name/IP address         Stratum Poll Reach LastRx Last sample
	===============================================================================
	^* controller                    3   6    17    23    -10ns[+6000ns] +/-  248ms
	```
	
- 3. Thêm Openstack repository
- add các packages

	```sh
	apt install software-properties-common -y
	add-apt-repository cloud-archive:pike -y
	```
	
- Cập nhật các gói phần mềm
	
	```sh
	apt -y update && apt -y dist-upgrade
	```
	
- Cài đặt các gói client của OpenStack.

	```sh
	apt install python-openstackclient -y
	```
	
### 2.2 Cài đặt và cấu hình manila
- 1. Cài đặt

	```sh
	apt install -y manila-share python-pymysql
	```
	
- 2. Cấu hình
- Sao lưu file cấu hình của manila trước khi chỉnh sửa.

	```sh
	cp /etc/manila/manila.conf /etc/manila/manila.conf.orig
	```
	
- Dùng vi để chỉnh sửa file cấu hình manila `/etc/manila/manila.conf`
- Trong `[database]`, cấu hình truy cập database
	
	```sh
	[database]
	...
	connection = mysql+pymysql://manila:Welcome123@controller/manila
	```
	
- Trong `[DEFAULT]` section, thêm các dòng cấu hình

	```sh
	[DEFAULT]
	...
	transport_url = rabbit://openstack:Welcome123@controller
	
	default_share_type = default_share_type
	rootwrap_config = /etc/manila/rootwrap.conf
	
	auth_strategy = keystone
	
	my_ip = 10.10.10.195
	```
	
- Trong `[keystone_authtoken]`, thêm các dòng cấu hình sau:

	```sh
	[keystone_authtoken]
	...
	memcached_servers = controller:11211
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	auth_type = password
	project_domain_id = default
	user_domain_id = default
	project_name = service
	username = manila
	password = Welcome123
	```
	
- Trong `[oslo_concurrency]` section, cấu hình lock path

	```sh
	[oslo_concurrency]
	
	lock_path = /var/lib/manila/tmp
	```	
	
--- 

### Option 1:
- Triển khai dịch vụ mà không cần hỗ trợ driver để quản lý share server. Trong option này, manila không làm có thao tác gì liên quan đến networking. Các thao tác phải được đảm bảo kết nối mạng giữa các VMs và các servers dựa trên giao thức NAS.
- Hướng dẫn này demo cài đặt LVM driver tạo ra các LVM volumes trên share node và export chúng với sự hỗ trợ của NFS server được cài đặt trên share node. Như vậy yêu cầu các gói LVM và NFS cũng như thêm các ổ đĩa để tạo volume group `mainla-share`.
- Driver này có thể được gọi là `driver_handles_share_servers = False`, hoặc đơn giản `DHSS = False`

### Cấu hình Manila option 1
- Trên node manila, có 2 ổ cứng: 1 ổ để cài OS và 1 ổ để sử dụng cho manila

	```sh
	# lsblk
	NAME                  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
	sr0                    11:0    1  829M  0 rom
	vda                   253:0    0   20G  0 disk
	├─vda1                253:1    0  487M  0 part /boot
	├─vda2                253:2    0    1K  0 part
	└─vda5                253:5    0 19.5G  0 part
		├─ubuntu--vg-root   252:0    0 17.5G  0 lvm  /
		└─ubuntu--vg-swap_1 252:1    0    2G  0 lvm  [SWAP]
	vdb                   253:16   0   20G  0 disk
	```

## Thực hiện cài đặt và cấu hình. 
- Thực hiện các bước sau trên node manila
- 1. Cài đặt các gói hỗ trợ

	```sh
	apt install -y lvm2 nfs-kernel-server
	```
	
- 2. Tạo LVM physical volume `/dev/vdb`

	```sh
	pvcreate /dev/vdb
	```
	
- 3. Tạo LVM volume group `manila-volumes`
	
	```sh
	vgcreate manila-volumes /dev/vdb
	```
	
- 4. Chỉnh sửa file `/etc/lvm/lvm.conf`. Tìm đến `devices` và sửa như sau:

	```sh
	devices {
	...
	filter = [ "a/vdb/", "r/.*/"]
	```
	
- 5. Cấu hình trong file `/etc/manila/manila.conf`
- Trong `[DEFAULT]` section, enable LVM và NFS:

	```sh
	[DEFAULT]
	...
	enabled_share_backends = lvm
	enabled_share_protocols = NFS
	```
	
- Trong `[lvm]` section, thêm các dòng cấu hình như sau:

	```sh
	[lvm]
	share_backend_name = LVM
	share_driver = manila.share.drivers.lvm.LVMShareDriver
	driver_handles_share_servers = False
	lvm_share_volume_group = manila-volumes
	lvm_share_export_ip = 172.16.69.195
	```
	
- 6. Kết thúc cài đặt

	```sh
	service manila-share restart
	
	rm -f /var/lib/manila/manila.sqlite
	```
	
	
## kiểm tra lại cài đặt (thực hiện trên controller node)
- List các service của manila:

	```sh
	manila service-list
	+----+------------------+------------+------+---------+-------+----------------------------+
	| Id | Binary           | Host       | Zone | Status  | State | Updated_at                 |
	+----+------------------+------------+------+---------+-------+----------------------------+
	| 1  | manila-scheduler | controller | nova | enabled | up    | 2017-11-11T10:02:45.000000 |
	| 2  | manila-share     | manila@lvm | nova | enabled | up    | 2017-11-11T10:02:28.000000 |
	+----+------------------+------------+------+---------+-------+----------------------------+
	```
	
- Tạo kiểu chia sẻ mặc định

	```sh
	~# manila type-create default_share_type False
	+----------------------+--------------------------------------+
	| Property             | Value                                |
	+----------------------+--------------------------------------+
	| required_extra_specs | driver_handles_share_servers : False |
	| Name                 | default_share_type                   |
	| Visibility           | public                               |
	| is_default           | -                                    |
	| ID                   | de80850d-1a91-4bc3-9b71-f30075c758e9 |
	| optional_extra_specs |                                      |
	+----------------------+--------------------------------------+
	```
	
	```sh
	:~# manila type-list
	+--------------------------------------+--------------------+------------+------------+--------------------------------------+----------------------+
	| ID                                   | Name               | visibility | is_default | required_extra_specs                 | optional_extra_specs |
	+--------------------------------------+--------------------+------------+------------+--------------------------------------+----------------------+
	| de80850d-1a91-4bc3-9b71-f30075c758e9 | default_share_type | public     | YES        | driver_handles_share_servers : False |                      |
	+--------------------------------------+--------------------+------------+------------+--------------------------------------+----------------------+
	```
	
- Tạo chia sẻ NFS

	```sh
	~# manila create NFS 10 --name share01
	+---------------------------------------+--------------------------------------+
	| Property                              | Value                                |
	+---------------------------------------+--------------------------------------+
	| status                                | creating                             |
	| share_type_name                       | default_share_type                   |
	| description                           | None                                 |
	| availability_zone                     | None                                 |
	| share_network_id                      | None                                 |
	| share_server_id                       | None                                 |
	| share_group_id                        | None                                 |
	| host                                  |                                      |
	| revert_to_snapshot_support            | False                                |
	| access_rules_status                   | active                               |
	| snapshot_id                           | None                                 |
	| create_share_from_snapshot_support    | False                                |
	| is_public                             | False                                |
	| task_state                            | None                                 |
	| snapshot_support                      | False                                |
	| id                                    | b192a681-8953-42fd-af94-15f9a729ea4e |
	| size                                  | 10                                   |
	| source_share_group_snapshot_member_id | None                                 |
	| user_id                               | de6faf4fb0484e90a21bd63c4cffa465     |
	| name                                  | share01                              |
	| share_type                            | de80850d-1a91-4bc3-9b71-f30075c758e9 |
	| has_replicas                          | False                                |
	| replication_type                      | None                                 |
	| created_at                            | 2017-11-11T10:09:17.000000           |
	| share_proto                           | NFS                                  |
	| mount_snapshot_support                | False                                |
	| project_id                            | ca6e13d11f564a90aca3cd13c6eaf8e7     |
	| metadata                              | {}                                   |
	+---------------------------------------+--------------------------------------+
	```
	
- Sau vài phút, trạng thái sẽ được chuyển sang available

	```sh
	~# manila list
	+--------------------------------------+---------+------+-------------+-----------+-----------+--------------------+----------------------------+-------------------+
	| ID                                   | Name    | Size | Share Proto | Status    | Is Public | Share Type Name    | Host                       | Availability Zone |
	+--------------------------------------+---------+------+-------------+-----------+-----------+--------------------+----------------------------+-------------------+
	| b192a681-8953-42fd-af94-15f9a729ea4e | share01 | 10   | NFS         | available | False     | default_share_type | manila@lvm#lvm-single-pool | nova              |
	+--------------------------------------+---------+------+-------------+-----------+-----------+--------------------+----------------------------+-------------------+
	```
	
- Cấp phát quyền truy cập vào NFS share

	```sh
	~# manila access-allow share01 ip 172.16.69.0/24 --access-level rw
	+--------------+--------------------------------------+
	| Property     | Value                                |
	+--------------+--------------------------------------+
	| access_key   | None                                 |
	| share_id     | b192a681-8953-42fd-af94-15f9a729ea4e |
	| created_at   | 2017-11-11T10:40:46.000000           |
	| updated_at   | None                                 |
	| access_type  | ip                                   |
	| access_to    | 172.16.69.0/24                       |
	| access_level | rw                                   |
	| state        | queued_to_apply                      |
	| id           | 1bf9fd47-2ecc-4b69-b9c3-cf489e7b18da |
	+--------------+--------------------------------------+
	```
	
- Lấy đường dẫn đến NFS share đã tạo ở trên

	```sh
	~# manila show share01 | grep path | cut -d'|' -f3
	path = 172.16.69.195:/var/lib/manila/mnt/share-4ae82103-21a7-41d5-b1e6-5413a7a457bf
	``
	
- Kiểm tra các VM có trong hệ thống

	```sh
	~# openstack server list
	+--------------------------------------+------+--------+----------------------------+----------------------+-----------+
	| ID                                   | Name | Status | Networks                   | Image                | Flavor    |
	+--------------------------------------+------+--------+----------------------------+----------------------+-----------+
	| 4faba68d-251e-49f5-a5b6-598f19dad9e1 | trrs | ACTIVE | selfservice=192.168.10.109 | manila-service-image | m1.medium |
	| 5c097144-7034-47ce-8569-6d295dca50f5 | kpo  | ACTIVE | provider=172.16.69.197     | ubuntu-xen           | m2.small  |
	+--------------------------------------+------+--------+----------------------------+----------------------+-----------+
	```
	
- Thực hiện ssh vào vm `kpo` và mount

	```sh
	root@kpo:~# mount -vt nfs 172.16.69.195:/var/lib/manila/mnt/share-4ae82103-21a7-41d5-b1e6-5413a7a457bf /tmp/
	mount.nfs: timeout set for Sat Nov 11 14:54:26 2017
	mount.nfs: trying text-based options 'vers=4,addr=172.16.69.195,clientaddr=172.16.69.197'
	```
	
- Kiểm tra lại các điểm mount

	```sh
	root@kpo:~# df -h
	Filesystem                                                                    Size  Used Avail Use% Mounted on
	udev                                                                          490M     0  490M   0% /dev
	tmpfs                                                                         100M  3.2M   97M   4% /run
	/dev/vda1                                                                     4.8G  873M  4.0G  18% /
	tmpfs                                                                         497M     0  497M   0% /dev/shm
	tmpfs                                                                         5.0M     0  5.0M   0% /run/lock
	tmpfs                                                                         497M     0  497M   0% /sys/fs/cgroup
	tmpfs                                                                         100M     0  100M   0% /run/user/1000
	tmpfs                                                                         100M     0  100M   0% /run/user/0
	172.16.69.195:/var/lib/manila/mnt/share-4ae82103-21a7-41d5-b1e6-5413a7a457bf  9.8G   23M  9.2G   1% /tmp
	```
	
- Tạo một file trong thư mục `/tmp` và kiểm tra trên node manila có kết quả ra sao?

	```sh
	root@kpo:~# cd /tmp/
	root@kpo:/tmp# touch file1
	```
	
- đăng nhập vào node manila và kiểm tra các file trong thư mục `/var/lib/manila/mnt/share-4ae82103-21a7-41d5-b1e6-5413a7a457bf`.
	
	```sh
	root@manila:~# ls /var/lib/manila/mnt/share-4ae82103-21a7-41d5-b1e6-5413a7a457bf/
	file1  lost+found
	```
	
- Như vậy đã thành công.
