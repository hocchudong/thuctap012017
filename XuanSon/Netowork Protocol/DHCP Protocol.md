# DHCP Protocol

# MỤC LỤC
- [1.Giới thiệu và Vai trò DHCP Protoclol](#1)
  - [1.1.Khái niệm](#1.1)
  - [1.2.Vai trò DHCP protocol](#1.2)
- [2.Hoạt động của giao thức DHCP](#2)
  - [2.1.Giới thiệu](#2.1)
  - [2.2.Tiến trình hoạt động của DHCP](#2.2)
  - [2.3. Các loại bản tin DHCP](#2.3)
  - [2.4.DHCP Header Structure](#2.4)
  - [2.5.Dùng Wireshark bắt DHCP message](#2.5)
- [3.Cài đặt DHCP Server on Ubuntu Server 14.04 và LAB](#3)
  - [3.1.isc-dhcp-server](#3.1)
  - [3.2.Install and Configuration](#3.2)
    - [3.2.1.Install](#3.2.1)
    - [3.2.2.Configuration](#3.2.2)
  - [3.3.Lab](#3.3)
    - [3.3.1.Mô hình](#3.3.1)
    - [3.3.2.Cấu hình](#3.3.2)
    - [3.3.3.Kết quả](#3.3.3)
- [THAM KHẢO](#thamkhao)

<a name="1"></a>
# 1.Giới thiệu và Vai trò DHCP Protoclol

<a name="1.1"></a>
## 1.1.Khái niệm
\- DHCP (Dynamic Host Configuration Protocol ) là network protocol được sử dụng trên Internet Protocol (IP). DHCP là protocol của application layer , có chức năng chính là cấp phát IP address cho các DHCP client trong network .  
\- DHCP hoạt động dựa trên mô hình client-server . DHCP server quản lý pool của IP address và thông tin về thông số configuration client , như defaul gateway , domain name , name servers và time servers .  
\- Tùy thuộc vào triển khai , DHCP server có thể có 3 phương pháp allocating IP address :  
- Dynamic allocation : Network admin dự trữ một range của IP address cho DHCP , mỗi DHCP client trong LAN được cấu hình yêu cầu IP address từ DHCP server trong quá trình khởi động . Quá trình request and grant sử dụng khái niệm “lease” với một khoảng time , cho phép DHCP server lấy lại IP address không được gia hạn .
- Automatic allocation : DHCP server gán vĩnh viễn IP address cho client yêu cầu từ range được định nghĩa bởi admin . 
Điều này giống như dynamic allocation , nhưng DHCP server giữa một table của phân công IP address trong quá khứ , để nó có thể ưu tiên assign IP address giống IP address đã đươc assign trước đó .
- Manual allocation ( thường gọi là static allocation ) 
DHCP server assign IP addres phụ thuộc vào MAC address của từng client . Tính năng này thường gọi là static DHCP assignment .

<a name="1.2"></a>
## 1.2.Vai trò DHCP protocol
\- DHCP giảm thiểu tối đa lỗi cấu hình gây ra bởi việc cấu hình IP thủ công .  
Ví dụ : Cấu hình sai topology hay cấu hình IP bị xung đột (hai máy trong mạng cấu hình cùng một địa chỉ IP) .  
\- Đơn giản hóa việc quản trị mạng:  
- Cấu hình tập trung và tự động các thông tin TCP/IP cho các máy client ( như deafault gateway , DNS server , etc )
- Quản lý và duy trì miền địa chỉ IP cấp phát cho các client, tự động cấp phát nhưng cũng tự động thu hồi địa chỉ IP (khi một máy client rời khỏi mạng)
- Chuyển tiếp bản tin DHCP khởi tạo bằng việc sử dụng DHCP relay agent, tránh việc phải cài đặt DHCP trên mỗi subnet .

<a name="2"></a>
# 2. Hoạt động của giao thức DHCP

<a name="2.1"></a>
## 2.1.Giới thiệu
\- DHCP sử dụng connection less service , đang sử dụng UDP .  
\- Nó sử dụng 2 UDP port cho hoạt động như BOOTO protocol . UDP port 67 là destination port của server , UDP port number 68 là được sử dụng bởi client .  
\- DHCP hoạt động trong 4 bước : server discovery , IP lease offer , IP lease request , IP lease acknowledgement . Các giai đoạn này thường được biết tắt là DORA <=> discovery , offer , request ,và acknowledgement .

<a name="2.2"></a>
## 2.2.Tiến trình hoạt động của DHCP

<img src="http://i.imgur.com/hb4NPdp.png" >  

\- **Bước 1:** Khi máy Client khởi động, Client sẽ gửi **broadcast** packet `DHCP DISCOVER`, yêu cầu một DHCP Server phục vụ mình. Gói tin này cũng chứa địa chỉ MAC của client. Nếu client không liên lạc được với DHCP Server thì sau 4 lần truy vấn không thành công nó sẽ tự động phát sinh ra 1 địa chỉ IP riêng cho chính mình nằm trong dãy `169.254.0.0` đến `169.254.255.255` dùng để liên lạc tạm thời. Và client vẫn duy trì việc phát tín hiệu Broadcast sau mỗi 5 phút để xin cấp IP từ DHCP Server.  
\- **Bước 2:** Các máy DHCP Server trên mạng khi nhận được yêu cầu đó. Nếu còn khả năng cung cấp địa chỉ IP, đều gửi lại cho máy Client một gói tin `DHCP OFFER`( bản tin broadcast ) , đề nghị cho thuê một địa chỉ IP trong một khoảng thời gian nhất định, kèm theo là một Subnet Mask và Server IP address. Server sẽ không cấp phát IP address vừa đề nghị cho client thuê trông suốt thời gian thương thuyết.  
\- **Bước 3:** Máy Client sẽ lựa chọn một trong những lời đề nghị ( DHCPOFFER) và gửi broadcast lại gói tin `DHCPREQUEST` và chấp nhận lời đề nghị đó. Điều này cho phép các lời đề nghị không được chấp nhận sẽ được các Server rút lại và dùng để cấp phát cho các Client khác.  
\- **Bước 4:** Máy Server được Client chấp nhận sẽ gửi ngược lại một gói tin `DHCP ACK` (đây là bản tin broadcast ) như một lời xác nhận, cho biết địa chỉ IP đó, Subnet Mask đó và thời hạn cho sử dụng đó sẽ chính thức được áp dụng. Ngoài ra server còn gửi kèm những thông tin bổ xung như địa chỉ default gateway, địa chỉ DNS Server.  
<a name="2.3"></a>
## 2.3. Các loại bản tin DHCP
\- **DHCP Discover**  
Client gửi message broacast on the network subnet sử dụng destination address `255.255.255.255` hoặc subnet broacast address chỉ định .  
Broadcast message này của client để yêu cầu DHCP server cấp phát IP address cho mình .  
\- **DHCP Offer**  
Khi DHCP server nhận được DHCPDISCOVER message từ client , 1 IP address là được yêu cầu thuê , server dành 1 IP address cho client bằng cách gửi DHCPOFFER message đến client (đây là message unicast ) .  
Message chứa MAC address của client , IP address mà server dành cho client , subnet mask , IP address ,DNS domain, gateway của DHCP server gửi DHCPOFFER message .  
\- **DHCP Request**  
DHCP client sau khi lựa chọn một bản tin DHCPOffer. Bản tin này chứa địa chỉ IP từ bản tin DHCPOffer đã chọn, xác nhận thông tin IP đã nhận từ server để các DHCP server khác không gửi bản tin Offer cho client đó nữa.  
\- **DHCP Ack**  
Khi DHCP server nhận DHCPREQUEST message từ client , DHCP server gửi DHCPACK packet đến client , message mang tất cả thông tin cấu hình IP . Sau đó ,kết thúc quá trình cấp phát IP .  

\- **DHCP Nack**  
Broadcast bởi DHCP server tới DHCP client thông báo từ chối bản tin DHCPRequest vì nó không còn giá trị nữa hoặc được sử dụng hiện tại bởi một máy tính khác .  
\- **DHCP Decline**  
Nếu DHCP Client quyết định tham số thông tin được đề nghị nào không có giá trị, nó gửi gói DHCP Decline đến các Server và Client phải bắt đầu tiến trình thuê bao lại.  
\- **DHCP Release**  
Unicast từ DHCP client tới DHCP server rằng nó bỏ địa chỉ IP và thời gian sử dụng còn lại.  
\- **DHCPInform**  
Một DHCP Client gửi một gói DHCP Release đến một server để giải phóng địa chỉ IP và xoá bất cứ thuê bao nào đang tồn tại.  

<a name="2.4"></a>
## 2.4.DHCP Header Structure

<img src="http://i.imgur.com/8Hau7Yr.png" >  

| Trường | Dung lượng | Mô tả|
|------- |-------|------|
| Opcode | 8 bits | Xác định loại message . Giá trị “1” là request message , “2” là reply message|
| Hardware type | 8 bits | Quy định cụ thể loại hardware.   <img src="http://i.imgur.com/w8uaKb6.png" >|
| Hardware length | 8 bits | Quy định chiều dài của hardware address |
|Hop counts |8 bits|Set bằng “0” bởi client trước khi truyền request và được sử dụng bởi relay agent để control forwarding của BOOTP và DHCP messages .|
|Transaction Identifier	|32 bits|Được tạo bởi client, dùng để liên kết giữa request và replies của client và server.|
|Number of seconds |16 bits|được định nghĩa là số giây trôi qua kể từ khi client bắt đầu cố gắng để có được 1 IP hoặc thuê 1 IP mới . Điều này có thể được sử dụng khi DHCP Server bận , để sắp xếp thứ tự ưu tiên khi có nhiều request từ client chưa được giải quyết .|
|Flags |16 bits|<img src="http://i.imgur.com/Fd4cj0G.png" >|
|Client IP address |32 bits|Client sẽ đặt IP của mình trong field này nếu và chỉ nếu nó đang có IP hay đang xin cấp lại IP, không thì mặc định = 0|
|Your IP address |32 bits|IP address được server cấp cho client|
|Server IP address |32 bits|IP address của Sever|
|Gateway IP address	|32 bits|Sử dụng trong relay agent|
|Client hardware address |16 bytes|Địa chỉ lớp 2 của client, dùng để định danh|
|Server host name |64 bytes|Khi DHCP server gửi DHCPOFFER hay DHCPACK thì sẽ đặt tên của nó vào trường này, nó có thể là “nickname” hoặc tên DNS domain|
|Boot filename |128 bytes|Option được sử dụng bởi client khi request 1 loại boot file trong DHCPDISCOVER message.  Được sử dụng bởi server trong DHCPOFFER để chỉ định path đến boot file directory và filename .|
|Options |Variable||

<a name="2.5"></a>
## 2.5.Dùng Wireshark bắt DHCP message
<img src="http://i.imgur.com/f7zIKv4.png" >  

\- **DHCP Discover**  
<img src="http://i.imgur.com/EZbHL4a.png" >   

\- **DHCP offer**  
<img src="http://i.imgur.com/tUvJ9BF.png" >  
<img src="http://i.imgur.com/cHm7Wcq.png" >  

\- **DHCP Request**  
<img src="http://i.imgur.com/Cs0y4Je.png" >  
<img src="http://i.imgur.com/lClNxgc.png" >  

\- **DHCP ACK**  
<img src="http://i.imgur.com/vA1AYOx.png" >  
<img src="http://i.imgur.com/zjuwCxm.png" >  

<a name="3"></a>
# 3.Cài đặt DHCP Server on Ubuntu Server 14.04 và LAB
<a name="3.1"></a>
## 3.1.isc-dhcp-server
\- `isc-dhcp-server` là phần mềm tạo cho host giả lập DHCP Server.  
<a name="3.2"></a>
## 3.2.Install and Configuration
<a name="3.2.1"></a>
### 3.2.1.Install
```
#apt-get install isc-dhcp-server
```

<a name="3.2.2"></a>
### 3.2.2.Configuration
#### a.File /etc/default/isc-dhcp-server
\- Sửa hoặc tạo ( nếu không có ) 1 file `/etc/default/isc-dhcp-server` với quyền root có nội dung như sau :  
```
INTERFACES="<ethx> <ethy>"
```
với `ethx` , `ethy` là network card thuộc mạng LAN cần cài dhcp server .  
\- Chú ý: Nếu để cấu hình như sau:  
```
INTERFACES=""
```

thì DHCP server sẽ lắng nghe trên tất cả các địa chỉ IP.

#### b.File /etc/dhcp/dhcpd.conf
\- Nội dung file `/etc/dhcp/dhcpd.conf` :  
```
# Sample configuration file for ISC dhcpd for Debian
#
# Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as
# configuration file instead of this file.
#
#

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# No service will be given on this subnet, but declaring it helps the
# DHCP server to understand the network topology.

#subnet 10.152.187.0 netmask 255.255.255.0 {
#}
# This is a very basic subnet declaration.

#subnet 10.254.239.0 netmask 255.255.255.224 {
#  range 10.254.239.10 10.254.239.20;
#  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
#}

# This declaration allows BOOTP clients to get dynamic addresses,
# which we don't really recommend.

#subnet 10.254.239.32 netmask 255.255.255.224 {
#  range dynamic-bootp 10.254.239.40 10.254.239.60;
#  option broadcast-address 10.254.239.31;
#  option routers rtr-239-32-1.example.org;
#}

# A slightly different configuration for an internal subnet.
#subnet 10.5.5.0 netmask 255.255.255.224 {
#  range 10.5.5.26 10.5.5.30;
#  option domain-name-servers ns1.internal.example.org;
#  option domain-name "internal.example.org";
#  option routers 10.5.5.1;
#  option broadcast-address 10.5.5.31;
#  default-lease-time 600;
#  max-lease-time 7200;
#}
# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
#host fantasia {
#  hardware ethernet 08:00:07:26:c0:a5;
#  fixed-address fantasia.fugue.com;
#}
```

\- Giải thích file cấu hình : ( các từ trong dấu < > là các biến )  
- `ddns-update-style <none>;`  : Không cho cập nhật DNS động
- `option domain-name <"example.org">;`  : Tên domain của mạng
- `option domain-name-servers <ns1.example.org> , <ns2.example.org>;`  : Máy chủ DNS , ns1.example.org và ns2.example.org có thể là IP address .
- `default-lease-time <600>;` : Thời gian cấp mặc định là 600 giây
- `max-lease-time <7200>;` : Thời gian tối đa cấp IP nếu sau thời gian này không phản hồi tín hiệu thì IP sẽ được cấp cho clients khác trong mạng
- `authoritative;` : Nếu DHCP Server dùng cho mạng cục bộ thì ta nên kích hoạt tính năng authritative
- `log-facility local7;` : file log.
- `subnet <172.16.69.0> ;` : Địa chỉ mạng.
- `netmask <255.255.255.0> ;` : Định nghĩa lớp mạng.
- `option routers <172.16.69.1> ;` : Default getway cho mạng.
- `range <172.16.69.50> <172.16.69.100> ;` : khoảng IP dùng để cấp cho các client trong mạng.
- host <fantasia> {  
hardware ethernet <08:00:07:26:c0:a5>;  
fixed-address <fantasia.fugue.com> ;  
	}  
	: cái này để cấu hình IP address tĩnh cho từng dhcp client . Với `hardware ethernet` là MAC address , `fixed-address` là IP address của client đó .

\- Ví dụ :  
```
ddns-update-style none;

default-lease-time 600;
max-lease-time 7200;

authoritative;

subnet 172.16.69.0 netmask 255.255.255.0 {
range 172.16.69.50 172.16.69.100;
range 172.16.69.150 172.16.69.200;
option domain-name-servers 172.16.69.1;
option domain-name "network_one";
option routers 172.16.69.1;
option broadcast-address 172.16.69.255;
}

host client2 {
    hardware ethernet 00:0C:29:09:6F:7E;
    fixed-address 172.16.69.25;
}
```
 
\- Lưu ý :  
If you need to specify a WINS server for your Windows clients, you will need to include the netbios-name-servers option, e.g.  
```
vi /etc/dhcp/dhcpd.conf
```
```
option netbios-name-servers 192.168.1.1; 
```
\- Sau khi config file `/etc/dhcp/dhcpd.conf` . Start and stop service :  
```
sudo service isc-dhcp-server restart
sudo service isc-dhcp-server start
sudo service isc-dhcp-server stop
```

<a name="3.3"></a>
## 3.3.Lab
<a name="3.3.1"></a>
### 3.3.1.Mô hình
<img src="http://i.imgur.com/CJJg7Iw.png" >  

\- Hai máy ảo Ubuntu Server 14.04 cài trên VMWare Workstation 12.5 Pro .  
\- Network : 3 máy chung dải network 172.16.69.0/24 : chế độ NAT  
\- Cấu hình :  
- Cấp IP address cho Client 1 trong dải được cấu hình .
- Cấu hình cấp phát IP theo MAC address cho Client 2 . 

<a name="3.3.2"></a>
### 3.3.2.Cấu hình

\- Bước 1: Update hệ thống:  
```
sudo apt-get update
```
\- Bước 2: Cài đặt gói `isc-dhcp-server` và các gói phụ thuộc:  
```
sudo apt-get install isc-dhcp-server -y
```
\- Bước 3: Sau khi cài đặt xong, thực hiện cấu hình gán interface của DHCP server, chỉnh sửa file sau:  
```
sudo vi /etc/default/isc-dhcp-server 
```
Ở đây chọn card `eth0`.  
<img src="http://i.imgur.com/iB1sZgU.png" >  

\- Bước 4: Cấu hình 2 dải IP cấp cho client. Mở và cấu hình file:  
```
sudo vi /etc/dhcp/dhcpd.conf
```
và ghi nội dung như sau :  
```
ddns-update-style none;

default-lease-time 600;
max-lease-time 7200;

authoritative;

subnet 172.16.69.0 netmask 255.255.255.0 {
range 172.16.69.50 172.16.69.100;
range 172.16.69.150 172.16.69.200;
option domain-name-servers 172.16.69.1;
option domain-name "network_one";
option routers 172.16.69.1;
option broadcast-address 172.16.69.255;
}
```  

> **Note** : có thể tìm tới dòng "slightly" và uncomment rồi chỉnh sửa lại cho nhanh .

\- Bước 5 : Cấp phát IP address theo MAC address . Mở và cấu hình file:  
```
sudo vi /etc/dhcp/dhcpd.conf
```
và thêm nội dung  :  
```
host client2 {
    hardware ethernet 00:0C:29:09:6F:7E;
    fixed-address 172.16.69.25;
}
```
\- Bước 5: Khởi động lại dịch vụ:  
```\
sudo service isc-dhcp-server restart
```

> **Note** : Sau khi cài đặt và cấu hình xong DHCP server, cần phải tắt DHCP server ảo của VMware .

<a name="3.3.3"></a>
### 3.3.3.Kết quả
\- Trên Client 1 :  
<img src="http://i.imgur.com/l7LD9J6.png" >  

\- Trên Client 2 :  
<img src="http://i.imgur.com/wQ7HaKG.png" >  

> Note : 
>- Bạn hoàn toàn có thể cấu hình 1 DHCP server cho 2 network với điều kiện DHCP server có 2 network card nối đến 2 network đó .
>- Bạn có thể phân tích packet của DHCP protocol với tcpdump bằng cách ghi vào file và đọc bằng Wireshark .



<a name="thamkhao"></a>
# THAM KHẢO
- https://github.com/doxuanson/Thuc-tap-thang-03-2016/blob/master/ThaiPH/ThaiPH_baocaotimhieudhcp.md  
- https://github.com/doxuanson/Thuc-tap-thang-03-2016/tree/master/LTLinh/LTLinh-B%C3%A1o%20c%C3%A1o%20giao%20th%E1%BB%A9c%20DHCP  
- https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol  
- https://www.youtube.com/watch?v=1NKw5ULEjik&index=48&list=PLBOZzuSFDzSL_5CvfuNo7EhFQR1z6hhpo  
- https://wiki.debian.org/DHCP_Server  
- https://help.ubuntu.com/community/isc-dhcp-server  
- Book : The TCPIP guide  









