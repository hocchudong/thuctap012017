# Nova - Quản lý quotas




# 6.Quản lý quotas
## 6.1.Khái niệm
\- Quota là khái niệm chỉ sự giới hạn resource.  
\- Nó cho biết số resource được cho phép trên mỗi project.  
\- Được định nghĩa trong file cấu hình: `/etc/nova/nova.conf`.  
## 6.2.Cấu hình
\- Từ phiên bản OpenStack Ocata trở về trước, **quota** được cấu hình trong section `[DEFAULT]`với các thông số như sau:  
```
# Number of instances allowed per project (integer value)
quota_instances=10
# Number of instance cores allowed per project (integer value)
quota_cores=20
# Megabytes of instance RAM allowed per project (integer value)
quota_ram=51200
# Number of floating IPs allowed per project (integer value)
quota_floating_ips=10
# Number of fixed IPs allowed per project (this should be at least the number
# of instances allowed) (integer value)
quota_fixed_ips=-1
# Number of metadata items allowed per instance (integer value)
quota_metadata_items=128
# Number of injected files allowed (integer value)
quota_injected_files=5
# Number of bytes allowed per injected file (integer value)
quota_injected_file_content_bytes=10240
# Length of injected file path (integer value)
quota_injected_file_path_length=255
# Number of security groups per project (integer value)
quota_security_groups=10
# Number of security rules per security group (integer value)
quota_security_group_rules=20
# Number of key pairs per user (integer value)
quota_key_pairs=100
```

\- Trong phiên bản OpenStack Ocata, **quota** được cấu hình tương tự trong section `[quota]` , tham khảo tại : 
https://docs.openstack.org/ocata/config-reference/compute/config-options.html 
\- Nếu muốn thay đổi quota, ta phải cấu hình trong file `/etc/nova/nova.conf` và restart lại các service nova.  
## 6.3.Các command liên quan
\- Show thông tin về quota:  
```
nova quota-show
```

<img src="../images/nova-quotas1.png" />

Hoặc bạn có thể xem trong dashboard:  
<img src="../images/nova-quotas2.png" />

\- Thay đổi quota cho 1 project riêng biệt:  
```
nova quota-update 16f44d2a075a4139a2a5425a42f1b447 --instances 4
```









