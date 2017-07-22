# Cinder command


# MỤC LỤC


# 1.cinder command
\- Tham khảo:
https://docs.openstack.org/python-cinderclient/latest/man/cinder.html  
\- Create volume  
- Tạo volume không gắn image  
```
cinder create --name volumetest --description "This is volume test" 5
```

(5 ở đây chỉ 5G)  
<img src="../images/9.png" />

- Tạo volume gắn image  
```
cinder create --name volumetest --description "This is volume test" --image cirros 5
```

or
```
cinder create --name volumetest --description "This is volume test" –image-id 00dd2fdb-7783-4ae3-88f4-3140f00bd6d1 5
```

- Tạo volume từ volume snapshot  
```
cinder create --name volumetest --description "This is volume test" --snapshot-id e6ece5dd-dc2c-41bb-9ec9-09e40270622e 5
```

>Note: Kích thước của volume mới phải bằng hoặc lớn hơn kích thước của bản snapshot

\- Delete volume  
```
cinder delete <volume-name_or_volume-id>
```

>Note: Không thể xóa volume nếu chưa xóa hết các bản snapshot của volume đó.

\- List volumes  
```
cinder list
```

<img src="../images/10.png" />

\- Show thông tin về volume  
```
cinder show <volume-id_or_volume-name>
```

```
root@controller:~# cinder show volumetest
+--------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Property                       | Value                                                                                                                                                                                                                                 |
+--------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| attachments                    | []                                                                                                                                                                                                                                    |
| availability_zone              | nova                                                                                                                                                                                                                                  |
| bootable                       | true                                                                                                                                                                                                                                  |
| consistencygroup_id            | None                                                                                                                                                                                                                                  |
| created_at                     | 2017-07-20T13:49:24.000000                                                                                                                                                                                                            |
| description                    | This is volume test                                                                                                                                                                                                                   |
| encrypted                      | False                                                                                                                                                                                                                                 |
| id                             | 9daa6817-2c03-46dd-94d6-2e5d832d3d7c                                                                                                                                                                                                  |
| metadata                       | {}                                                                                                                                                                                                                                    |
| migration_status               | None                                                                                                                                                                                                                                  |
| multiattach                    | False                                                                                                                                                                                                                                 |
| name                           | volumetest                                                                                                                                                                                                                            |
| os-vol-host-attr:host          | block1@lvm#LVM                                                                                                                                                                                                                        |
| os-vol-mig-status-attr:migstat | None                                                                                                                                                                                                                                  |
| os-vol-mig-status-attr:name_id | None                                                                                                                                                                                                                                  |
| os-vol-tenant-attr:tenant_id   | 72df503c6f7644bf86e642c031daa7db                                                                                                                                                                                                      |
| replication_status             | None                                                                                                                                                                                                                                  |
| size                           | 5                                                                                                                                                                                                                                     |
| snapshot_id                    | None                                                                                                                                                                                                                                  |
| source_volid                   | None                                                                                                                                                                                                                                  |
| status                         | available                                                                                                                                                                                                                             |
| updated_at                     | 2017-07-20T13:49:32.000000                                                                                                                                                                                                            |
| user_id                        | 97a6768ecb66490cbd5c27155f32c5f7                                                                                                                                                                                                      |
| volume_image_metadata          | {'container_format': 'bare', 'min_ram': '0', 'disk_format': 'qcow2', 'image_name': 'cirros', 'image_id': '00dd2fdb-7783-4ae3-88f4-3140f00bd6d1', 'checksum': 'f8ab98ff5e73ebab884d80c9dc9c7290', 'min_disk': '0', 'size': '13267968'} |
| volume_type                    | None                                                                                                                                                                                                                                  |
+--------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

\- Đổi tên volume  
```
cinder rename [--description <description>] <volume-id_or_volume-name> [<volume-new-name>]
```

\- Mở rộng volume  
```
cinder extend <volume-id_or_volume-name> <new_size>
```

new_size : đơn vị GB.

\- Tạo image từ volume  
- Cú pháp:  
```
cinder upload-to-image [--force [<True|False>]]
                              [--container-format <container-format>]
                              [--disk-format <disk-format>]
                              <volume> <image-name>
```

- Ví dụ:  
```
cinder upload-to-image --disk-format qcow2 test son1
```

<img src="../images/11.png" />

\- Create snapshot  
- Cú pháp:  
```
cinder snapshot-create [--force [<True|False>]] [--name <name>]
                              [--description <description>]
                              [--metadata [<key=value> [<key=value> ...]]]
                              <volume>
```

- Ví dụ:  
```
cinder snapshot-create --name volume-backup volumetest
```

<img src="../images/12.png" />

\- Delete snapshot  
```
cinder snapshot-delete [--force] <snapshot> [<snapshot> ...]
```

\- List snapshot  
- List all snapshot
```
cinder snapshot-list
```

<img src="../images/13.png" />

- List các bản snapshot của 1 volume  
```
cinder snapshot-list [--volume-id <volume-id>]
```

<img src="../images/14.png" />

\- Show thông tin về snapshot  
```
cinder snapshot-show <volume-id_or_volume-name>
```

<img src="../images/15.png" />

\- Sửa thông tin bản snapshot  
```
cinder snapshot-rename [--description <description>]
                              <snapshot> [<name>]
```







