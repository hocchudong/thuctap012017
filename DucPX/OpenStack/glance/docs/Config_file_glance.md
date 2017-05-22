# Một số cấu hình cơ bản của glance

## Mục lục
- [Cấu hình lữu trữ image ở nhiều nơi trong filesystem](#multi)
- [Cấu hình các định dạng disk được hỗ trợ](#format)


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
