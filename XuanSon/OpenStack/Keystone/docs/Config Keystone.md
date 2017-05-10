# Config Keystone


# MỤC LỤC




Tham khảo: https://docs.openstack.org/ocata/config-reference/identity.html  
Config Keystone trong file `/etc/keystone/keystone.conf`  
\- In the `[database]` section, configure database access:  
```
[database]
# ...
connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone
```

Replace `KEYSTONE_DBPASS` with the password you chose for the database.

>Note  
Comment out or remove any other connection options in the [database] section.

\- In the [token] section, configure the Fernet token provider:  
```
[token]
# ...
provider = fernet
```

Bạn có thể thế fernet bởi `uuid`, `pki` hoặc `pkiz`.  

\- Trên là các attribute bắt buộc phải cấu hình, ngoài ra bạn có thể cấu hình thêm các attribute sau:  
- số key tối đa dùng cho fernet (`max_active_keys`)  
Trong section `[fernet_tokens]` ,thêm dòng:  
```
max_active_keys = 3
```

Ở đây ta để số key max bằng 3.  
- Hạn sử dụng của một token (`expiration`)  
Trong section `[tokens]` ,thêm dòng:  
```
expiration = 3600
```

ở đây ta để thời hạn sử dụng token là 1h.  
- Time to cache identity data (`cache_time`)  
Ví dụ sử dụng horizon để truy cập openstack, thì `cache_time` là thuộc tính chỉ định thời gian lưu trữ token trong memcache của server.  
Trong section `[identity]`,thêm dòng:  
```
cache_time = 600
```

Thời gian lưu trữ ở đây là 600s.  
- Time to cache the revocation list and the revocation events (`cache_time`)  
Trong section `[revoke]`,thêm dòng:  
```
cache_time = 3600
```

Thời gian lưu trữ ở đây là 3600s.  
- Cấu hình access Keystone sử dụng ssl.



















