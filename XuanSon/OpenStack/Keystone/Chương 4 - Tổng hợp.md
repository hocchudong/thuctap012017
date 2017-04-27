# Chương 4 - Tổng hợp


# MỤC LỤC
- [1.Keystone’s Components](#1)
- [2.Keystone workflow](#2)
- [3.Config Keystone](#3)
- [4.Keystone command line](#4)










<a name="1"></a>
# 1.Keystone’s Components  
Các thành phần của Keystone bao gồm :  
- User
- Project (Tenant)
- Role
- Domain
- Token
- Service: An OpenStack service, such as Compute (Nova), Object Storage (Swift), or Image Service (Glance), provides one or more endpoints through which users can access resources and perform operations.
- Endpoint: An endpoint is a network-accessible address, usually described by URL, from which services are accessed.

<a name="2"></a>
# 2.Keystone workflow  
<img src="http://imgur.com/3Bcjo1t.png" />  

<img src="http://imgur.com/3TPxgVH.png" />  

<img src="http://imgur.com/0jHV8Hh.png" />  

<a name="3"></a>
# 3.Config Keystone
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

\- Ngoài ra bạn có thể cấu hình tham các attribute:  
- số key tối đa dùng cho fernet (max_active_key)
- hạn sử dụng của một token (expiration_time)
- Time to cache identity data (cache_time) , ví dụ sử dụng horizon để truy cập openstack, thì cache_time là thuộc tính chỉ định thời gian lưu trữ token trong cache của web brower.
- Time to cache the revocation list and the revocation events (revocation_cache_time)
- Cấu hình access Keystone sử dụng ssl.

<a name="4"></a>
# 4.Keystone command line
Tham khảo:  
https://docs.openstack.org/developer/keystone/man/keystone-manage.html 
















