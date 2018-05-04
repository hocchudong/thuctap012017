# Cài đặt Swift với keystone trên Ubuntu 16.04 64-bit.

# Mục lục
- [Mô hình mạng](#1)
- [1. Cài đặt môi trường trên node controller](#2)
  - [1.1 Cài đặt networking.](#3)
  - [1.2 Cài đặt NTP](#4)
  - [1.3 Cài đặt repos để cài OpenStack PIKE](#5)
  - [1.4 Cài đặt SQL database](#6)
  - [1.5 Cài đặt RabbitMQ](#7)
  - [1.6 Cài đặt Memcached](#8)
- [2. Cài đặt môi trường trên 2 node object.](#9)
  - [2.1 Cài đặt networking cho object1](#10)
  - [2.2 Cài đặt networking cho object2](#11)
  - [2.3 Cài đặt NTP](#12)
  - [2.4 Cài đặt repos để cài OpenStack PIKE](#13)
- [3. Thực hiện cài đặt keystone.](#14)
  - [3.1 Tạo database cho keystone](#15)
  - [3.2 Cài đặt và cấu hình keystone](#16)
  - [3.3 Kết thúc cài đặt](#17)
  - [3.4 Tạo domain, projects, users, và roles](#18)
  - [3.5  Kiểm chứng lại các bước cài đặt keysonte](#19)
  - [3.6 Tạo script biến môi trường cho client](#20)
- [4. Cài đặt swift trên controller](#21)
  - [4.1. Tạo user swift, gán quyền và tạo endpoint API cho dịch vụ swift](#22)
  - [4.2. Cài đặt và cấu hình cho dịch vụ Swift](#23)
- [5. Cài đặt các thành phần trên 2 node object.](#24)
  - [5.1. Cài đặt các gói hỗ trợ.](#25)
  - [5.2. Cài đặt và cấu hình các thành phần](#26)
- [6. Tạo và phân phối các rings ban đầu.](#27)
- [7. Hoàn thành cài đặt](#28)

<a name=1></a>
# Mô hình mạng

  ![](../images/layout_swift.png)
  
## Lưu ý

  ```sh
  - Đăng nhập với quyền root cho tất cả các bước cài đặt
  - Các thao tác sửa file trong hướng dẫn này sử dụng lệnh vi hoặc vim
  - Password thống nhất cho tất cả các dịch vụ là Welcome123
  ```
  
<a name=2></a>
# 1. Cài đặt môi trường trên node controller.
- Cập nhật các gói phần mềm

  ```sh
  apt-get update
  ```
  
<a name=3></a>
### 1.1 Cài đặt networking.
- Dùng lệnh vi để sửa file /etc/network/interfaces với nội dung như sau.

  ```sh
  auto ens3
  iface ens3 inet static
          address 10.10.10.11
          netmask 255.255.255.0


  auto ens4
  iface ens4 inet static
          address 172.16.10.11
          netmask 255.255.255.0
          gateway 172.16.10.1
          dns-nameservers 8.8.8.8


  auto ens5
  iface ens5 inet static
          address 10.10.20.11
          netmask 255.255.255.0
  ```
  
- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

  ```sh
  ifdown -a && ifup -a
  ```
  
- Kiểm tra kết nối tới gateway và internet sau khi thiết lập xong.

  ```sh
  ping gateway ping -c 4 172.16.1.1
  ping -c 4 172.16.1.1

  PING 172.16.1.1 (172.16.1.1) 56(84) bytes of data.
  64 bytes from 172.16.1.1: icmp_seq=1 ttl=64 time=0.306 ms
  64 bytes from 172.16.1.1: icmp_seq=2 ttl=64 time=0.299 ms
  64 bytes from 172.16.1.1: icmp_seq=3 ttl=64 time=0.264 ms
  64 bytes from 172.16.1.1: icmp_seq=4 ttl=64 time=0.299 ms
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
  
- Cấu hình hostname. Dùng vi sửa file `/etc/hostname` với tên là controller.

  ```sh
  controller
  ```
  
- Cập nhật file /etc/hosts để phân giải từ IP sang hostname và ngược lại, nội dung như sau

  ```sh
  127.0.0.1       localhost       controller
  10.10.10.11     controller
  
  10.10.10.100    object1
  10.10.10.101    object2
  ```

- Khởi động lại máy, sau đó đăng nhập vào với quyền root.

  ```sh
  init 6
  ```
  
<a name=4></a>
### 1.2 Cài đặt NTP.
- 1. Cài gói chrony.

  ```sh
  apt install chrony -y
  ```
  
- 2. Mở file /etc/chrony/chrony.conf bằng vi và thêm vào các dòng sau:
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
  
<a name=5></a>
### 1.3 Cài đặt repos để cài OpenStack PIKE
- 1. Cài đặt gói để cài OpenStack PIKE
  ```sh
  apt-get install software-properties-common -y
  add-apt-repository cloud-archive:pike -y
  ```
  
- 2. Cập nhật các gói phần mềm
  ```sh
  apt -y update && apt -y dist-upgrade
  ```
  
- 3. Cài đặt các gói client của OpenStack.
  ```sh
  apt install python-openstackclient -y
  ```
  
- 4. Khởi động lại máy chủ
  ```sh
  init 6
  ```
  
<a name=6></a>
### 1.4 Cài đặt SQL database
- 1. Cài đặt MariaDB
  ```sh
  apt install mariadb-server python-pymysql -y
  ```
  
- 2. Thiết lập mật khẩu cho tài khoản root (tài khoản root của mariadb)
  ```sh
  mysql_secure_installation
  ```
  
  - Ngay đoạn đầu tiên nó sẽ hỏi bạn nhập mật khẩu root hiện tại, nhưng chúng ta chưa có mật khẩu thì hãy Enter để bỏ qua, kế tiếp chọn gõ Y để bắt đầu thiết lập mật khẩu cho root và các tùy chọn sau bạn vẫn Y hết.
  - Nhập mật khẩu root là: Welcome123
  
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
  
<a name=7></a>
### 1.5 Cài đặt RabbitMQ
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
  
<a name=8></a>
### 1.6 Cài đặt Memcached
- 1. Cài đặt các gói cần thiết cho memcached
  ```sh
  apt install memcached python-memcache -y
  ```
  
- 2. Dùng vi sửa file /etc/memcached.conf, thay dòng `-l 127.0.0.1` bằng dòng dưới.
  ```sh
  -l 0.0.0.0
  ```
  
- 3. Khởi động lại memcache.
  ```sh
  service memcached restart
  ```
  
<a name=9></a>
# 2. Cài đặt môi trường trên 2 node object.
- Cập nhật các gói phần mềm

  ```sh
  apt-get update
  ```
  
<a name=10></a>
### 2.1 Cài đặt networking cho object1
- Dùng lệnh vi để sửa file /etc/network/interfaces với nội dung như sau.

  ```sh
  auto ens3
  iface ens3 inet static
          address 10.10.10.100
          netmask 255.255.255.0


  auto ens4
  iface ens4 inet static
          address 172.16.10.100
          netmask 255.255.255.0
          gateway 172.16.10.1
          dns-nameservers 8.8.8.8


  auto ens5
  iface ens5 inet static
          address 10.10.20.100
          netmask 255.255.255.0
  ```
  
- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

  ```sh
  ifdown -a && ifup -a
  ```

  - Cấu hình hostname. Dùng vi sửa file `/etc/hostname` với tên là controller.

  ```sh
  object1
  ```
  
- Cập nhật file /etc/hosts để phân giải từ IP sang hostname và ngược lại, nội dung như sau

  ```sh
  127.0.0.1       localhost       controller
  10.10.10.11     controller
  
  10.10.10.100    object1
  10.10.10.101    object2
  ```

- Khởi động lại máy, sau đó đăng nhập vào với quyền root.

  ```sh
  init 6
  ```
  
<a name=11></a>
### 2.2 Cài đặt networking cho object2
- Dùng lệnh vi để sửa file /etc/network/interfaces với nội dung như sau.

  ```sh
  auto ens3
  iface ens3 inet static
          address 10.10.10.101
          netmask 255.255.255.0


  auto ens4
  iface ens4 inet static
          address 172.16.10.101
          netmask 255.255.255.0
          gateway 172.16.10.1
          dns-nameservers 8.8.8.8


  auto ens5
  iface ens5 inet static
          address 10.10.20.101
          netmask 255.255.255.0
  ```
  
- Khởi động lại card mạng sau khi thiết lập IP tĩnh.

  ```sh
  ifdown -a && ifup -a
  ```

  - Cấu hình hostname. Dùng vi sửa file `/etc/hostname` với tên là controller.

  ```sh
  object2
  ```
  
- Cập nhật file /etc/hosts để phân giải từ IP sang hostname và ngược lại, nội dung như sau

  ```sh
  127.0.0.1       localhost       controller
  10.10.10.11     controller
  
  10.10.10.100    object1
  10.10.10.101    object2
  ```

- Khởi động lại máy, sau đó đăng nhập vào với quyền root.

  ```sh
  init 6
  ```
  
<a name=12></a>
# Các bước cài đặt sau được thực hiện trên cả 2 node object
### 2.3 Cài đặt NTP.
- 1. Cài gói chrony.

  ```sh
  apt install chrony -y
  ```
  
- 2. Mở file /etc/chrony/chrony.conf bằng vi và thêm vào các dòng sau:
  - commnet dòng sau:
  
  ```sh
  #pool 2.debian.pool.ntp.org offline iburst
  ```
  
  - Thêm các dòng sau:

  ```sh
  server controller iburst
  ```

- 3. Restart dịch vụ NTP

  ```sh
  service chrony restart
  ```
  
<a name=13></a>
### 2.4 Cài đặt repos để cài OpenStack PIKE
- 1. Cài đặt gói để cài OpenStack PIKE
  ```sh
  apt-get install software-properties-common -y
  add-apt-repository cloud-archive:pike -y
  ```
  
- 2. Cập nhật các gói phần mềm
  ```sh
  apt -y update && apt -y dist-upgrade
  ```
  
- 3. Cài đặt các gói client của OpenStack.
  ```sh
  apt install python-openstackclient -y
  ```
  
- 4. Khởi động lại máy chủ
  ```sh
  init 6
  ```
  
<a name=14></a>
# 3. Thực hiện cài đặt keystone.
<a name=15></a>
### 3.1 Tạo database cho keystone
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
  
<a name=16></a>
### 3.2 Cài đặt và cấu hình keystone
- 1. Cài đặt keystone
  ```sh
  apt install keystone apache2 libapache2-mod-wsgi -y
  ```
  
- 2. Dùng lệnh vi để mở và sửa file /etc/keystone/keystone.conf.
  - Trong section `[database]` thêm dòng dưới. 
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
  
- 6. Cấu hình apache cho keysonte. Dùng vi để mở và sửa file `/etc/apache2/apache2.conf`. Thêm dòng dưới ngay sau dòng `# Global configuration`
  ```sh
  # Global configuration
  ServerName controller
  ```
  
<a name=17></a>
### 3.3 Kết thúc cài đặt
- 1. Restart lại apache và xóa database SQLite mặc định
  ```sh
  service apache2 restart
  rm -f /var/lib/keystone/keystone.db
  ```
  
- 2. Cấu hình cho tài khoản quản trị:
  ```sh
  export OS_USERNAME=admin
  export OS_PASSWORD=Welcome123
  export OS_PROJECT_NAME=admin
  export OS_USER_DOMAIN_NAME=Default
  export OS_PROJECT_DOMAIN_NAME=Default
  export OS_AUTH_URL=http://controller:35357/v3
  export OS_IDENTITY_API_VERSION=3
  ```
  
<a name=18></a>
### 3.4 Tạo domain, projects, users, và roles
- 1. Tạo project `service`
  ```sh
  ~# openstack project create --domain default \
  --description "Service Project" service
  
  +-------------+----------------------------------+
  | Field       | Value                            |
  +-------------+----------------------------------+
  | description | Service Project                  |
  | domain_id   | default                          |
  | enabled     | True                             |
  | id          | 0987a7610a74491bb35ad3ef57588887 |
  | is_domain   | False                            |
  | name        | service                          |
  | parent_id   | default                          |
  +-------------+----------------------------------+
  ```
  
- 2. Tạo project demo:
  ```sh
  ~# openstack project create --domain default \
  --description "Demo Project" demo
  
  +-------------+----------------------------------+
  | Field       | Value                            |
  +-------------+----------------------------------+
  | description | Demo Project                     |
  | domain_id   | default                          |
  | enabled     | True                             |
  | id          | 4b50aef935b143d4966076705c17c387 |
  | is_domain   | False                            |
  | name        | demo                             |
  | parent_id   | default                          |
  +-------------+----------------------------------+
  ```
  
- 3. Tạo user demo
  ```sh
  ~# openstack user create --domain default \
  --password Welcome123 demo
  
  +---------------------+----------------------------------+
  | Field               | Value                            |
  +---------------------+----------------------------------+
  | domain_id           | default                          |
  | enabled             | True                             |
  | id                  | 8a806b41ca134a378950127ac25cff15 |
  | name                | demo                             |
  | options             | {}                               |
  | password_expires_at | None                             |
  +---------------------+----------------------------------+
  ```
  
- 4. Tạo role user:
  ```sh
  ~# openstack role create user

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
  
<a name=19></a>
### 3.5  Kiểm chứng lại các bước cài đặt keysonte
- 1. Vô hiệu hóa cơ chế xác thực bằng token tạm thời trong keysonte bằng cách xóa `admin_token_auth` trong các section `[pipeline:public_api]`, `[pipeline:admin_api]` và `[pipeline:api_v3]` của file `/etc/keystone/keystone-paste.ini`
- 2. Bỏ thiết lập trong biến môi trường của `OS_AUTH_URL` và `OS_PASSWORD` bằng lệnh:
  ```sh
  unset OS_AUTH_URL OS_PASSWORD
  ```
  
- 3. Gõ lần lượt 2 lệnh dưới sau đó nhập mật khẩu là `Welcome123`
  ```sh
  ~# openstack --os-auth-url http://controller:35357/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name admin --os-username admin token issue
  Password:

  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  | Field      | Value                                                                                                                              |
  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  | expires    | 2017-06-08T14:37:45+0000                                                                                                           |
  | id         | gAAAAABZOVMpzGj_G62qWkgpIL58u2l1FKFBkWTpqW5zocPPdraLwYWEdHUsKsOkCZwMNGFelZlI0vilWo4gMsZ5nWXb2ELD4aMHU4W3rnMSxKqv4QtSxiRCv8hTJ_IGIj |
  |            | vYFF_e2qtySAsuhoRCZVOhy3KfS2FelCpzQE4UDRP5VHWKX5OMeI4                                                                              |
  | project_id | b54646bf669746db8c62ec0410bd0528                                                                                                   |
  | user_id    | 102f8ea368cd4451ad6fefeb15801177                                                                                                   |
  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  ```
  
  và 
  
  ```sh
  ~# openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name demo --os-username demo token issue
  Password:

  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  | Field      | Value                                                                                                                              |
  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  | expires    | 2017-06-08T14:39:37+0000                                                                                                           |
  | id         | gAAAAABZOVOZu1qQ0_9OkDgoDiQjRhiNH8UxWEwbXZCtiFZ7r4dX37cs5edGxwKpDVriIc3SpRWmPK-YY2Qt0VVaxJ1m8210RsQRitplup1_kBZMp86lZKLibnjoEX-    |
  |            | gqXssudHceQObctojg_m8hwihsy5wGsRk-H3HYBQqiIroJ_OHuY7T7gA                                                                           |
  | project_id | 46c2ef11a6904008be75a90d28b1928c                                                                                                   |
  | user_id    | c83518ba02064bc795e7e282024647ad                                                                                                   |
  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  ```
  
<a name=20></a>
### 3.6 Tạo script biến môi trường cho client
- 1. Tạo file `admin-openrc` với nội dung sau:
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
  
- 2. Tạo file `demo-openrc` với nội dung sau:
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
  
- 3. Chạy script admin-openrc
  ```sh
  source  admin-openrc
  ```
  
- 4. Kết quả sẽ như bên dưới (Lưu ý: giá trị sẽ khác nhau)
  ```sh
  ~# openstack token issue

  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  | Field      | Value                                                                                                                              |
  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  | expires    | 2017-06-08T14:45:58+0000                                                                                                           |
  | id         | gAAAAABZOVUWFfzGA7YgH4B8E22pSmM1z0woDouvaBCUF8NhnY1ne65hCFHU1TnfFadXXtX8RH0NXLa1KNKClrf-                                           |
  |            | Xxdl6qOyNGHBJ2jLHSws8TCaLtZYu6UoCIHxLzVus35krZGYS1DXpfBjB77YiLmuXhvf8qryZbWvBQX5K9otIbPv7e_dHqU                                    |
  | project_id | b54646bf669746db8c62ec0410bd0528                                                                                                   |
  | user_id    | 102f8ea368cd4451ad6fefeb15801177                                                                                                   |
  +------------+------------------------------------------------------------------------------------------------------------------------------------+
  ```
  
- Đã cài xong keystone. Tiếp theo sẽ cài swift trên controller.

<a name=21></a>
# 4. Cài đặt swift trên controller
<a name=22></a>
### 4.1. Tạo user swift, gán quyền và tạo endpoint API cho dịch vụ swift
- 1. Chạy script biến môi trường: `source admin-openrc`
- 2. Tạo user `swift`

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
  
- 3. Thêm role admin cho user swift trên project service

  ```sh
  openstack role add --project service --user swift admin
  ```
  
  - Kiểm tra lại xem user swift có role là gì
  
  ```sh
  ~# openstack role list --user swift --project service
  Listing assignments using role list is deprecated. Use role assignment list --user <user-name> --project <project-name> --names instead.
  +----------------------------------+-------+---------+-------+
  | ID                               | Name  | Project | User  |
  +----------------------------------+-------+---------+-------+
  | ec9157c203314df69c4f3805e3fec0e7 | admin | service | swift |
  +----------------------------------+-------+---------+-------+
  ```

- 4. Tạo dịch vụ có tên swift

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
  
- 5. Tạo các endpoint cho swift

  ```sh
  openstack endpoint create --region RegionOne \
  object-store public http://controller:8080/v1/AUTH_%\(tenant_id\)s
  
  openstack endpoint create --region RegionOne \
  object-store internal http://controller:8080/v1/AUTH_%\(tenant_id\)s

  openstack endpoint create --region RegionOne \
  object-store admin http://controller:8080/v1
  ```
 
<a name=23></a>
### 4.2. Cài đặt và cấu hình cho dịch vụ Swift
- 1. Cài đặt gói swift

  ```sh
  apt-get install -y swift swift-proxy python-swiftclient \
  python-keystoneclient python-keystonemiddleware \
  memcached
  ```
  
- 2. Tạo thư mục `/etc/swift`

  ```sh
  mkdir /etc/swift
  ```
  
- 3. Lấy file cấu hình dịch vụ proxy từ kho lưu trữ Object storage.

  ```sh
  curl -o /etc/swift/proxy-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/newton
  ```
  
- 4. Sửa file `/etc/swift/proxy-server.conf`.
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
  
  - chú ý không thay đổi thứ tự các modules.
  
- Trong `[app:proxy-server]` section, cho phép tự động tạo tài khoản.

  ```sh
  [app:proxy-server]
  use = egg:swift#proxy
  ...
  account_autocreate = True
  ```
  
- Trong `[filter:keystoneauth]` section, cấu hình các roles của operator.

  ```sh
  [filter:keystoneauth]
  use = egg:swift#keystoneauth
  ...
  operator_roles = admin,user
  ```
  
- Trong `[filter:authtoken]` section, cấu hình truy cập dịch vụ identity

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
  
- Trong `[filter:cache]` section, cấu hình vị trí memcached.

  ```sh
  [filter:cache]
  use = egg:swift#memcache
  ...
  memcache_servers = controller:11211
  ```
 
<a name=24></a>
# 5. Cài đặt các thành phần trên 2 node object.
- Trên mỗi node object đều có 3 ổ đĩa. Kiểm tra bằng lệnh sau
  ```sh
  ~# lsblk
  NAME                  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
  sda                     8:0    0   20G  0 disk
  ├─sda1                  8:1    0  487M  0 part /boot
  ├─sda2                  8:2    0    1K  0 part
  └─sda5                  8:5    0 19.5G  0 part
    ├─ubuntu--vg-root   252:0    0 17.5G  0 lvm  /
    └─ubuntu--vg-swap_1 252:1    0    2G  0 lvm  [SWAP]
  sdb                     8:16   0   10G  0 disk
  sdc                     8:32   0   10G  0 disk
  ```sh
  
  - Cả 2 node trên hệ thống làm hướng dẫn đều có kết quả như trên.
  - ổ `sda` dùng để cài OS
  - 2 ổ `sdb` và `sdc` để sử dụng cho Swift.
  
- Trên cả 2 node, chúng ta đều thực hiện như sau:

<a name=25></a>
### 5.1. Cài đặt các gói hỗ trợ.
- 1. Cài đặt các gói hỗ trợ.

  ```sh
  apt install xfsprogs rsync -y
  ```

- 2. Định dạng `/dev/sdb` và `/dev/vdc` theo XFS

  ```sh
  mkfs.xfs /dev/sdb
  mkfs.xfs /dev/sdc
  ```
  
- 3. Tạo thư mục để mount.

  ```sh
  mkdir -p /srv/node/sdb
  mkdir -p /srv/node/sdc
  ```

- 4. Sửa file `/etc/fstab`, thêm các dòng sau.

  ```sh
  /dev/sdb /srv/node/sdb xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
  /dev/sdc /srv/node/sdc xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
  ```
  
- 5. Mount

  ```sh
  mount /srv/node/sdb
  mount /srv/node/sdc
  ```
 
- 6. Tạo file mới có tên là `/etc/rsyncd.conf` với nội dung sau

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
  
  - Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.100`
  - Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.101`

- 7. Sửa file `/etc/default/rsync` và bật dịch vụ `rsync`.

  ```sh
  RSYNC_ENABLE=true
  ```
  
- 8. Bật dịch vụ `rsync `

  ```sh
  service rsync start
  ```
 
<a name=26></a>
### 5.2. Cài đặt và cấu hình các thành phần
- 1. Cài đặt các gói

  ```sh
  apt install swift swift-account swift-container swift-object -y
  ```
  
- 2. Lấy files cấu hình accounting, container, object service từ kho Object storage.

  ```sh
  curl -o /etc/swift/account-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/account-server.conf-sample?h=stable/newton
  curl -o /etc/swift/container-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/container-server.conf-sample?h=stable/newton
  curl -o /etc/swift/object-server.conf https://git.openstack.org/cgit/openstack/swift/plain/etc/object-server.conf-sample?h=stable/newton
  ```
  
- 3. Sửa file `/etc/swift/account-server.conf`.
- Trong `[DEFAULT]` section, cấu hình địa chỉ `bind IP`, `bind port`, `user`, cấu hình directory, và mount point directory:

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

  - Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.100`
  - Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.101`
  
- Trong `[pipeline:main]` section, enable các modules phù hợp

  ```sh
  [pipeline:main]
  pipeline = healthcheck recon account-server
  ```
  
- Trong `[filter:recon]` section, cấu hình như sau:

  ```sh
  [filter:recon]
  use = egg:swift#recon
  #...
  recon_cache_path = /var/cache/swift
  ```

- 4. Sửa file `/etc/swift/container-server.conf`.
- Trong `[DEFAULT]` section, cấu hình `bind IP address`, `bind port`, `user`, cấu hình directory, và mount point directory:

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

  - Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.100`
  - Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.101`

- Trong `[pipeline:main]` section, enable các modules phù hợp:

  ```sh
  [pipeline:main]
  pipeline = healthcheck recon container-server
  ```
  
- Trong `[filter:recon]` section, cấu hình như sau:

  ```sh
  [filter:recon]
  use = egg:swift#recon
  #...
  recon_cache_path = /var/cache/swift
  ```
  
- 5. Sửa file `/etc/swift/object-server.conf`
- Trong `[DEFAULT]` section, cấu hình `bind IP address`, `bind port`, `user`, cấu hình directory, và mount point directory:

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

  - Trên node Object1 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.100`
  - Trên node Object2 thì thay MANAGEMENT_INTERFACE_IP_ADDRESS bằng địa chỉ `10.10.10.101`

- Trong `[pipeline:main]` section, enable các modules phù hợp:

  ```sh
  [pipeline:main]
  pipeline = healthcheck recon object-server
  ```
  
- Trong `[filter:recon]` section, cấu hình như sau:

  ```sh
  [filter:recon]
  use = egg:swift#recon
  #...
  recon_cache_path = /var/cache/swift
  recon_lock_path = /var/lock
  ```
 
- 6. Phân quyền thư mục

  ```sh
  chown -R swift:swift /srv/node
  ```
  
- 7. Tạo thư mục `recon` và phân quyền cho nó

  ```sh
  mkdir -p /var/cache/swift
  chown -R root:swift /var/cache/swift
  chmod -R 775 /var/cache/swift
  ```

<a name=27></a>  
## 6. Tạo và phân phối các rings ban đầu.
- Bước này thực hiện trên node controller
### 6.1. Tạo tài khoản ring
- 1. đến thư mục `/etc/swift`

  ```sh
  cd /etc/swift
  ```
  
- 2. Tạo file `account.builder`

  ```sh
  swift-ring-builder account.builder create 10 3 1
  ```
  
- 3. Thêm mỗi node đến ring

  ```sh
  swift-ring-builder account.builder add \
  --region 1 --zone 1 --ip 10.10.10.100 --port 6202 --device sdb --weight 10
  
  swift-ring-builder account.builder add \
  --region 1 --zone 1 --ip 10.10.10.100 --port 6202 --device sdc --weight 10
  
  swift-ring-builder account.builder add \
  --region 1 --zone 1 --ip 10.10.10.101 --port 6202 --device sdb --weight 10
  
  swift-ring-builder account.builder add \
  --region 1 --zone 1 --ip 10.10.10.101 --port 6202 --device sdc --weight 10
  ```
  
- 4. Kiểm tra lại nội dung của ring

  ```sh
  /etc/swift# swift-ring-builder account.builder
  account.builder, build version 4
  1024 partitions, 3.000000 replicas, 1 regions, 1 zones, 4 devices, 100.00 balance, 0.00 dispersion
  The minimum number of hours before a partition can be reassigned is 1 (0:00:00 remaining)
  The overload factor is 0.00% (0.000000)
  Ring file account.ring.gz not found, probably it hasn't been written yet
  Devices:   id region zone   ip address:port replication ip:port  name weight partitions balance flags meta
              0      1    1 10.10.10.100:6202   10.10.10.100:6202   sdb  10.00          0 -100.00
              1      1    1 10.10.10.100:6202   10.10.10.100:6202   sdc  10.00          0 -100.00
              2      1    1 10.10.10.101:6202   10.10.10.101:6202   sdb  10.00          0 -100.00
              3      1    1 10.10.10.101:6202   10.10.10.101:6202   sdc  10.00          0 -100.00
  ```
  
- 5. Tái cân bằng ring

  ```sh
  /etc/swift# swift-ring-builder account.builder rebalance
  Reassigned 3072 (300.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
  ```
  
### 6.2. Tạo container ring
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
  --region 1 --zone 1 --ip 10.10.10.100 --port 6201 --device sdb --weight 10

  swift-ring-builder container.builder add \
  --region 1 --zone 1 --ip 10.10.10.100 --port 6201 --device sdc --weight 10

  swift-ring-builder container.builder add \
  --region 1 --zone 1 --ip 10.10.10.101 --port 6201 --device sdb --weight 10

  swift-ring-builder container.builder add \
  --region 1 --zone 1 --ip 10.10.10.101 --port 6201 --device sdc --weight 10
  ```

- 4. Kiểm tra lại nội dung của ring

  ```sh
  /etc/swift# swift-ring-builder container.builder
  container.builder, build version 4
  1024 partitions, 3.000000 replicas, 1 regions, 1 zones, 4 devices, 100.00 balance, 0.00 dispersion
  The minimum number of hours before a partition can be reassigned is 1 (0:00:00 remaining)
  The overload factor is 0.00% (0.000000)
  Ring file container.ring.gz not found, probably it hasn't been written yet
  Devices:   id region zone   ip address:port replication ip:port  name weight partitions balance flags meta
              0      1    1 10.10.10.100:6201   10.10.10.100:6201   sdb  10.00          0 -100.00
              1      1    1 10.10.10.100:6201   10.10.10.100:6201   sdc  10.00          0 -100.00
              2      1    1 10.10.10.101:6201   10.10.10.194:6201   sdb  10.00          0 -100.00
              3      1    1 10.10.10.101:6201   10.10.10.194:6201   sdc  10.00          0 -100.00
  ```
  
- 5. Tái cân bằng ring

  ```sh
  /etc/swift# swift-ring-builder container.builder rebalance
  Reassigned 3072 (300.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
  ```

### 6.3. Tạo object ring
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
  --region 1 --zone 1 --ip 10.10.10.100 --port 6200 --device sdb --weight 10
  
  swift-ring-builder object.builder add \
  --region 1 --zone 1 --ip 10.10.10.100 --port 6200 --device sdc --weight 10
  
  swift-ring-builder object.builder add \
  --region 1 --zone 1 --ip 10.10.10.101 --port 6200 --device sdb --weight 10
  
  swift-ring-builder object.builder add \
  --region 1 --zone 1 --ip 10.10.10.101 --port 6200 --device sdc --weight 10
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
              0      1    1 10.10.10.100:6200   10.10.10.100:6200   sdb  10.00          0 -100.00
              1      1    1 10.10.10.100:6200   10.10.10.100:6200   sdc  10.00          0 -100.00
              2      1    1 10.10.10.101:6200   10.10.10.101:6200   sdb  10.00          0 -100.00
              3      1    1 10.10.10.101:6200   10.10.10.101:6200   sdc  10.00          0 -100.00
  ```
  
- 5. Tái cân bằng ring

  ```sh
  /etc/swift# swift-ring-builder object.builder rebalance
  Reassigned 3072 (300.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
  ```
 
### 6.4. Copy các file `account.ring.gz, container.ring.gz, and object.ring.gz` đến thư mục `/etc/swift` trên mỗi node object storage
- Sử dụng lệnh scp để đẩy các file này đến mỗi node Object storage

  ```sh
  scp /etc/swift/account.ring.gz /etc/swift/container.ring.gz /etc/swift/object.ring.gz root@10.10.10.100:/etc/swift
  scp /etc/swift/account.ring.gz /etc/swift/container.ring.gz /etc/swift/object.ring.gz root@10.10.10.101:/etc/swift
  ```

<a name=28></a>
# 7. Hoàn thành cài đặt
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
  scp /etc/swift/swift.conf root@10.10.10.100:/etc/swift/
  
  scp /etc/swift/swift.conf root@10.10.10.101:/etc/swift/
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
- Khai cáo cridentials cho user demo (Thực hiện trên node controller):

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
 
  
  
  
  
  
  