# 7.Config Nova

# MỤC LỤC
- [Controller](#7.1)
- [Compute](#7.2)


\- Sau đây là các dòng cấu hình cơ bản để cài đặt nova.  

<a name="7.1"></a>
## 7.1.File /etc/nova/nova.conf trên node controller
\- Trong `[api_database]` và `[database]` sections, cấu hình truy cập database:  
```
[api_database]
# ...
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api

[database]
# ...
connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova
```

Thay  `NOVA_DBPASS` với mật khẩu bạn chọn cho Compute databases.  

\- Trong `[DEFAULT]` section, cấu hình truy cập RabbitMQ message queue:  
```
[DEFAULT]
# ...
transport_url = rabbit://openstack:RABBIT_PASS@controller
```

Thay `RABBIT_PASS` bằng mật khẩu bạn cho account openstack trong RabbitMQ.  

\- Trong `[api]` và `[keystone_authtoken]` sections, cấu hình truy cập Identity service:  
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
password = NOVA_PASS
```

Thay `NOVA_PASS` bằng mật khẩu bạn cho nova user trong Identity service.  

>Chú ý: 
Comment hoặc xóa bất kỳ options nào khác trong `[keystone_authtoken]` section.

\- Trong `[DEFAULT]` section, cấu hình `my_ip` option sử dụng để management interface IP address của node controller:  
```
[DEFAULT]
# ...
my_ip = 10.0.0.11
```

Thay `10.0.0.11` với địa chỉ IP dùng để quản lý của node controller.  

\- Trong `[DEFAULT]` section, enable hỗ trợ Networking service:  
```
[DEFAULT]
# ...
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
```

>Note:  
Mặc định, Compute sử dụng internal firewall driver. Từ khi Networking service bao gồm firewall driver, bạn phải disable Compute firewall driver bằng cách sử dụng `nova.virt.firewall.NoopFirewallDriver` firewall driver.

\- Trong `[vnc]` section, cấu hình VNC proxy để sử dụng địa chỉ IP interface quản lý của node controller:  
```
[vnc]
enabled = true
# ...
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
```

\- Trong `[glance]` section, cấu hình để xác định vị trí của Image service API:  
```
[glance]
# ...
api_servers = http://controller:9292
```

\- Trong `[oslo_concurrency]` section, cấu hình lock path:  
```
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp
```

\- Do bug, xóa bỏ `log_dir` option từ `[DEFAULT]` section.  

\- Trong `[placement]` section, cấu hình Placement API:  
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
password = PLACEMENT_PASS
```

Thay `PLACEMENT_PASS` với password bạn cho cho placement user trong Identity service. Comment bất kỳ option nào trong `[placement]` section.

<a name="7.2"></a>
## 7.2.File /etc/nova/nova.conf trên node compute
\- Trong `[DEFAULT]` section, cấu hình truy cập RabbitMQ message queue :  
```
[DEFAULT]
# ...
transport_url = rabbit://openstack:RABBIT_PASS@controller
```

Thay thế `RABBIT_PASS` với password bạn chọn cho account openstack trong RabbitMQ.  

\- Trong `[api]` và `[keystone_authtoken]` sections, cấu hình truy cập Identity service:  
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
password = NOVA_PASS
```

Thay thế `NOVA_PAS`S với password bạn chọn cho nova user trong Identity service.  

>Note
Comment hoặc xóa bất kỳ tùy chọn nào trong [keystone_authtoken] section.  

\- Trong `[DEFAULT]` section, cấu hình `my_ip` option:  
```
[DEFAULT]
# ...
my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
```

Thay thế `MANAGEMENT_INTERFACE_IP_ADDRESS` với địa chỉ IP của management network interface trên node compute.  

\- Trong `[DEFAULT]` section, enable support cho Networking service:  
```
[DEFAULT]
# ...
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
```

>Note:  
Mặc định, Compute sử dụng internal firewall driver. Từ khi Networking service bao gồm firewall driver, bạn phải disable Compute firewall driver bằng cách sử dụng `nova.virt.firewall.NoopFirewallDriver` firewall driver.

\- Trong `[vnc]` section, enable và cấu hình truy cập remote console:  
```
[vnc]
# ...
enabled = True
# Server lằng nghe tất cả các địa chỉ IP
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html
```

\- Trong `[glance]` section, cấu hình để xác định vị trí của Image service API:  
```
[glance]
# ...
api_servers = http://controller:9292
```

\- Trong `[oslo_concurrency]` section, cấu hình lock path:  
```
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp
```

\- Do bug, xóa bỏ `log_dir` option từ `[DEFAULT]` section.  

\- Trong `[placement]` section, cấu hình Placement API:  
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
password = PLACEMENT_PASS
```

Thay `PLACEMENT_PASS` với password bạn cho cho placement user trong Identity service. Comment bất kỳ option nào trong `[placement]` section.








