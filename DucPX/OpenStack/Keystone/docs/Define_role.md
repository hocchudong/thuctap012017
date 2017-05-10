# Thực hành định nghĩa role trong keystone openstack

# File policy.json
- Mỗi OpenStack service, Identity, Compute, Networking, và các service khác, có policies của chúng dựa trên role. Xác định user có quyền access objects đó hay không, được defined trong service’s policy.json file.
- path của file policy.json thưòng là `/etc/<project>/policy.json` (project tương ứng với từng project cụ thể).
- Bất cứ lúc nào có lời gọi tới API của service trong openstack là được thực hiện, service’s policy engine sử dụng các định nghĩa policy để xác định nếu lời gọi được chấp nhận. Bất cứ thay đổi nào trong file policy.json là có hiệu quả ngay lập tức, cho phép chính sách mới thực hiện trong khi dịch vụ đó đang chạy.
- `policy.json` file là text định dạng Json. Mỗi policy được định nghĩa bởi một dòng theo cấu trúc "<target>" : "<rule>" .
	- <target>: các quyền thực hiện đã được định nghĩa sẵn bởi từng dịch vụ.
	- <rule>: chính là quy tắc do mình đặt ra để dễ nhớ

# Thực hiện định nghĩa một số role.
- Cấu trúc của file json:
  ```sh
  {
  	"<rule>": "define rule",

  	
  	"<target>": "<rule> or <role>"
  }
  ```

- Để minh họa cho cấu trúc trên, ta định nghĩa role như sau: một role tên `duc` cho user `duc` có thể list user.
- Trước hết tạo role có tên là `duc`, user `duc`, project `duc` và gán role `duc` cho user `duc` trên project `duc`
  	```sh
  	# Tạo project duc
  	root@controller:~# openstack project create --domain Default --description "Project duc for testing role" duc
	+-------------+----------------------------------+
	| Field       | Value                            |
	+-------------+----------------------------------+
	| description | Project duc for testing role     |
	| domain_id   | default                          |
	| enabled     | True                             |
	| id          | a7f6b02e0cbc43e5bb3ad5520eb70131 |
	| is_domain   | False                            |
	| name        | duc                              |
	| parent_id   | default                          |
	+-------------+----------------------------------+

	# Tạo role duc
	root@controller:~# openstack role create duc
	+-----------+----------------------------------+
	| Field     | Value                            |
	+-----------+----------------------------------+
	| domain_id | None                             |
	| id        | 38435afbaa7640bda4bc9784b0aa7df0 |
	| name      | duc                              |
	+-----------+----------------------------------+

	# Tạo user duc
	root@controller:~# openstack user create --domain Default --password 123 --enable --description "User for testing role" duc
	+---------------------+----------------------------------+
	| Field               | Value                            |
	+---------------------+----------------------------------+
	| description         | User for testing role            |
	| domain_id           | default                          |
	| enabled             | True                             |
	| id                  | 49b68f1a90fc493fa1acb82cfe30d6c4 |
	| name                | duc                              |
	| options             | {}                               |
	| password_expires_at | None                             |
	+---------------------+----------------------------------+

	# Gián role 
	root@controller:~# openstack role add --project duc --user duc duc

	# Kiểm tra lại xem user duc có role gì
	root@controller:~# openstack role list --user duc --project duc
	Listing assignments using role list is deprecated. Use role assignment list --user <user-name> --project <project-name> --names instead.
	+----------------------------------+------+---------+------+
	| ID                               | Name | Project | User |
	+----------------------------------+------+---------+------+
	| 38435afbaa7640bda4bc9784b0aa7df0 | duc  | duc     | duc  |
	+----------------------------------+------+---------+------+

	# Trước khi định nghĩa role này được phép list user, chúng ta thử kiểm tra xem có list user không đã :))
	root@controller:~# openstack user list
	You are not authorized to perform the requested action: identity:list_users. (HTTP 403) (Request-ID: req-444bec77-51ec-4848-b618-9fb0d9300acf)

	# Như vậy role này chưa được phép list user
	```
- Chúng ta sẽ định nghĩa role này trong file policy.json.
	- Đối với role được phép list user, chúng ta định nghĩa role trong file `/etc/keystone/policy.json` (list user thuộc project keystone quản lý).
	- Mở file `/etc/keystone/policy.json` mà thực hiện định nghĩa role như sau:
	```sh
	"list_user":"role:duc", 	
	# dòng này để giải thích cấu trúc của file đã đề cập ở trên "<rule>": "define rule",
	# Ý nghĩa của dòng này: định nghĩa ra một quy tắc là `list_user`, role được phép thực hiện quy tắc này là `duc`
	# Chúng ta có thể thêm nhiều hơn 1 role cho phép thực hiện rule này

	# Để cho phép thực hiện list user, chúng ta tìm đến dòng `"identity:list_users": "rule:admin_required",` và thay thế bằng dòng sau:

	"identity:list_users": "rule:admin_required or rule:list_user",	# dòng này tương đương với "<target>": "<rule> or <role>"

	# Hoặc có thể thêm ngay role vào thay vì rule như sau
	"identity:list_users": "rule:admin_required or role:duc",
	```

- Kiểm tra lại bằng các sau:
	```sh
	# Khai báo biến môi trường để xác thực user duc
	root@controller:~# export OS_PROJECT_DOMAIN_NAME=Default
	root@controller:~# export OS_USER_DOMAIN_NAME=Default
	root@controller:~# export OS_PROJECT_NAME=duc
	root@controller:~# export OS_USERNAME=duc
	root@controller:~# export OS_PASSWORD=123
	root@controller:~# export OS_AUTH_URL=http://controller:35357/v3
	root@controller:~# export OS_IDENTITY_API_VERSION=3
	root@controller:~# export OS_IMAGE_API_VERSION=2

	# Thực hiện lệnh list user ra và xem kết quả
	root@controller:~# openstack user list
	+----------------------------------+-----------+
	| ID                               | Name      |
	+----------------------------------+-----------+
	| 0dbfa2b697d24b0cb3aaad815d72799a | nova      |
	| 116522ee479c4cc7a7dc9c81691d5a9b | demo      |
	| 3ce3ca843dc7458bb61c851d3a654b8b | admin     |
	| 49b68f1a90fc493fa1acb82cfe30d6c4 | duc       |
	| 9424c28abcbd494bb2cd241184dffec7 | placement |
	| f00f9e4d49d54cbca319d9075e502127 | neutron   |
	| fe1d690b18df406d9b2aa500ce808346 | glance    |
	+----------------------------------+-----------+
	```

##### Trên đây là một ví dụ định nghĩa role đơn giản.