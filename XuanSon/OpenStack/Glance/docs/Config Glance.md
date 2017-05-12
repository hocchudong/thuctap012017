# Config Glance

# MỤC LỤC





<a name="1"></a>
# 1.File /etc/glance/glance-api.conf
\- In the `[database]` section, configure database access:  
```
[database]
# ...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
```

Replace `GLANCE_DBPASS` with the password you chose for the Image service database.  
\- In the `[keystone_authtoken]` and `[paste_deploy]` sections, configure Identity service access:  
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

Replace `GLANCE_PASS` with the password you chose for the glance user in the Identity service.

>Note  
Comment out or remove any other options in the [keystone_authtoken] section.  

\- In the `[glance_store]` section, configure the local file system store and location of image files:  
```
[glance_store]
# ...
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
```

<a name="2"></a>
# 2.File /etc/glance/glance-registry.conf
\- In the `[database]` section, configure database access:  
```
[database]
# ...
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
```

Replace `GLANCE_DBPASS` with the password you chose for the Image service database.  
\- In the `[keystone_authtoken]` and `[paste_deploy]` sections, configure Identity service access:  
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

Replace `GLANCE_PASS` with the password you chose for the glance user in the Identity service.

>Note  
Comment out or remove any other options in the `[keystone_authtoken]` section.  

<a name="3"></a>
# 3.File log của glance
Mặc định Glance có hai file nhật ký lưu trong thư mục `/var/log/glance/`:  
- **glance-api.log**: ghi lại lịch sử truy cập api server
- **glance-registry.log** : ghi lại lịch sử liên quan tới registry server
