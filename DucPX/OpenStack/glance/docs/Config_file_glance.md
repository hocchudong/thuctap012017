# Một số cấu hình cơ bản của glance

## Mục lục
- [Cấu hình lữu trữ image ở nhiều nơi trong filesystem](#multi)
- [Cấu hình các định dạng disk được hỗ trợ](#format)
- [Cấu hình xác thực với keystone](#authkeystone)

<a name=multi></a>
### Cấu hình lữu trữ image ở nhiều nơi trong filesystem.
- Cấu hình chức năng này cho phép mở rộng lưu trữ.
- file để cấu hình là `/etc/glance/glance-api.conf`
- Trong cấu hình này, sử dụng back end để lưu trữ image là filesystem
- Cấu hình trong section `[glance_store]`
- Dòng để cấu hình: `filesystem_store_datadirs=PATH:PRIORITY`
	- PATH: đường dẫn đến thư mục để lưu trữ.
	- PRIORITY: độ ưu tiên của thư mục.
- Mặc định: `filesystem_store_datadir=/var/lib/glance/images:1`
- Chúng ta cũng cần chỉ rõ độ ưu tiên của thư mục dùng để lưu trữ images. Thư mục nào có độ ưu tiên cao hơn sẽ được ưu tiên lưu trữ trước. Nếu chúng ta không chỉ rõ độ ưu cho thư mục thì mặc định thư mục có độ ưu tiên là 0.
- Ví dụ:
	```sh
	[glance_store]
	filesystem_store_datadir=
	filesystem_store_datadirs=/var/lib/glance/images
	filesystem_store_datadirs=/home/images-1:200
	filesystem_store_datadirs=/home/images-2:100
	```
- Tham khảo cấu hình chức năng này [tại đây](../docs/Multi_store_locations.md)

<a name=format></a>
### Cấu hình các định dạng disk được hỗ trợ
- Mỗi image trong glance có thuộc tính liên quan đến `disk format`.
- Khi tạo 1 image, người tạo phải chỉ rõ `disk format`. 
- Định dạng này là 1 trong những định dạng mà dịch vụ glance hỗ trợ.
- Có thể thêm, bớt định dạng ở trong file cấu hình để được glance hỗ trợ.
- Được cấu hình trong section `[image_formats]` của file `/etc/glance/glance-api.conf`
- Tham số để cấu hình: `disk_formats=<Comma separated list of disk formats>`
- Mặc định glance hỗ trợ: ami,ari,aki,vhd,vhdx,vmdk,raw,qcow2,vdi,iso,ploop.
- Ví dụ:
	```sh
	[image_format]

	disk_formats = ami,ari,aki,vhd,vhdx,vmdk,raw,qcow2,vdi,iso,ploop.root-tar
	```

<a name=authkeystone></a>
### Cấu hình xác thực với keystone
#### Cấu hình glance server để sử dụng keystone
- Keystone được tích hợp với glance thông qua sử dụng middleware. Các file cấu hình mặc định cho cả glance API và glance registry sử dụng phần duy nhất của middleware được gọi là `unauthenticated-context`. Điều này phát sinh một ngữ cảnh yêu cầu chứa thông tin xác thực rỗng. Để cấu hình glance sử dụng keystone, xác thực token và trong ngữ cảnh middleware thì phải được triển khai ở `unauthenticated-context` của middleware. `authtoken` middleware thực hiện xác thực token xác thực (authentication token validation) và lấy thông tin xác thực user thực tế. 

- **Cấu hình glance API để sử dụng keystone**
- Để cấu hình glance api sử dung keystone, hãy chắc chắn rằng khai báo hai phần của middleware tồn tại trong `glance-api-paste.ini`.
	- ví dụ:
	```sh
	[filter:authtoken]
	paste.filter_factory = keystonemiddleware.auth_token:filter_factory
	auth_url = http://localhost:35357
	project_domain_id = default
	project_name = service_admins
	user_domain_id = default
	username = glance_admin
	password = password1234
	```
	- giá trị các biến ở đây tùy thuộc vào hệ thống của bạn. Tham khảo về [Middleware tại đây](../../Keystone/docs/Middlewarearchitecture.md)

