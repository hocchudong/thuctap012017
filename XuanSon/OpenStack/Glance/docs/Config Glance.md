# Config Glance

# MỤC LỤC
- [1.File /etc/glance/glance-api.conf](#1)
- [2.File /etc/glance/glance-registry.conf](#2)
- [3.File log của glance](#3)



<a name="1"></a>
# 1.File /etc/glance/glance-api.conf
\- Trong `[database]` section, cấu hình access database:  
```
[database]
# ...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
```

Thay `GLANCE_DBPASS` với password bạn chọn cho Image service database.  
\- Trong `[keystone_authtoken]` và `[paste_deploy]` sections, cấu hình access Identity service :  
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
password = GLANCE_PASS

[paste_deploy]
# ...
flavor = keystone
```

Thay `GLANCE_PASS` với password bạn chọn cho glance user trong Identity service.

>Note  
Comment out hoặc remove bất kỳ options trong `[keystone_authtoken]` section.  

\- Trong `[glance_store]` section, cấu hình local file system store và vị trí của image files:  
```
[glance_store]
# ...
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
```

<a name="2"></a>
# 2.File /etc/glance/glance-registry.conf
\- Trong `[database]` section, cấu hình database access:  
```
[database]
# ...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
```

Thay `GLANCE_DBPASS` với password bạn chọn cho Image service database.  
\- Trong `[keystone_authtoken]` và `[paste_deploy]` sections, cấu hình Identity service access:  
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
password = GLANCE_PASS

[paste_deploy]
# ...
flavor = keystone
```

Thay `GLANCE_PASS` với password bạn chọn cho glance user trong Identity service.

>Note  
Comment out hoặc remove bất kỳ options trong `[keystone_authtoken]` section.  

<a name="3"></a>
# 3.File log của glance
Mặc định Glance có hai file nhật ký lưu trong thư mục `/var/log/glance/`:  
- **glance-api.log**: ghi lại lịch sử truy cập api server
- **glance-registry.log** : ghi lại lịch sử liên quan tới registry server
