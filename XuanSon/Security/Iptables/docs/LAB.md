# LAB

# MỤC LỤC
- [1.LAB1](#1)
	- [1.1.Mô hình](#1.1)
	- [1.2.Mục đích](#1.2)
	- [1.3.Cấu hình](#1.3)
- [2.LAB 2](#2)
	- [2.1.Mô hình](#2.1)
	- [2.2.Mục đích](#2.2)
	- [2.3.Cấu hình](#2.3)
		- [a.Trên Client](#2.3.a)
		- [b.Trên Server](#2.3.b)
- [3.LAB 3](#3)
	- [3.1.Mô hình](#3.1)
	- [3.2.Mục đích](#3.2)
	- [3.3.Cấu hình](#3.3)
		- [a.Trên Client](#3.3.a)
		- [b.Trên Backend1](#3.3.b)
		- [c.Trên Backend2](#3.3.c)
		- [d.Trên Server](#3.3.d)
	- [3.4.Demo](#3.4)
- [4.LAB 4](#4)
	- [4.1.Mô hình](#4.1)
	- [4.2.Mục đích](#4.2)
	- [4.3.Cấu hình](#4.3)
		- [a.Trên Client](#4.3.a)
		- [b.Trên Backend1](#4.3.b)
		- [c.Trên Backend2](#4.3.c)
		- [d.Trên Server](#4.3.d)
	- [4.4.Demo](#4.4)
- [5.LAB5: DMZ](#4)
	- [5.1.Mô hình](#5.1)
	- [5.2.Mục đích](#5.2)
	- [5.3.Cấu hình](#5.3)



<a name="1"></a>
# 1.LAB1

<a name="1.1"></a>
## 1.1.Mô hình
<img src="../images/lab1.png" />

\- Client, Server cài hệ điều hành Ubuntu Server 16.04.  
\- Cấu hình iptables tại Server.  

<a name="1.2"></a>
## 1.2.Mục đích
\- Mặc định, DROP INPUT.  
\- Mặc định, ACCEPT OUTPUT.  
\- Mặc định, DROP FORWARD.  
\- ACCEPT Established Connection.  
\- ACCEPT kết nối từ loopback.  
\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
\- ACCEPT kết nối SSH từ trong mạng LAN.  s

<a name="1.3"></a>
## 1.3.Cấu hình
\- DROP INPUT, ACCEPT OUTPUT và DROP FORWARD:  
```
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
```

\- ACCEPT Established Connection.  
```
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

\- ACCEPT kết nối từ loopback:  
```
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
```

\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
```
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/m --limit-burst 5 -s 172.16.69.0/24 -d 172.16.69.11 -j ACCEPT
```

\- ACCEPT kết nối SSH từ trong mạng LAN:  
```
iptables -A INPUT -p tcp -m state --state NEW -s 172.16.69.0/24 -d 172.16.69.11 --dport 22 -j ACCEPT
```

\- Sau khi cấu hình xong, từ Client , ta gửi bản tin icmp echo request (sử dụng lệnh ping) đến Server, ta sẽ thấy kết quả ping liên tục. Đó là do các gói tin icmp echo request bắt đầu từ gói tin tin thứ 2 sẽ được đồng ý bởi rule "ACCEPT Established Connection".  
Muốn kết nối Ping với 5 lần mỗi phút từ mạng LAN, ta phải sửa lại rule "ACCEPT Established Connection" như sau:  
```
iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
```

<a name="2"></a>
# 2.LAB 2

<a name="2.1"></a>
## 2.1.Mô hình
<img src="../images/lab2.png" />

\- Client, Server cài hệ điều hành Ubuntu Server 16.04.  
\- Cấu hình iptables tại Server.  

<a name="2.2"></a>
## 2.2.Mục đích
\- Mặc định, DROP INPUT.  
\- Mặc định, ACCEPT OUTPUT.  
\- Mặc định, DROP FORWARD.  
\- ACCEPT Established Connection.  
\- ACCEPT kết nối từ loopback.  
\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
\- ACCEPT kết nối SSH từ trong mạng LAN.  
\-  ACCEPT Outgoing gói tin thông qua Server từ mạng LAN (10.10.10.0/24) và nat địa chỉ nguồn của gói tin.  

<a name="2.3"></a>
## 2.3.Cấu hình

<a name="2.3.a"></a>
### a.Trên Client
- Cấu hình IP như mô hình, gateway là 10.10.10.11.

<a name="2.3.b"></a>
### b.Trên Server
- Kích hoạt iptables fordward packet sang máy khác, ta cần sửa file `/etc/sysctl.conf`:  
```
net.ipv4.ip_forward = 1
```

Chạy lệnh `sysctl -p /etc/sysctl.conf` để kiểm tra cài đặt.  
\- Sau đó:  
```
/etc/init.d/procps restart
```

\- DROP INPUT, ACCEPT OUTPUT và DROP FORWARD:  
```
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
```

\- ACCEPT Established Connection.  
```
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

\- ACCEPT kết nối từ loopback:  
```
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
```

\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
```
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/m --limit-burst 5 \
	-s 10.10.10.0/24 -d 10.10.10.11 -j ACCEPT
```

\- ACCEPT kết nối SSH từ trong mạng LAN:  
```
iptables -A INPUT -p tcp -s 10.10.10.0/24 -d 10.10.10.11 --dport 22 -m state --state NEW -j ACCEPT
```

\-  ACCEPT Outgoing gói tin thông qua Server từ mạng LAN (10.10.10.0/24) và nat địa chỉ nguồn của gói tin.  
```
iptables -A FORWARD -i ens38 -o ens33 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens33 -s 10.10.10.0/24 -j SNAT --to-source 10.10.10.11
```

hoặc  
```
iptables -A FORWARD -i ens38 -o ens33 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens33 -s 10.10.10.0/24 -j MASQUERADE
```

<a name="3"></a>
# 3.LAB 3

<a name="3.1"></a>
## 3.1.Mô hình
<img src="../images/lab3.png" />

\- Client, Server cài hệ điều hành Ubuntu Server 16.04.  
\- Cấu hình iptables tại Server.  
\- Trên Backend1, cài Web server (apache2) lắng nghê trên port 80.  
\- Trên Backend2, cài Web server (apache2) lắng nghê trên port 443.  

<a name="3.2"></a>
## 3.2.Mục đích
\- Mặc định, DROP INPUT.  
\- Mặc định, ACCEPT OUTPUT.  
\- Mặc định, DROP FORWARD.  
\- ACCEPT Established Connection.  
\- ACCEPT kết nối từ loopback.  
\- FORWARD gói tin đến port 80 trên ens33 đến port tương tự trên Backend1.  
FORWARD gói tin đến port 443 trên ens33 đến port tương tự trên Backend2.  
Nhưng DROP gói tin từ 172.16.69.2.  
\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
\- ACCEPT kết nối SSH từ trong mạng LAN  
Nhưng DROP gói tin từ 10.10.10.101.  
\-  ACCEPT Outgoing Packets thông qua Server từ mạng LAN (10.10.10.0/24) và nat địa chỉ nguồn của packet.  

<a name="3.3"></a>
## 3.3.Cấu hình

<a name="3.3.a"></a>
### a.Trên Client
\- Cấu hình IP như mô hình, gateway là 10.10.10.11.  

<a name="3.3.b"></a>
### b.Trên Backend1
\- Cấu hình IP như mô hình, gateway là 10.10.10.11.  
\- Cài đặt apache2:  
```
# apt install apache2
```

\- Sửa nôi dụng file `/var/www/html/index.html` như sau:  
```
<h1>This is Backend1</h1>
```

<a name="3.3.c"></a>
### c.Trên Backend2
\- Cấu hình IP như mô hình, gateway là 10.10.10.11.  
\- Cài đặt apache2:  
```
# apt install apache2
```

\- Sửa nôi dụng file `/var/www/html/index.html` như sau:  
```
<h1>This is Backend2</h1>
```

\- Kích hoạt ssl:  
```
a2enmod ssl
a2ensite default-ssl.conf
systemctl restart apache2
```

<a name="3.3.d"></a>
### d.Trên Server 
- Kích hoạt iptables fordward packet sang máy khác, ta cần sửa file `/etc/sysctl.conf`:  
```
net.ipv4.ip_forward = 1
```

Chạy lệnh `sysctl -p /etc/sysctl.conf` để kiểm tra cài đặt.  

\- Sau đó:  
```
/etc/init.d/procps restart
```

\- Mặc định, DROP INPUT.  
Mặc định, ACCEPT OUTPUT.  
Mặc định, DROP FORWARD.  
```
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
```

\- ACCEPT Established Connection.  
```
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

\- ACCEPT kết nối từ loopback.  
```
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
```

\- FORWARD gói tin đến port 80 trên ens33 đến port tương tự trên Backend1.  
FORWARD gói tin đến port 443 trên ens33 đến port tương tự trên Backend2.  
Nhưng DROP gói tin từ 172.16.69.2.  
```
iptables -A FORWARD -s 172.16.69.2 -j DROP
iptables -A FORWARD -p tcp --dst 10.10.10.51 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dst 10.10.10.52 --dport 443 -j ACCEPT
iptables -t nat -A PREROUTING -i ens33 -p tcp -d 172.16.69.11 --dport 80 \
	-j DNAT --to-destination 10.10.10.51:80
iptables -t nat -A PREROUTING -i ens33 -p tcp -d 172.16.69.11 --dport 443 \
	-j DNAT --to-destination 10.10.10.52:443
```

\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
```
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/m --limit-burst 5 \
	-s 10.10.10.0/24 -d 10.10.10.11 -j ACCEPT
```

\- ACCEPT kết nối SSH từ trong mạng LAN  
Nhưng DROP gói tin từ 10.10.10.101.  
```
iptables -A INPUT -s 10.10.10.101 -j DROP
iptables -A INPUT -p tcp -s 10.10.10.0/24 -d 10.10.10.11 --dport 22 -m state --state NEW -j ACCEPT
```

\-  ACCEPT Outgoing Packets thông qua Server từ mạng LAN (10.10.10.0/24) và nat địa chỉ nguồn của packet.  
```
iptables -A FORWARD -i ens38 -o ens33 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens33 -s 10.10.10.0/24 -j SNAT --to-source 10.10.10.11
```

<a name="3.4"></a>
## 3.4.Demo
\- Truy cập vào IP 172.16.69.11, port 80 của Server  
<img src="../images/lab4.png" />

\- Truy cập vào IP 172.16.69.11, port 443 của Server  
<img src="../images/lab5.png" />

<a name="4"></a>
# 4.LAB 4

<a name="4.1"></a>
## 4.1.Mô hình
<img src="../images/lab6.png" />

\- Client, Server cài hệ điều hành Ubuntu Server 16.04.  
\- Router, có thể giả lập là VM.  
\- Cấu hình iptables tại Server.  
\- Trên Backend1, cài SSH lắng nghê trên port 22.  
\- Trên Backend2, cài Web server (apache2) lắng nghê trên port 80.  

<a name="4.2"></a>
## 4.2.Mục đích
\- Mặc định, DROP INPUT.  
\- Mặc định, ACCEPT OUTPUT.  
\- Mặc định, DROP FORWARD.  
\- ACCEPT Established Connection.  
\- ACCEPT kết nối từ loopback.  
\- FORWARD gói tin đến port 80 trên ens33 đến port tương tự trên Backend1.  
FORWARD gói tin đến port 443 trên ens33 đến port tương tự trên Backend2.  
\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
\- ACCEPT kết nối SSH từ trong mạng LAN.  
\-  ACCEPT Outgoing Packets thông qua Server từ mạng LAN (10.10.10.0/24) và nat địa chỉ nguồn của packet.  

<a name="4.3"></a>
## 4.3.Cấu hình

<a name="4.3.a"></a>
### a.Trên Client
\- Cấu hình IP như mô hình, gateway là 10.10.10.11.  

<a name="4.3.b"></a>
### b.Trên Backend1
\- Cấu hình IP như mô hình, gateway là 10.10.10.11.  
\- Cài đặt SSH daemon:  
```
# apt install ssh
```

<a name="4.3.c"></a>
### c.Trên Backend2
\- Cấu hình IP như mô hình, gateway là 10.10.10.11.  
\- Cài đặt apache2:  
```
# apt install apache2
```

\- Sửa nôi dụng file `/var/www/html/index.html` như sau:  
```
<h1>This is Backend2</h1>
```

<a name="4.3.d"></a>
### d.Trên Server 
\- Kích hoạt iptables fordward packet sang máy khác, ta cần sửa file `/etc/sysctl.conf`:  
```
net.ipv4.ip_forward = 1
```

Chạy lệnh `sysctl -p /etc/sysctl.conf` để kiểm tra cài đặt.  

\- Sau đó:  
```
/etc/init.d/procps restart
```

\- Mặc định, DROP INPUT.  
Mặc định, ACCEPT OUTPUT.  
Mặc định, DROP FORWARD.  
```
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
```

\- ACCEPT Established Connection.  
```
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

\- ACCEPT kết nối từ loopback.  
```
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
```

\- FORWARD gói tin đến port 80 trên ens33 đến port tương tự trên Backend1.  
FORWARD gói tin đến port 443 trên ens33 đến port tương tự trên Backend2.  
```
iptables -A FORWARD -p tcp -d 10.10.10.51 --dport 22 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.10.10.52 --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -d 172.16.69.11 --dport 22 \
	-j DNAT --to-destination 10.10.10.51
iptables -t nat -A POSTROUTING -p tcp -d 10.10.10.51 --dport 22 \
	-j SNAT --to-source 10.10.10.11
iptables -t nat -A PREROUTING -p tcp -d 172.16.69.11 --dport 80 \
	-j DNAT --to-destination 10.10.10.52
iptables -t nat -A POSTROUTING -p tcp -d 10.10.10.52 --dport 80 \
	-j SNAT --to-source 10.10.10.11
```

\- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.  
```
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/m --limit-burst 5 \
	-s 10.10.10.0/24 -d 10.10.10.11 -j ACCEPT
```

\- ACCEPT kết nối SSH từ trong mạng LAN.  
```
iptables -A INPUT -p tcp -s 10.10.10.0/24 -d 10.10.10.11 --dport 22 -m state --state NEW -j ACCEPT
```

\-  ACCEPT Outgoing Packets thông qua Server từ mạng LAN (10.10.10.0/24) và nat địa chỉ nguồn của packet.  
```
iptables -A FORWARD -i ens38 -o ens33 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens33 -s 10.10.10.0/24 -j SNAT --to-source 10.10.10.11
```

<a name="4.4"></a>
## 4.4.Demo
\- Truy cập vào IP 172.16.69.11, port 80 của Server  
<img src="../images/lab7.png" />

\- SSH vào IP 172.16.69.11, port 22 của Server  
<img src="../images/lab8.png" />


<a name="5"></a>
# 5.LAB5: DMZ

<a name="5.1"></a>
## 5.1.Mô hình
<img src="../images/lab9.png" />

\- Client1, Client2, WebServer và Firewall cài hệ điều hành Ubuntu Server 16.04.  
\- Cấu hình iptables tại Firewall.  
\- Trên WebServer, cài Web server (apache2) lắng nghê trên port 80.  

<a name="5.2"></a>
## 5.2.Mục đích
\- Mặc định, DROP INPUT.  
\- Mặc định, ACCEPT OUTPUT.  
\- Mặc định, DROP FORWARD.  
\- ACCEPT Established Connection.  
\- FORWARD gói tin đến port 80 trên ens33 sang port ens38 và đến port 80 trên Webserver.  
\- Cho phép 1 máy (Client1) trong dải `10.10.20.0/24` quản trị Webserver.  
\- Cho phép các máy trong dải `10.10.20.0/24` kết nối ra Internet.  

<a name="5.3"></a>
## 5.3.Cấu hình
\- Mặc định, DROP INPUT.  
Mặc định, ACCEPT OUTPUT.  
Mặc định, DROP FORWARD.  
```
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
```

\- ACCEPT Established Connection.  
```
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

\- FORWARD gói tin đến port 80 trên ens33 sang port ens38 và đến port 80 trên Webserver.  
```
iptables -A FORWARD -i ens33 -o ens38 -p tcp -d 10.10.10.51 --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -i ens33 -p tcp -d 172.16.69.11 --dport 80 \
	-j DNAT --to-destination 10.10.10.51
iptables -t nat -A POSTROUTING -o ens38 -p tcp -d 10.10.10.51 --dport 80 \
	-j SNAT --to-source 10.10.10.11
```

\- Cho phép 1 máy (Client1) trong dải `10.10.20.0/24` quản trị Webserver.  
```
iptables -A FORWARD -m state --state NEW -i ens39 -o ens38 -p tcp -s 10.10.20.101 -d 10.10.10.51 \
	--dport 22 -j ACCEPT
```

\- Cho phép các máy trong dải `10.10.20.0/24` kết nối ra Internet.  
```
iptables -A FORWARD -m state --state NEW -i ens39 -o ens33 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens33 -s 10.10.20.0/24 \
	-j SNAT --to-source 172.16.69.11
```




















