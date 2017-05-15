# Lab thực hiện thiết lập cho phép lưu Image ở nhiều nơi

#### 1. Trước tiên cần tạo thư mục để lưu Images
- tạo thư mục images-1 và images-2 trong thư mục `/home/`
	```sh
	mkdir /home/images-1
	mkdir /home/images-2
	```
#### 2. Chuyển hai thư mục này vào group `glance` và user `glance`
	```sh
	chown glance:glance /home/images-1
	chown glance:glance /home/images-2
	```

#### 3. Bước tiếp theo là cấu hình sử dụng multiple store location
- Để có thể sử dụng multiple store location (lưu trữ image ở nhiều nơi), chúng ta cấu hình trong file `/etc/glance/glance-api.conf`
- Trong section `[glance_store]`, chúng ta tìm kiếm tùy chọn cấu hình `filesystem_store_datadir` và cho giá trị trống. Nếu như comment dòng này, thì glance sẽ sử dụng nó như là vị trí lưu trữ mặc định và sẽ báo lỗi trong quá trình tạo image.
- Thêm các tùy chọn `filesystem_store_datadirs`. Giá trị của tùy chọn này sẽ là đường dẫn tới các thư mục dùng để lưu trữ image
- Chúng ta cũng cần chỉ rõ độ ưu tiên của thư mục dùng để lưu trữ images. Thư mục nào có độ ưu tiên cao hơn sẽ được ưu tiên lưu trữ trước. Nếu chúng ta không chỉ rõ độ ưu cho thư mục thì mặc định thư mục có độ ưu tiên là 0.
- Nội dung trong section [glance_store] như sau (chỉ thêm những dòng cấu hình này, các dòng cấu hình khác giữ nguyên):
	```sh
	[glance_store]
	filesystem_store_datadir=
	filesystem_store_datadirs=/var/lib/glance/images
	filesystem_store_datadirs=/home/images-1:200
	filesystem_store_datadirs=/home/images-2:100
	```
- Sau đó khởi động lại dịch vụ glance-api
	```sh
	service glance-api restart
	```
- Theo như cấu hình trên thì thư mục `/home/images-1` sẽ có độ ưu tiên cao nhất, nên khi upload image lên glance thì image sẽ được lưu vào thư mục này. Chúng ta sẽ kiểm tra lại xem có đúng như vậy không.

#### 4. Kiểm tra lại cấu hình
- Upload image lên glance. Chúng ta sẽ tải file img từ internet về.
	```sh
	wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
	```

- upload image vừa tải về lên glance
	```sh
	openstack image create "cirros-multiple-store-location" \
 	--file cirros-0.3.5-x86_64-disk.img \
 	--disk-format qcow2 --container-format bare \
 	--public
 	```
- upload thành công
	```sh
	+------------------+------------------------------------------------------+
	| Field            | Value                                                |
	+------------------+------------------------------------------------------+
	| checksum         | f8ab98ff5e73ebab884d80c9dc9c7290                     |
	| container_format | bare                                                 |
	| created_at       | 2017-05-14T08:35:48Z                                 |
	| disk_format      | qcow2                                                |
	| file             | /v2/images/88b19636-37ce-4c06-9025-1972a856dcbc/file |
	| id               | 88b19636-37ce-4c06-9025-1972a856dcbc                 |
	| min_disk         | 0                                                    |
	| min_ram          | 0                                                    |
	| name             | cirros-multiple-store-location                       |
	| owner            | 1667a274e14647ec8f2c0dd593e661de                     |
	| protected        | False                                                |
	| schema           | /v2/schemas/image                                    |
	| size             | 13267968                                             |
	| status           | active                                               |
	| tags             |                                                      |
	| updated_at       | 2017-05-14T08:35:53Z                                 |
	| virtual_size     | None                                                 |
	| visibility       | public                                               |
	+------------------+------------------------------------------------------+
	```
- Kiểm tra vị trí lưu image.
- đăng nhập vào database và nhập lệnh sau để kiểm tra `select * from glance.image_locations\G`
	```sh
	MariaDB [(none)]> select * from glance.image_locations\G
	*************************** 1. row ***************************
	        id: 1
	  image_id: c051e5d4-89d2-4a3f-973e-eb307a9b551d
	     value: file:///var/lib/glance/images/c051e5d4-89d2-4a3f-973e-eb307a9b551d
	created_at: 2017-04-19 08:38:30
	updated_at: 2017-05-14 02:25:29
	deleted_at: 2017-05-14 02:25:29
	   deleted: 1
	 meta_data: {}
	    status: deleted
	*************************** 2. row ***************************
	        id: 2
	  image_id: 615af8b9-9c04-4f0a-94d7-e1ed4516e247
	     value: file:///var/lib/glance/images/615af8b9-9c04-4f0a-94d7-e1ed4516e247
	created_at: 2017-05-14 02:50:09
	updated_at: 2017-05-14 02:50:09
	deleted_at: NULL
	   deleted: 0
	 meta_data: {}
	    status: active
	*************************** 3. row ***************************
	        id: 3
	  image_id: 88b19636-37ce-4c06-9025-1972a856dcbc
	     value: file:///home/images-1/88b19636-37ce-4c06-9025-1972a856dcbc
	created_at: 2017-05-14 08:35:53
	updated_at: 2017-05-14 08:35:53
	deleted_at: NULL
	   deleted: 0
	 meta_data: {}
	    status: active
	3 rows in set (0.04 sec)
	```
- Sử dụng `openstack image list`
	```sh
	root@controller:~# openstack image list
	+--------------------------------------+--------------------------------+--------+
	| ID                                   | Name                           | Status |
	+--------------------------------------+--------------------------------+--------+
	| 88b19636-37ce-4c06-9025-1972a856dcbc | cirros-multiple-store-location | active |
	| 615af8b9-9c04-4f0a-94d7-e1ed4516e247 | cirros-test-upload-image       | active |
	+--------------------------------------+--------------------------------+--------+

- Ta thấy rằng image có Id `88b19636-37ce-4c06-9025-1972a856dcbc` là image mà chúng ta vừa tạo sau khi cấu hình multiple store location. Thông tin chúng ta có được trong database chỉ rõ vị trí lưu của image này là ở thư mục `/home/images-1`. Như vậy là đúng với lý thuyết mà mình đã nêu ở trên

---

Trên đây là ghi chép lại của mình về thiết lập multiple store location for image. Các bạn có thể tham khảo [tại đây](http://egonzalez.org/multiple-store-locations-for-glance-images/)
