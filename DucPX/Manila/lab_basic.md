# Thực hành lab các tính năng trong Manila với back end LVM

# Mục lục
- [1. Tạo share](#1)
- [2. Kiểm soát truy cập share](#2)
- [3. Thay đổi kích thước của share](#3)
- [4. Xóa share](#4)


<a name=1></a>
## 1. Tạo share
- Khi tạo share cần lưu ý các tham số khi tạo share: kích thước share và giao thức để truy cập share (NFS, CIFS, etc)
- Sau khi share được tạo xong và đã available, sử dụng `manila show <share-name>` để lấy vị trí và share được export.
- Tiếp theo tạo rules để truy cập share
- Mount và sử dụng share.
- Trước khi tạo share, kiểm tra lại các kiểu share có trong hệ thống

```
root@controller:~# manila type-list
+--------------------------------------+--------------------+------------+------------+--------------------------------------+----------------------+
| ID                                   | Name               | visibility | is_default | required_extra_specs                 | optional_extra_specs |
+--------------------------------------+--------------------+------------+------------+--------------------------------------+----------------------+
| de80850d-1a91-4bc3-9b71-f30075c758e9 | default_share_type | public     | YES        | driver_handles_share_servers : False |                      |
+--------------------------------------+--------------------+------------+------------+--------------------------------------+----------------------+
```

- Tạo một share mới với tên `Share1`, giao thức truy cập `nfs`, kích thước `1GB` và kiểu share `default_share_type`

```
root@controller:~# manila create nfs 1 --name Share1 --description "My share" --share-type default_share_type
+---------------------------------------+--------------------------------------+
| Property                              | Value                                |
+---------------------------------------+--------------------------------------+
| status                                | creating                             |
| share_type_name                       | default_share_type                   |
| description                           | My share                             |
| availability_zone                     | None                                 |
| share_network_id                      | None                                 |
| share_server_id                       | None                                 |
| share_group_id                        | None                                 |
| host                                  |                                      |
| revert_to_snapshot_support            | False                                |
| access_rules_status                   | active                               |
| snapshot_id                           | None                                 |
| create_share_from_snapshot_support    | False                                |
| is_public                             | False                                |
| task_state                            | None                                 |
| snapshot_support                      | False                                |
| id                                    | 5246e4d8-d47d-4425-9f6b-0d6717733eb5 |
| size                                  | 1                                    |
| source_share_group_snapshot_member_id | None                                 |
| user_id                               | de6faf4fb0484e90a21bd63c4cffa465     |
| name                                  | Share1                               |
| share_type                            | de80850d-1a91-4bc3-9b71-f30075c758e9 |
| has_replicas                          | False                                |
| replication_type                      | None                                 |
| created_at                            | 2017-11-30T02:25:02.000000           |
| share_proto                           | NFS                                  |
| mount_snapshot_support                | False                                |
| project_id                            | ca6e13d11f564a90aca3cd13c6eaf8e7     |
| metadata                              | {}                                   |
+---------------------------------------+--------------------------------------+
```

- Kiểm tra trạng thái của share

```
root@controller:~# manila show Share1
+---------------------------------------+-------------------------------------------------------------------------------------+
| Property                              | Value                                                                               |
+---------------------------------------+-------------------------------------------------------------------------------------+
| status                                | available                                                                           |
| share_type_name                       | default_share_type                                                                  |
| description                           | My share                                                                            |
| availability_zone                     | nova                                                                                |
| share_network_id                      | None                                                                                |
| export_locations                      |                                                                                     |
|                                       | path = 172.16.69.195:/var/lib/manila/mnt/share-e0aefdf9-ab5e-4a78-907c-17e089700cee |
|                                       | preferred = False                                                                   |
|                                       | is_admin_only = False                                                               |
|                                       | id = a6c2eff6-aa2f-455c-953f-1d1d049e53b0                                           |
|                                       | share_instance_id = e0aefdf9-ab5e-4a78-907c-17e089700cee                            |
| share_server_id                       | None                                                                                |
| share_group_id                        | None                                                                                |
| host                                  | manila@lvm#lvm-single-pool                                                          |
| revert_to_snapshot_support            | False                                                                               |
| access_rules_status                   | active                                                                              |
| snapshot_id                           | None                                                                                |
| create_share_from_snapshot_support    | False                                                                               |
| is_public                             | False                                                                               |
| task_state                            | None                                                                                |
| snapshot_support                      | False                                                                               |
| id                                    | 5246e4d8-d47d-4425-9f6b-0d6717733eb5                                                |
| size                                  | 1                                                                                   |
| source_share_group_snapshot_member_id | None                                                                                |
| user_id                               | de6faf4fb0484e90a21bd63c4cffa465                                                    |
| name                                  | Share1                                                                              |
| share_type                            | de80850d-1a91-4bc3-9b71-f30075c758e9                                                |
| has_replicas                          | False                                                                               |
| replication_type                      | None                                                                                |
| created_at                            | 2017-11-30T02:25:02.000000                                                          |
| share_proto                           | NFS                                                                                 |
| mount_snapshot_support                | False                                                                               |
| project_id                            | ca6e13d11f564a90aca3cd13c6eaf8e7                                                    |
| metadata                              | {}                                                                                  |
+---------------------------------------+-------------------------------------------------------------------------------------+
```

	- `status: available`: share đã được tạo thành công và có thể được sử dụng
	- `path = 172.16.69.195:/var/lib/manila/mnt/share-e0aefdf9-ab5e-4a78-907c-17e089700cee`: đây là đường dẫn và được sử dụng cho client mount
	
- Quản lý truy cập share bằng cách tạo các rules. Đối với LVM, chỉ hỗ trợ kiểu truy cập dựa trên địa chỉ IP hỗ trợ giao thức NFS.Cho phép các VM trong dải mạng `172.16.69.0/24` được phép đọc ghi trên Share1

```
root@controller:~# manila access-allow Share1 ip 172.16.69.0/24 --access-level rw
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| access_key   | None                                 |
| share_id     | 5246e4d8-d47d-4425-9f6b-0d6717733eb5 |
| created_at   | 2017-11-30T02:46:34.000000           |
| updated_at   | None                                 |
| access_type  | ip                                   |
| access_to    | 172.16.69.0/24                       |
| access_level | rw                                   |
| state        | queued_to_apply                      |
| id           | 82c5e50a-59e1-444c-9d8c-c178ee20b273 |
+--------------+--------------------------------------+
```

- Để kiểm tra rule truy cập vào Share1 giữa các project khác nhau, chúng ta thử với 2 vm ở trên 2 project admin và demo. Các vm trên 2 project là:

```
root@controller:~# . demo-openrc
root@controller:~# openstack server list
+--------------------------------------+-------------+--------+------------------------+------------+----------+
| ID                                   | Name        | Status | Networks               | Image      | Flavor   |
+--------------------------------------+-------------+--------+------------------------+------------+----------+
| d49bd653-e951-468e-91c4-90a5ac8b12c8 | ubuntu-demo | ACTIVE | provider=172.16.69.199 | ubuntu-xen | m2.small |
+--------------------------------------+-------------+--------+------------------------+------------+----------+
root@controller:~# . admin-openrc
root@controller:~# openstack server list
+--------------------------------------+--------+--------+------------------------+------------+----------+
| ID                                   | Name   | Status | Networks               | Image      | Flavor   |
+--------------------------------------+--------+--------+------------------------+------------+----------+
| 0f0396ee-9884-4934-b1de-b3ba19590071 | ubuntu | ACTIVE | provider=172.16.69.197 | ubuntu-xen | m2.small |
+--------------------------------------+--------+--------+------------------------+------------+----------+
```

- Kiểm tra truy cập share. Lưu ý các VM phải được hỗ trợ giao thức NFS.
- Kiểm tra lại truy cập vào share1 với vm ở project admin (share1 được tạo vởi admin)

```
root@ubuntu:~# mount -vt nfs 172.16.69.195:/var/lib/manila/mnt/share-e0aefdf9-ab5e-4a78-907c-17e089700cee /tmp
mount.nfs: timeout set for Thu Nov 30 03:26:37 2017
mount.nfs: trying text-based options 'vers=4,addr=172.16.69.195,clientaddr=172.16.69.197'

root@ubuntu:~# df -h
Filesystem                                                                    Size  Used Avail Use% Mounted on
udev                                                                          490M     0  490M   0% /dev
tmpfs                                                                         100M  3.1M   97M   4% /run
/dev/vda1                                                                     4.8G  1.1G  3.8G  22% /
tmpfs                                                                         497M     0  497M   0% /dev/shm
tmpfs                                                                         5.0M     0  5.0M   0% /run/lock
tmpfs                                                                         497M     0  497M   0% /sys/fs/cgroup
tmpfs                                                                         100M     0  100M   0% /run/user/1000
172.16.69.195:/var/lib/manila/mnt/share-e0aefdf9-ab5e-4a78-907c-17e089700cee  976M  1.3M  908M   1% /tmp
```

- Tạo file trong thư mục `/tmp`

```
root@ubuntu:~# cd /tmp/
root@ubuntu:/tmp# touch file1
```

- Thực hiện mount ở vm thuộc project demo

```
root@ubuntu-demo:~# mount -vt nfs 172.16.69.195:/var/lib/manila/mnt/share-e0aefdf9-ab5e-4a78-907c-17e089700cee /tmp
mount.nfs: timeout set for Thu Nov 30 03:41:07 2017
mount.nfs: trying text-based options 'vers=4,addr=172.16.69.195,clientaddr=172.16.69.199'
root@ubuntu-demo:~# ls /tmp/
file1  lost+found
```

- Giữa các project khác nhau cũng có thể truy cập share.

<a name=2></a>
## 2. Kiểm soát truy cập share
- Đối với back end LVM, truy cập chỉ kiểu truy cập qua ip hỗ trợ giao thức NFS (Only IP access type is supported for NFS)
- Cho phép một dải mạng ip được phép truy cập với quyền đọc và ghi.

```
manila access-allow <share-name> ip <net-ip> --access-level rw
```

- Như ví dụ ở trên phần 1, Share1 được chia sẻ cho dải mạng `172.16.69.0/24`. Như vậy tất cả các vm được kết nối với dải `172.16.69.0/24` đều truy cập được share1

- Nếu muốn chỉ rõ từng VM được phép truy cập thì thay địa chỉ mạng bằng địa chỉ ip cụ thể. Ví dụ:

```
manila access-allow <share-name> ip 172.16.69.197 --access-level rw
```

- Nếu muốn thêm một VM nữa được phép truy cập vào share này thì chạy thêm lệnh tương tự với địa chỉ ip của vm.
- Chặn truy cập. Với các IP chưa được cho phép sẽ không thể truy cập share. Các ip được cho phép truy cập share rồi, nếu muốn chặn lại sử dụng lệnh sau:

```
manila access-deny <share-name> <id-access>
```

- Ví dụ.
- Kiểm tra các access của Share2

```
root@controller:~# manila access-list Share2
+--------------------------------------+-------------+---------------+--------------+--------+------------+----------------------------+------------+
| id                                   | access_type | access_to     | access_level | state  | access_key | created_at                 | updated_at |
+--------------------------------------+-------------+---------------+--------------+--------+------------+----------------------------+------------+
| 59a36d6f-44fa-4f35-ba18-21a1605f5dd7 | ip          | 172.16.69.197 | rw           | active | None       | 2017-11-30T03:49:33.000000 | None       |
| 5d20f517-663a-4912-944a-5195afda3fe8 | ip          | 172.16.69.199 | rw           | active | None       | 2017-11-30T03:52:30.000000 | None       |
+--------------------------------------+-------------+---------------+--------------+--------+------------+----------------------------+------------+
```

- Muốn chặc địa chỉ `172.16.69.199` không được truy cập vào share2 sử dụng lệnh sau

```
manila access-deny Share2 5d20f517-663a-4912-944a-5195afda3fe8
```

- Kiểm tra lại danh sách truy cập share2

```
root@controller:~# manila access-list Share2
+--------------------------------------+-------------+---------------+--------------+--------+------------+----------------------------+------------+
| id                                   | access_type | access_to     | access_level | state  | access_key | created_at                 | updated_at |
+--------------------------------------+-------------+---------------+--------------+--------+------------+----------------------------+------------+
| 59a36d6f-44fa-4f35-ba18-21a1605f5dd7 | ip          | 172.16.69.197 | rw           | active | None       | 2017-11-30T03:49:33.000000 | None       |
+--------------------------------------+-------------+---------------+--------------+--------+------------+----------------------------+------------+
```

<a name=3></a>
## 3. Thay đổi kích thước của share
- Kiểm tra xem kích thước hiện tại của share1

```
root@controller:~# manila show Share1 | grep size | cut -d'|' -f3
 1
```
	
	- Hiện tại Share1 có size là 1 Gb
	
- Thay đổi size của share1 thành 5 Gb, sử dụng lệnh sau:

```
root@controller:~# manila extend Share1 5

root@controller:~# manila show Share1 | grep size | cut -d'|' -f3
 5
```

<a name=4></a>
## 4. Xóa share
- dùng lệnh sau để xóa share

```
manila delete <share-name>
```