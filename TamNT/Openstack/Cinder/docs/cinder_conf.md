# Một số ghi chép cấu hình Cinder

File cấu hình của Cinder nằm trong thư mục `/etc/cinder/cinder.conf`

## 1. Giải thích một số cấu hình khi cài đặt 

- Section `[DEFAULT]`
	
	`transport_url = rabbit://openstack:RABBIT_PASS@controller`

	Cấu hình url cho các message điều khiển sử dụng rabbitmq làm bộ trung gian giao tiếp giữa các node.
	
	`auth_strategy = keystone`

	Cấu hình xác thực sử dụng Keystone.
	
	`my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS`

	Cấu hình địa chỉ IP của node để tiện theo dõi.
	
	`volume_name_template = volume-%s`

	Template mẫu sử dụng để tạo tên cho các volume (tên volume bắt đầu bằng `“volume- “` )
	
	`enabled_backends = lvm`

	- Cấu hình backend muốn sử dụng, ở đây là LVM
	
	- Đối với multiple backend có thể liệt kê các backend dùng, chỉ cần dấu phẩy giữa các backend (ví dụ : `enable_backends = lvm,nfs,glusterfs`)

	`glance_api_servers = http://controller:9292`

	API cung cấp image. (sử dụng để upload image nếu muốn volume dùng để boot được máy ảo)

- Section `[database]`:

	```
	[database]
	# ...
	connection = mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder
	```

	Cấu hình kết nối với database trên `controller` node để lưu trữ và truy xuất dữ liệu

- Section `[keystone_authtoken]`

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
	username = cinder
	password = CINDER_PASS
	```
	
	Cấu hình dịch vụ xác thực sử dụng Keystone và định danh cho service cinder. 

- Section `[lvm]`

	```
	[lvm]
	# ...
	volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
	volume_group = cinder-volumes
	iscsi_protocol = iscsi
	iscsi_helper = tgtadm
	```

	Cấu hình backend sử dụng lvm, chia sẻ volume group mặc định là `cinder-volumes`, sử dụng giao thức iCSI để kết nối giữa compute và cinder được tạo ra với tgtadm.

## 2.	Volume drive:

Cấu hình mặc định cho volume backend là sử dụng local volumes quản lý bởi LVM. Driver này hỗ trợ giao thức iCSI.

Cấu hình trong file `cinder.conf` như sau: 

	```
	[DEFAULT]
	# …
	volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
	iscsi_protocol = iscsi
	lvm_type = default		# Loại lvm volume (default, thin, hoặc auto)
	volume_group = cinder-volumes	# tên của volume group đã tạo cho lvm
	```

## 3.	Cấu hình giới hạn quota

Sau đây là một số tùy chọn giới hạn quota trên service Cinder, cấu hình tại section [DEAULT]:

![img](../images/1.3.png)

## Tham khảo

https://docs.openstack.org/ocata/config-reference/block-storage.html  



