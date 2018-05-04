# Giải thích file cấu hình cơ bản của manila

## 1. Back end là LVM
---
- File cấu hình manila trên node controller `/etc/manila/manila.conf`

```
[DEFAULT]
transport_url = rabbit://openstack:Welcome123@controller
default_share_type = default_share_type
share_name_template = share-%s
rootwrap_config = /etc/manila/rootwrap.conf
api_paste_config = /etc/manila/api-paste.ini
auth_strategy = keystone
my_ip = 10.10.10.190

[database]
connection = mysql+pymysql://manila:Welcome123@controller/manila

[keystone_authtoken]
memcached_servers = controller:11211
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = manila
password = Welcome123

[oslo_concurrency]
lock_path = /var/lock/manila
```

- Trong section `[DEFAULT]`
	- `transport_url = rabbit://openstack:Welcome123@controller`: khai báo truy cập rabbitMq
	- `default_share_type = default_share_type`: đây là kiểu share mặc định khi mà share được tạo mà không chỉ rõ kiểu share trong request tạo. Ở đây kiểu mặc định là default_share_type
	- `rootwrap_config = /etc/manila/rootwrap.conf`: đường dẫn đến file rootwrap
	- `auth_strategy = keystone`: Khai báo xác thực bằng keystone
	- `my_ip = 10.10.10.190`: địa chỉ ip cho admin trên node controller.
- Trong section `[database]`, khai báo kết nối đến database cho manila
- Trong section `[keystone_authtoken]` khai báo các thông tin xác thực cho user admin của manila
- Trong section `[oslo_concurrency]` khai báo thư mục đường dẫn đến thư mục lock.

----
- File cấu hình trên manila-share

```
[DEFAULT]
transport_url = rabbit://openstack:Welcome123@controller
default_share_type = default_share_type
rootwrap_config = /etc/manila/rootwrap.conf
auth_strategy = keystone
my_ip = 10.10.10.195
enabled_share_backends = lvm
enabled_share_protocols = NFS

[database]
connection = mysql+pymysql://manila:Welcome123@controller/manila

[keystone_authtoken]
memcached_servers = controller:11211
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = manila
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/manila/tmp

[lvm]
share_backend_name = LVM
share_driver = manila.share.drivers.lvm.LVMShareDriver
driver_handles_share_servers = False
lvm_share_volume_group = manila-volumes
lvm_share_export_ip = 172.16.69.195
```

- Trong section `[DEFAULT]`:
	- `transport_url = rabbit://openstack:Welcome123@controller` khai báo truy cập RabbitMQ
	- `default_share_type = default_share_type` tương tự như trên controller
	- `rootwrap_config = /etc/manila/rootwrap.conf` đường dẫn đến file rootwrap
	- `auth_strategy = keystone` xác thực bằng keystone
	- `my_ip = 10.10.10.195` địa chỉ Ip của node manila-share
	- `enabled_share_backends = lvm` enable back end được sử dụng để lưu trữ share, cần tạo một section với tên `lvm` ở cuối file để khai báo các thông tin cấu hình cho back end LVM
	- `enabled_share_protocols = NFS` enable giao thức được sử dụng để truy cập share
- Section `[database]` khai báo truy cập database manila
- Section `[keystone_authtoken]` khai báo các thông tin xác thực user admin của manila
- Section `[oslo_concurrency]` khai báo thư mục đường dẫn đến thư mục lock.
- Section `[lvm]` Khai báo các thông tin cấu hình cho back end lvm
	- `share_backend_name = LVM`: khai báo tên back end là `LVM`
	- `share_driver = manila.share.drivers.lvm.LVMShareDriver` khai báo driver hỗ trợ back end LVM
	- `driver_handles_share_servers = False` không sử dụng driver xử lý share server  
	- `lvm_share_volume_group = manila-volumes`: Khai báo một volume-groups được sử dụng để tạo các share.
	- `lvm_share_export_ip = 172.16.69.195`: đây là địa chỉ ip mà share được export, các VM sẽ thông qua địa chỉ này để truy cập share.
	
---

## 2. Back end là glusterfs
- Sẽ có các phần tương tự như ở back end LVM. Sau đây sẽ giải thích các phần khác được sử dụng cho back end glusterfs
- file cấu hình trên node controller

```
[DEFAULT]
transport_url = rabbit://openstack:Welcome123@controller
default_share_type = default_share_type
share_name_template = share-%s
rootwrap_config = /etc/manila/rootwrap.conf
api_paste_config = /etc/manila/api-paste.ini
auth_strategy = keystone
my_ip = 10.10.10.190
enabled_share_protocols=NFS,CIFS,GLUSTERFS  

[database]
connection = mysql+pymysql://manila:Welcome123@controller/manila

[keystone_authtoken]
memcached_servers = controller:11211
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = manila
password = Welcome123

[oslo_concurrency]
lock_path = /var/lock/manila
```

- `enabled_share_protocols=NFS,CIFS,GLUSTERFS` khai báo những giao thức được sử dụng để truy cập share.

- File cấu hình trên node manila-share

```
[DEFAULT]
transport_url = rabbit://openstack:Welcome123@controller
default_share_type = default_share_type
rootwrap_config = /etc/manila/rootwrap.conf
auth_strategy = keystone
my_ip = 10.10.10.195
enabled_share_backends = glusterfsnative
enabled_share_protocols = NFS,CIFS,GLUSTERFS

[database]
connection = mysql+pymysql://manila:Welcome123@controller/manila

[keystone_authtoken]
memcached_servers = controller:11211
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = manila
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/manila/tmp

[glusterfsnative]
share_backend_name = glusterfsnative
glusterfs_servers = root@glusterfs-1
glusterfs_server_password = PASSWORD_USER_ROOT
glusterfs_volume_pattern = manila-#{size}-.* 
share_driver = manila.share.drivers.glusterfs.glusterfs_native.GlusterfsNativeShareDriver 
driver_handles_share_servers = False
```

- Trong section `[DEFAULT]`:
	- `enabled_share_backends = glusterfsnative` khai báo back end
	- `enabled_share_protocols = NFS,CIFS,GLUSTERFS` các giao thức có thể truy cập share
	
- Section `[glusterfsnative]`:
	- `share_backend_name = glusterfsnative` khai báo tên back end
	- `glusterfs_servers = root@glusterfs-1`: khai báo user root của server glusterfs-1. Thông tin này được sử dụng để ssh từ manila-share sang glusterfs-1
	- `glusterfs_server_password = PASSWORD_USER_ROOT`: PASSWORD_USER_ROOT là mật khẩu của user root trên glusterfs-1.
	- `glusterfs_volume_pattern = manila-#{size}-.* `: pattern volume trên manila khi tạo share mapping với volume trên glusterfs 
	- `share_driver = manila.share.drivers.glusterfs.glusterfs_native.GlusterfsNativeShareDriver` : khai báo driver mà glusterfs hỗ trợ
	- `driver_handles_share_servers = False` không sử dụng driver xử lý share server  


