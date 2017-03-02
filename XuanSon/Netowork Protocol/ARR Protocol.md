# ARP Protocol

# Mục lục
- [1.Khái niệm ARP](#1)
- [2.Cơ chế hoạt động](#2)
- [3.Paket structure](#3)
  - [3.1.Cấu trúc của ARP packet ](#3.1)
  - [3.2.Cấu trúc của ARP message](#3.2)
- [4.Example](#4)
  - [4.1.Truyền tin giữa các PC trong cùng mạng LAN](#4.1)
  - [4.2.Truyền tin trong môi trường Internet toàn cầu](#4.2)
- [5.ARP Caching](#5)
  - [5.1.Đặt vấn đề ](#5.1)
  - [5.2. ARP Cache](#5.2)
- [THAM KHẢO](#thamkhao)



<a name="1"></a>
# 1.Khái niệm ARP
\- **ARP ( Address resolution prrotocol )** là protocol có nhiệm vụ 
map địa chỉ IPv4 thành địa chỉ MAC .   
\- **ARP** được miêu tả là giao thức tại OSI layer 3 và encapsulated 
tại OSI layer 2 .  

<a name="2"></a>
# 2.Cơ chế hoạt động
\- Khi một network device  muốn biết MAC address của một network device 
nào đó mà nó đã biết địa chỉ ở tầng network (IPv4) , 
nó sẽ gửi một “ARP request” bao gồm địa chỉ MAC address của nó và 
IP address của network device  mà nó cần biết MAC address trên toàn bộ 
miền broadcast .  
\- Mỗi network device nhận được request này sẽ so sánh địa chỉ IP 
trong request với IP address của mình . 
Nếu trùng IP address thì sẽ gửi ngược lại cho network device kia 
một packet “ARP request” ( trong đó có MAC address của mình ) .  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/1.jpg">  

<a name="3"></a>
# 3.Paket structure

<a name="3.1"></a>
## 3.1.Cấu trúc của ARP packet 

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/2.jpg">  
Ta nhìn thấy “ARP message” được encapsulated trong Ethernet header . 

<a name="3.2"></a>
## 3.2.Cấu trúc của ARP message
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/3.jpg">  
 
\- Giải thích các trường trong “ARP message”  
- **Hardware type (HTYPE)** : Trường này cho biết network protocol . 
Example : Ethernet là “1” .
- **Protocol type ( PTYPE )** : Trường này cho biết internetwork protocol  .
Example : IPv4 là “0x0800”
- **Hardware length ( HLEN )** : Độ dài ( octets) của hardware address . Ethernet address có độ dài là 6 octets .
- **Protocol length ( PLEN )** : Độ dài của internetwork address được sử dụng . IPv4 address có độ dài là 4 octets .
- **Operation** : Cho biết packet là “ARP request” hay “ARP reply” .
“ARP request” là “1” và “ARP reply” là “2” .
- **Sender hardware address (SHA)** : MAC address của sender .
- **Sender protocol address (SPA)** : Internetwork address (IP) của sender .
- **Target hardware address (THA)** : MAC address của receiver .
- **Target protocol address (TPA)** : Internetwork address (IP) của receiver .

<a name="4"></a>
# 4.Example
<a name="4.1"></a>
## 4.1.Truyền tin giữa các PC trong cùng mạng LAN
\- **Mô hình** : PC A và PC B ở trong cùng một mạng LAN có địa chỉ network 
192.168.1.0/24 . IP address và MAC address của PC A và PC B 
như hình bên dưới .  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/4.jpg">  

\- **Nguyên tắc hoạt động**  
- Giả sử PC A muốn gửi packet đến PC B và nó biết IP address của PC B 
là 192.168.1.20 . Khi đó PC A sẽ gửi “ARP request” với destination MAC 
là broadcast (ff:ff:ff:ff:ff:ff) cho toàn mạng để hỏi xem “ MAC address 
của PC nào có IP address là 192.168.1.20 . 
- Khi đó PC B nhận được broadcast này , nó sẽ so sánh IP address trong 
packet với IP address của nó . Nhận thấy address đó là address của mình , 
PC sẽ gửi một packet “ARP reply” cho PC A trong đó chứa MAC address 
của PC B . 
- Sau đó PC A mới bắt đầu truyền packet cho PC B .  

\- **Bắt packet với Wireshark**
- 2 packet “ARP request” và “ARP reply” .

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/5.jpg">  

- Cấu trúc packet “ARP request”  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/6.jpg">  

- Cấu trúc packet “ARP reply”  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/7.jpg">  

<a name="4.2"></a>
## 4.2.Truyền tin trong môi trường Internet toàn cầu
\- **Mô hình** :  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/8.jpg">  

\- Giả sử PC A muốn gửi packet ra ngoài Internet . 
Do broadcast không thể truyền qua Router nên PC A sẽ xem Router C 
như một cầu nối trung gian để truyền dữ liệu . Trước đó PC A sẽ biết 
IP address của Router C ( địa chỉ gateway ) và biết được rằng để truyền 
packet ra ngoài Internet thì phải đi qua Router .  
\- Quá trình truyền packet theo từng bước sau :  
- PC A gửi một “ARP request” để tìm MAC address của “Port 1” của Router C .
- Router C gửi lại cho PC A một “ARP reply” , cung cấp cho PC A MAC address của Port 1 .
- PC A truyền packet đến Port 1 của Router .
- Router nhận được packet từ PC A và chuyển packet rra “Port WAN” và truyền ra Internet . 

\- **Note** : Thực tế, mỗi khi NIC được enable , 
PC sẽ tự động dò tìm MAC address của tương ứng với IP gateway .  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/9.jpg">  

<a name="5"></a>  
# 5.ARP Caching
<a name="5.1"></a>  
## 5.1.Đặt vấn đề 
\- Mỗi khi truyền packet trên mạng thì PC phải sử ARP protocol 
để biết được MAC address tương ứng với “trạm” tiếp theo packet muốn đến . 
Điều này đẫn đến tiêu tốn băng thông và tăng thời gian truyền gói tin . 
Để giảy quyết vấn đề này , người ta sử dụng caching cho mỗi PC .  

<a name="5.2"></a>  
## 5.2. ARP Cache
\- ARP Cache là bảng chứa tập hợp các IP address và MAC address tương ứng . 
Mỗi network device quản lý bảng ARP cache của nó .  
\- Có 2 cách khác theo để ghi vào bảng ARP cache :  
- Static ARP Cache Entries : Đây là cặp hardware/IP address được thêm vào manual . Nó được lưu trữ vĩnh viễn trong bảng ARP cache .
- Dynamic ARP cache Entries : Đây là cặp hardware/IP address được thêm vào cache bởi phần mềm ( tự động ) , là kết quả của ARP resolution . Chúng được lưu trữ trong bảng ARP cache chỉ một khoảng thời gian ngắn rồi bị xóa đi .  

\- Bảng ARP cache có thể lưu trữ cả static và dynamic , 
nhưng thực tế người ta thường dùng dynamic do tính tiện lợi mà nó mang lại .  
\- Chúng ta có thể dùng câu lệnh : `arp -a` để show ra bảng ARP cache .  

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Netowork%20Protocol/ARP%20Protocol/10.jpg">  


<a name="thamkhao"></a>
# THAM KHẢO
- https://en.wikipedia.org/wiki/Address_Resolution_Protocol  
- https://www.youtube.com/watch?v=ELdZr88eqRg&list=PLBOZzuSFDzSL_5CvfuNo7EhFQR1z6hhpo&index=49
- https://quantrimang.com/arp-va-nguyen-tac-lam-viec-trong-mang-lan-17302  
- http://www.tcpipguide.com/free/t_ARPCaching.htm  








