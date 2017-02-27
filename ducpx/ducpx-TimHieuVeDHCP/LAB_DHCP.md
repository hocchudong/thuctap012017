#Lab DHCP trên máy ảo VMware Workstation

##Mô hình bài lab
![Imgur](http://i.imgur.com/UOA1Mrl.png)

- Yêu cầu bài lab:
	- Dựng mô hình DHCP trên môi trường Ubuntu server 64 bit 14.04.
	- Cấp phát IP theo địa chỉ MAC.
	- Cấp phát nhiều dải địa chỉ IP trong hệ thống mạng.
	
##1. Cài đặt và cấu hình
- Đăng nhập vào hệ thống với quyền **root**
- Cập nhật các gói phần mềm: `apt-get update`
- Cài đặt phần mềm chạy dịch vụ dhpc: `apt-get install -y isc-dhcp-server`
- Bắt đầu cấu hình. Trong mô hình yêu cầu cấp 2 dải địa chỉ khác nhau thông qua 2 card mạng. Chỉ rõ 2 interface này trong file `/etc/default/isc-dhcp-server` ![Imgur](http://i.imgur.com/bJ0x9m1.png). Khai báo 2 interface như hình.
	- `eth1` cấp dải địa chỉ `192.168.10.0/24`
	- `eth2` cấp dải địa chỉ `192.168.20.0/24`
	
- Cấu hình để DHCP Server trong file `/etc/dhcp/dhcpd.conf`:
	- Khai báo 2 dải địa chỉ dùng để cấp phát cho client  ![Imgur](http://i.imgur.com/QffELsG.png):
	- Khai báo cấp phát địa chỉ IP theo địa một địa chỉ MAC định trước ![Imgur](http://i.imgur.com/YmxdzGN.png)

- Khởi động lại dịch vụ: `service isc-dhcp-server restart`

##2. Kiểm tra kết quả chạy trên client
- cấu hình card mạng nhận cấp phát DHCP trên tất cả các máy:
```sh
auto eth1
iface eth1 inet dhcp
```
- kiểm tra thông tin cấu hình: ifconfig -a
	- một máy nhận từ dải `192.168.10.0/24`	![Imgur](http://i.imgur.com/6dS8xzt.png)
	- một máy nhận từ dải `192.168.20.0/24` ![Imgur](http://i.imgur.com/qJ7YzHR.png)
	- một máy nhận 1 địa chỉ được chỉ rõ trước theo địa chỉ MAC ![Imgur](http://i.imgur.com/Vc90Hjk.png)  
	


	