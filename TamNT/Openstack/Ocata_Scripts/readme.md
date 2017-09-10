# Tổng hợp scripts cài đặt Openstack Ocata

scripts cài đặt Ocata theo docs [trang chủ.](https://docs.openstack.org/ocata/install-guide-ubuntu)

## Topology 

![img](../Keystone/images/topo_ocata.png)

## IP planning

![img](../Keystone/images/ipplan.png)

## Hướng dẫn chạy scripts cài trên node controller và một node compute là compute1

- Download các file scripts.

- Sử dụng người dùng sudoer hoặc người dùng `root` để thực hiện các lệnh sau.

- Thực hiện gán quyền thực thi cho các file scripts

  `chmod a+x *.sh`

- Chỉnh sửa lại cấu hình theo ý muốn tại file [config.sh](./config.sh)

- Chạy lần lượt các lệnh như sau:

- **Node controller**:

	- Cấu hình IP và host name cho node controller:

		`source ctl-0-ipadd.sh`

	- Cài đặt các gói cần thiết cài đặt Openstack

		`source ctl-1-env.sh`

	- Cài đặt và cấu hình Keystone:

		`source ctl-2-keystone.sh`

	- Cài đặt và cấu hình Glance:

		`source ctl-3-glance.sh`

	- Cài đặt và cấu hình Nova:

		`source ctl-4-nova.sh`

	- Cài đặt và cấu hình Neutron (option 2):

		`source ctl-6-neutron.sh`

	- Cài đặt và cấu hình Horizon: 

		`source ctl-7-horizon.sh`

- **Node compute1**:

	- Cài đặt và cấu hình IP và hostname cho node compute1:

		`source com1-0-ipadd.sh`

	- Cài đặt và cấu hình môi trường chuẩn bị cài đặt Openstack:

		`source com1-1-env.sh`

	- Cài đặt và cấu hình Nova node compute:

		`source com1-2-nova.sh`

		Sau khi cài đặt service nova-compute trên node 	`compute1`, cần update lại trên node `controller` để nó có thể liên kết với compute1 trong service nova. Chạy script sau (***lưu ý thực hiện trên node `controller`***): 

		`source ctl-5-discoveryHost.sh`

	- Cài đặt và cấu hình Neutron node compute:

		`source com1-3-neutron.sh`

- Vậy là hoàn thành setup Openstack Ocata. 


