# Sử dụng cURL để thao tác image trong glance
Tương tự như keystone, glance cũng cung cấp các endpoint cho phép người dùng gọi đến API mà nó cung cấp để thao tác với image. Trong bài viết này, mình sẽ thực hiện một số thao tác quản trị cơ bản thông qua lệnh cURL.

### 1. Lấy token
- Token được thêm vào phần header trong lệnh cURL dùng để các dịch vụ xác thực người dùng.
- Sử dụng cURL để lấy token
	```sh
	curl -i -X POST -H "Content-Type: application/json" -d '
	{
	   "auth": {
	     "identity": {
	       "methods": [
	         "password"
	       ],
	       "password": {
	         "user": {
	           "name": "admin",
	           "password": "Welcome123",
	           "domain": {
	             "name": "default"
	           }
	         }
	       }
	     },
	     "scope": {
	       "project": {
	         "name": "admin",
	         "domain": {
	           "name": "default"
	         }
	       }
	     }
	  }
	}' http://10.10.10.61:5000/v3/auth/tokens
	```
Thay thế `Welcome123` bằng mật khẩu của user admin trên hệ thống openstack của bạn

- Kết quả trả về
	```sh
	HTTP/1.1 201 Created
	Date: Sun, 14 May 2017 17:08:35 GMT
	Server: Apache/2.4.18 (Ubuntu)
	X-Subject-Token: gAAAAABZGI8XtQXM3NY6Z0Zfx96eClgw6FIlkR9yKjSjq9sVkYh0YJne7G2YIzFT3QcYIEKyTCjum4NAMDTMFEVzpQss1uKpnWL2eA4QW78TkIxneZNr2Owxu2QOB79pJ3A7s98Z1rWm_dnbKp9hgds2vBhOmM5JIOJ3iUdc8DELQEqiB5-vIcw
	Vary: X-Auth-Token
	X-Distribution: Ubuntu
	x-openstack-request-id: req-649b2d06-4f71-4e22-a245-3e66ab228866
	Content-Length: 3305
	Content-Type: application/json

	{"token": {"is_domain": false, "methods": ["password"], "roles": [{"id": "9577b0c1837b430cabfd7d20e548e8fe", "name": "admin"}], "expires_at": "2017-05-14T17:09:39.000000Z", "project": {"domain": {"id": "default", "name": "Default"}, "id": "1667a274e14647ec8f2c0dd593e661de", "name": "admin"}, "catalog": [{"endpoints": [{"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "internal", "id": "14685bad4aec40f08981c3f1740e3545"}, {"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "admin", "id": "7064b62c47c346f18c5fa237eaf6226f"}, {"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "public", "id": "a1c9071a4f1649f5a4f1c698cf2011c0"}], "type": "network", "id": "372bb5b327cf4729929f17ca254a2347", "name": "neutron"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:5000/v3/", "region": "RegionOne", "interface": "internal", "id": "b2838eb934c9497c8d56f8999276ec91"}, {"region_id": "RegionOne", "url": "http://controller:35357/v3/", "region": "RegionOne", "interface": "admin", "id": "f0fb030e514741dd93b7b8f486a2e0d2"}, {"region_id": "RegionOne", "url": "http://controller:5000/v3/", "region": "RegionOne", "interface": "public", "id": "f3dd04abc59542838494d08967aa0af0"}], "type": "identity", "id": "46fb085ff2594d2bb3e1c928b8cdb05e", "name": "keystone"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller/placement", "region": "RegionOne", "interface": "public", "id": "42227e78ceff4bebb78e5a2f8ba71598"}, {"region_id": "RegionOne", "url": "http://controller/placement", "region": "RegionOne", "interface": "internal", "id": "9441739790b0476e9ca82f472dd71ded"}, {"region_id": "RegionOne", "url": "http://controller/placement", "region": "RegionOne", "interface": "admin", "id": "c95d2c05791b478192fcc139a3e57751"}], "type": "placement", "id": "6b1281d26ba940439bda68155fafd903", "name": "placement"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "public", "id": "340ccc966bbf4a92b772b050f339ff3b"}, {"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "internal", "id": "486b3a9f5b904d9f998d106ab21165db"}, {"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "admin", "id": "ecfd4ecc85d54f4b836c0be89f991b01"}], "type": "compute", "id": "bdf3c1364bcb4b569d75e98a4914644a", "name": "nova"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "public", "id": "256f8c335b2942bfaa48ff5b8f736194"}, {"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "admin", "id": "71b72367765942fe9aeacce70601f2ee"}, {"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "internal", "id": "99d90e0a37294678ab983e53af2e8c70"}], "type": "image", "id": "feba9d8531944339b45bb5bfa55e9fd6", "name": "glance"}], "user": {"password_expires_at": null, "domain": {"id": "default", "name": "Default"}, "id": "3ce3ca843dc7458bb61c851d3a654b8b", "name": "admin"}, "audit_ids": ["WVxFSlY4Rsy0ImGZlTO-Xg"], "issued_at": "2017-05-14T17:08:39.000000Z"}}
	```

- Token mà chúng ta nhận được chính là chuỗi ký tự sau `X-Subject-Token`. Vậy token của ở đây là
	```sh
	gAAAAABZGI8XtQXM3NY6Z0Zfx96eClgw6FIlkR9yKjSjq9sVkYh0YJne7G2YIzFT3QcYIEKyTCjum4NAMDTMFEVzpQss1uKpnWL2eA4QW78TkIxneZNr2Owxu2QOB79pJ3A7s98Z1rWm_dnbKp9hgds2vBhOmM5JIOJ3iUdc8DELQEqiB5-vIcw
	```
- Để thuận tiện cho quá trình sử dụng token này trong phần header của lệnh cURL, chúng ta khai báo biến môi trường với giá trị bằng token nhận được
	```sh
	OS_TOKEN=gAAAAABZGI8XtQXM3NY6Z0Zfx96eClgw6FIlkR9yKjSjq9sVkYh0YJne7G2YIzFT3QcYIEKyTCjum4NAMDTMFEVzpQss1uKpnWL2eA4QW78TkIxneZNr2Owxu2QOB79pJ3A7s98Z1rWm_dnbKp9hgds2vBhOmM5JIOJ3iUdc8DELQEqiB5-vIcw
	```

### 2. Liệt kê ra các image có trong glance 
- Dùng lệnh sau để lấy thông tin về các image có trong glance
	```sh
	curl -s -X GET -H "X-Auth-Token: $OS_TOKEN" http://10.10.10.61:9292/v2/images | python -mjson.tool
	```

- Kết quả trả về.
	```sh
	{
	    "first": "/v2/images",
	    "images": [
	        {
	            "checksum": "f8ab98ff5e73ebab884d80c9dc9c7290",
	            "container_format": "bare",
	            "created_at": "2017-05-14T08:35:48Z",
	            "disk_format": "qcow2",
	            "file": "/v2/images/88b19636-37ce-4c06-9025-1972a856dcbc/file",
	            "id": "88b19636-37ce-4c06-9025-1972a856dcbc",
	            "min_disk": 0,
	            "min_ram": 0,
	            "name": "cirros-multiple-store-location",
	            "owner": "1667a274e14647ec8f2c0dd593e661de",
	            "protected": false,
	            "schema": "/v2/schemas/image",
	            "self": "/v2/images/88b19636-37ce-4c06-9025-1972a856dcbc",
	            "size": 13267968,
	            "status": "active",
	            "tags": [],
	            "updated_at": "2017-05-14T08:35:53Z",
	            "virtual_size": null,
	            "visibility": "public"
	        },
	        {
	            "checksum": "f8ab98ff5e73ebab884d80c9dc9c7290",
	            "container_format": "bare",
	            "created_at": "2017-05-14T02:50:08Z",
	            "disk_format": "qcow2",
	            "file": "/v2/images/615af8b9-9c04-4f0a-94d7-e1ed4516e247/file",
	            "id": "615af8b9-9c04-4f0a-94d7-e1ed4516e247",
	            "min_disk": 0,
	            "min_ram": 0,
	            "name": "cirros-test-upload-image",
	            "owner": "1667a274e14647ec8f2c0dd593e661de",
	            "protected": false,
	            "schema": "/v2/schemas/image",
	            "self": "/v2/images/615af8b9-9c04-4f0a-94d7-e1ed4516e247",
	            "size": 13267968,
	            "status": "active",
	            "tags": [],
	            "updated_at": "2017-05-14T02:50:09Z",
	            "virtual_size": null,
	            "visibility": "public"
	        }
	    ],
	    "schema": "/v2/schemas/images"
	}
	```
- Kết quả trả về chứa đầy đủ thông tin của các image có trong glance. Nếu như muốn xem thông tin của một image nhất định, thì cần chỉ rõ id của image đó trong lệnh cURL (sẽ giải thích rõ ngay sau đây).
- Hãy chú ý đến thông tin **"self"** trong từng image, ví dụ: `"self": "/v2/images/615af8b9-9c04-4f0a-94d7-e1ed4516e247",`. Đây là đường dẫn địa chỉ đến từng image cụ thể. Chuỗi ký tự `615af8b9-9c04-4f0a-94d7-e1ed4516e247` này chính là id của image. Chúng ta sẽ xem thông tin chi tiết của image cụ thể bằng cách thêm id này vào trong lệnh cURL như sau:
- Cú pháp:
	```sh
	curl -s -X GET -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/<id của image> | python -mjson.tool
	```
- Ví dụ xem thông tin của image có id `615af8b9-9c04-4f0a-94d7-e1ed4516e247`:
	```sh
	curl -s -X GET -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/615af8b9-9c04-4f0a-94d7-e1ed4516e247 | python -mjson.tool
	```
- Thông tin của image này chúng ta cũng đã nhận được ở kết quả của lệnh trước rồi. Tuy nhiên thì sử dụng lệnh này sẽ giúp chúng ta đọc thông tin về từng image cụ thể sẽ tập trung hơn:
	```sh
	{
	    "checksum": "f8ab98ff5e73ebab884d80c9dc9c7290",
	    "container_format": "bare",
	    "created_at": "2017-05-14T02:50:08Z",
	    "disk_format": "qcow2",
	    "file": "/v2/images/615af8b9-9c04-4f0a-94d7-e1ed4516e247/file",
	    "id": "615af8b9-9c04-4f0a-94d7-e1ed4516e247",
	    "min_disk": 0,
	    "min_ram": 0,
	    "name": "cirros-test-upload-image",
	    "owner": "1667a274e14647ec8f2c0dd593e661de",
	    "protected": false,
	    "schema": "/v2/schemas/image",
	    "self": "/v2/images/615af8b9-9c04-4f0a-94d7-e1ed4516e247",
	    "size": 13267968,
	    "status": "active",
	    "tags": [],
	    "updated_at": "2017-05-14T02:50:09Z",
	    "virtual_size": null,
	    "visibility": "public"
	}
	```

### 3. Tạo một image
- Lệnh sau đây sẽ tạo ra một image trống (chưa có dữ liệu). Image này sẽ được vào trạng thái **queued** chờ được up dữ liệu vào
	```sh
	curl -i -X POST -H "X-Auth-Token: $OS_TOKEN" \
	    -H "Content-Type: application/json" \
	    -d '{"container_format": "bare", "disk_format": "qcow2", "name": "cirros-test-curl"}' \
	    http://controller:9292/v2/images 
	```
- Kết quả
	```sh
	HTTP/1.1 201 Created
	Content-Length: 560
	Content-Type: application/json; charset=UTF-8
	Location: http://controller:9292/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9
	X-Openstack-Request-Id: req-7185973d-fc33-4568-a732-eedda9c8cbe9
	Date: Sun, 14 May 2017 18:46:16 GMT

	{
	  "status": "queued",
	  "name": "cirros-test-curl",
	  "tags": [],
	  "container_format": "bare",
	  "created_at": "2017-05-14T18:46:16Z",
	  "size": null,
	  "disk_format": "qcow2",
	  "updated_at": "2017-05-14T18:46:16Z",
	  "visibility": "shared",
	  "self": "/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9",
	  "min_disk": 0,
	  "protected": false,
	  "id": "73924ee2-96bb-44f3-b37d-dc4d61cf96c9",
	  "file": "/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9/file",
	  "checksum": null,
	  "owner": "1667a274e14647ec8f2c0dd593e661de",
	  "virtual_size": null,
	  "min_ram": 0,
	  "schema": "/v2/schemas/image"
	}
	```
- Chú ý id của image `"id": "73924ee2-96bb-44f3-b37d-dc4d61cf96c9",` để thực hiện các thao tác sau này.
- Chúng ta có thể thấy được image đang ở trạng thái **queued** sẵn sàng để được up dữ liệu.
- Bây giờ chúng ta sẽ up dữ liệu cho image.
- Chuẩn bị 1 file image. Bạn có thể dowload file image bằng lệnh sau để test
	```sh
	wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
	```
- Dùng lệnh sau để up dữ liệu theo dòng nhị phân cho image đã tạo ở lúc trước.
	- Cú pháp để thực hiện:
	```sh
	curl -i -X PUT -H "X-Auth-Token: $token" \
   -H "Content-Type: application/octet-stream" \
   -d @{đường dẫn đến file image chứa dữ liệu để upload} \
   $image_url/v2/images/{image_id}/file
   ```
   - Áp dụng vào trường hợp của mình. path đến file là `/root/cirros-0.3.5-x86_64-disk.img` và id của image là `73924ee2-96bb-44f3-b37d-dc4d61cf96c9`.
	```sh
	curl -i -X PUT -H "X-Auth-Token: $OS_TOKEN" \
   -H "Content-Type: application/octet-stream" \
   -d @/root/cirros-0.3.5-x86_64-disk.img \
   http://controller:9292/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9/file
   ```
- Thông tin nhận được trên console
	```sh
	HTTP/1.1 100 Continue

	HTTP/1.1 204 No Content
	Content-Type: text/html; charset=UTF-8
	Content-Length: 0
	X-Openstack-Request-Id: req-5d2e2413-d075-4ca3-920a-eb81c94080f3
	Date: Sun, 14 May 2017 19:07:44 GMT
	```
- Kết quả trả về mã 204 có nghĩa là dữ liệu của image đã được up lên thành công. Chúng ta kiểm tra lại thông tin của image này.
	```sh
	root@controller:~# curl -s -X GET -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9 | python -mjson.tool
	{
	    "checksum": "5330265d2649c25ba62260b7e4640474",
	    "container_format": "bare",
	    "created_at": "2017-05-14T18:46:16Z",
	    "disk_format": "qcow2",
	    "file": "/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9/file",
	    "id": "73924ee2-96bb-44f3-b37d-dc4d61cf96c9",
	    "min_disk": 0,
	    "min_ram": 0,
	    "name": "cirros-test-curl",
	    "owner": "1667a274e14647ec8f2c0dd593e661de",
	    "protected": false,
	    "schema": "/v2/schemas/image",
	    "self": "/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9",
	    "size": 6893708,
	    "status": "active",
	    "tags": [],
	    "updated_at": "2017-05-14T19:07:44Z",
	    "virtual_size": null,
	    "visibility": "shared"
	}
	```
- image đã ở trạng thái active.

### 4. Thực hiện deactivate image 
- `curl -i -X POST -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/{id_image}/actions/deactivate`

	```sh
	root@controller:~# curl -i -X POST -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9/actions/deactivate
	HTTP/1.1 204 No Content
	Content-Type: text/html; charset=UTF-8
	Content-Length: 0
	X-Openstack-Request-Id: req-8ddadb87-be87-40c1-ba87-feedd81235ad
	Date: Sun, 14 May 2017 19:23:44 GMT
	```
- Kết quả trả về mã 204 đã thành công. Bạn có thể xem trạng thái của image đã chuyển sang deactivated hay chưa bằng cách xem thông tin chi tiết của image đã trình bày ở trên

### 5. Reactivate image 
- `curl -i -X POST -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/{id_image}/actions/reactivate`

	```sh
	root@controller:~# curl -i -X POST -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9/actions/reactivate
	HTTP/1.1 204 No Content
	Content-Type: text/html; charset=UTF-8
	Content-Length: 0
	X-Openstack-Request-Id: req-d19965b8-4860-49a4-a583-8cd5bac4a836
	Date: Sun, 14 May 2017 19:27:05 GMT
	```

### 6. Xóa image 

- `curl -i -X DELETE -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/{id_image}`

	```sh
	curl -i -X DELETE -H "X-Auth-Token: $OS_TOKEN" http://controller:9292/v2/images/73924ee2-96bb-44f3-b37d-dc4d61cf96c9
	```
- Lưu ý khi xóa một image: thuộc tính `protected` của image phải là `false` thì mới có thể xóa còn nếu `true` thì phải thực hiện gán về giá trị `false` trước khi thực hiện xóa.

--- 
Trên đây là một số cách dùng lệnh cURL để gọi đến API của glance mà mình ghi chép lại trong quá trình tìm hiểu. Các bạn có thể vào [docs](https://developer.openstack.org/api-ref/image/v2/) của openstack để xem tìm hiểu thêm về nhiều API khác mà glance đã cung cấp.