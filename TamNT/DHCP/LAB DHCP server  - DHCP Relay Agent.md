# LAB DHCP

## ***Mục lục***

[1. LAB triển khai DHCP server ](#1)

- [1.1. Mô hình](#1.1)

- [1.2. Chuẩn bị](#1.2)

- [1.3. Cấu hình DHCP server ](#1.3)

[2. LAB triển khai DHCP Relay Agent](#2)

- [2.1. DHCP Relay Agent là gì?](#2.1)

- [2.2. Mô hình bài Lab](#2.2)

- [2.3. Cấu hình DHCP server ](#2.3)

- [2.4. Cấu hình DHCP Relay Agent](#2.4)


[3. Tham khảo](#3)


---

<a name="1"></a>
# 1. LAB triển khai DHCP server 

<a name="1.1"></a>
## 1.1. Mô hình

<img src="http://imgur.com/stB0I9I.jpg">

- Mô hình Lab thực hiện trên các máy ảo VMware cài hệ điều hành Ubuntu.

- Tắt chế độ DHCP của VMware: 

<img src="http://imgur.com/GljXCY8.jpg">

- Mục đích bài Lab:

  - Hiểu về mô hình triển khai DHCP.

  - Cấu hình DHCP cấp phát địa chỉ IP cho các client trong dải mạng VMnet 1.

  - Cấu hình cấp phát IP theo địa chỉ MAC (cấu hình cho máy client 1).

<a name="1.2"></a>
## 1.2. Chuẩn bị

**Chuẩn bị cho DHCP server**

DHCP server chạy trên hệ điều hành Ubuntu server 14.04, sử dụng gói phần mềm `isc-dhcp-server` để chạy DHCP server. Địa chỉ ip: 10.10.10.10/24

Để cài đặt `isc-dhcp-server` ta thực hiện như sau:

```
sudo apt-get update
sudo apt-get install isc-dhcp-server -y
```

**Chuẩn bị cho các máy DHCP Client**

Các máy client 1 và 2 đóng vai trò là các máy DHCP client. Sửa trong file `/etc/network/interfaces` để các máy sử dụng DHCP cấu hình cho card mạng host-only (trong bài này đều là các card eth1) cả 2 máy như sau:

```
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback

auto eth0                   #cấu hình cho card eth0 không cần quan tâm
iface eth0 inet static
address 172.16.69.20/24
gateway 172.16.69.1
dns-nameservers 8.8.8.8

auto eth1                   #cấu hình DHCP cho card eth1 dải host-only
iface eth1 inet dhcp 

```

<a name="1.3"></a>
## 1.3. Cấu hình DHCP server 

- **Bước 1**: Cấu hình Interface lắng nghe các bản tin DHCP cho DHCP server trong file `/etc/default/isc-dhcp-server` như sau:

<img src="http://imgur.com/GjfctDO.jpg">

(Ở đây cho lắng nghe các bản tin DHCP trên interface eth1 do các máy client trong dải VMnet 1)

- **Bước 2**: Cấu hình một dải IP được quản lý bởi DHCP server. Ở đây cấu hình dải 10.10.10.0/24 để DHCP server có thể lắng nghe bản tin DHCP trên eth1.

Chỉnh sửa trong file /etc/dhcp/dhcpd.conf

<img src="http://imgur.com/eberoZO.jpg">

Đây là cấu hình mặc định, có thể đọc thêm thông tin trong file các tùy chọn được giải thích ở bên trên để cấu hình tùy ý. 

  Giải thích: 

    - Cấu hình cho DHCP server cấp phát và quản lý các địa chỉ trong dải 10.10.10.0/24. Cấp dải địa chỉ động từ 10.10.10.150 tới 10.10.10.200

    - Cấu hình tĩnh IP cho client có MAC là : `00:0c:29:e2:ce:21` địa chỉ 10.10.10.50

- **Bước 3**: Khởi động lại dịch vụ DHCP bằng lệnh:

  `sudo isc-dhcp-server restart`

- **Kết quả**: Bật lại các card eth1 của các máy client 1 và 2 bằng lệnh `ifdown eth1 && ifup eth1` ta thu được kết quả như sau: 

  - Máy client 1 nhận được địa chỉ IP cấp phát từ DHCP server (10.10.10.10):
  
  <img src="http://imgur.com/MgRn6rU.jpg">

  - Máy client 2 cấp địa chỉ 10.10.10.50 theo địa chỉ MAC:

  <img src="http://imgur.com/UI7ASBJ.jpg">

<a name="2"></a>
# 2. LAB triển khai DHCP Relay Agent

<a name="2.1"></a>
## 2.1. DHCP Relay Agent là gì?

- Do DHCP sử dụng broadcast, nên DHCP client và DHCP server phải nằm trên cũng một mạng vật lý để có thể lắng nghe các bản tin broadcast của nhau. Để một client và một server trên các mạng khác nhau có thể liên lạc, một thành phần thứ 3 được yêu cầu giải quyết vấn đề chuyển tiếp các bản tin broadcast là DHCP relay agent. 

- Thiết bị này thông thường là router lắng nghe DHCP client và relay chúng tới DHCP server. Server gửi bản tin reply lại cho client tới DHCP relay agent và nó sẽ gửi bản tin đó lại cho client.

- Hoạt động của DHCP Relay Agent: 

<img src="http://imgur.com/Nvw2VRG.jpg">

- Quá trình xử lý các bản tin: 

<img src="http://imgur.com/LO7knnY.jpg">

- Ưu điểm: 

  - Phù hợp với các máy tính thường xuyên di chuyển giữa các lớp mạng.

  - Kết hợp với hệ thống mạng không dây ( Wireless) cung cấp tại các điểm – Hotspot như: nhà ga, sân bay, khách sạn, trường học.

  - Thuận tiện cho việc mở rộng hệ thống mạng.

  - Quản lý địa chỉ tập trung.

<a name="2.2"></a>
# 2.2. Mô hình bài lab

<img src="http://imgur.com/pQnqUAw.jpg">


Thực hiện lab trên các máy ảo VMware Work station 12, cấu hình 2 dải mạng host-only VMnet 1 ứng với dải địa chỉ 0.10.10.0/24 và dải VMnet2 ứng với dải địa chỉ 10.10.20.0/24.

\- Máy DHCP server có nhiệm vụ cấp phát và quản lý địa chỉ IP.

\- Máy DHCP Relay Agent có nhiệm vụ chuyển tiếp các bản tin DHCP từ client tới server và ngược lại.

\- 2 máy DHCP cùng nằm trong dải VMnet1: 10.10.10.0/24

\- DHCP Relay Agent và Client cùng nằm trong dải VMnet2: 10.10.20.0/24

\- DHCP Relay Agent có 2 card mạng: eth1 : 10.10.10.20/24 và eth2: 10.10.20.20/24 cấu hình tĩnh.

<a name="2.3"></a>
# 2.3. Cấu hình DHCP server 

- **Bước 1**: cấu hình địa chỉ IP eth1 địa chỉ tĩnh 10.10.10.10/24

- **Bước 2**: Định tuyến tĩnh cho dải địa chỉ 10.10.20.0/24

  Bởi vì DHCP server và client nằm trên 2 dải mạng khác nhau, nên chúng ta cần cấu hình định tuyến tĩnh để bản tin reply từ DHCP server có thể tìm được đường về với client.
  
  Sửa lại trong file `/etc/network/interfaces` như sau:
  ```
  auto eth1
  iface eth1 inet static
  address 10.10.10.10/24
  up route add -net 10.10.20.0 netmask 255.255.255.0 gw 10.10.10.20
  ```

  Các bản tin từ dải mạng 10.10.20.0/24 sẽ được gửi về qua 10.10.10.20 (địa chỉ IP của DHCP Relay Agent)

  Sau khi khởi động lại card mạng, ta có bảng định tuyến tĩnh mới và đồng thời có thể ping tới dải mạng 10.10.20.0/24

  <img src="http://imgur.com/LML3aSW.jpg">

- **Bước 3**: Cài đặt và cấu hình isc-dhcp-server như trong phần 1. Tạo thêm một subnet DHCP quản lý như sau:

<img src="http://imgur.com/wm450Lp.jpg">

  option router: để địa chỉ gateway của mạng. (Chính là DHCP Relay Agent để nó có thể forward gói tin cho DHCP server )

- **Bước 4**: Khởi động lại dịch vụ DHCP server: 

`sudo isc-dhcp-server restart`

<a name="2.4"></a>
# 2.4. Cấu hình trên DHCP Relay Agent

- **Bước 1**: Cấu hình địa chỉ tĩnh cho card eth1 và eth2 như mô hình lab. 

- **Bước 2**: Cài đặt gói DHCP Relay Agent: `isc-dhcp-relay`

`sudo apt-get install isc-dhcp-relay -y`

Trong lúc setup, bạn sẽ được hỏi một số thông tin cấu hình như sau: 

<img src="http://imgur.com/bOvtlZe.jpg">

Nhập địa chỉ DHCP server mà muốn DHCP relay forward các bản tin DHCP. Ở đây điền vào IP 10.10.10.10 của DHCP server.(Bước này sau có thể chỉnh sửa được trong file cấu hình)

<img src="http://imgur.com/MmuNu0Q.jpg">

Điền 2 interface eth1 và eth2 để DHCP relay lắng nghe các bản tin DHCP request tới từ client trên eth2, và các bản tin DHCP reply trên eth1.

Các phần còn lại để mặc định, nhấn `ENTER`. Vậy là đã cài đặt xong DHCP relay trên máy 10.10.10.20.

- **Bước 3**: Sửa lại cấu hình trong file `/etc/default/isc-dhcp-relay` như sau: 

<img src="http://imgur.com/YOXFwS6.jpg">

Hoặc bạn có thể tùy chỉnh theo các cấu hình trong mô hình của bạn.

Khởi động lại dịch vụ DHCP relay: 

`sudo isc-dhcp-relay restart`

- **Bước 4**: Cấu hình cho phép chuyển tiếp các gói tin qua các card: Sửa bỏ comment tại dòng: `net.ipv4.ip_forward=1` trong file `/etc/sysctl.conf`

<img src="http://imgur.com/f7igkmR.jpg">


### ***Kết quả***

Máy client nhận được IP trong dải 10.10.20.0/24 như sau:


<img src="http://imgur.com/RpJEXau.jpg">

<a name="3"></a>
# 3. Tham khảo:

[1] DHCP Server: https://github.com/hocchudong/thuctap032016/blob/master/LTLinh/LTLinh-B%C3%A1o%20c%C3%A1o%20giao%20th%E1%BB%A9c%20DHCP/LTLinh-LABtrienkhaiDHCPServer.md

[2] DHCP Relay Agent: https://github.com/hocchudong/thuctap032016/blob/master/LTLinh/LTLinh-B%C3%A1o%20c%C3%A1o%20giao%20th%E1%BB%A9c%20DHCP/LTLinh-LABDHCPRelay.md