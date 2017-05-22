# Định nghĩa một số role cơ bản trong glance

- Một số công việc cơ bản trong glance như thêm, sửa, xóa, liệt kê image. User có được thực hiện các việc đó hay không sẽ do role quyết định. Các dòng cấu hình trong file `/etc/glance/policy.json` để thực hiện những việc đó là:
	- **add_image**: Tạo một image.
	- **delete_image**: xóa iamge.
	- **get_image**: show thông tin chi tiết của một image cụ thể.
	- **get_images**: Liệt kê tất cả các image
	- **modify_image**: Update image
	- **publicize_image**: Tạo hoặc Update public image
	- **communitize_image**: Tạo hoặc update communitize images

- Như vậy, để định nghĩa một role được phép làm gì đó thì ta chỉ cần thêm role vào trong dòng cấu hình cho phép làm điều đó.
- Ví dụ: tạo một số role như sau:
	```sh
	"add_image": "role:upload", 
    "delete_image": "role:delete", 
    "get_image": "role:list", 
    "get_images": "role:lists",
    "modify_image": "role:edit",
    "publicize_image": "role:upload_public",
    "communitize_image": "role:upload_comm",
	```

	- upload: có khả năng tạo một image, 
	- delete: có khả năng delete một image
	- list: có khả năng show ra một image với id cụ thể
	- lists: liệt kê ra tất cả các image
	- edit: có khả năng sửa một số thuộc tính của image
	- upload_public: có khả năng tạo một image với visibility là public
	- upload_comm: có khả năng tạo một image với visibility là communiti
- Sau khi khai báo như trên, chúng ta tạo ra các user và gán các role tương ứng để kiểm tra.
- Nếu một user muốn có nhiều hơn 1 quyền với image, chúng ta có thể add thêm role cho user hoặc định nghĩa một role khác dành riêng cho user. Sau đó thêm rule đó vào các quyền mà chúng ta muốn cho phép. Ví dụ:
	- muốn cho phép một user có hai quyền là liệt kê tất cả các image và xóa một image, ta định nghĩa một role là `role_user1` cho user là user1 như sau:
	```sh
	"get_images": "role:role_user1",
	"delete_image": "role:role_user1",
	```

1. tạo project
	```sh
	root@controller:~# openstack project create --domain default --description "Labs role image" project1
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | Labs role image                  |
	| domain_id   | default                          |
	| enabled     | True                             |
	| id          | 3205755f8b6d493aa202cea775fd48b2 |
	| is_domain   | False                            |
	| name        | project1                         |
	| parent_id   | default                          |
	+-------------+----------------------------------+
	```

2. tạo các user
	```sh
	root@controller:~# openstack user create --project project1 --domain default --password 123 --description "User1 duoc up image" user1
	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| default_project_id  | 3205755f8b6d493aa202cea775fd48b2 |
	| description         | User1 duoc up image              |
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | 0ee8b90e6da14902be1788cfde1ecbd2 |
	| name                | user1                            |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+
	```

3. tạo role
	```sh
	root@controller:~# openstack role create upload
	+-----------+----------------------------------+
	| Field     | Value                            |
	+-----------+----------------------------------+
	| domain_id | None                             |
	| id        | 8f6cb1ad27b446faae22fefef5182f01 |
	| name      | upload                           |
	+-----------+----------------------------------+
	```

4. Gán role cho user
	```sh
	openstack role add --project project1 --user user1 upload
	```

5. Định nghĩa role upload được upload 1 image public
- Tìm dòng `"publicize_image": "role:admin",` và thêm role `upload` vào như sau:
	```sh
	"publicize_image": "role:admin or role:upload",
	```

6. Kiểm tra lại
- Khai báo biến môi trường cho xác thực user1

	```sh
	export OS_PROJECT_DOMAIN_NAME=Default
	export OS_USER_DOMAIN_NAME=Default
	export OS_PROJECT_NAME=project1
	export OS_USERNAME=user1
	export OS_PASSWORD=123
	export OS_AUTH_URL=http://controller:35357/v3
	export OS_IDENTITY_API_VERSION=3
	export OS_IMAGE_API_VERSION=2
	```

- Thực hiện lệnh tạo một public image để kiểm tra
	```sh
	openstack image create "cirros" \
 	--file cirros-0.3.5-x86_64-disk.img \
 	--disk-format qcow2 --container-format bare \
 	--public
 	```
---
Trên đây là ghi chép của mình về cách định nghĩa role cơ bản. Tài liệu về policy của image được liệt kê đầy đủ ở docs của openstack, link: https://docs.openstack.org/admin-guide/image-policies.html