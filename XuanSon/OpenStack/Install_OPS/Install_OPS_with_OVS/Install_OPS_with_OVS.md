# Cài OpenStack với OpenvSwitch



# MỤC LỤC
- [1.Mô hình](#1)
- [2.IP Planning](#2)
- [3.Cài đặt](#3)
	- [3.1.Environment](#3.1)
		- [3.1.1.Cấu hình mạng cho các nodes](#3.1.1)
		- [3.1.2.Network Time Protocol](#3.1.2)
		- [3.1.3.OpenStack packages](#3.1.3)
		- [3.1.4.SQL database](#3.1.4)
		- [3.1.5.Message queue](#3.1.5)
		- [3.1.6.Memcached](#3.1.6)
	- [3.2.Identity service](#3.2)
	- [3.3.Image service](#3.3)
	- [3.4.Compute service](#3.4)
		- [3.4.1.Cài đặt và cấu hình trên node Controller](#3.4.1)
		- [3.4.2.Cài đặt và cấu hình trên node Compute1](#3.4.2)
		- [3.4.3.Kiểm tra](#3.4.3)
	- [3.5.Networking service](#3.5)
		- [3.5.1.Cài đặt và cấu hình trên node Controller](#3.5.1)
		- [3.5.2.Cài đặt và cấu hình trên node Compute1](#3.5.2)
- [Tài liệu tham khảo](#tailieuthamkhao)




<a name="1"></a>

# 1.Mô hình
Mô hình cài đặt OpenStack Ocata gồm 2 node: Controller và Compute.

<img src="images/mo_hinh.png" />

<a name="2"></a>

# 2.IP Planning
Yêu cầu phần cứng và địa chỉ IP cho các nodes.

<img src="images/ip_planning.png" />

<a name="3"></a>

# 3.Cài đặt
\- Chú ý:  
- Các nodes dùng hệ điều hành Ubuntu Server 16.04.
- Tất cả các bước thực hiện dưới quyền người dùng root.
- Password thống nhất cho tất cả các dịch vụ là `Welcome123`.

<a name="3.1"></a>

## 3.1.Environment
<a name="3.1.1"></a>

### 3.1.1.Cấu hình mạng cho các nodes
#### Controller
\- Sửa file `/etc/networking/interfaces` đến nội dung sau:  
```
auto lo
iface lo inet loopback

auto ens3
iface ens3 inet static
address 192.168.2.71/24
gateway 192.168.2.1
dns-nameservers 8.8.8.8

auto ens4
iface ens4 inet static
address 10.10.10.71/24
```

\- Thiết lập hostname cho node **controller**.  
Sửa file `/etc/hostname` đến nội dụng sau:  
```
controller
```

\- Sửa file `/etc/hosts` đến nội dung sau:  
```
127.0.0.1       localhost

# controller
10.10.10.71       controller

# compute1
10.10.10.72       compute1

# block1
10.10.10.73       block1
```

\- Reboot lại hệ thống.  

#### Compute1
\- Sửa file `/etc/networking/interfaces` đến nội dung sau:  
```
auto lo
iface lo inet loopback

auto ens3
iface ens3 inet static
address 192.168.2.72/24
gateway 192.168.2.1
dns-nameservers 8.8.8.8

auto ens4
iface ens4 inet static
address 10.10.10.72/24
```

\- Thiết lập hostname cho node **compute1**.  
Sửa file `/etc/hostname` đến nội dụng sau:  
```
compute1
```

\- Sửa file `/etc/hosts` đến nội dung sau:  
```
127.0.0.1       localhost

# controller
10.10.10.71       controller

# compute1
10.10.10.72       compute1

# block1
10.10.10.73       block1
```

\- Reboot lại hệ thống.  

#### Kiểm tra kết nối
\- Từ Controller, kiểm tra truy cập Internet.  
```
root@controller:~# ping -c 4 openstack.org
PING openstack.org (162.242.140.107) 56(84) bytes of data.
64 bytes from 162.242.140.107: icmp_seq=1 ttl=46 time=204 ms
64 bytes from 162.242.140.107: icmp_seq=2 ttl=46 time=203 ms
64 bytes from 162.242.140.107: icmp_seq=3 ttl=46 time=203 ms
64 bytes from 162.242.140.107: icmp_seq=4 ttl=46 time=203 ms

--- openstack.org ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 203.701/203.989/204.514/0.636 ms
```

\- Từ Controller, kiểm tra truy cập đến management interface trên node Compute.  
```
root@controller:~# ping -c 4 compute1
PING compute1 (10.10.10.72) 56(84) bytes of data.
64 bytes from compute1 (10.10.10.72): icmp_seq=1 ttl=64 time=0.884 ms
64 bytes from compute1 (10.10.10.72): icmp_seq=2 ttl=64 time=0.543 ms
64 bytes from compute1 (10.10.10.72): icmp_seq=3 ttl=64 time=0.587 ms
64 bytes from compute1 (10.10.10.72): icmp_seq=4 ttl=64 time=0.516 ms

--- compute1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3001ms
rtt min/avg/max/mdev = 0.516/0.632/0.884/0.149 ms
```

\- Từ Compute1, kiểm tra truy cập Internet.  
```
root@compute1:~# ping -c 4 openstack.org
PING openstack.org (162.242.140.107) 56(84) bytes of data.
64 bytes from 162.242.140.107: icmp_seq=1 ttl=46 time=204 ms
64 bytes from 162.242.140.107: icmp_seq=2 ttl=46 time=204 ms
64 bytes from 162.242.140.107: icmp_seq=3 ttl=46 time=203 ms
64 bytes from 162.242.140.107: icmp_seq=4 ttl=46 time=203 ms

--- openstack.org ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3002ms
rtt min/avg/max/mdev = 203.619/203.982/204.296/0.400 ms
```

\- Từ Compute1, kiểm tra truy cập đến management interface trên node Controller.  
```
root@compute1:~# ping -c 4 controller
PING controller (10.10.10.71) 56(84) bytes of data.
64 bytes from controller (10.10.10.71): icmp_seq=1 ttl=64 time=0.640 ms
64 bytes from controller (10.10.10.71): icmp_seq=2 ttl=64 time=0.643 ms
64 bytes from controller (10.10.10.71): icmp_seq=3 ttl=64 time=0.518 ms
64 bytes from controller (10.10.10.71): icmp_seq=4 ttl=64 time=0.823 ms

--- controller ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3000ms
rtt min/avg/max/mdev = 0.518/0.656/0.823/0.108 ms
```

<a name="3.1.2"></a>

### 3.1.2.Network Time Protocol
#### Controller
\- Cài package:  
```
apt install chrony
```

\- Sửa file `/etc/chrony/chrony.conf` và comment, xóa tất cả các dòng có chứa `server` và thay bằng các dòng sau:  
```
server 0.asia.pool.ntp.org iburst
server 1.asia.pool.ntp.org iburst
server 2.asia.pool.ntp.org iburst
```

\- Cho phép các nodes kết nối đến chrony daemon trên node controller, thêm dòng sau vào cuối file `/etc/chrony/chrony.conf`:  
```
allow 10.10.10.0/24
```

\- Restart dịch vụ NTP:  
```
service chrony restart
```

#### Compute1
\- Cài package:  
```
apt install chrony
```

\- Sửa file `/etc/chrony/chrony.conf` và comment, xóa tất cả các dòng có chứa `server` và thay bằng các dòng sau:  
```
server controller iburst
```

\- Restart dịch vụ NTP:  
```
service chrony restart
```

#### Kiểm tra
\- Chạy lệnh sau trên node controller:  
```
root@controller:~# chronyc sources
210 Number of sources = 3
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^- time.iqnet.com                2  10   377   408  +2887us[+2887us] +/-  195ms
^+ ntp.nic.kz                    1  10   377   320    -17ms[  -17ms] +/-  126ms
^* sin.wrtpoona.in               2  10   377   926  +9362us[+9871us] +/-  180ms
```

\- Chạy lệnh sau trên node compute1:  
```
root@compute1:~# chronyc sources
210 Number of sources = 1
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* controller                    3   7   377    63    -54us[  -72us] +/-   59ms
```

<a name="3.1.3"></a>

### 3.1.3.OpenStack packages
\- Cài OpenStack packages trên tất cả các nodes.  
\- Kích hoạt OpenStack repository  
```
apt install software-properties-common
add-apt-repository cloud-archive:ocata
```

\- Update và upgrade:  
```
# apt update && apt dist-upgrade
```

\- Cài OpenStack client:  
```
apt install python-openstackclient
```

<a name="3.1.4"></a>

### 3.1.4.SQL database
\- Cài MySQL trên node Controller.  
\- Cài đặt packages:  
```
apt install mariadb-server python-pymysql
```

\- Tạo và sửa file `/etc/mysql/mariadb.conf.d/99-openstack.cnf` theo nội dung sau:  
```
[mysqld]
bind-address = 10.10.10.71

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
```

Trong đó `bind-address` là địa chỉ management IP của node controller.  

\- Restart lại database service:  
```
service mysql restart
```

<a name="3.1.5"></a>

### 3.1.5.Message queue
\- Cài đặt **Message queue** trên node Controller. Ở đây dùng **RabbitMQ**.  
\- Cài đặt package:  
```
apt install rabbitmq-server
```

\- Thêm user `openstack` với mật khẩu `Welcome123`:  
```
rabbitmqctl add_user openstack Welcome123
```

\- Cho phép user `openstack` có quyền ghi và đọc:  
```
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
```

<a name="3.1.6"></a>

### 3.1.6.Memcached
\- Cài đặt **Memcached** trên node Controller.  
\- Cài đặt package:  
```
apt install memcached python-memcache
```

\- Sửa fuke `/etc/memcached.conf` và cấu hình service sử dụng địa chỉ management IP của node controller.  
```
-l 10.10.10.71
```

\- Restart Memcached service:  
```
service memcached restart
```

<a name="3.2"></a>

## 3.2.Identity service
\- Cài dịch vụ Identity (Keystone) trên node Controller. Cấu hình triển khai token Fernet và Apache HTTP server để xử lý request.  
\- Taọ database:  
- Sử dụng database client để kết nối đến database server như user `root`:  
```
mysql
```

- Tạo database `keystone`:  
```
CREATE DATABASE keystone;
```

- Gán quyến truy cập đến database `keystone`:  
```
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'Welcome123';
```

- Thoát database client:  
```
quit
```

\- Cài đặt và cấu hình các thành phần:  
- Cài packages:  
```
apt install keystone
```

- Sửa file `/etc/keystone/keystone.conf` và thực hiện các hành động sau:  
  - Trong section `[database], cấu hình truy cập database:  
    ```
    [database]
    # ...
    connection = mysql+pymysql://keystone:Welcome123@controller/keystone
    ```

  - Trong section `[token`], caasu hinhf Fernet token provider:  
    ```
    [token]
    # ...
    provider = fernet
    ```

- Sinh database cho Identity service:  
```
su -s /bin/sh -c "keystone-manage db_sync" keystone
```

- Khởi tạo kho Fernet key:  
```
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

- Bootstrap Identity service:  
```
keystone-manage bootstrap --bootstrap-password Welcome123 \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
```

\- Cấu hình Apache HTTP server  
- Sửa file `/etc/apache2/apache2.conf` và cấu hình tùy `ServerName` option để tham chiếu đến node controller:  
```
ServerName controller
```

\- Kết thúc cài đặt  
- Restart Apache service và xóa default SQLite database:  
```
service apache2 restart
rm -f /var/lib/keystone/keystone.db
```

- Thiết lập biến môi trường cho account admin:  
```
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
```

\- Tạo scripts cho việc thiết lập biến môi trường  
- Tạo file `admin-openrc` với nội dung như sau:  
```
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

- Tạo file `demo-openrc` với nội dung như sau:  
```
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

\- Sử dụng scripts:  
- Chạy file `admin-openrc`:  
```
. admin-openrc
```

- Thực hiện lệnh sau để lấy token:  
```
openstack token issue
root@controller:~# openstack token issue
+------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                              |
+------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2017-08-18T10:17:23+0000                                                                                                                           |
| id         | gAAAAABZlrCjsPgV1LcR5BwSsG2PXr3ho5jMpn5YgHH9mk2mjcNI_Rlp85_TMjv00do3tBn27qWi7zk7h6iLpW1zGZeJxfhMx-5EJWru-                                          |
|            | Uxlb10-eXy4PyXUsSmbhPlG6vmQLqnAnvDRQBfvn1Lps2bjxCCBcbN3VwV3xXqErn7_Am3jHuEBsxY                                                                     |
| project_id | ab61083f314a4872ab85abd6e07ae84b                                                                                                                   |
| user_id    | 7cd46e5a740241c29a4b4c02025d9a1d                                                                                                                   |
+------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
```

<a name="3.3"></a>

## 3.3.Image service
\- Cài dịch vụ Image (Glance) trên node Controller. Cấu hình lưu trữ image bằng local file system.  
\- Taọ database:  
- Sử dụng database client để kết nối đến database server như user `root`:  
```
mysql
```

- Tạo database `glance`:  
```
CREATE DATABASE glance;
```

- Gán quyến truy cập đến database `glance`:  
```
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
IDENTIFIED BY 'Welcome123';
```

- Thoát database client:  
```
quit
```

\- Thiết lập biến môi trường cho user `admin`:  
```
. admin-openrc
```

\- Tạo service glance:  
- Tạo user glance:  
```
root@controller:~# openstack user create --domain default --password-prompt glance

User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | 8dad4d6bd8f64f489991ab7d8761d8bb |
| name                | glance                           |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```

- Thêm role `admin` đến user `glance` và project `service`:  
```
openstack role add --project service --user glance admin
```

- Tạo service `glance`:  
```
root@controller:~# openstack service create --name glance \
  --description "OpenStack Image" image

+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Image                  |
| enabled     | True                             |
| id          | 0ef6b1771b42488f980179727801c88c |
| name        | glance                           |
| type        | image                            |
+-------------+----------------------------------+
```

\- Tạo Image service API endpoints:  
```
root@controller:~# openstack endpoint create --region RegionOne \
  image public http://controller:9292  

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 57d1cd0e0fed46a180420d9d262db47f |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 0ef6b1771b42488f980179727801c88c |
| service_name | glance                           |
| service_type | image                            |
| url          | http://controller:9292           |
+--------------+----------------------------------+


root@controller:~# openstack endpoint create --region RegionOne \
  image internal http://controller:9292

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | b08c200fbac6491487bf4a975aced2a8 |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 0ef6b1771b42488f980179727801c88c |
| service_name | glance                           |
| service_type | image                            |
| url          | http://controller:9292           |
+--------------+----------------------------------+


root@controller:~# openstack endpoint create --region RegionOne \
  image admin http://controller:9292

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 67d11470a29548f4b9c01ac0116748d7 |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 0ef6b1771b42488f980179727801c88c |
| service_name | glance                           |
| service_type | image                            |
| url          | http://controller:9292           |
+--------------+----------------------------------+
```

\- Cài đặt và cấu hình các thành phần:  
- Cài đặt packages:  
```
apt install glance
```

- Sửa file `/etc/glance/glance-api.conf`:  
  - Trong section `[database]`, cấu hình truy cập database:  
  ```
  [database]
    # ...
    connection = mysql+pymysql://glance:Welcome123@controller/glance
  ```

  - Trong section `[keystone_authtoken]` và `[paste_deploy]`, cấu hình truy cập Identity service:  
  ```
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

  - Trong section `[glance_store]`, cấu hình lưu trữ local file system và vị trí của file image:  
  ```
  [glance_store]
  # ...
  stores = file,http
  default_store = file
  filesystem_store_datadir = /var/lib/glance/images/
  ```

- Sửa file `/etc/glance/glance-registry.conf`:  
  - Trong section `[database]`, cấu hình truy cập database:  
  ```
  [database]
  # ...
  connection = mysql+pymysql://glance:Welcome123@controller/glance
  ```

  - Trong sections `[keystone_authtoken]` và `[paste_deploy]`, cấu hình truy cập Identity service:  
  ```
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

- Sinh database cho Image service:  
```
su -s /bin/sh -c "glance-manage db_sync" glance
```

\- Kết thúc cài đặt  
- Restart Image service:  
```
service glance-api restart
service glance-registry restart
```

\- Tạo image cirros  
- Thiết lập biến môi trường cho user `admin`  
```
. admin-openrc
```

- Download source image:  
```
wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
```

- Upload image đến Image service:  
```
openstack image create "cirros" \
  --file cirros-0.3.5-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public
```

- Kiểm tra image vừa được upload:  
```
openstack image list
```

<a name="3.4"></a>

## 3.4.Compute service
<a name="3.4.1"></a>

### 3.4.1.Cài đặt và cấu hình trên node Controller
\- Taọ database:  
- Sử dụng database client để kết nối đến database server như user `root`:  
```
mysql
```

- Tạo database `nova_api`, `nova` và `nova_cell0`:  
```
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
```

- Gán quyến truy cập:  
```
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';
```

- Thoát database client:  
```
quit
```

\- Thiết lập biến môi trường cho user `admin`:  
```
. admin-openrc
```

\- Tạo Compute service:  
- Tạo user `nova`:  
```
root@controller:~# openstack user create --domain default --password-prompt nova

User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | 7de1e0375dbe4892992113505e6df644 |
| name                | nova                             |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```

- Thêm role `admin` đến user `nova`:  
```
openstack role add --project service --user nova admin
```

- Tạo service `nova`:  
```
root@controller:~# openstack service create --name nova \
  --description "OpenStack Compute" compute

+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Compute                |
| enabled     | True                             |
| id          | c22c1b3575f94497a505280abad5eaba |
| name        | nova                             |
| type        | compute                          |
+-------------+----------------------------------+
```

\- Tạo endpoint cho Compute API service:  
```
root@controller:~# openstack endpoint create --region RegionOne \
compute public http://controller:8774/v2.1

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | e034243228804911bf281dd2fa22bc7c |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | c22c1b3575f94497a505280abad5eaba |
| service_name | nova                             |
| service_type | compute                          |
| url          | http://controller:8774/v2.1      |
+--------------+----------------------------------+


root@controller:~# openstack endpoint create --region RegionOne \
compute internal http://controller:8774/v2.1

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 8bd8710918f84461a45e48fad45fbe69 |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | c22c1b3575f94497a505280abad5eaba |
| service_name | nova                             |
| service_type | compute                          |
| url          | http://controller:8774/v2.1      |
+--------------+----------------------------------+


root@controller:~# openstack endpoint create --region RegionOne \
compute admin http://controller:8774/v2.1

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 1acbc55b162e489586f79da2ebe0ea1d |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | c22c1b3575f94497a505280abad5eaba |
| service_name | nova                             |
| service_type | compute                          |
| url          | http://controller:8774/v2.1      |
+--------------+----------------------------------+
```

\- Tạo user cho Placement service:  
```
root@controller:~# openstack user create --domain default --password-prompt placement

User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | 957cad276e204d2f98ccde94a78b8be1 |
| name                | placement                        |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```

\- Thêm `Placement` user đến project `service` với quyền role `admin`:  
```
openstack role add --project service --user placement admin
```

\- Tạo Placement API service:  
```
root@controller:~# openstack service create --name placement --description "Placement API" placement
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Placement API                    |
| enabled     | True                             |
| id          | 7e436f3c9a6b49b38e5930177f5c3a23 |
| name        | placement                        |
| type        | placement                        |
+-------------+----------------------------------+
```

\- Tạo Placement API service endpoints:  
```
root@controller:~# openstack endpoint create --region RegionOne placement public http://controller:8778
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | d0fda606c1c9454c9d4ee3a17ce40538 |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 7e436f3c9a6b49b38e5930177f5c3a23 |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+

root@controller:~# openstack endpoint create --region RegionOne placement internal http://controller:8778
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | ae8b2866e1fb451bae8db8356bf4becc |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 7e436f3c9a6b49b38e5930177f5c3a23 |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+

root@controller:~# openstack endpoint create --region RegionOne placement admin http://controller:8778
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | ba95a6dff4f440febd8742dd90d95c2b |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 7e436f3c9a6b49b38e5930177f5c3a23 |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+
```

\- Cài đặt và cấu hình các thành phần:  
- Cài packages:  
```
apt install nova-api nova-conductor nova-consoleauth \
  nova-novncproxy nova-scheduler nova-placement-api
```

- Sửa file `/etc/nova/nova.conf` và hoàn thành các hành động sau:  
  - Trong section `[api_database]` và `[database]`, cấu hình truy cập database:  
  ```
  [api_database]
  # ...
  connection = mysql+pymysql://nova:Welcome123@controller/nova_api
  
  [database]
  # ...
  connection = mysql+pymysql://nova:Welcome123@controller/nova
  ```

  - Trong section `[DEFAULT]`, cấu hình truy cập `RabbitMQ` message queue:  
  ```
  [DEFAULT]
  # ...
  transport_url = rabbit://openstack:Welcome123@controller
  ```

  - Trong section `[api]` và `[keystone_authtoken]`, cấu hình truy cập Identity service:  
  ```
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

  - Trong section `[DEFAULT]`, cấu hình `my_ip` option để sử dụng địa chỉ management interface IP của node controller:  
  ```
  [DEFAULT]
  # ...
  my_ip = 10.0.0.11
  ```

  - Trong section `[DEFAULT]`, cho phép hỗ trợ Networking service:  
  ```
  [DEFAULT]
  # ...
  use_neutron = True
  firewall_driver = nova.virt.firewall.NoopFirewallDriver
  ```

  - Trong section `[vnc]`, cấu hình VNC proxy để dụng địa chỉ management interface IP của node controller:  
  ```
  [vnc]
  enabled = true
  # ...
  vncserver_listen = $my_ip
  vncserver_proxyclient_address = $my_ip
  ```

  - Trong section `[glance]`, cấu hình vị trí của Image service API:  
  ```
  [glance]
  # ...
  api_servers = http://controller:9292
  ```

  - Trong section `[oslo_concurrency]`, cấu hình lock path:  
  ```
  [oslo_concurrency]
  # ...
  lock_path = /var/lib/nova/tmp
  ```

  - Xóa `log_dir` option từ section `DEFAULT`.  
  - Trong section `[placement]`, cấu hình Placement API:  
  ```
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

\- Sinh database `nova-api`:  
```
su -s /bin/sh -c "nova-manage api_db sync" nova
```

\- Đăng kí database `cell0`:  
```
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
```

\- Tạo cell `cell1`:  
```
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
```

\- Sinh database `nova`:  
```
su -s /bin/sh -c "nova-manage db sync" nova
```

\- Kiểm tra nova cell0 và cell1 đã được đăng ký:  
```
root@controller:~# nova-manage cell_v2 list_cells
+-------+--------------------------------------+
|  Name |                 UUID                 |
+-------+--------------------------------------+
| cell0 | 00000000-0000-0000-0000-000000000000 |
| cell1 | 68457ec9-57cb-48a4-9fab-e2b97f9091ce |
+-------+--------------------------------------+
```

\- Kết thúc cài đặt:  
- Restart Compute services:  
```
service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
```

<a name="3.4.2"></a>

### 3.4.2.Cài đặt và cấu hình trên node Compute1
\- Cài packages:  
```
apt install nova-compute
```

\- Sửa file `/etc/nova/nova.conf` và hoàn thành các thực hiện sau:  
- Trong section `[DEFAULT]`, cấu hình truy cập `RabbitMQ` message queue:  
```
[DEFAULT]
# ...
transport_url = rabbit://openstack:Welcome123@controller
```

- Trong section `[api]` và `[keystone_authtoken]`, cấu hình truy cập Identity service:  
```
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

- Trong section `[DEFAULT]`, cấu hình `my_ip` option:  
```
[DEFAULT]
# ...
my_ip = 10.10.10.62
```

trong đó `10.10.10.62` là địa chỉ IP của management interface trên node compute.  

- Trong section `[DEFAULT]`, cho phép hỗ trợ Networking service:  
```
[DEFAULT]
# ...
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
```

- Trong section `[vnc]`, kích hoạt và cấu hình truy cập remote console:  
```
vnc]
# ...
enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html
```

- Trong section `[glance], cấu hình vị trí của Image service API:  
```
[glance]
# ...
api_servers = http://controller:9292
```

- Trong section `[oslo_concurrency]`, cấu hình lock path:  
```
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp
```

- Xóa `log_dir` option từ section `DEFAULT`.  
- Trong section `[placement]`, cấu hình Placement API:  
```
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

\- Kết thúc cài đặt:  
- Kiểm tra node compute có hỗ trợ **hardware acceleration** cho virtual machines hay không:  
```
egrep -c '(vmx|svm)' /proc/cpuinfo
```

Nếu command return giá trị bằng > 0, node compute của bạn có hỗ trợ **hardware acceleration**, bạn không cần cấu hình gì thêm.  
Nếu command return giá trị bằng 0, node compute cảu bạn không hỗ trợ **hardware acceleration** và bạn phải cấu hình section `[libvirt]` để sử dụng QEMU thay vì KVM.  
  - Sửa section `[libvirt]` trong file `/etc/nova/nova-compute.conf` như sau:  
  ```
  [libvirt]
  # ...
  virt_type = qemu
  ```

- Restart Compute service:  
```
service nova-compute restart
```

\- Thêm node compute đến database cell  
>Chạy các command sau trên node controller

- Xác thực compute hosts trong database:  
```
root@controller:~# . admin-openrc
root@controller:~# openstack hypervisor list
+----+---------------------+-----------------+-------------+-------+
| ID | Hypervisor Hostname | Hypervisor Type | Host IP     | State |
+----+---------------------+-----------------+-------------+-------+
|  1 | compute1            | QEMU            | 10.10.10.72 | up    |
+----+---------------------+-----------------+-------------+-------+
```

\- Khám phá compute hosts:  
```
root@controller:~# su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
Found 2 cell mappings.
Skipping cell0 since it does not contain hosts.
Getting compute nodes from cell 'cell1': 68457ec9-57cb-48a4-9fab-e2b97f9091ce
Found 1 computes in cell: 68457ec9-57cb-48a4-9fab-e2b97f9091ce
Checking host mapping for compute host 'compute1': 3e73c383-f334-4f1d-a41d-94bd878507b8
```

>Chú ý:  
Khi thêm 1 node compute mới, bạn phải chạy command `nova-manage cell_v2 discover_hosts` trên node controller để đăng kí node compute mới. Hoặc bạn có thể thiết lập thời gian tự động khám phá node mới trong file `/etc/nova/nova.conf`:  
>```
>[scheduler]
>discover_hosts_in_cells_interval = 300
>```

<a name="3.4.3"></a>

### 3.4.3.Kiểm tra
\- Thiết lập biến môi trường cho user `admin`:  
```
. admin-openrc
```

\- Liệt kê các thành phần compute service:  
``` 
root@controller:~# openstack compute service list
+----+------------------+------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
+----+------------------+------------+----------+---------+-------+----------------------------+
|  1 | nova-conductor   | controller | internal | enabled | up    | 2017-08-18T11:10:09.000000 |
|  2 | nova-consoleauth | controller | internal | enabled | up    | 2017-08-18T11:10:09.000000 |
|  3 | nova-scheduler   | controller | internal | enabled | up    | 2017-08-18T11:10:12.000000 |
|  9 | nova-compute     | compute1   | nova     | enabled | up    | 2017-08-18T11:10:09.000000 |
+----+------------------+------------+----------+---------+-------+----------------------------+
```

<a name="3.5"></a>

## 3.5.Networking service
<a name="3.5.1"></a>

### 3.5.1.Cài đặt và cấu hình trên node Controller
\- Tạo database:  
- Sử dụng database client để kết nối đến database server như user `root`:  
```
mysql
```

- Tạo database `neutron`:  
```
CREATE DATABASE neutron;
```

- Gán quyến truy cập đến database `neutron`:  
```
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
IDENTIFIED BY 'Welcome123';
```

- Thoát database client:  
```
quit
```

\- Thiết lập biến môi trường cho user `admin`:  
```
. admin-openrc
```

\- Tạo service `neutron`:  
- Tạo user `neutron`:  
```
root@controller:~# openstack user create --domain default --password-prompt neutron

User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | 5fc0a00182c64e1abe8be566c85be6ba |
| name                | neutron                          |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```

- Thêm role `admin` đến user `neutron`:  
```
openstack role add --project service --user neutron admin
```

- Tạo service `neutron`:  
```
root@controller:~# openstack service create --name neutron \
  --description "OpenStack Networking" network

+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Networking             |
| enabled     | True                             |
| id          | 46cba81afaec40c9a6913e84d85abd41 |
| name        | neutron                          |
| type        | network                          |
+-------------+----------------------------------+
```

\- Tạo Networking service API endpoints:  
```
root@controller:~# openstack endpoint create --region RegionOne \
  network public http://controller:9696

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 8da128a1b0414c4caf85da14781a55f8 |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 46cba81afaec40c9a6913e84d85abd41 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://controller:9696           |
+--------------+----------------------------------+


root@controller:~# openstack endpoint create --region RegionOne \
  network internal http://controller:9696

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 359f068269f340bc83c2d601746482ff |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 46cba81afaec40c9a6913e84d85abd41 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://controller:9696           |
+--------------+----------------------------------+


root@controller:~# openstack endpoint create --region RegionOne \
  network admin http://controller:9696

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | a8a55776e7a2427ba18ad6ffc8b9bd5f |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 46cba81afaec40c9a6913e84d85abd41 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://controller:9696           |
+--------------+----------------------------------+
```

\- Cấu hình tùy chọn networking  
Bạn có thể triển khai Networking service sử dụng 1 trong 2 kiến trúc sau:  
- [Networking Option 1: Provider networks](Controller_Provider_networks.md)
- [Networking Option 2: Self-service networks](#)

\- Cấu hình metadata agent  
Metadata agent cung cấp cấu hình thông tin cho instances.  
- Sửa file `/etc/neutron/metadata_agent.ini`, cấu hình như sau:  
```
[DEFAULT]
# ...
nova_metadata_ip = controller
metadata_proxy_shared_secret = Welcome123
```

\- Cấu hình Compute service để sử dụng Networking service  
- Sửa file `/etc/nova/nova.conf`:  
Trong section `[neutron]`, cấu hình truy cập parameters, kích hoạt metadata proxy và cấu hình secret:  
```
[neutron]
# ...
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

\- Kết thúc cài đặt  
- Sinh database:  
```
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
```

- Restart Compute API service:  
```
service nova-api restart
```

- Restart Networking services.  
```
service neutron-server restart
service neutron-openvswitch-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
```

Cho networking option 2, restart layer-3 service:  
```
service neutron-l3-agent restart
```

<a name="3.5.2"></a>

### 3.5.2.Cài đặt và cấu hình trên node Compute1
\- Cài các thành phần  
```
apt install neutron-openvswitch-agent
```

\- Cấu hình thành phần chung  
- Sửa file `/etc/neutron/neutron.conf` và hoàn thành các hành động sau:  
  - Trong section `[database]`, comment out bất kì `connection` options bởi vì node compute không trực tiếp truy cập đến database.  
  - Trong section `[DEFAULT]`, cấu hình truy cập `RabbitMQ` message queue:
  ```
  [DEFAULT]
  # ...
  transport_url = rabbit://openstack:Welcome123@controller
  ```
  
  - Trong section `[DEFAULT`] và `[keystone_authtoken]`, cấu hình truy cập Identity service:  
  ```
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
  username = neutron
  password = Welcome123
  ```

\- Cấu hình tùy chọn networking  
Bạn có thể triển khai Networking service sử dụng 1 trong 2 kiến trúc sau:  
- [Networking Option 1: Provider networks](Compute_Provider_networks.md.md)
- [Networking Option 2: Self-service networks](#)

\- Cấu hình Compute service để sử dụng Networking service  
- Sửa file `/etc/nova/nova.conf`:  
Trong section `[neutron]`, cấu hình truy cập parameters:  
```
[neutron]
# ...
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

\- Kết thúc cài đặt  
- Restart Compute service:  
```
service nova-compute restart
```

- Restart Open vSwitch agent:  
```
service neutron-openvswitch-agent restart
```

<a name="tailieuthamkhao"></a>

# Tài liệu tham khảo











