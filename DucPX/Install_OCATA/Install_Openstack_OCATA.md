# Cài đặt OpenStack OCATA
---

## I. Cài đặt cơ bản
---

## 1. Chuẩn bị môi trường
### 1.1 Mô hình mạng
- Mô hình đầy đủ 

![Imgur](http://i.imgur.com/ORqhd62.png)

- Hướng dẫn này tiến hành cài đặt 2 nodes là **controller** và **compute1**

### 1.2 Yêu cầu phần cứng cho 2 nodes `controller` và `computer1`

![Imgur](http://i.imgur.com/oaXv2o4.png)

## 2. Cài đặt node controller
**Lưu ý**:

	- Đăng nhập với quyền root cho tất cả các bước cài đặt
	- Các thao tác sửa file trong hướng dẫn này sử dụng lệnh vi hoặc vim
	- Password thống nhất cho tất cả các dịch vụ là Welcome123

- Tiến hành cài đặt trên hệ điều hành **Ubuntu Server 16.04 64bit**.
- Các nodes đều là máy ảo chạy trên VMware Workstation
- Node controller và compute1 đều có các card mạng như sau

	![Imgur](http://i.imgur.com/Kc3ZEsR.png)

### 2.1 Cài đặt phần chung

=== 

#### 2.1.1 Thiết lập và cài đặt các gói cơ bản

- Chạy lệnh để cập nhật các gói phần mềm
	```sh
	apt-get -y update
	```

- Thiết lập địa chỉ IP
- Dùng lệnh `vi` để sửa file `/etc/network/interfaces` với nội dung như sau.
	![Imgur](http://i.imgur.com/w29Avxv.png)

- Khởi động lại card mạng sau khi thiết lập IP tĩnh
	```sh
	ifdown -a && ifup -a
	```

- Đăng nhập lại máy `Controller` với quyền `root` và thực hiện kiểm tra kết nối. 
- Kiểm tra kết nối tới gateway và internet sau khi thiết lập xong.

	![Imgur](http://i.imgur.com/PF2GXPI.png)

	![Imgur](http://i.imgur.com/uCYoQ0K.png)

- Cấu hình hostname
- Dùng `vi` sửa file `/etc/hostname` với tên là `controller`

	```sh
	controller
	```

- Cập nhật file `/etc/hosts` để phân giải từ IP sang hostname và ngược lại, nội dung như sau

	```sh
	127.0.0.1      localhost controller
	10.10.10.61    controller
	10.10.10.62    compute1
	```

#### 2.1.2 Cài đặt NTP

- Cài gói `chrony`
	```sh
	apt-get -y install chrony
	```

- Mở file `/etc/chrony/chrony.conf` bằng *vi* và thêm vào các dòng sau:
	![Imgur](http://i.imgur.com/0sz6IV9.png)

- Khởi động lại dịch vụ NTP
	```sh
	service chrony restart
	```
- Kiểm tra lại hoạt động của NTP bằng lệnh dưới
	```sh
	root@controller:~# chronyc sources
	```
	
	- Kết quả như sau
	![Imgur](http://i.imgur.com/4CvGuZa.png)

#### 2.1.3 Cài đặt repos để cài OpenStack OCATA

- Cài đặt gói để cài OpenStack Mitaka
	```sh
	 apt-get install software-properties-common -y
	 add-apt-repository cloud-archive:ocata -y
	```

- Cập nhật các gói phần mềm
	```sh
	apt-get -y update && apt-get -y dist-upgrade
	```

-Cài đặt các gói client của OpenStack
	```sh
	apt-get -y install python-openstackclient
	```

- Khởi động lại máy chủ
	```sh
	init 6
	```

#### 2.1.4 Cài đặt SQL database

- Cài đặt MariaDB
	```sh
	apt-get -y install mariadb-server python-pymysql
	```

- Thiết lập mật khẩu cho tài khoản **root** (tài khoản root của mariadb)
	```sh
	mysql_secure_installation
	```

	- Ngay đoạn đầu tiên nó sẽ hỏi bạn nhập mật khẩu root hiện tại, nhưng chúng ta chưa có mật khẩu thì hãy Enter để bỏ qua, kế tiếp chọn gõ Y để bắt đầu thiết lập mật khẩu cho root và các tùy chọn sau bạn vẫn Y hết.
	- Nhập mật khẩu root là: `Welcome123`

- Cấu hình cho Mariadb, tạo file `/etc/mysql/mariadb.conf.d/99-openstack.cnf` với nội dung sau:
	```sh
	[mysqld]
	bind-address = 10.10.10.61

	default-storage-engine = innodb
	innodb_file_per_table = on
	collation-server = utf8_general_ci
	character-set-server = utf8
	```

- Khởi động lại MariaDB
	```sh
	service mysql restart
	```

- Đăng nhập bằng tài khoản `root` vào `MariaDB` để kiểm tra lại. Sau đó gõ lệnh `exit` để thoát.
	```sh
	root@controller:~# mysql -u root -p
	```
	- Nhập mật khẩu `Welcome123`
	
	![Imgur](http://i.imgur.com/woaHyZj.png)

#### 2.1.5 Cài đặt RabbitMQ

- Cài đặt gói
	```sh
	apt-get -y install rabbitmq-server
	```

-Cấu hình RabbitMQ, tạo user `openstack` với mật khẩu là `Welcome123`

	```sh
	rabbitmqctl add_user openstack Welcome123
	```

- Gán quyền read, write cho tài khoản `openstack` trong `RabbitMQ`

	```sh
	rabbitmqctl set_permissions openstack ".*" ".*" ".*"
	```

#### 2.1.6 Cài đặt Memcached
- Cài đặt các gói cần thiết cho `memcached`

	```sh
	apt-get -y install memcached python-memcache
	```

- Dùng vi sửa file `/etc/memcached.conf`, thay dòng `-l 127.0.0.1` bằng dòng dưới.

	```sh
	-l 10.10.10.61
	```

- Khởi động lại `memcache`
	```sh
	service memcached restart
	```

## 3. Cài đặt Keystone
***

### 3.1 Cài đặt và cấu hình cho keysonte
***

#### 3.1.1. Tạo database cài đặt các gói và cấu hình keystone
- Đăng nhập vào MariaDB

	```sh
	mysql -u root -p
	```
- Tạo user, database cho keystone

	```sh
	CREATE DATABASE keystone;
	GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost'  IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Welcome123';
	FLUSH PRIVILEGES;
	
	exit;
	```

#### 3.1.2. Cài đặt và cấu hình `keystone`
- Cài đặt gói keystone

	```sh
	apt-get -y install keystone
	```
- Sao lưu file cấu hình của dịch vụ keystone trước khi chỉnh sửa.

	```sh
	cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.orig
	```

- Dùng lệnh `vi` để mở và sửa file `/etc/keystone/keystone.conf`.
	- Trong section `[database]` thêm dòng dưới
 
		```sh
		connection = mysql+pymysql://keystone:Welcome123@10.10.10.61/keystone
		```

	- Trong section `[token]`, cấu hình Fernet token provider:

		```sh
		[token]

		provider = fernet
		```

- Đồng bộ database cho keystone
	```sh
	su -s /bin/sh -c "keystone-manage db_sync" keystone
	```

	- Lệnh trên sẽ tạo ra các bảng trong database có tên là keysonte

- Thiết lập `Fernet` key

	```sh
	keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
	keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
	```

- Bootstrap the Identity service:
	```sh
	~# keystone-manage bootstrap --bootstrap-password Welcome123 \
  		--bootstrap-admin-url http://controller:35357/v3/ \
  		--bootstrap-internal-url http://controller:5000/v3/ \
  		--bootstrap-public-url http://controller:5000/v3/ \
  		--bootstrap-region-id RegionOne
	```

- Cấu hình apache cho `keysonte`
	- Dùng `vi` để mở và sửa file `/etc/apache2/apache2.conf`. Thêm dòng dưới ngay sau dòng `# Global configuration`

		 ```sh
		 # Global configuration
		 ServerName controller
		 ```

- Khởi động lại `apache`
	```sh
	service apache2 restart
	```

- Xóa file database mặc định của `keysonte` 
	```sh
	rm -f /var/lib/keystone/keystone.db
	```

- Cấu hình cho tài khoản quản trị:
	```sh
	$ export OS_USERNAME=admin
	$ export OS_PASSWORD=Welcome123
	$ export OS_PROJECT_NAME=admin
	$ export OS_USER_DOMAIN_NAME=Default
	$ export OS_PROJECT_DOMAIN_NAME=Default
	$ export OS_AUTH_URL=http://controller:35357/v3
	$ export OS_IDENTITY_API_VERSION=3
	```

#### 3.1.3. Tạo domain, projects, users, và roles
- Tạo project `service`
	```sh
	openstack project create --domain default \
  	--description "Service Project" service
	```

	![Imgur](http://i.imgur.com/VDNzosM.png)

- Tạo project `demo`:
	```sh
	openstack project create --domain default \
  	--description "Demo Project" demo
	```

	![Imgur](http://i.imgur.com/W8KQKoZ.png)

- Tạo user `demo`:
	```sh
	openstack user create --domain default \
  	--password-prompt demo
	```
	- Nhập mật khẩu `Welcome123` cho user
	
	![Imgur](http://i.imgur.com/1VdSEkK.png)

- Tạo role `user`:
	```sh
	openstack role create user
	```

	![Imgur](http://i.imgur.com/5COCpo4.png)

- Thêm role `user` cho project `demo` và user `demo`:
	```sh
	openstack role add --project demo --user demo user
	```

#### 3.1.4. Kiểm chứng lại các bước cài đặt `keysonte`
- Vô hiệu hóa cơ chế xác thực bằng token tạm thời trong `keysonte` bằng cách xóa `admin_token_auth` trong các section `[pipeline:public_api]`,  `[pipeline:admin_api]`  và `[pipeline:api_v3]` của file `/etc/keystone/keystone-paste.ini`
- Bỏ thiết lập trong biến môi trường của OS_AUTH_URL và OS_PASSWORD bằng lệnh:
	```sh
	unset OS_AUTH_URL OS_PASSWORD
	```

- Gõ lần lượt 2 lệnh dưới sau đó nhập mật khẩu
	```sh
	openstack --os-auth-url http://controller:35357/v3 \
  	--os-project-domain-name default --os-user-domain-name default \
  	--os-project-name admin --os-username admin token issue

	và 

	openstack --os-auth-url http://controller:5000/v3 \
  	--os-project-domain-name default --os-user-domain-name default \
  	--os-project-name demo --os-username demo token issue
	```

	![Imgur](http://i.imgur.com/rhNov9x.png)

#### 3.1.5. Tạo script biến môi trường cho client 
- Tạo file `admin-openrc` với nội dung sau: 
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

- Tạo file `demo-openrc` với nội dung sau:
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

- Chạy script `admin-openrc`
	```sh
	source  admin-openrc
	```
- Kết quả sẽ như bên dưới (Lưu ý: giá trị sẽ khác nhau)

	```sh
	root@controller:~# openstack token issue
	```

	![Imgur](http://i.imgur.com/10Rg5Bd.png)

### 4. Cài đặt Glance
***
`Glance` là dịch vụ cung cấp các image (các hệ điều hành đã được đóng gói sẵn), các image này sử dụng theo cơ chế template để tạo ra các máy ảo. )
- Lưu ý: Thư mục chứa các file images trong hướng dẫn này là `/var/lib/glance/images/`


- Glance có các thành phần sau: 
 - glance-api:
 - glance-registry:
 - Database:
 - Storage repository for image file:
 - Metadata definition service


### 4.1. Tạo database và endpoint cho `glance`
***

#### 4.1.1 Tạo database cho `glance`
- Đăng nhập vào mysql
	```sh
	mysql -uroot -pWelcome123
	```

- Tạo database và gán các quyền cho user `glance` trong database glance
	```sh
	CREATE DATABASE glance;
	GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Welcome123';
	FLUSH PRIVILEGES;
		
	exit;
	```
#### 4.1.2. Cấu hình xác thực cho dịch vụ `glance`

- Khai báo biến môi trường `admin`: **source admin-openrc**
- Tạo user `glance` nhập lệnh sau, sau đó nhập mật khẩu cho user glance là `Welcome123`
	```sh
	openstack user create --domain default --password-prompt glance
	```

	![Imgur](http://i.imgur.com/3r4MeSN.png)

- Thêm role `admin` cho user `glane` và project `service`
	```sh
	openstack role add --project service --user glance admin
	```

- Kiểm tra lại xem user `glance` có role là gì

    ```sh
    openstack role list --user glance --project service
    ```

- Tạo dịch vụ có tên `glance`
	```sh 
	openstack service create --name glance \
  	--description "OpenStack Image" image
	```

	![Imgur](http://i.imgur.com/pXqAqWp.png)

- Tạo các endpoint cho dịch vụ `glance`
	```sh 
	openstack endpoint create --region RegionOne \
  	image public http://controller:9292
	```

	![Imgur](http://i.imgur.com/Su9o4DI.png)

	```sh
	openstack endpoint create --region RegionOne \
  	image internal http://controller:9292
	```

	![Imgur](http://i.imgur.com/S4kxjzu.png)

	```sh
	openstack endpoint create --region RegionOne \
  	image admin http://controller:9292
	```

	![Imgur](http://i.imgur.com/hr3cvL6.png)

#### 4.1.3. Cài đặt các gói và cấu hình cho dịch vụ `glance`

- Cài đặt gói `glance`
	```sh
	apt-get -y install glance
	```


- Sao lưu các file `/etc/glance/glance-api.conf` và file `/etc/glance/glance-registry.conf` trước khi cấu hình
	```sh
	cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf.orig
	cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.orig
	```

- Sửa các mục dưới đây ở cả file `/etc/glance/glance-api.conf` và file `/etc/glance/glance-registry.conf`
	- Trong section `[DEFAULT]`  thêm hoặc tìm và thay thế dòng cũ bằng dòng dưới để cho phép chế độ ghi log với `glance`
	 ```sh
	 verbose = true
	 ```

	- Trong section `[database]` :
 
 	- Comment dòng 
	 ```sh
	 #sqlite_db = /var/lib/glance/glance.sqlite
	 ```
 	- Thêm dòng dưới 
	 ```sh
	 connection = mysql+pymysql://glance:Welcome123@controller/glance
	 ```
	
	- Trong section `[keystone_authtoken]` và `[paste_deploy]`, cấu hình truy cập dịch vụ Identity:
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

	- Trong section `[glance_store]`, cấu hình lưu trữ file hệ thống cục bộ (local file system store) và vị trí của file `image` (mục này không phải làm trong file `/etc/glance/glance-registry.conf`):
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

- Khởi động lại dịch vụ `Glance`
	```sh
	service glance-registry restart
	service glance-api restart
	```
### 4.2. Kiểm chứng lại việc cài đặt `glance`
***

- Khai báo biến môi trường cho dịch vụ `glance`
	```sh
	source admin-openrc
	```

- Tải file image cho `glance`
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

	![Imgur](http://i.imgur.com/Utnuh9C.png)

- Kiểm tra lại image đã có hay chưa
	```sh
	openstack image list
	```

- Nếu kết quả lệnh trên hiển thị như bên dưới thì dịch vụ `glance` đã cài đặt thành công.
	![Imgur](http://i.imgur.com/wcbxPwJ.png)

### 5. Cài đặt NOVA (Compute service)
***

### 5.1. Tóm tắt về dịch vụ `nova` trong OpenStack
***
- Đây là bước cài đặt các thành phần của `nova` trên máy chủ `Controller`
- `nova` đảm nhiệm chức năng cung cấp và quản lý tài nguyên trong OpenStack để cấp cho các VM. Trong hướng dẫn nãy sẽ sử dụng KVM làm hypervisor. Nova sẽ tác động vào KVM thông qua `libvirt`

#### 5.2.1. Tạo database, tạo dịch vụ credentials và API endpoint cho `nova`

- Tạo database:
	- Đăng nhập vào database với quyền `root`
	```sh
	mysql -uroot -pWelcome123
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

- Khai báo biến môi trường
	```sh
	source admin-openrc
	```

- Tạo user, phân quyền và dịch vụ `nova`:
	- Tạo user `nova` dùng lệnh sau và nhập mật khẩu cho user là `Welcome123`:
		```sh
		openstack user create --domain default --password-prompt nova
		```
	
	![Imgur](http://i.imgur.com/CJZ4jwG.png)

	- Thêm role `admin` cho user `nova`:
		```sh
		openstack role add --project service --user nova admin
		```

	- Tạo dịch vụ `nova`:
		```sh
		openstack service create --name nova \
  		--description "OpenStack Compute" compute
		```

	![Imgur](http://i.imgur.com/aEevoV7.png)

- Tạo các endpoint:
	```sh
	openstack endpoint create --region RegionOne \
  	compute public http://controller:8774/v2.1
	```

	![Imgur](http://i.imgur.com/mAFyJCC.png)

	```sh
	openstack endpoint create --region RegionOne \
  	compute internal http://controller:8774/v2.1
	```

	![Imgur](http://i.imgur.com/0rV4cfd.png)

	```sh
	openstack endpoint create --region RegionOne \
  	compute admin http://controller:8774/v2.1
	```

	![Imgur](http://i.imgur.com/lHitBsN.png)

- Tạo user `placement`
	```sh
	openstack user create --domain default --password-prompt placement
	```

	![Imgur](http://i.imgur.com/lRm1cld.png)

- Thêm role `admin` cho user `placement` và project `service`:
	```sh
	openstack role add --project service --user placement admin
	```

- Tạo dịch vụ `placement`:
	```sh
	openstack service create --name placement --description "Placement API" placement
	```

	![Imgur](http://i.imgur.com/Zc2ylVM.png)

- Tạo endpoint cho `placement `
	```sh
	openstack endpoint create --region RegionOne placement public http://controller/placement
	```

	![Imgur](http://i.imgur.com/8KwHqqt.png)

	```sh
	openstack endpoint create --region RegionOne placement internal http://controller/placement
	```

	![Imgur](http://i.imgur.com/5vv964S.png)

	```sh
	openstack endpoint create --region RegionOne placement admin http://controller/placement
	```

	![Imgur](http://i.imgur.com/KWvOxVy.png)

#### 5.2.2. Cài đặt và cấu hình `nova`

- Cài đặt các gói:
	```sh
	apt-get -y install nova-api nova-conductor nova-consoleauth \
  nova-novncproxy nova-scheduler nova-placement-api
	```

- Sao lưu file `/etc/nova/nova.conf` trước khi cấu hình

	```sh
	cp /etc/nova/nova.conf /etc/nova/nova.conf.orig
	```

- Sửa file `/etc/nova/nova.conf`. 
- Lưu ý: Trong trường hợp nếu có dòng khai bao trước đó thì tìm và thay thế, chưa có thì khai báo mới hoàn toàn. 
- Trong `[api_database]` và `[database]` sections, cấu hình truy cập database:
	- Tìm và thay thế. Trong `[database]` phải khai báo thêm.  
	```sh
	[api_database]
	# ...
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
	my_ip = 10.10.10.61
	transport_url = rabbit://openstack:Welcome123@controller
	```

- Trong  `[api]` và `[keystone_authtoken]`, cấu hình dịch vụ identity:
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

- Trong `[vnc]`:
	```sh
	[vnc]
	enabled = true
	# ...
	vncserver_listen = $my_ip
	vncserver_proxyclient_address = $my_ip
	```

- Trong `[glance]`:
	```sh
	[glance]
	# ...
	api_servers = http://controller:9292
	```

- Trong `[oslo_concurrency]`:
	```sh
	[oslo_concurrency]
	# ...
	lock_path = /var/lib/nova/tmp
	```

- Trong `[placement]`, cấu hình Placement API:
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

-  Tạo database cho `nova_api`
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

- Tạo database cho `nova`
	```sh
	su -s /bin/sh -c "nova-manage db sync" nova
	```

- Kiểm tra lại nova cell0 và cell1 đã được đăng ký đúng hay chưa:
	```sh
	nova-manage cell_v2 list_cells
	```

	![Imgur](http://i.imgur.com/LCxnfWX.png)

#### 5.2.3. Kết thúc bước cài đặt và cấu hình `nova`
- Khởi động lại các dịch vụ của `nova` sau khi cài đặt & cấu hình `nova`
	```sh
	service nova-api restart
	service nova-consoleauth restart
	service nova-scheduler restart
	service nova-conductor restart
	service nova-novncproxy restart 
	```
- Khai báo biến môi trường: `source admin-openrc`
- Kiểm tra lại xem nova có hoạt động tốt hay không, thực hiện một số lệnh như trong các hình sau:
	
	![Imgur](http://i.imgur.com/PYJdv5Z.png)

	![Imgur](http://i.imgur.com/naCoo20.png)

	![Imgur](http://i.imgur.com/FGcHUZ4.png)


### 6. Cài đặt NEUTRON(Networking service)
***

### 6.1. Giới thiệu về `neutron`
***

### 6.2.1. Tạo database và endpoint cho neutron.
***

- Tạo database cho neutron
 	- Đăng nhập vào `neutron`
	 ```sh
	 mysql -uroot -pWelcome123
	 ```

	- Tạo database `neutron` và phân quyền:
	```sh
	CREATE DATABASE neutron;
	GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'Welcome123';
	GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'Welcome123';

	FLUSH PRIVILEGES;
	exit;
	```

- Tạo user, endpoint cho dịch vụ `neutron`
	- Khai báo biến môi trường
	 ```sh
	 source admin-openrc
	 ```

- Tạo tài khoản tên là `neutron` bằng lênh dưới, sau đó nhập mật khẩu `Welcome123`:
	 ```sh
	 openstack user create --domain default --password-prompt neutron
	 ```

	![Imgur](http://i.imgur.com/1wss2z3.png)

- Gán role `admin` cho tài khoản `neutron`
	```sh
	openstack role add --project service --user neutron admin
	```
- Tạo dịch vụ tên là `neutron`
	```sh
	openstack service create --name neutron \
  	--description "OpenStack Networking" network
	```

	![Imgur](http://i.imgur.com/lL2nZ3U.png)

- Tạo endpoint tên cho `neutron`
	```sh
	openstack endpoint create --region RegionOne network public http://controller:9696
	openstack endpoint create --region RegionOne network internal http://controller:9696
	openstack endpoint create --region RegionOne network admin http://controller:9696
	```

- Cài đặt và cấu hình cho dịch vụ `neutron`. Trong hướng dẫn này lựa chọn cơ chế self-service netwok
- Cài đặt các thành phần cho `neutron`
	```sh
	apt-get -y install neutron-server neutron-plugin-ml2 \
  	neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
  	neutron-metadata-agent
	```
- Cấu hình cho dịch vụ `neutron`
 	- Sao lưu file cấu hình gốc của `neutron`
	```sh
	cp /etc/neutron/neutron.conf  /etc/neutron/neutron.conf.orig
	```
- Trong section `[database]` comment dòng:
	 ```sh
	 # connection = sqlite:////var/lib/neutron/neutron.sqlite
	 ```
	 
 	và thêm dòng dưới

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
- Trong section `[nova]` khai báo mới hoặc thêm các dòng dưới
	```sh
	[nova]
	auth_url = http://controller:35357
	auth_type = password
	project_domain_name = default
	user_domain_name = default
	region_name = RegionOne
	project_name = service
	username = nova
	password = Welcome123
	```

- Cài đặt và cấu hình plug-in `Modular Layer 2 (ML2)`
- Sao lưu file `/etc/neutron/plugins/ml2/ml2_conf.ini`
	```sh
	cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.orig
	```

- Trong section `[ml2]` khai báo thêm hoặc sửa dòng dưới
	```sh
	[ml2]
	type_drivers = flat,vlan,vxlan
	tenant_network_types = vxlan
	mechanism_drivers = linuxbridge,l2population
	extension_drivers = port_security
 	```

- Trong section `[ml2_type_flat]` khai báo thêm hoặc sửa thành dòng dưới
	```sh
	[ml2_type_flat]
	flat_networks = provider
	```

- Trong section `[ml2_type_vxlan]` khai báo thêm hoặc sửa thành dòng dưới
	```sh
	[ml2_type_vxlan]
	vni_ranges = 1:1000
	```

- Trong section `[securitygroup]` khai báo thêm hoặc sửa thành dòng dưới
	```sh
	[securitygroup]
	enable_ipset = true
	```

- Cấu hình `linuxbridge`
- Sao lưu file  `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
	```sh
	cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini  /etc/neutron/plugins/ml2/linuxbridge_agent.ini.orig
	```

- Trong section `[linux_bridge]` khai báo mới hoặc sửa thành dòng
	 ```sh
	 physical_interface_mappings = provider:ens38
	 ```

- Trong section `[vxlan]` khai báo mới hoặc sửa thành dòng
	```sh
	enable_vxlan = true
	local_ip = 10.10.10.61
	l2_population = true
	```

- Trong section `[securitygroup]` khai báo mới hoặc sửa thành dòng
	```sh
	enable_security_group = true
	firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
	```

- Cấu hình `l3-agent`
 	- Sao lưu file `/etc/neutron/l3_agent.ini`
	```sh
	cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini.orig
	```

- Trong section `[DEFAULT]` khai báo mới hoặc sửa thành dòng dưới: 
	```sh
	interface_driver = linuxbridge
	```

- Cấu hình `DHCP Agent`
 	- Sao lưu file ` /etc/neutron/dhcp_agent.ini` gốc
	```sh
	cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.orig
	```

- Trong section `[DEFAULT]` khai báo mới hoặc sửa thành dòng dưới
	```sh
	interface_driver = linuxbridge
	dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
	enable_isolated_metadata = true
	```

- Cấu hình `metadata agent`
 	- Sao lưu file `/etc/neutron/metadata_agent.ini` 
	```sh
	cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.orig
	```

- Trong section `[DEFAULT]` khai báo mới hoặc sửa thành dòng dưới
	```sh
	nova_metadata_ip = controller
	metadata_proxy_shared_secret = Welcome123
	```
- Trong file `/etc/nova/nova.conf`
- Trong section `[neutron]` khai báo mới hoặc sửa thành dòng dưới (thêm section `[neutron]`):
	```sh
	[neutron]
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

- Kết thúc quá trình cài đặt `neutron` trên `controller` node
 	- Đồng bộ database cho `neutron`
	```sh
	su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
	```

- Khởi động lại `nova-api`
	```sh
	service nova-api restart
	```
- Khởi động lại các dịch vụ của `neutron`
	```sh
	service neutron-server restart
	service neutron-linuxbridge-agent restart
	service neutron-dhcp-agent restart
	service neutron-metadata-agent restart
	service neutron-l3-agent restart
	```

- Kiểm tra lại hoạt động của các dịch vụ trong `neutron`
	- Khai báo biến môi trường: `source admin-openrc`
	
```sh
openstack extension list --network

+---------------------------+---------------------------+----------------------------+
| Name                      | Alias                     | Description                |
+---------------------------+---------------------------+----------------------------+
| Default Subnetpools       | default-subnetpools       | Provides ability to mark   |
|                           |                           | and use a subnetpool as    |
|                           |                           | the default                |
| Availability Zone         | availability_zone         | The availability zone      |
|                           |                           | extension.                 |
| Network Availability Zone | network_availability_zone | Availability zone support  |
|                           |                           | for network.               |
| Port Binding              | binding                   | Expose port bindings of a  |
|                           |                           | virtual port to external   |
|                           |                           | application                |
| agent                     | agent                     | The agent management       |
|                           |                           | extension.                 |
| Subnet Allocation         | subnet_allocation         | Enables allocation of      |
|                           |                           | subnets from a subnet pool |
| DHCP Agent Scheduler      | dhcp_agent_scheduler      | Schedule networks among    |
|                           |                           | dhcp agents                |
| Tag support               | tag                       | Enables to set tag on      |
|                           |                           | resources.                 |
| Neutron external network  | external-net              | Adds external network      |
|                           |                           | attribute to network       |
|                           |                           | resource.                  |
| Neutron Service Flavors   | flavors                   | Flavor specification for   |
|                           |                           | Neutron advanced services  |
| Network MTU               | net-mtu                   | Provides MTU attribute for |
|                           |                           | a network resource.        |
| Network IP Availability   | network-ip-availability   | Provides IP availability   |
|                           |                           | data for each network and  |
|                           |                           | subnet.                    |
| Quota management support  | quotas                    | Expose functions for       |
|                           |                           | quotas management per      |
|                           |                           | tenant                     |
| Provider Network          | provider                  | Expose mapping of virtual  |
|                           |                           | networks to physical       |
|                           |                           | networks                   |
| Multi Provider Network    | multi-provider            | Expose mapping of virtual  |
|                           |                           | networks to multiple       |
|                           |                           | physical networks          |
| Address scope             | address-scope             | Address scopes extension.  |
| Subnet service types      | subnet-service-types      | Provides ability to set    |
|                           |                           | the subnet service_types   |
|                           |                           | field                      |
| Resource timestamps       | standard-attr-timestamp   | Adds created_at and        |
|                           |                           | updated_at fields to all   |
|                           |                           | Neutron resources that     |
|                           |                           | have Neutron standard      |
|                           |                           | attributes.                |
| Neutron Service Type      | service-type              | API for retrieving service |
| Management                |                           | providers for Neutron      |
|                           |                           | advanced services          |
| Tag support for           | tag-ext                   | Extends tag support to     |
| resources: subnet,        |                           | more L2 and L3 resources.  |
| subnetpool, port, router  |                           |                            |
| Neutron Extra DHCP opts   | extra_dhcp_opt            | Extra options              |
|                           |                           | configuration for DHCP.    |
|                           |                           | For example PXE boot       |
|                           |                           | options to DHCP clients    |
|                           |                           | can be specified (e.g.     |
|                           |                           | tftp-server, server-ip-    |
|                           |                           | address, bootfile-name)    |
| Resource revision numbers | standard-attr-revisions   | This extension will        |
|                           |                           | display the revision       |
|                           |                           | number of neutron          |
|                           |                           | resources.                 |
| Pagination support        | pagination                | Extension that indicates   |
|                           |                           | that pagination is         |
|                           |                           | enabled.                   |
| Sorting support           | sorting                   | Extension that indicates   |
|                           |                           | that sorting is enabled.   |
| security-group            | security-group            | The security groups        |
|                           |                           | extension.                 |
| RBAC Policies             | rbac-policies             | Allows creation and        |
|                           |                           | modification of policies   |
|                           |                           | that control tenant access |
|                           |                           | to resources.              |
| standard-attr-description | standard-attr-description | Extension to add           |
|                           |                           | descriptions to standard   |
|                           |                           | attributes                 |
| Port Security             | port-security             | Provides port security     |
| Allowed Address Pairs     | allowed-address-pairs     | Provides allowed address   |
|                           |                           | pairs                      |
| project_id field enabled  | project-id                | Extension that indicates   |
|                           |                           | that project_id field is   |
|                           |                           | enabled.                   |
+---------------------------+---------------------------+----------------------------+
```

![Imgur](http://i.imgur.com/s7xDXeg.png)

### 7. Cài đặt HORIZON (dashboad)
***
- HORIZON hay còn gọi là dashboad - cung cấp giao diện trên web để người dùng có thể sử dụng OpenStack

#### 7.1. Cài đặt và cấu hình HORIZON (dashboad)
***

- Cài đặt các thành phần cho dashboad
	```sh
	apt-get -y install openstack-dashboard
	```

- Sao lưu lại file cấu hình cho dashboad 

	```sh
	cp /etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py.orig
	```

- Tìm các dòng sau trong file ` /etc/openstack-dashboard/local_settings.py` và chỉnh sửa như bên dưới

```sh
OPENSTACK_HOST = "controller"
```

```sh
ALLOWED_HOSTS = ['*', ]
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

- Khởi động lại apache
```sh
chown www-data:www-data /var/lib/openstack-dashboard/secret_key 
service apache2 restart
```

- Vào trình duyệt nhập địa chỉ `http://10.10.10.61/horizon` để kiểm tra kêt quả

