# Tài liệu cài đặt Openstack PIKE trên Ubuntu 16.04 64-bit

# Mục lục
- [1. Mô hình cài đặt](#1)

- [2. IP Planning](#2)

- [3. Cài đặt môi trường](#3)
	- [3.1 Cài đặt môi trường trên node controller](#a)
	- [3.2 Cài đặt môi trường trên node compute1](#b)
	- [3.3 Cài đặt môi trường cho node Block Storage](#c)
	- [3.4 Cài đặt môi trường trên 2 node object](#d)

- [4. Cài dịch vụ Identity (keystone). Cài đặt trên node controller](#4)

- [5. Cài dịch vụ Image (Glance). Cài đặt trên node controller](#5)

- [6.  Cài dịch vụ Compute (Nova)](#6)
	- [6.1 Cài đặt các thành phần trên node controller](#e)
	- [6.2 Cài đặt nova-compute1](#f)
	- [6.3 Thực hiện các lệnh sau trên controller](#q)

- [7. Cài đặt Networking service (NEUTRON)](#6)
	- [7.1 Cài đặt trên node Controller](#g)
	- [7.2 Cài đặt neutron trên node compute1](#h)
	
- [8. Cài đặt và cấu hình HORIZON (dashboad). Cài đặt trên controller node](#8)

- [9. Cài đặt Block Storage node](#9)
	- [9.1 Cài đặt trên node controller](#i)
	- [9.2 Cài đặt trên node Block Storage](#k)
	
- [10. Cài đặt Swift](#10)
	- [10.1. Cài đặt Swift trên node controller](#l)
	- [10.2 Cài đặt và cấu hình trên 2 node Object](#m)

<a name=1></a>
## 1. Mô hình cài đặt
- Mô hình cài đặt Lab OPS Pike trên Ubuntu 16.04 64-bit
	
	![](../images/pike.png)
	
<a name=2></a>
## 2. IP Planning
- Phân hoạch địa chỉ Ip và yêu cầu phần cứng

	![](../images/ip_pike.png)
	
<a name=3></a>
## 3. Cài đặt môi trường
- Lưu ý: 

	```sh
	- Đăng nhập với quyền root cho tất cả các bước cài đặt
	- Các thao tác sửa file trong hướng dẫn này sử dụng lệnh vi hoặc vim
	- Password thống nhất cho tất cả các dịch vụ là Welcome123
	```
	
<a name=a></a>
## 3.1 Cài đặt môi trường trên node controller
- Cập nhật các gói phần mềm

	```sh
	apt-get update
	```
	
### 1. Cấu hình network
- 1. Cấu hình card mạng.

	```sh
	auto ens3
	iface ens3 inet static
				address 10.10.10.190
				netmask 255.255.255.0


	auto ens4
	iface ens4 inet static
				address 172.16.69.190
				netmask 255.255.255.0
				gateway 172.16.69.1
				dns-nameservers 8.8.8.8


	auto ens5
	iface ens5 inet static
				address 10.10.20.190
				netmask 255.255.255.0
	```
	
- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

	```sh
	ifdown -a && ifup -a
	```
	
- Kiểm tra kết nối tới gateway và internet sau khi thiết lập xong.
	- ping gateway `ping -c 4 172.16.69.1`
	
		```sh
		ping -c 4 172.16.69.1

		PING 172.16.69.1 (172.16.69.1) 56(84) bytes of data.
		64 bytes from 172.16.69.1: icmp_seq=1 ttl=64 time=0.306 ms
		64 bytes from 172.16.69.1: icmp_seq=2 ttl=64 time=0.299 ms
		64 bytes from 172.16.69.1: icmp_seq=3 ttl=64 time=0.264 ms
		64 bytes from 172.16.69.1: icmp_seq=4 ttl=64 time=0.299 ms
		```
	- ping ra ngoài internet `ping -c 4 google.com`
	
		```sh
		ping -c 4 google.com

		PING google.com (216.58.221.142) 56(84) bytes of data.
		64 bytes from hkg07s02-in-f142.1e100.net (216.58.221.142): icmp_seq=1 ttl=54 time=22.3 ms
		64 bytes from hkg07s02-in-f142.1e100.net (216.58.221.142): icmp_seq=2 ttl=54 time=22.3 ms
		64 bytes from hkg07s02-in-f142.1e100.net (216.58.221.142): icmp_seq=3 ttl=54 time=22.4 ms
		64 bytes from hkg07s02-in-f142.1e100.net (216.58.221.142): icmp_seq=4 ttl=54 time=22.3 ms
		```
		
- 2. Cấu hình hostname
- dùng vi sửa file `/etc/hostname` với tên là controller

	```sh
	controller
	```
	
- Cập nhật file `/etc/hosts` để phân giải từ IP sang hostname và ngược lại, nội dung như sau
	
	```sh
	10.10.10.190				controller
	10.10.10.191				compute1
	10.10.10.192				block
	10.10.10.193				object1
	10.10.10.194				object2
	```
	
- Khởi động lại máy, sau đó đăng nhập vào với quyền root.

	```sh
	init 6
	```
	
### 2. Cài đặt NTP
- 1. Cài gói chrony.

	```sh
	apt -y install chrony
	```
	
- 2. Mở file `/etc/chrony/chrony.conf` bằng vi và thêm vào các dòng sau:
	- commnet dòng sau:
	
		```sh
		#pool 2.debian.pool.ntp.org offline iburst
		```
		
	- Thêm các dòng sau:
	
		```sh
		server 1.vn.poo.ntp.org iburst
		server 0.asia.pool.ntp.org iburst 
		server 3.asia.pool.ntp.org iburst

		allow 10.10.10.0/24
		```

- 3. Restart dịch vụ NTP
	
	```sh
	service chrony restart
	```
	
- 4. Kiểm tra lại hoạt động của NTP bằng lệnh dưới

	```sh
	root@controller:~# chronyc sources
	210 Number of sources = 2
	MS Name/IP address         Stratum Poll Reach LastRx Last sample
	===============================================================================
	^* sr-99-184-140-118-on-nets     2   6    17    32    +79us[  -38ms] +/-   60ms
	^- send.mx.cdnetworks.com        2   6    17    31    +73ms[  +73ms] +/-  223ms
	```
	
### 3.  Cài đặt repos để cài OpenStack PIKE
- Cài đặt gói để cài OpenStack PIKE

	```sh
	apt-get install software-properties-common -y
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
	
- Khởi động lại máy chủ
	
	```sh
	init 6
	```
	
### 4. Cài đặt SQL database
- Cài đặt MariaDB

	```sh
	apt install mariadb-server python-pymysql -y
	```

- Thiết lập mật khẩu cho tài khoản root (tài khoản root của mariadb)

	```sh
	mysql_secure_installation
	```
	
- Cấu hình cho Mariadb, tạo file `/etc/mysql/mariadb.conf.d/99-openstack.cnf` với nội dung sau:

	```sh
	[mysqld]
	bind-address = 0.0.0.0

	default-storage-engine = innodb
	innodb_file_per_table = on
	collation-server = utf8_general_ci
	character-set-server = utf8
	```	
	
- Khởi động lại MariaDB

	```sh
	service mysql restart
	```
	
### 5. Cài đặt RabbitMQ
- Cài đặt gói

	```sh
	apt install rabbitmq-server -y
	```
	
- Cấu hình RabbitMQ, tạo user `openstack` với mật khẩu là `Welcome123`

	```sh
	rabbitmqctl add_user openstack Welcome123
	```
	
- Gán quyền read, write cho tài khoản openstack trong RabbitMQ

	```sh
	rabbitmqctl set_permissions openstack ".*" ".*" ".*"
	```
	
### 6. Cài đặt Memcached
- Cài đặt các gói cần thiết cho memcached

	```sh
	apt install memcached python-memcache -y
	```
	
- Dùng vi sửa file `/etc/memcached.conf`, thay dòng `-l 127.0.0.1` bằng dòng dưới.

	```sh
	-l 0.0.0.0
	```
	
- Khởi động lại memcache.

	```sh
	service memcached restart
	```

<a name=b></a>
## 3.2 Cài đặt môi trường trên node compute1
- Cập nhật các gói phần mềm

	```sh
	apt update
	```
	
### 1. Cài đặt card mạng
- Dùng lệnh vi để sửa file `/etc/network/interfaces` với nội dung như sau.

	```sh
	auto ens3
	iface ens3 inet static
					address 10.10.10.191
					netmask 255.255.255.0


	auto ens4
	iface ens4 inet static
					address 172.16.69.191
					netmask 255.255.255.0
					gateway 172.16.69.1
					dns-nameservers 8.8.8.8


	auto ens5
	iface ens5 inet static
					address 10.10.20.191
					netmask 255.255.255.0
	```
	
- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

	```sh
	ifdown -a && ifup -a
	```
	
- Đăng nhập lại máy Compute1 với quyền root và thực hiện kiểm tra kết nối.
	- ping gateway `ping -c 4 172.16.69.1`
	
		```sh
		ping -c 4 172.16.69.1
		PING 172.16.69.1 (172.16.69.1) 56(84) bytes of data.
		64 bytes from 172.16.69.1: icmp_seq=1 ttl=64 time=0.250 ms
		64 bytes from 172.16.69.1: icmp_seq=2 ttl=64 time=0.308 ms
		64 bytes from 172.16.69.1: icmp_seq=3 ttl=64 time=0.343 ms
		64 bytes from 172.16.69.1: icmp_seq=4 ttl=64 time=0.321 ms

		--- 172.16.69.1 ping statistics ---
		4 packets transmitted, 4 received, 0% packet loss, time 2998ms
		rtt min/avg/max/mdev = 0.250/0.305/0.343/0.038 ms
		```
		
	- ping ra ngoài internet `ping -c 4 google.com`
	
		```sh
		ping -c 4 google.com
		PING google.com (172.217.24.206) 56(84) bytes of data.
		64 bytes from hkg12s13-in-f14.1e100.net (172.217.24.206): icmp_seq=1 ttl=54 time=22.5 ms
		64 bytes from hkg12s13-in-f14.1e100.net (172.217.24.206): icmp_seq=2 ttl=54 time=22.6 ms
		64 bytes from hkg12s13-in-f14.1e100.net (172.217.24.206): icmp_seq=3 ttl=54 time=22.6 ms
		64 bytes from hkg12s13-in-f14.1e100.net (172.217.24.206): icmp_seq=4 ttl=54 time=22.6 ms

		--- google.com ping statistics ---
		4 packets transmitted, 4 received, 0% packet loss, time 3004ms
		rtt min/avg/max/mdev = 22.574/22.632/22.666/0.187 ms
		```
		
- 2. Cấu hình hostname. Dùng vi sửa file `/etc/hostname` với tên là compute1.
	
	```sh
	compute1
	```
	
- Cập nhật file `/etc/hosts` để phân giải từ IP sang hostname và ngược lại, nội dung như sau
	
	```sh
	10.10.10.190				controller
	10.10.10.191				compute1
	10.10.10.192				block
	10.10.10.193				object1
	10.10.10.194				object2
	```
	
- Khởi động lại máy, sau đó đăng nhập vào với quyền root.

	```sh
	init 6
	```
	
### 2. Cài đặt NTP.
- Cài gói chrony.

	```sh
	apt install chrony -y
	```
	
- Mở file /etc/chrony/chrony.conf bằng vi và thêm vào dòng sau:
	- commnet dòng sau:
	
	```sh
	#pool 2.debian.pool.ntp.org offline iburst
	```
	
	- Thêm dòng sau:
	
	```sh
	server controller iburst
	```
	
- Restart dịch vụ NTP

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

### 3. Cài đặt repos để cài OpenStack PIKE
- Cài đặt gói để cài OpenStack PIKE

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
	
- Khởi động lại máy chủ

	```sh
	init 6
	```
	
<a name=c></a>
## 3.3 Cài đặt môi trường cho node Block Storage
- Cập nhật các gói phần mềm

	```sh
	apt update
	```
	
### 1 Cài đặt card mạng
- 1. Dùng lệnh vi để sửa file vi /etc/network/interfaces với nội dung như sau.

	```sh
	auto ens3
	iface ens3 inet static
					address 10.10.10.192
					netmask 255.255.255.0


	auto ens4
	iface ens4 inet static
					address 172.16.69.192
					netmask 255.255.255.0
					gateway 172.16.69.1
					dns-nameservers 8.8.8.8
	```
	
- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

	```sh
	ifdown -a && ifup -a
	```
	
- 2. Cấu hình hostname và phân giải tên
- Dùng vi sửa file `/etc/hostname` với tên là block

	```sh
	block
	```
	
- Sửa file `/etc/hosts` chứa nội dung như sau:

	```sh
	10.10.10.190				controller
	10.10.10.191				compute1
	10.10.10.192				block
	10.10.10.193				object1
	10.10.10.194				object2
	```

### 2. Cài đặt NTP service:
- Cài đặt các gói

	```sh
	apt install chrony -y
	```
	
- Sửa file `/etc/chrony/chrony.conf` và comment hoặc xóa tất cả dòng có chứa `server` và thêm dòng sau:

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

### 3. Thêm Openstack repository
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

<a name=d></a>
## 3.4 Cài đặt môi trường trên 2 node object.
- Cập nhật các gói phần mềm

	```sh
	apt-get update
	```
	
### 1 Cài đặt networking cho object1
- Dùng lệnh vi để sửa file `/etc/network/interfaces` với nội dung như sau.

	```sh
	auto ens3
	iface ens3 inet static
					address 10.10.10.193
					netmask 255.255.255.0


	auto ens4
	iface ens4 inet static
					address 172.16.10.193
					netmask 255.255.255.0
					gateway 172.16.10.1
					dns-nameservers 8.8.8.8
	```

- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

	```sh
	ifdown -a && ifup -a
	```
	
- Cấu hình hostname. Dùng vi sửa file `/etc/hostname` với tên là object1.

	```sh
	object1
	```
	
- Cập nhật file /etc/hosts để phân giải từ IP sang hostname và ngược lại, nội dung như sau

	```sh
	10.10.10.190				controller
	10.10.10.191				compute1
	10.10.10.192				block
	10.10.10.193				object1
	10.10.10.194				object2
	```

- Khởi động lại máy, sau đó đăng nhập vào với quyền root.

	```sh
	init 6
	```
	
### 2 Cài đặt networking cho object1
- Dùng lệnh vi để sửa file `/etc/network/interfaces` với nội dung như sau.

	```sh
	auto ens3
	iface ens3 inet static
					address 10.10.10.194
					netmask 255.255.255.0


	auto ens4
	iface ens4 inet static
					address 172.16.10.194
					netmask 255.255.255.0
					gateway 172.16.10.1
					dns-nameservers 8.8.8.8
	```

- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

	```sh
	ifdown -a && ifup -a
	```
	
- Cấu hình hostname. Dùng vi sửa file `/etc/hostname` với tên là object2.

	```sh
	object2
	```
	
- Cập nhật file /etc/hosts để phân giải từ IP sang hostname và ngược lại, nội dung như sau

	```sh
	10.10.10.190				controller
	10.10.10.191				compute1
	10.10.10.192				block
	10.10.10.193				object1
	10.10.10.194				object2
	```

- Khởi động lại máy, sau đó đăng nhập vào với quyền root.

	```sh
	init 6
	```

### 3. Các bước cài đặt sau được thực hiện trên cả 2 node object
- 1. Cài đặt NTP.
- Cài gói chrony.

	```sh
	apt install chrony -y
	```

- Mở file `/etc/chrony/chrony.conf` bằng vi và thêm vào các dòng sau:
- commnet dòng sau:

	```sh
	#pool 2.debian.pool.ntp.org offline iburst
	```

- Thêm các dòng sau:

	```sh
	server controller iburst
	```
	
- Restart dịch vụ NTP

	```sh
	service chrony restart
	```

- 2. Cài đặt repos để cài OpenStack PIKE
- Cài đặt gói để cài OpenStack PIKE

	```sh
	apt-get install software-properties-common -y
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
	
- Khởi động lại máy chủ

	```sh
	init 6
	```
---

<a name=4></a>
## 4. Cài dịch vụ Identity (keystone). Cài đặt trên node controller.
### 4.1 Tạo database cho keystone
- 1. Đăng nhập vào MariaDB

	```sh
	mysql -u root -pWelcome123
	```
	
- 2. Tạo database cho keystone

	```sh
	CREATE DATABASE keystone;
	```
	
- 3. Cấp quyền truy cập vào cơ sở dữ liệu keystone.
	
	```sh
	GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost'  IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Welcome123';
	FLUSH PRIVILEGES;
	exit;
	```
	
### 4.2 Cài đặt và cấu hình keystone
- 1. Cài đặt keystone

	```sh
	apt install keystone apache2 libapache2-mod-wsgi -y
	```
	
- Sao lưu file cấu hình của dịch vụ keystone trước khi chỉnh sửa.

	```sh
	cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.orig
	```
	
- 2. Dùng lệnh vi để mở và sửa file `/etc/keystone/keystone.conf`.
	- Trong section `[database]` thêm dòng dưới
	
		```sh
		connection = mysql+pymysql://keystone:Welcome123@controller/keystone
		```
		
	- Trong section `[token]`, cấu hình Fernet token provider:
	
		```sh
		provider = fernet
		```
	
- 3. Đồng bộ database cho keystone

	```sh
	su -s /bin/sh -c "keystone-manage db_sync" keystone
	```
	
- 4. Thiết lập Fernet key

	```sh
	keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
	keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
	```

- 5. Bootstrap the Identity service:

	```sh
	keystone-manage bootstrap --bootstrap-password Welcome123 \
	--bootstrap-admin-url http://controller:35357/v3/ \
	--bootstrap-internal-url http://controller:5000/v3/ \
	--bootstrap-public-url http://controller:5000/v3/ \
	--bootstrap-region-id RegionOne
	```
	
### 4.3 Cấu hình apache cho keysonte
- Dùng vi để mở và sửa file `/etc/apache2/apache2.conf`. Thêm dòng dưới ngay sau dòng `# Global configuration`

	```sh
	# Global configuration
	ServerName controller
	```
	
### 4.4 Kết thúc cài đặt
- Restart lại apache và xóa database SQLite mặc định

	```sh
	service apache2 restart
	rm -f /var/lib/keystone/keystone.db
	```	
	
- Cấu hình cho tài khoản quản trị:

	```sh
	export OS_USERNAME=admin
	export OS_PASSWORD=Welcome123
	export OS_PROJECT_NAME=admin
	export OS_USER_DOMAIN_NAME=Default
	export OS_PROJECT_DOMAIN_NAME=Default
	export OS_AUTH_URL=http://controller:35357/v3
	export OS_IDENTITY_API_VERSION=3
	```
	
### 4.5 Tạo domain, projects, users, và roles
- Tạo project service

	```sh
	~# openstack project create --domain default \
  --description "Service Project" service
	
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | Service Project                  |
	| domain_id   | default                          |
	| enabled     | True                             |
	| id          | e99255bab0a94a87b1184d18e14bd928 |
	| is_domain   | False                            |
	| name        | service                          |
	| parent_id   | default                          |
	+-------------+----------------------------------+
	```
	
- Tạo project demo:

	```sh
	openstack project create --domain default \
  --description "Demo Project" demo
		
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | Demo Project                     |
	| domain_id   | default                          |
	| enabled     | True                             |
	| id          | 46c2ef11a6904008be75a90d28b1928c |
	| is_domain   | False                            |
	| name        | demo                             |
	| parent_id   | default                          |
	+-------------+----------------------------------+
	```
	
- Tạo user demo

	```sh
	openstack user create --domain default \
  --password Welcome123 demo
		
	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | c83518ba02064bc795e7e282024647ad |
	| name                | demo                             |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```
	
- Tạo role `user`:
	
	```sh
	openstack role create user

	+-----------+----------------------------------+
	| Field     | Value                            |
	+-----------+----------------------------------+
	| domain_id | None                             |
	| id        | 013e86513757495c8ef8fc9b82b40523 |
	| name      | user                             |
	+-----------+----------------------------------+
	```
	
- Thêm role user cho user demo trên project demo:

	```sh
	openstack role add --project demo --user demo user
	```
	
### 4.6 Kiểm chứng lại các bước cài đặt keysonte
- Bỏ thiết lập trong biến môi trường của OS_AUTH_URL và OS_PASSWORD bằng lệnh:

	```sh
	unset OS_AUTH_URL OS_PASSWORD
	```
	
- Gõ lần lượt 2 lệnh dưới sau đó nhập mật khẩu là Welcome123
	
	```sh
	openstack --os-auth-url http://controller:35357/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name admin --os-username admin token issue
	Password:

	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	| Field      | Value                                                                                                                              |
	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	| expires    | 2017-08-08T14:37:45+0000                                                                                                           |
	| id         | gAAAAABZOVMpzGj_G62qWkgpIL58u2l1FKFBkWTpqW5zocPPdraLwYWEdHUsKsOkCZwMNGFelZlI0vilWo4gMsZ5nWXb2ELD4aMHU4W3rnMSxKqv4QtSxiRCv8hTJ_IGIj |
	|            | vYFF_e2qtySAsuhoRCZVOhy3KfS2FelCpzQE4UDRP5VHWKX5OMeI4                                                                              |
	| project_id | b54646bf669746db8c62ec0410bd0528                                                                                                   |
	| user_id    | 102f8ea368cd4451ad6fefeb15801177                                                                                                   |
	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	```

	- và

	```sh
	openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name demo --os-username demo token issue
	Password:

	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	| Field      | Value                                                                                                                              |
	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	| expires    | 2017-08-08T14:39:37+0000                                                                                                           |
	| id         | gAAAAABZOVOZu1qQ0_9OkDgoDiQjRhiNH8UxWEwbXZCtiFZ7r4dX37cs5edGxwKpDVriIc3SpRWmPK-YY2Qt0VVaxJ1m8210RsQRitplup1_kBZMp86lZKLibnjoEX-    |
	|            | gqXssudHceQObctojg_m8hwihsy5wGsRk-H3HYBQqiIroJ_OHuY7T7gA                                                                           |
	| project_id | 46c2ef11a6904008be75a90d28b1928c                                                                                                   |
	| user_id    | c83518ba02064bc795e7e282024647ad                                                                                                   |
	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	```
	
### 4.7 Tạo script biến môi trường cho client
- Tạo file admin-openrc với nội dung sau:

	```sh
	export OS_PROJECT_DOMAIN_NAME=Default
	export OS_USER_DOMAIN_NAME=Default
	export OS_PROJECT_NAME=admin
	export OS_USERNAME=admin
	export OS_PASSWORD=Welcome123
	export OS_AUTH_URL=http://controller:35357/v3
	export OS_IDENTITY_API_VERSION=3
	export OS_IMAGE_API_VERSION=2
	```

- Tạo file demo-openrc với nội dung sau:

	```sh
	export OS_PROJECT_DOMAIN_NAME=Default
	export OS_USER_DOMAIN_NAME=Default
	export OS_PROJECT_NAME=demo
	export OS_USERNAME=demo
	export OS_PASSWORD=Welcome123
	export OS_AUTH_URL=http://controller:5000/v3
	export OS_IDENTITY_API_VERSION=3
	export OS_IMAGE_API_VERSION=2
	```
	
- Chạy script admin-openrc

	```sh
	source  admin-openrc
	```
	
- Kết quả sẽ như bên dưới (Lưu ý: giá trị sẽ khác nhau)
	
	```sh
	openstack token issue

	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	| Field      | Value                                                                                                                              |
	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	| expires    | 2017-08-08T14:45:58+0000                                                                                                           |
	| id         | gAAAAABZOVUWFfzGA7YgH4B8E22pSmM1z0woDouvaBCUF8NhnY1ne65hCFHU1TnfFadXXtX8RH0NXLa1KNKClrf-                                           |
	|            | Xxdl6qOyNGHBJ2jLHSws8TCaLtZYu6UoCIHxLzVus35krZGYS1DXpfBjB77YiLmuXhvf8qryZbWvBQX5K9otIbPv7e_dHqU                                    |
	| project_id | b54646bf669746db8c62ec0410bd0528                                                                                                   |
	| user_id    | 102f8ea368cd4451ad6fefeb15801177                                                                                                   |
	+------------+------------------------------------------------------------------------------------------------------------------------------------+
	```
	
<a name=5></a>
## 5. Cài dịch vụ Image (Glance). Cài đặt trên node controller.
### 5.1 Tạo database cho glance
- Đăng nhập vào mysql

	```sh
	mysql -u root -pWelcome123
	```
	
- Tạo database glance

	```sh
	CREATE DATABASE glance;
	```
	
- Cấp quyền truy cập vào cơ sở dữ liệu

	```sh
	GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Welcome123';
	FLUSH PRIVILEGES;
	Exit;
	```	
	
### 5.2 Tạo user glance, gán quyền và tạo endpoint API cho dịch vụ glance
- Chạy script biến môi trường: `source admin-openrc`

- Tạo user glance:

	```sh
	~# openstack user create --domain default --password Welcome123 glance

	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | 119d2cad45584585b5bf9ef799cbfbfa |
	| name                | glance                           |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```
	
- Thêm role admin cho user glance trên project service

	```sh
	openstack role add --project service --user glance admin
	```
	
- Tạo dịch vụ có tên glance

	```sh
	~# openstack service create --name glance \
  --description "OpenStack Image" image
   
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | OpenStack Image                  |
	| enabled     | True                             |
	| id          | 5ef6ca4ca183461eb2bb64b3c406a839 |
	| name        | glance                           |
	| type        | image                            |
	+-------------+----------------------------------+
	```
	
- Tạo các endpoint cho dịch vụ glance

	```sh
	openstack endpoint create --region RegionOne \
	image public http://controller:9292
		

	openstack endpoint create --region RegionOne \
	image internal http://controller:9292


	openstack endpoint create --region RegionOne \
	image admin http://controller:9292
	```
	
### 5.3 Cài đặt và cấu hình cho dịch vụ glance
- Cài đặt gói glance

	```sh
	apt install glance -y
	```
	
- Sao lưu các file `/etc/glance/glance-api.conf` và file `/etc/glance/glance-registry.conf` trước khi cấu hình

	```sh
	cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf.orig
	cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.orig
	```	
	
- Cấu hình glance
- Sửa các mục dưới đây ở cả 2 file `/etc/glance/glance-api.conf` và `/etc/glance/glance-registry.conf`
	- Trong section `[DEFAULT]` thêm hoặc tìm và thay thế dòng cũ bằng dòng dưới để cho phép chế độ ghi log với glance
	
	```sh
	verbose = true
	```
	
	- Trong section [database]
	- Comment dòng
	
	```sh
	#sqlite_db = /var/lib/glance/glance.sqlite
	```
	
	- Thêm dòng dưới
	
	```sh
	connection = mysql+pymysql://glance:Welcome123@controller/glance
	```
	
	- Trong section [keystone_authtoken] và [paste_deploy], cấu hình truy cập dịch vụ Identity:
	
	```sh
	[keystone_authtoken]
	# ...
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = glance
	password = Welcome123

	[paste_deploy]
	# ...
	flavor = keystone
	```
	
- Trong section `[glance_store]`, cấu hình lưu trữ file trên hệ thống (local file system store) và vị trí của file image (mục này không phải làm trong file /etc/glance/glance-registry.conf):

	```sh
	[glance_store]
	# ...
	stores = file,http
	default_store = file
	filesystem_store_datadir = /var/lib/glance/images/
	```
	
- Đồng bộ database cho glance

	```sh
	su -s /bin/sh -c "glance-manage db_sync" glance
	```
	
- Restart dịch vụ Glance.

	```sh
	service glance-registry restart
	service glance-api restart
	```
	
### 5.4 Kiểm chứng lại việc cài đặt glance
- Chạy script biến môi trường: `source admin-openrc`

- Tải file image cho glance

	```sh
	wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
	```
	
- Upload file image vừa tải về

	```sh
	openstack image create "cirros" \
	--file cirros-0.3.5-x86_64-disk.img \
	--disk-format qcow2 --container-format bare \
	--public
	```
	
- Kiểm tra lại image đã có hay chưa

	```sh
	~# openstack image list
	+--------------------------------------+--------+--------+
	| ID                                   | Name   | Status |
	+--------------------------------------+--------+--------+
	| 9b989c67-57a3-4f7d-88d0-d4137aa0a7fa | cirros | active |
	+--------------------------------------+--------+--------+
	```
	
- Nếu kết quả như trên là đã cài đặt thành công

<a name=6></a>
## 6.  Cài dịch vụ Compute (Nova)
- Tóm tắt về dịch vụ nova trong OpenStack
- Nova đảm nhiệm chức năng cung cấp và quản lý tài nguyên trong OpenStack để cấp cho các VM. Trong hướng dẫn nãy sẽ sử dụng KVM làm hypervisor. Nova sẽ tác động vào KVM thông qua libvirt

<a name=e></a>
### 6.1 Cài đặt các thành phần trên node controller.
### 6.1.1 Tạo database cho nova
- Đăng nhập vào database với quyền root

	```sh
	mysql -u root -pWelcome123
	```
	
- Tạo database nova_api, nova, và nova_cell0:

	```sh
	CREATE DATABASE nova_api;
	CREATE DATABASE nova;
	CREATE DATABASE nova_cell0;
	```
	
- Cấp quyền truy cập database:

	```sh
	GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'Welcome123';

	GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'Welcome123';

	GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'Welcome123';

	FLUSH PRIVILEGES;
	EXIT;	
	```	
	
### 6.1.2 Tạo user, service và các endpoint API cho nova
- Chạy script biến môi trường: `source admin-openrc`

- Tạo user nova

	```sh
	~# openstack user create --domain default --password Welcome123 nova

	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | d4645d60bdb14e9b9148a2e3193e744f |
	| name                | nova                             |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```
	
- Thêm role admin cho user nova trên project service

	```sh
	openstack role add --project service --user nova admin
	```
	
- Tạo dịch vụ nova

	```sh
	~# openstack service create --name nova \
		--description "OpenStack Compute" compute
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | OpenStack Compute                |
	| enabled     | True                             |
	| id          | 29b8545253fd4bb389480040882eff31 |
	| name        | nova                             |
	| type        | compute                          |
	+-------------+----------------------------------+
	```
	
- Tạo các endpoint cho dịch vụ compute:

	```sh
	openstack endpoint create --region RegionOne \
	compute public http://controller:8774/v2.1

	openstack endpoint create --region RegionOne \
	compute internal http://controller:8774/v2.1

	openstack endpoint create --region RegionOne \
	compute admin http://controller:8774/v2.1
	```
	
- Tạo user placement

	```sh
	~# openstack user create --domain default --password Welcome123 placement

	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | 6328b10db2734a4bbc8f022d8bee2630 |
	| name                | placement                        |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```
	
- Thêm role admin cho user placement trên project service:

	```sh
	openstack role add --project service --user placement admin
	```
	
- Tạo dịch vụ placement:

	```sh
	~# openstack service create --name placement --description "Placement API" placement

	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | Placement API                    |
	| enabled     | True                             |
	| id          | 19372a41560d4df5ba04842174ef4ced |
	| name        | placement                        |
	| type        | placement                        |
	+-------------+----------------------------------+
	```
	
- Tạo endpoint cho placement

	```sh
	openstack endpoint create --region RegionOne placement public http://controller:8778

	openstack endpoint create --region RegionOne placement internal http://controller:8778

	openstack endpoint create --region RegionOne placement admin http://controller:8778
	```
	
### 6.1.3 Cài đặt và cấu hình Nova
- 1. Cài đặt các gói:

	```sh
	apt install -y nova-api nova-conductor nova-consoleauth \
	nova-novncproxy nova-scheduler nova-placement-api
	```
	
- Sao lưu file /etc/nova/nova.conf trước khi cấu hình

	```sh
	cp /etc/nova/nova.conf /etc/nova/nova.conf.orig
	```
	
- 2. Cấu hình nova. Sửa file `/etc/nova/nova.conf`

- Trong `[api_database]` và `[database]` sections, cấu hình truy cập database:

	```sh
	[api_database]
	# ...
	#connection=sqlite:////var/lib/nova/nova.sqlite
	connection = mysql+pymysql://nova:Welcome123@controller/nova_api

	[database]
	# ...
	connection = mysql+pymysql://nova:Welcome123@controller/nova
	```
	
- Trong `[DEFAULT]` section:

	```sh
	[DEFAULT]
	# ...
	use_neutron = True
	firewall_driver = nova.virt.firewall.NoopFirewallDriver
	my_ip = 10.10.10.190
	transport_url = rabbit://openstack:Welcome123@controller
	```
	
- Trong [api] và [keystone_authtoken], cấu hình dịch vụ identity:

	```sh
	[api]
	# ...
	auth_strategy = keystone

	[keystone_authtoken]
	# ...
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = nova
	password = Welcome123
	```
	
- Trong [vnc]:

	```sh
	[vnc]
	enabled = true
	# ...
	vncserver_listen = $my_ip
	vncserver_proxyclient_address = $my_ip
	```
	
- Trong [glance]:

	```sh
	[glance]
	# ...
	api_servers = http://controller:9292
	```
	
- Trong [oslo_concurrency]:

	```sh
	[oslo_concurrency]
	# ...
	lock_path = /var/lib/nova/tmp
	```	
	
- Trong [placement], cấu hình Placement API:

	```sh
	[placement]
	# ...
	os_region_name = RegionOne
	project_domain_name = Default
	project_name = service
	auth_type = password
	user_domain_name = Default
	auth_url = http://controller:35357/v3
	username = placement
	password = Welcome123
	```
	
### 6.1.4 Import database cho nova
- Tạo database cho nova_api

	```sh
	su -s /bin/sh -c "nova-manage api_db sync" nova
	```
	
- Đăng ký cell0 database:

	```sh
	su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
	```
	
- Create the cell1 cell:

	```sh
	su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova  
	```
	
- Tạo database cho nova

	```sh
	su -s /bin/sh -c "nova-manage db sync" nova
	```
	
- Kiểm tra lại nova cell0 và cell1 đã được đăng ký đúng hay chưa:

	```sh
	~# nova-manage cell_v2 list_cells
	+-------+--------------------------------------+
	|  Name |                 UUID                 |
	+-------+--------------------------------------+
	| cell0 | 00000000-0000-0000-0000-000000000000 |
	| cell1 | 3ca28930-9d49-4a26-867e-88f7285d3b0e |
	+-------+--------------------------------------+
	```
	
### 6.1.5 Kết thúc bước cài đặt và cấu hình nova
- Khởi động lại các dịch vụ của nova sau khi cài đặt & cấu hình nova

	```sh
	service nova-api restart
	service nova-consoleauth restart
	service nova-scheduler restart
	service nova-conductor restart
	service nova-novncproxy restart 
	```
	
## Sau khi cài đặt xong các thành phần của nova trên node controller, chúng ta bắt đầu cài đặt nova-compute trên node compute1.

<a name=f></a>
## 6.2 Cài đặt nova-compute1
### 6.2.1 Cài đặt và cấu hình
- 1. Cài đặt

	```sh
	apt install nova-compute -y
	```
	
- Sao lưu file cấu hình của dịch vụ nova-compute trước khi chỉnh sửa.

	```sh
	cp /etc/nova/nova.conf /etc/nova/nova.conf.orig
	```

- 2. Cấu hình
- Trong `[DEFAULT]` section:

	```sh
	[DEFAULT]
	#..
	transport_url = rabbit://openstack:Welcome123@controller
	my_ip = 10.10.10.191
	use_neutron = True
	firewall_driver = nova.virt.firewall.NoopFirewallDriver
	```
	
- Trong `[api]` và `[keystone_authtoken]`, cấu hình dịch vụ identity:

	```sh
	[api]
	# ...
	auth_strategy = keystone

	[keystone_authtoken]
	# ...
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = nova
	password = Welcome123
	```
	
- Trong [vnc] section:

	```sh
	[vnc]
	# ...
	enabled = True
	vncserver_listen = 0.0.0.0
	vncserver_proxyclient_address = $my_ip
	novncproxy_base_url = http://172.16.69.190:6080/vnc_auto.html
	```
	
- Trong [glance]:

	```sh
	[glance]
	# ...
	api_servers = http://controller:9292
	```
	
- Trong [oslo_concurrency]:

	```sh
	[oslo_concurrency]
	# ...
	lock_path = /var/lib/nova/tmp
	```
	
- Trong [placement], cấu hình Placement API:

	```sh
	[placement]
	# ...
	os_region_name = RegionOne
	project_domain_name = Default
	project_name = service
	auth_type = password
	user_domain_name = Default
	auth_url = http://controller:35357/v3
	username = placement
	password = Welcome123
	```

### 6.2.2 Kết thúc bước cài đặt và cấu hình nova
- Xác định xem compute1 node có hỗ trợ ảo hóa hay không

	```sh
	egrep -c '(vmx|svm)' /proc/cpuinfo
	```
	
- Nếu lệnh này trả về một giá trị là 1 hoặc lớn hơn, thì compute node này sẽ hỗ trợ ảo hóa.

- Restart the Compute service:

	```sh
	service nova-compute restart
	```

<a name=q></a>
### 6.3 Sau khi cài đặt xong nova-compute trên node compute. Chúng ta quay lại node controller tiến hành các bước tiếp theo.
- 1. Thêm compute node vào trong database cell

	```sh
	~# . admin-openrc

	~# openstack hypervisor list
	+----+---------------------+-----------------+--------------+-------+
	| ID | Hypervisor Hostname | Hypervisor Type | Host IP      | State |
	+----+---------------------+-----------------+--------------+-------+
	|  1 | compute1            | QEMU            | 10.10.10.191 | up    |
	+----+---------------------+-----------------+--------------+-------+
	```
	
- 2. Discover compute hosts:

	```sh
	~# su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

	Found 2 cell mappings.
	Skipping cell0 since it does not contain hosts.
	Getting compute nodes from cell 'cell1': 3ca28930-9d49-4a26-867e-88f7285d3b0e
	Found 1 computes in cell: 3ca28930-9d49-4a26-867e-88f7285d3b0e
	Checking host mapping for compute host 'compute1': dc48e539-3223-48d1-8a3c-47c016be15e6
	Creating host mapping for compute host 'compute1': dc48e539-3223-48d1-8a3c-47c016be15e6
	```

### 6.3.1 Kiểm tra kết quả cài đặt nova.
- Khai báo các biến môi trường: `source admin-openrc`
- Liệt kê ra các dịch vụ thành phần

	```sh
	~# openstack compute service list
	+----+------------------+------------+----------+---------+-------+----------------------------+
	| ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
	+----+------------------+------------+----------+---------+-------+----------------------------+
	|  3 | nova-consoleauth | controller | internal | enabled | up    | 2017-08-08T17:22:06.000000 |
	|  4 | nova-scheduler   | controller | internal | enabled | up    | 2017-08-08T17:22:02.000000 |
	|  5 | nova-conductor   | controller | internal | enabled | up    | 2017-08-08T17:22:03.000000 |
	|  6 | nova-compute     | compute1   | nova     | enabled | up    | 2017-08-08T17:22:08.000000 |
	+----+------------------+------------+----------+---------+-------+----------------------------+
	```

- Liệt kê ra các API endpoint.

	```sh
	~# openstack catalog list
	+-----------+-----------+-----------------------------------------+
	| Name      | Type      | Endpoints                               |
	+-----------+-----------+-----------------------------------------+
	| placement | placement | RegionOne                               |
	|           |           |   public: http://controller:8778        |
	|           |           | RegionOne                               |
	|           |           |   internal: http://controller:8778      |
	|           |           | RegionOne                               |
	|           |           |   admin: http://controller:8778         |
	|           |           |                                         |
	| nova      | compute   | RegionOne                               |
	|           |           |   internal: http://controller:8774/v2.1 |
	|           |           | RegionOne                               |
	|           |           |   admin: http://controller:8774/v2.1    |
	|           |           | RegionOne                               |
	|           |           |   public: http://controller:8774/v2.1   |
	|           |           |                                         |
	| glance    | image     | RegionOne                               |
	|           |           |   public: http://controller:9292        |
	|           |           | RegionOne                               |
	|           |           |   admin: http://controller:9292         |
	|           |           | RegionOne                               |
	|           |           |   internal: http://controller:9292      |
	|           |           |                                         |
	| keystone  | identity  | RegionOne                               |
	|           |           |   internal: http://controller:5000/v3/  |
	|           |           | RegionOne                               |
	|           |           |   admin: http://controller:35357/v3/    |
	|           |           | RegionOne                               |
	|           |           |   public: http://controller:5000/v3/    |
	|           |           |                                         |
	+-----------+-----------+-----------------------------------------+
	```
	
- Liệt các image

	```sh
	~# openstack image list
	+--------------------------------------+--------+--------+
	| ID                                   | Name   | Status |
	+--------------------------------------+--------+--------+
	| 9b989c67-57a3-4f7d-88d0-d4137aa0a7fa | cirros | active |
	+--------------------------------------+--------+--------+
	```
	
- Kiểm tra cells và placement API

	```sh
	~# nova-status upgrade check
	+---------------------------+
	| Upgrade Check Results     |
	+---------------------------+
	| Check: Cells v2           |
	| Result: Success           |
	| Details: None             |
	+---------------------------+
	| Check: Placement API      |
	| Result: Success           |
	| Details: None             |
	+---------------------------+
	| Check: Resource Providers |
	| Result: Success           |
	| Details: None             |
	+---------------------------+
	```

<a name=7></a>
## 7 Cài đặt Networking service (NEUTRON).

<a name=g></a>
### 7.1 Cài đặt trên node Controller.
### 7.1.1 Tạo database cho neutron
- Đăng nhập vào neutron

	```sh
	mysql -u root -pWelcome123
	```
	
- Tạo database neutron:

	```sh
	CREATE DATABASE neutron;
	```
	
- Cấp quyền truy cập vào neutron database

	```sh
	GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'Welcome123';

	FLUSH PRIVILEGES;
	exit;
	```

### 7.1.2 Tạo user, dịch vụ và các endpoint API cho neutron
- Khai báo biến môi trường `source admin-openrc`

- Tạo user neutron

	```sh
	~# openstack user create --domain default --password Welcome123 neutron

	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | 13bc1e0d3fb547d1b02ffa69d6597a73 |
	| name                | neutron                          |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```
	
- Gán role admin cho tài khoản neutron

	```sh
	openstack role add --project service --user neutron admin
	```
	
- Tạo dịch vụ tên là neutron

	```sh
	~# openstack service create --name neutron \
		--description "OpenStack Networking" network
		
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | OpenStack Networking             |
	| enabled     | True                             |
	| id          | bd88da44044c4146843b6fbffbdadb4f |
	| name        | neutron                          |
	| type        | network                          |
	+-------------+----------------------------------+
	```
	
- Tạo endpoint tên cho neutron

	```sh
	openstack endpoint create --region RegionOne \
	network public http://controller:9696

	openstack endpoint create --region RegionOne \
	network internal http://controller:9696

	openstack endpoint create --region RegionOne \
	network admin http://controller:9696
	```

### 7.1.3 Cài đặt và cấu hình neutron
- Cài đặt và cấu hình cho dịch vụ neutron. Trong hướng dẫn này lựa chọn cơ chế `self-service netwok`

- Cài đặt các thành phần cho neutron

	```sh
	apt -y install neutron-server neutron-plugin-ml2 \
	neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
	neutron-metadata-agent
	```
	
- Sao lưu file cấu hình gốc của neutron

	```sh
	cp /etc/neutron/neutron.conf  /etc/neutron/neutron.conf.orig
	```
	
- Cấu hình cho dịch vụ neutron. Dùng vi chỉnh sửa file `/etc/neutron/neutron.conf`

- Trong section `[database]` comment dòng:

	```sh
	# connection = sqlite:////var/lib/neutron/neutron.sqlite
	```
	- và thêm dòng dưới

	```sh
	connection = mysql+pymysql://neutron:Welcome123@controller/neutron
	```

- Trong section `[DEFAULT]` khai báo lại hoặc thêm mới các dòng dưới:

	```sh
	core_plugin = ml2
	service_plugins = router
	allow_overlapping_ips = true
	transport_url = rabbit://openstack:Welcome123@controller
	auth_strategy = keystone
	notify_nova_on_port_status_changes = true
	notify_nova_on_port_data_changes = true
	```
	
- Trong section `[keystone_authtoken]` khai báo hoặc thêm mới các dòng dưới:

	```sh
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = neutron
	password = Welcome123
	```
	
- Trong section [nova] khai báo mới hoặc thêm các dòng dưới

	```sh
	auth_url = http://controller:35357
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	region_name = RegionOne
	project_name = service
	username = nova
	password = Welcome123
	```

- Cài đặt và cấu hình plug-in Modular Layer 2 (ML2)
- Sao lưu file `/etc/neutron/plugins/ml2/ml2_conf.ini`

	```sh
	cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.orig
	```
	
- Trong section [ml2] khai báo thêm hoặc sửa dòng dưới

	```sh
	type_drivers = flat,vlan,vxlan
	tenant_network_types = vxlan
	mechanism_drivers = linuxbridge,l2population
	extension_drivers = port_security
	```
	
- Trong section [ml2_type_flat] khai báo thêm hoặc sửa thành dòng dưới

	```sh
	flat_networks = provider
	```
	
- Trong section [ml2_type_vxlan] khai báo thêm hoặc sửa thành dòng dưới

	```sh
	vni_ranges = 1:1000
	```
	
- Trong section [securitygroup] khai báo thêm hoặc sửa thành dòng dưới

	```sh
	enable_ipset = true
	```

- Cấu hình linuxbridge
- Sao lưu file `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`

	```sh
	cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini  /etc/neutron/plugins/ml2/linuxbridge_agent.ini.orig
	```
	
- Trong section [linux_bridge] khai báo mới hoặc sửa thành dòng

	```sh
	physical_interface_mappings = provider:ens4
	```
	
- Trong section [vxlan] khai báo mới hoặc sửa thành dòng

	```sh
	enable_vxlan = true
	local_ip = 10.10.10.190
	l2_population = true
	```
	
- Trong section [securitygroup] khai báo mới hoặc sửa thành dòng

	```sh
	enable_security_group = true
	firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
	```
	
-Cấu hình l3-agent
- Sao lưu file /etc/neutron/l3_agent.ini

	```sh
	cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini.orig
	```
	
- Trong section [DEFAULT] khai báo mới hoặc sửa thành dòng dưới:

	```sh
	interface_driver = linuxbridge
	```
	
- Cấu hình DHCP Agent
- Sao lưu file /etc/neutron/dhcp_agent.ini gốc

	```sh
	cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.orig
	```
	
- Trong section [DEFAULT] khai báo mới hoặc sửa thành dòng dưới

	```sh
	interface_driver = linuxbridge
	dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
	enable_isolated_metadata = true
	```
	
- Cấu hình metadata agent
- Sao lưu file /etc/neutron/metadata_agent.ini

	```sh
	cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.orig
	```

- Sửa file vi /etc/neutron/metadata_agent.ini
- Trong section [DEFAULT] khai báo mới hoặc sửa thành dòng dưới

	```sh
	nova_metadata_ip = controller
	metadata_proxy_shared_secret = Welcome123
	```
	
- Sửa trong file /etc/nova/nova.conf
- Trong section [neutron] khai báo mới hoặc sửa thành dòng dưới:

	```sh
	url = http://controller:9696
	auth_url = http://controller:35357
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	region_name = RegionOne
	project_name = service
	username = neutron
	password = Welcome123
	service_metadata_proxy = true
	metadata_proxy_shared_secret = Welcome123
	```
	
- Kết thúc quá trình cài đặt neutron trên controller node
	
- **7.1.4 Đồng bộ database cho neutron**

	```sh
	su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
	--config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
	```
	
- Restart nova-api

	```sh
	service nova-api restart
	```
	
- Restart các dịch vụ của neutron

	```sh
	service neutron-server restart
	service neutron-linuxbridge-agent restart
	service neutron-dhcp-agent restart
	service neutron-metadata-agent restart
	service neutron-l3-agent restart
	```
	
- Tiếp theo sẽ cài đặt neutron trên node compute.
	
<a name=h></a>
### 7.2 Cài đặt neutron trên node compute1
### 7.2.1 Cài đặt và cấu hình neutron
- 1. cài đặt các thành phần

	```sh
	apt install neutron-linuxbridge-agent -y
	```
	
- Cấu hình
- Sao lưu file /etc/neutron/neutron.conf trước khi cài đặt

	```sh
	cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.orig
	```
	
- Trong [database] section, comment hết các connection

	```sh
	#connection = sqlite:////var/lib/neutron/neutron.sqlite
	```
	
- Trong [DEFAULT] section:

	```sh
	auth_strategy = keystone
	transport_url = rabbit://openstack:Welcome123@controller
	```
	
- Trong [keystone_authtoken] section:

	```sh
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = neutron
	password = Welcome123
	```
	
- Cấu hình Linux bridge agent

- Sao lưu file /etc/neutron/plugins/ml2/linuxbridge_agent.ini

	```sh
	cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.orig
	```
	
- Trong [linux_bridge] section:

	```sh
	physical_interface_mappings = provider:ens4
	```
	
- Trong [vxlan] section:

	```sh
	enable_vxlan = true
	local_ip = 10.10.10.191
	l2_population = true
	```
	
- Trong [securitygroup] section:

	```sh
	enable_security_group = true
	firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
	```	
	
- Cấu hình dịch vụ compute sử dụng dịch vụ network

- Sửa file `/etc/nova/nova.conf`

- Trong [neutron] section:

	```sh
	url = http://controller:9696
	auth_url = http://controller:35357
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	region_name = RegionOne
	project_name = service
	username = neutron
	password = Welcome123
	```
	
- Kết thúc cài đặt

-	Restart nova-compute

	```sh
	service nova-compute restart
	```
	
- Restart Linux bridge agent:

	```sh
	service neutron-linuxbridge-agent restart
	```
	
- Quay lại **node controller** để kiểm lại cài đặt neutron

### 7.3 Kiểm tra kết quả cài đặt
- Khai báo biến môi trường: `source admin-openrc`
- Thực hiện các lệnh sau để kiểm tra

	```sh
	~# openstack extension list --network

	# kết quả

	+----------------------------------------------------------+---------------------------+----------------------------------------------------------+
	| Name                                                     | Alias                     | Description                                              |
	+----------------------------------------------------------+---------------------------+----------------------------------------------------------+
	| Default Subnetpools                                      | default-subnetpools       | Provides ability to mark and use a subnetpool as the     |
	|                                                          |                           | default                                                  |
	| Network IP Availability                                  | network-ip-availability   | Provides IP availability data for each network and       |
	|                                                          |                           | subnet.                                                  |
	| Network Availability Zone                                | network_availability_zone | Availability zone support for network.                   |
	| Auto Allocated Topology Services                         | auto-allocated-topology   | Auto Allocated Topology Services.                        |
	| Neutron L3 Configurable external gateway mode            | ext-gw-mode               | Extension of the router abstraction for specifying       |
	|                                                          |                           | whether SNAT should occur on the external gateway        |
	| Port Binding                                             | binding                   | Expose port bindings of a virtual port to external       |
	|                                                          |                           | application                                              |
	| agent                                                    | agent                     | The agent management extension.                          |
	| Subnet Allocation                                        | subnet_allocation         | Enables allocation of subnets from a subnet pool         |
	| L3 Agent Scheduler                                       | l3_agent_scheduler        | Schedule routers among l3 agents                         |
	| Tag support                                              | tag                       | Enables to set tag on resources.                         |
	| Neutron external network                                 | external-net              | Adds external network attribute to network resource.     |
	| Neutron Service Flavors                                  | flavors                   | Flavor specification for Neutron advanced services       |
	| Network MTU                                              | net-mtu                   | Provides MTU attribute for a network resource.           |
	| Availability Zone                                        | availability_zone         | The availability zone extension.                         |
	| Quota management support                                 | quotas                    | Expose functions for quotas management per tenant        |
	| HA Router extension                                      | l3-ha                     | Add HA capability to routers.                            |
	| Provider Network                                         | provider                  | Expose mapping of virtual networks to physical networks  |
	| Multi Provider Network                                   | multi-provider            | Expose mapping of virtual networks to multiple physical  |
	|                                                          |                           | networks                                                 |
	| Address scope                                            | address-scope             | Address scopes extension.                                |
	| Neutron Extra Route                                      | extraroute                | Extra routes configuration for L3 router                 |
	| Subnet service types                                     | subnet-service-types      | Provides ability to set the subnet service_types field   |
	| Resource timestamps                                      | standard-attr-timestamp   | Adds created_at and updated_at fields to all Neutron     |
	|                                                          |                           | resources that have Neutron standard attributes.         |
	| Neutron Service Type Management                          | service-type              | API for retrieving service providers for Neutron         |
	|                                                          |                           | advanced services                                        |
	| Router Flavor Extension                                  | l3-flavors                | Flavor support for routers.                              |
	| Port Security                                            | port-security             | Provides port security                                   |
	| Neutron Extra DHCP opts                                  | extra_dhcp_opt            | Extra options configuration for DHCP. For example PXE    |
	|                                                          |                           | boot options to DHCP clients can be specified (e.g.      |
	|                                                          |                           | tftp-server, server-ip-address, bootfile-name)           |
	| Resource revision numbers                                | standard-attr-revisions   | This extension will display the revision number of       |
	|                                                          |                           | neutron resources.                                       |
	| Pagination support                                       | pagination                | Extension that indicates that pagination is enabled.     |
	| Sorting support                                          | sorting                   | Extension that indicates that sorting is enabled.        |
	| security-group                                           | security-group            | The security groups extension.                           |
	| DHCP Agent Scheduler                                     | dhcp_agent_scheduler      | Schedule networks among dhcp agents                      |
	| Router Availability Zone                                 | router_availability_zone  | Availability zone support for router.                    |
	| RBAC Policies                                            | rbac-policies             | Allows creation and modification of policies that        |
	|                                                          |                           | control tenant access to resources.                      |
	| Tag support for resources: subnet, subnetpool, port,     | tag-ext                   | Extends tag support to more L2 and L3 resources.         |
	| router                                                   |                           |                                                          |
	| standard-attr-description                                | standard-attr-description | Extension to add descriptions to standard attributes     |
	| Neutron L3 Router                                        | router                    | Router abstraction for basic L3 forwarding between L2    |
	|                                                          |                           | Neutron networks and access to external networks via a   |
	|                                                          |                           | NAT gateway.                                             |
	| Allowed Address Pairs                                    | allowed-address-pairs     | Provides allowed address pairs                           |
	| project_id field enabled                                 | project-id                | Extension that indicates that project_id field is        |
	|                                                          |                           | enabled.                                                 |
	| Distributed Virtual Router                               | dvr                       | Enables configuration of Distributed Virtual Routers.    |
	+----------------------------------------------------------+---------------------------+----------------------------------------------------------+
	
	```
	
- và

	```sh
	~# openstack network agent list
	+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
	| ID                                   | Agent Type         | Host       | Availability Zone | Alive | State | Binary                    |
	+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
	| 37dba433-cc42-4356-ae7c-c4ce6b4c337f | L3 agent           | controller | nova              | True  | UP    | neutron-l3-agent          |
	| 431fddfc-856e-42e6-af1e-7c006b6cca9a | DHCP agent         | controller | nova              | True  | UP    | neutron-dhcp-agent        |
	| 73401364-6c4d-412e-9510-0e42d36bb5cc | Linux bridge agent | controller | None              | True  | UP    | neutron-linuxbridge-agent |
	| eaa52af4-6ed3-4342-aa86-a961df3ccb70 | Linux bridge agent | compute1   | None              | True  | UP    | neutron-linuxbridge-agent |
	| f514f42a-c6b5-4b05-b4bc-b3242a3dc24d | Metadata agent     | controller | None              | True  | UP    | neutron-metadata-agent    |
	+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
	```
	
<a name=8></a>
## 8. Cài đặt và cấu hình HORIZON (dashboad). Cài đặt trên controller node.
- Cài đặt các thành phần cho dashboad

	```sh
	apt install openstack-dashboard -y
	```
	
- Sao lưu lại file cấu hình cho dashboad

	```sh
	cp /etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py.orig
	```
	
- Tìm các dòng sau trong file /etc/openstack-dashboard/local_settings.py và chỉnh sửa như bên dưới

	```sh
	OPENSTACK_HOST = "controller"
	```
	
	```sh
	ALLOWED_HOSTS = ['*']
	```
	
	```sh
	SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

	CACHES = {
		'default': {
				'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
				'LOCATION': 'controller:11211',
		}
	}
	```
	
	```sh
	OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
	```
	
	```sh
	OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
	```
	
	```sh
	OPENSTACK_API_VERSIONS = {
		"identity": 3,
		"image": 2,
		"volume": 2,
	}
	```
	
	```sh
	OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
	```
	
	```sh
	OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
	```
	
	```sh
	TIME_ZONE = "Asia/Ho_Chi_Minh"
	```
	
- Kết thúc cài đặt

- Restart apache

	```sh
	service apache2 restart
	```
	
- Vào trình duyệt nhập địa chỉ http://172.16.69.190/horizon để kiểm tra kết quả

<a name=9></a>
## 9. Cài đặt Block Storage node

<a name=i></a>
### 9.1 Cài đặt trên node controller
- Trước khi cài đặt và cấu hình Block Storage service, bạn phải tạo 1 database, service credentials, và API endpoints.
- Tạo database
- Đăng nhập vào MariaDB

	```sh
	mysql -u root -pWelcome123
	```
	
- Tạo database cinder

	```sh
	CREATE DATABASE cinder;
	```
	
- Cấp quyền truy cập đến cinder database

	```sh
	GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'Welcome123';

	GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'Welcome123';

	FLUSH PRIVILEGES;
	exit;
	```
	
#### tạo credentials cho dịch vụ
- Chạy script biến môi trường: `source admin-openrc`
- Tạo cinder user:

	```sh
	~# openstack user create --domain default --password Welcome123 cinder

	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | da27ad422b414bb4b9159ce5f385d1b6 |
	| name                | cinder                           |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```
	
- Thêm admin role cho cinder user:

	```sh
	openstack role add --project service --user cinder admin
	```
	
- Tạo cinderv2 và cinderv3 service entities:

	```sh
	~# openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2

	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | OpenStack Block Storage          |
	| enabled     | True                             |
	| id          | 9b7c43ccbf88464487910d04e9443e9d |
	| name        | cinderv2                         |
	| type        | volumev2                         |
	+-------------+----------------------------------+
	```
	
	```sh
	~# openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3

	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | OpenStack Block Storage          |
	| enabled     | True                             |
	| id          | 0512f93bd37c45b88c090488af093e24 |
	| name        | cinderv3                         |
	| type        | volumev3                         |
	+-------------+----------------------------------+
	```
	
#### Tạo Block Storage service API endpoints:

- volumev2

	```sh
	openstack endpoint create --region RegionOne \
	volumev2 public http://controller:8776/v2/%\(project_id\)s

	openstack endpoint create --region RegionOne \
	volumev2 internal http://controller:8776/v2/%\(project_id\)s

	openstack endpoint create --region RegionOne \
	volumev2 admin http://controller:8776/v2/%\(project_id\)s
	```
	
- volumev3

	```sh
	openstack endpoint create --region RegionOne \
	volumev3 public http://controller:8776/v3/%\(project_id\)s

	openstack endpoint create --region RegionOne \
	volumev3 internal http://controller:8776/v3/%\(project_id\)s

	openstack endpoint create --region RegionOne \
	volumev3 admin http://controller:8776/v3/%\(project_id\)s
	```
	
#### Cài đặt và cấu hình các thành phần trên node controller
- Cài đặt các gói:

	```sh
	apt install cinder-api cinder-scheduler -y
	```
	
- Sao lưu file cấu hình /etc/cinder/cinder.conf của cinder trước khi cấu hình

	```sh
	cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf.orig
	```
	
- Thực hiện cấu hình cinder
- Theo như quá trình mình cài đặt thì file cấu hình của cinder chỉ có 1 section - [DEFAULT]. Những section nào không có thì chỉ việc thêm vào file cấu hình là được.

- Trong [database] section, cấu hình truy cập database:

	```sh
	[database]
	# ...
	connection = mysql+pymysql://cinder:Welcome123@controller/cinder
	```
	
- Trong [DEFAULT] section, cấu hình truy cập RabbitMQ

	```sh
	[DEFAULT]
	# ...
	transport_url = rabbit://openstack:Welcome123@controller
	```
	
- Trong [DEFAULT] và [keystone_authtoken] sections, cấu hình truy cập dịch vụ Identity:

	```sh
	[DEFAULT]
	# ...
	auth_strategy = keystone

	[keystone_authtoken]
	# ...
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = cinder
	password = Welcome123
	```
	
- Trong [DEFAULT] section, cấu hình my_ip option để sử dụng địa chỉ management interface IP của node controller:

	```sh
	[DEFAULT]
	# ...
	my_ip = 10.10.10.190
	```
	
- Trong [oslo_concurrency] section, cấu hình lock path:

	```sh
	[oslo_concurrency]
	# ...
	lock_path = /var/lib/cinder/tmp
	```
	
- Phân quyền file cấu hình cinder

	```sh
	chmod 644 /etc/cinder/cinder.conf 
	chown root:cinder /etc/cinder/cinder.conf
	```
	
- Điền vào database của Block Storage:

	```sh
	su -s /bin/sh -c "cinder-manage db sync" cinder
	```
	
- Cấu hình Compute để sử dụng Block Storage:
- Sửa file `/etc/nova/nova.conf` trên node `controller` và `compute1`, sửa trong section [cinder] như sau:
	
	```sh
	[cinder]
	os_region_name = RegionOne
	```
	
- Kết thúc cài đặt
- Restart dịch vụ Compute API trên controller:

	```sh
	service nova-api restart	
	```
	
- Restart dịch vụ nova compute trên compute1:

	```sh
	systemctl restart nova-compute
	```
	
- Restart dịch vụ Block Storage:

	```sh
	service cinder-scheduler restart
	service apache2 restart
	```
	
<a name=k></a>
### 9.2 Cài đặt trên node Block Storage
- Cài đặt các tiện ích hỗ trợ.
- Cài đặt lvm2

	```sh
	apt install lvm2 -y
	```
	
- Tạo LVM physical volume /dev/vdb (Bạn có thể kiểm tra lại ổ đĩa dùng để cấp volume, ở đây trên hệ thống của mình là ổ /dev/vdb)

	```sh
	~# pvcreate /dev/vdb
	
	Physical volume "/dev/vdb" successfully created
	```
	
- Tạo LVM volume group là cinder-volumes

	```sh
	~# vgcreate cinder-volumes /dev/vdb
	
	Volume group "cinder-volumes" successfully created
	```
	
- Sửa file /etc/lvm/lvm.conf. Thêm dòng filter ở dưới vào section devices.

	```sh
	devices {
	....
	filter = ["a/vdb/", "r/.*/"]
	```
	
- Cài đặt các gói

	```sh
	apt install cinder-volume tgt thin-provisioning-tools -y
	```
	
- Thực hiện cấu hình

- Sửa file /etc/cinder/cinder.conf để cấu hình cinder. File cấu hình sẽ như sau:

	```sh
	[DEFAULT]
	my_ip = 10.10.10.192
	rootwrap_config = /etc/cinder/rootwrap.conf
	api_paste_confg = /etc/cinder/api-paste.ini
	state_path = /var/lib/cinder
	auth_strategy = keystone
	# RabbitMQ connection info
	transport_url = rabbit://openstack:Welcome123@controller


	glance_api_servers = http://controller:9292

	enabled_backends = lvm

	# MariaDB connection info
	[database]
	connection = mysql+pymysql://cinder:Welcome123@controller/cinder

	# Keystone auth info
	[keystone_authtoken]
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = cinder
	password = servicepassword

	[oslo_concurrency]
	lock_path = /var/lib/cinder/tmp

	[lvm]
	iscsi_helper = tgtadm
	# volume group name just created
	volume_group = cinder-volumes
	# IP address of Storage Node
	iscsi_ip_address = 10.10.10.192
	volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
	volumes_dir = /var/lib/cinder/volumes
	iscsi_protocol = iscsi
	```
	
- Kết thúc cài đặt
- Phân quyền file cấu hình:

	```sh
	chmod 644 /etc/cinder/cinder.conf 
	chown root:cinder /etc/cinder/cinder.conf 
	```
	
- Restart the Block Storage volume service:
	
	```sh
	service tgt restart
	service cinder-volume restart
	```
	
- Kiểm tra lại cài đặt. Thực hiện kiểm tra trên node controller.

	```sh
	~# openstack volume service list
	+------------------+------------+------+---------+-------+----------------------------+
	| Binary           | Host       | Zone | Status  | State | Updated At                 |
	+------------------+------------+------+---------+-------+----------------------------+
	| cinder-scheduler | controller | nova | enabled | up    | 2017-07-13T16:51:16.000000 |
	| cinder-volume    | block@lvm | nova | enabled | up    | 2017-07-13T16:51:09.000000 |
	+------------------+------------+------+---------+-------+----------------------------+
	```
	
<a name=10></a>
## 10. Cài đặt Swift

<a name=l></a>
### 10.1. Cài đặt Swift trên node controller

#### 1. Tạo user swift, gán quyền và tạo endpoint API cho dịch vụ swift
- Chạy script biến môi trường: `source admin-openrc`
- Tạo user swift

	```sh
	~# openstack user create --domain default --password Welcome123 swift
	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | 85072ff8b6134ec6a19a814ec52fa2a7 |
	| name                | swift                            |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```
Thêm role admin cho user swift trên project service

	```sh
	openstack role add --project service --user swift admin
	```
	
- Tạo dịch vụ có tên swift

	```sh
	~# openstack service create --name swift --description "OpenStack Object Storage" object-store
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | OpenStack Object Storage         |
	| enabled     | True                             |
	| id          | 5a6c0b0cf7834cd8a0aa70d73754433b |
	| name        | swift                            |
	| type        | object-store                     |
	+-------------+----------------------------------+
	```

- Tạo các endpoint cho swift

	```sh
	openstack endpoint create --region RegionOne \
	object-store public http://controller:8080/v1/AUTH_%\(tenant_id\)s

	openstack endpoint create --region RegionOne \
	object-store internal http://controller:8080/v1/AUTH_%\(tenant_id\)s

	openstack endpoint create --region RegionOne \
	object-store admin http://controller:8080/v1
	```
	
#### 2. Cài đặt và cấu hình cho dịch vụ Swift
- Cài đặt gói swift
	
	```sh
	apt-get install -y swift swift-proxy python-swiftclient \
	python-keystoneclient python-keystonemiddleware \
	memcached
	```
	
- Tạo thư mục /etc/swift
	
	```sh
	mkdir /etc/swift
	```
	
- Lấy file cấu hình dịch vụ proxy từ kho lưu trữ Object storage.

	```sh
	curl -o /etc/swift/proxy-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/newton
	```
	
- Sửa file `/etc/swift/proxy-server.conf`.
- Trong section [DEFAULT], cấu hình bind port, user, and cấu hình thư mục

	```sh
	[DEFAULT]
	...
	bind_port = 8080
	user = swift
	swift_dir = /etc/swift
	```
	
- Trong `[pipeline:main]` section, xóa 2 modules là `tempurl` và `tempauth`, thêm 2 modules là `authtoken` và `keystoneauth`.

	```sh
	[pipeline:main]
	pipeline = catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server
	```
	
- Trong `[app:proxy-server]` section, cho phép tự động tạo tài khoản.

	```sh
	[app:proxy-server]
	use = egg:swift#proxy
	...
	account_autocreate = True
	```
	
- Trong [filter:keystoneauth] section, cấu hình các roles của operator.

	```sh
	[filter:keystoneauth]
	use = egg:swift#keystoneauth
	...
	operator_roles = admin,user
	```
	
- Trong [filter:authtoken] section, cấu hình truy cập dịch vụ identity

	```sh
	[filter:authtoken]
	paste.filter_factory = keystonemiddleware.auth_token:filter_factory
	...
	auth_uri = http://controller:5000
	auth_url = http://controller:35357
	memcached_servers = controller:11211
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	project_name = service
	username = swift
	password = Welcome123
	delay_auth_decision = True
	```
	
- Trong [filter:cache] section, cấu hình vị trí memcached.

	```sh
	[filter:cache]
	use = egg:swift#memcache
	...
	memcache_servers = controller:11211
	```
	
<a name=m></a>
### 10.2 Cài đặt và cấu hình trên 2 node Object.
- Trên mỗi node object đều có 3 ổ đĩa. Kiểm tra bằng lệnh sau

	```sh
	~# lsblk
	NAME                  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
	sr0                    11:0    1  829M  0 rom
	vda                   253:0    0   20G  0 disk
	├─vda1                253:1    0  487M  0 part /boot
	├─vda2                253:2    0    1K  0 part
	└─vda5                253:5    0 19.5G  0 part
		├─ubuntu--vg-root   252:0    0 18.5G  0 lvm  /
		└─ubuntu--vg-swap_1 252:1    0    1G  0 lvm  [SWAP]
	vdb                   253:16   0   15G  0 disk
	vdc                   253:32   0   15G  0 disk
	```
	
- Thực hiện cài đặt trên cả 2 node các bước sau.
#### 1. Cài đặt các gói hỗ trợ.
- Cài đặt các gói hỗ trợ.

	```sh
	apt-get install xfsprogs rsync -y
	```
	
- Định dạng /dev/vdb và /dev/vdc theo XFS

	```sh
	mkfs.xfs /dev/vdb
	mkfs.xfs /dev/vdc
	```
	
- Tạo thư mục để mount.

	```sh
	mkdir -p /srv/node/vdb
	mkdir -p /srv/node/vdc
	```
	
-	Sửa file /etc/fstab, thêm các dòng sau.

	```sh
	/dev/vdb /srv/node/vdb xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
	/dev/vdc /srv/node/vdc xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
	```
	
- Mount

	```sh
	mount /srv/node/vdb
	mount /srv/node/vdc
	```
	
- Tạo file mới có tên là `/etc/rsyncd.conf` với nội dung sau

	```sh
	uid = swift
	gid = swift
	log file = /var/log/rsyncd.log
	pid file = /var/run/rsyncd.pid
	address = MANAGEMENT_INTERFACE_IP_ADDRESS

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
	```
	
	- Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.193
	- Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.194

- Sửa file /etc/default/rsync và bật dịch vụ rsync.
	
	```sh
	RSYNC_ENABLE=true
	```
	
- Bật dịch vụ rsync

	```sh
	service rsync start
	```

#### 2. Cài đặt và cấu hình các thành phần
- Cài đặt các gói

	```sh
	apt-get install swift swift-account swift-container swift-object -y
	```
	
- Lấy files cấu hình accounting, container, object service từ kho Object storage.
	
	```sh
	curl -o /etc/swift/account-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/account-server.conf-sample?h=stable/newton
	curl -o /etc/swift/container-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/container-server.conf-sample?h=stable/newton
	curl -o /etc/swift/object-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/object-server.conf-sample?h=stable/newton
	```
	
- Sửa file /etc/swift/account-server.conf.
Trong [DEFAULT] section, cấu hình địa chỉ bind IP, bind port, user, cấu hình directory, và mount point directory:

	```sh
	[DEFAULT]
	#...
	bind_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
	bind_port = 6202
	user = swift
	swift_dir = /etc/swift
	devices = /srv/node
	mount_check = True
	```
	
	- Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.193
	- Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.194
	
- Trong [pipeline:main] section, enable các modules phù hợp

	```sh
	[pipeline:main]
	pipeline = healthcheck recon account-server
	```

- Trong [filter:recon] section, cấu hình như sau:
	
	```sh
	[filter:recon]
	use = egg:swift#recon
	#...
	recon_cache_path = /var/cache/swift
	```
	
- Sửa file /etc/swift/container-server.conf.
- Trong [DEFAULT] section, cấu hình bind IP address, bind port, user, cấu hình directory, và mount point directory:


	```sh
	[DEFAULT]
	# ...
	bind_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
	bind_port = 6201
	user = swift
	swift_dir = /etc/swift
	devices = /srv/node
	mount_check = True
	```
	
	- Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.193
	- Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.194
	
- Trong [pipeline:main] section, enable các modules phù hợp:

	```sh
	[pipeline:main]
	pipeline = healthcheck recon container-server
	```
	
- Trong [filter:recon] section, cấu hình như sau:

	```sh
	[filter:recon]
	use = egg:swift#recon
	#...
	recon_cache_path = /var/cache/swift
	```
	
- Sửa file /etc/swift/object-server.conf
- Trong [DEFAULT] section, cấu hình bind IP address, bind port, user, cấu hình directory, và mount point directory:

	```sh
	[DEFAULT]
	# ...
	bind_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
	bind_port = 6200
	user = swift
	swift_dir = /etc/swift
	devices = /srv/node
	mount_check = True
	```
	
	- Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.193
	- Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ 10.10.10.194

- Trong [pipeline:main] section, enable các modules phù hợp:

	```sh
	[pipeline:main]
	pipeline = healthcheck recon object-server
	```
	
- Trong [filter:recon] section, cấu hình như sau:

	```sh
	[filter:recon]
	use = egg:swift#recon
	#...
	recon_cache_path = /var/cache/swift
	recon_lock_path = /var/lock
	```
	
- Phân quyền thư mục

	```sh
	chown -R swift:swift /srv/node
	```
	
- Tạo thư mục recon và phân quyền cho nó

	```sh
	mkdir -p /var/cache/swift
	chown -R root:swift /var/cache/swift
	chmod -R 775 /var/cache/swift
	```	
	
#### IV. Tạo và phân phối các rings ban đầu.
- Bước này thực hiện trên node controller
#### 1. Tạo account ring
- đến thư mục /etc/swift

	```sh
	cd /etc/swift
	```
	
- Tạo file account.builder

	```sh
	swift-ring-builder account.builder create 10 3 1
	```
	
- Thêm mỗi node đến ring

	```sh
	swift-ring-builder account.builder add \
	--region 1 --zone 1 --ip 10.10.10.193 --port 6202 --device vdb --weight 15

	swift-ring-builder account.builder add \
	--region 1 --zone 1 --ip 10.10.10.193 --port 6202 --device vdc --weight 15

	swift-ring-builder account.builder add \
	--region 1 --zone 1 --ip 10.10.10.194 --port 6202 --device vdb --weight 15

	swift-ring-builder account.builder add \
	--region 1 --zone 1 --ip 10.10.10.194 --port 6202 --device vdc --weight 15
	```
	
- Kiểm tra lại nội dung của ring

	```sh
	/etc/swift# swift-ring-builder account.builder
	account.builder, build version 4
	1024 partitions, 3.000000 replicas, 1 regions, 1 zones, 4 devices, 100.00 balance, 0.00 dispersion
	The minimum number of hours before a partition can be reassigned is 1 (0:00:00 remaining)
	The overload factor is 0.00% (0.000000)
	Ring file account.ring.gz not found, probably it hasn't been written yet
	Devices:   id region zone   ip address:port replication ip:port  name weight partitions balance flags meta
							0      1    1 10.10.10.193:6202   10.10.10.193:6202   vdb  15.00          0 -100.00
							1      1    1 10.10.10.193:6202   10.10.10.193:6202   vdc  15.00          0 -100.00
							2      1    1 10.10.10.194:6202   10.10.10.194:6202   vdc  15.00          0 -100.00
							3      1    1 10.10.10.194:6202   10.10.10.194:6202   vdb  15.00          0 -100.00
	```

- Tái cân bằng ring

	```sh
	/etc/swift# swift-ring-builder account.builder rebalance
	Reassigned 3072 (300.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
	```
	
### 2. Tạo container ring
- 1. đến thư mục `/etc/swift`

  ```sh
  cd /etc/swift
  ```
  
- 2. tạo file `container.builder`

  ```sh
  swift-ring-builder container.builder create 10 3 1
  ```
  
- 3. thêm mỗi node đến ring

  ```sh
  swift-ring-builder container.builder add \
  --region 1 --zone 1 --ip 10.10.10.193 --port 6201 --device vdb --weight 15

  swift-ring-builder container.builder add \
  --region 1 --zone 1 --ip 10.10.10.193 --port 6201 --device vdc --weight 15

  swift-ring-builder container.builder add \
  --region 1 --zone 1 --ip 10.10.10.194 --port 6201 --device vdb --weight 15

  swift-ring-builder container.builder add \
  --region 1 --zone 1 --ip 10.10.10.194 --port 6201 --device vdc --weight 15

- 4. Kiểm tra lại nội dung của ring

  ```sh
  /etc/swift# swift-ring-builder container.builder
  container.builder, build version 4
  1024 partitions, 3.000000 replicas, 1 regions, 1 zones, 4 devices, 100.00 balance, 0.00 dispersion
  The minimum number of hours before a partition can be reassigned is 1 (0:00:00 remaining)
  The overload factor is 0.00% (0.000000)
  Ring file container.ring.gz not found, probably it hasn't been written yet
  Devices:   id region zone   ip address:port replication ip:port  name weight partitions balance flags meta
              0      1    1 10.10.10.193:6201   10.10.10.193:6201   vdb  15.00          0 -100.00
              1      1    1 10.10.10.193:6201   10.10.10.193:6201   vdc  15.00          0 -100.00
              2      1    1 10.10.10.194:6201   10.10.10.194:6201   vdb  15.00          0 -100.00
              3      1    1 10.10.10.194:6201   10.10.10.194:6201   vdc  15.00          0 -100.00
  ```
  
- 5. Tái cân bằng ring

  ```sh
  /etc/swift# swift-ring-builder container.builder rebalance
  Reassigned 3072 (300.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
  ```
  
### 3. Tạo object ring
- 1. đến thư mục `/etc/swift`

  ```sh
  cd /etc/swift
  ```
  
- 2. Tạo file `object.builder`

  ```sh
  swift-ring-builder object.builder create 10 3 1
  ```
  
- 3. thêm mỗi node đến ring

  ```sh
  swift-ring-builder object.builder add \
  --region 1 --zone 1 --ip 10.10.10.193 --port 6200 --device vdb --weight 15
  
  swift-ring-builder object.builder add \
  --region 1 --zone 1 --ip 10.10.10.193 --port 6200 --device vdc --weight 15
  
  swift-ring-builder object.builder add \
  --region 1 --zone 1 --ip 10.10.10.194 --port 6200 --device vdb --weight 15
  
  swift-ring-builder object.builder add \
  --region 1 --zone 1 --ip 10.10.10.194 --port 6200 --device vdc --weight 15
  ```

- 4. Kiểm tra lại nội dung của ring

  ```sh
  /etc/swift# swift-ring-builder object.builder
  object.builder, build version 4
  1024 partitions, 3.000000 replicas, 1 regions, 1 zones, 4 devices, 100.00 balance, 0.00 dispersion
  The minimum number of hours before a partition can be reassigned is 1 (0:00:00 remaining)
  The overload factor is 0.00% (0.000000)
  Ring file object.ring.gz not found, probably it hasn't been written yet
  Devices:   id region zone   ip address:port replication ip:port  name weight partitions balance flags meta
              0      1    1 10.10.10.193:6200   10.10.10.193:6200   vdb  15.00          0 -100.00
              1      1    1 10.10.10.193:6200   10.10.10.193:6200   vdc  15.00          0 -100.00
              2      1    1 10.10.10.194:6200   10.10.10.194:6200   vdb  15.00          0 -100.00
              3      1    1 10.10.10.194:6200   10.10.10.194:6200   vdc  15.00          0 -100.00
  ```
  
- 5. Tái cân bằng ring

  ```sh
  /etc/swift# swift-ring-builder object.builder rebalance
  Reassigned 3072 (300.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
  ```
  
### 4. Copy các file `account.ring.gz, container.ring.gz, and object.ring.gz` đến thư mục `/etc/swift` trên mỗi node object storage
- Sử dụng lệnh scp để đẩy các file này đến mỗi node Object storage

  ```sh
  scp /etc/swift/account.ring.gz /etc/swift/container.ring.gz /etc/swift/object.ring.gz root@172.16.69.193:/etc/swift
  scp /etc/swift/account.ring.gz /etc/swift/container.ring.gz /etc/swift/object.ring.gz root@172.16.69.194:/etc/swift
  ```

## V. Hoàn thành cài đặt
- Thực hiện trên node controller
- 1. Lấy file `/etc/swift/swift.conf` từ kho lưu trữ Object storage

  ```sh
  curl -o /etc/swift/swift.conf \
  https://git.openstack.org/cgit/openstack/swift/plain/etc/swift.conf-sample?h=stable/newton
  ```
  
- 2. Sửa file `/etc/swift/swift.conf`
- Trong `[swift-hash]` section.

  ```sh
  [swift-hash]
  ...
  swift_hash_path_suffix = HASH_PATH_SUFFIX
  swift_hash_path_prefix = HASH_PATH_PREFIX
  ```
  
  - Thay HASH_PATH_PREFIX and HASH_PATH_SUFFIX với giá trị duy nhất.
  
- Trong `[storage-policy:0]` section, cấu hình chính sách storage mặc định

  ```sh
  [storage-policy:0]
  ...
  name = Policy-0
  default = yes
  ```
  
- 3. copy file `swift.conf` đến thư mục `/etc/swift` trên tất cả các node Object storage

  ```sh
  scp /etc/swift/swift.conf root@172.16.69.193:/etc/swift/
  
  scp /etc/swift/swift.conf root@172.16.69.194:/etc/swift/
  ```
  
- 4. Thực hiện lệnh sau trên các node controller và 2 node Object storage

  ```sh
  chown -R root:swift /etc/swift
  ```
  
- 5. Restart các dịch vụ trên controller

  ```sh
  service memcached restart
  service swift-proxy restart
  ```
  
#### Start dịch vụ Object storage
- thực hiện trên node Object storage

  ```sh
  swift-init all start
  ```
  
## Kiểm tra lại các bước cài đặt
- Khai cáo cridentials cho user demo:

  ```sh
  source demo-openrc
  ```
  
- Xem trạng thái dịch vụ

  ```sh
  ~# swift stat
                 Account: AUTH_b54646bf669746db8c62ec0410bd0528
              Containers: 0
                 Objects: 0
                   Bytes: 0
         X-Put-Timestamp: 1502470995.64351
             X-Timestamp: 1502470995.64351
              X-Trans-Id: txa09f5c3dd9494bf6aa0a3-00598de350
            Content-Type: text/plain; charset=utf-8
  X-Openstack-Request-Id: txa09f5c3dd9494bf6aa0a3-00598de350
  ```
  
- Tạo `container1` container

  ```sh
  ~# openstack container create container1
  +--------------------------------+------------+--------------------------------+
  | account                        | container  | x-trans-id                     |
  +--------------------------------+------------+--------------------------------+
  | AUTH_b54646bf669746db8c62ec041 | container1 | tx38e4667d3e6b49a087cc5-00598d |
  | 0bd0528                        |            | f2ec                           |
  +--------------------------------+------------+--------------------------------+
  ```
  
- upload `file1` để test

  ```sh
  root@controller:~# touch file1
    
  root@controller:~# openstack object create container1 file1
  +--------+------------+----------------------------------+
  | object | container  | etag                             |
  +--------+------------+----------------------------------+
  | file1  | container1 | d41d8cd98f00b204e9800998ecf8427e |
  +--------+------------+----------------------------------+
  ```
  
- List các file trong container1

  ```sh
  ~# openstack object list container1
  +-------+
  | Name  |
  +-------+
  | file1 |
  +-------+
  ```
  
---
# Kết thúc cài đặt