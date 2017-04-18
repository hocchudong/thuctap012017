# LINUX BRIDGE

## ***Mục lục***

[1. Tổng quan về Linux Bridge](#1)

- [1.1. Giới thiệu](#1.1)

- [1.2. Cấu trúc Linux bridge](#1.2)

- [1.3. Các tính năng ](#1.3)

[2. Một số câu lệnh với Linux bridge](#2)

[3. Lab ](#3)

- [3.1. Chuẩn bị và mô hình](#3.1)

- [3.2. Cấu hình](#3.2)

[4. Tham khảo](#4)

---

<a name = "1"></a>
# 1. Tổng quan vê Linux Bridge

<a name = "1.1"></a>
## 1.1. Giới thiệu

-	**Linux bridge** là một soft switch –  1 trong 3 công nghệ cung cấp switch ảo trong hệ thống Linux (bên cạnh macvlan và OpenvSwitch), giải quyết vấn đề ảo hóa network bên trong các máy vật lý. 

-	Bản chất, linux bridge sẽ tạo ra các switch layer 2 kết nối các máy ảo (VM) để các VM đó giao tiếp được với nhau và có thể kết nối được ra mạng ngoài. Linux bridge thường sử dụng kết hợp với hệ thống ảo hóa KVM-QEMU.

-	Linux Bridge thật ra chính là một switch ảo và được sử dụng với ảo hóa KVM/QEMU. ***Nó là 1 module trong nhân kernel***. Sử dụng với câu lệnh `brctl`.

-	Mô tả linux bridge (trường hợp cơ bản nhất):

<img src = "http://imgur.com/LpMlNof.jpg">

***Lưu ý***: Linux bridge chỉ plug-in card ethernet của máy host để ra ngoài máy host, không dùng plug-in các card mạng wireless. 

<a name = "1.2"></a>
## 1.2. Cấu trúc Linux bridge

<img src = "http://imgur.com/7d8bY6u.jpg">

Khái niệm về physical port và virtual port:

\- ***Virtual Computing Device***: Thường được biết đến như là máy ảo VM chạy trong host server 

\- ***Virtual NIC (vNIC)**: máy ảo VM có virtual network adapters(vNIC) mà đóng vai trò là NIC cho máy ảo.

\- **Physical swtich port**: Là port sử dụng cho Ethernet switch, cổng vật lý xác định bởi các port RJ45. Một port RJ45 kết nối tới port trên NIC của máy host.

\- **Virtual swtich port**: là port ảo tồn tại trên virtual switch. Cả virtual NIC (vNIC) và virtual port đều là phần mềm, nó liên kết với virtual cable kết nối vNIC



Kiến trúc Kiến trúc của Linux bridge như hình sau:

<img src = "http://imgur.com/J0ZvKPk.jpg">

Một số khái niệm liên quan tới linux bridge:

\-	**Port**: tương đương với port của switch thật

\-	**Bridge**: tương đương với switch layer 2

\-	**Tap**: hay tap interface có thể hiểu là giao diện mạng để các VM kết nối với bridge cho linux bridge tạo ra (nó nằm trong nhân kernel, hoạt động ở lớp 2 của mô hình OSI)

\-	**fd**: forward data - chuyển tiếp dữ liệu từ máy ảo tới bridge.

<a name = "1.3"></a>
## 1.3. Các tính năng

\- 	STP: Spanning Tree Protocol - giao thức chống loop gói tin trong mạng.

\-	VLAN: chia switch (do linux bridge tạo ra) thành các mạng LAN ảo, cô lập traffic giữa các VM trên các VLAN khác nhau của cùng một switch.

\-	FDB: chuyển tiếp các gói tin theo database để nâng cao hiệu năng switch.


<a name = "2"></a>
# 2. Một số câu lệnh

## 2.1. Cài đặt 

Linux bridge được hỗ trợ từ version nhân kernel từ 2.4 trở lên. Để sử dụng các tính năng của linux birdge, cần cài đặt gói bridge-utilities (dùng các câu lệnh brctl để sử dụng linux bridge). Cài đặt dùng lệnh như sau: 

`sudo  apt-get install bridge-ultils `

## 2.2. Một số câu lệnh quản lý

### BRIDGE MANAGEMENT

|ACTION	|BRCTL	|BRIDGE|
|creating bridge|	`brctl addbr <bridge>`| |	
|deleting bridge|	`brctl delbr <bridge>`| |
|add interface (port) to bridge	| `brctl addif <bridge> <ifname>`	| |
|delete interface (port) on bridge |	`brctl delbr <bridge>`|  |	


### FDB MANAGEMENT

|ACTION	|BRCTL	|BRIDGE|
|-|-|-|
|Shows a list of MACs in FDB|	`brctl showmacs <bridge>`	|`bridge fdb show`|
|Sets FDB entries ageing time|	`brctl setageingtime  <bridge> <time>`|	|
|Sets FDB garbage collector interval|	`brctl setgcint <brname> <time>`| |	
|Adds FDB entry	|	|`bridge fdb add dev <interface> [dst, vni, port, via]`|
|Appends FDB entry|		|`bridge fdb append` (parameters same as for fdb add)|
|Deletes FDB entry|		|`bridge fdb delete ` (parameters same as for fdb add)|

### STP MANAGEMENT

|ACTION	|BRCTL	|BRIDGE|
|-|-|-|
|Turning STP on/off	|`brctl stp <bridge> <state>`| |	
|Setting bridge priority|	`brctl setbridgeprio <bridge> <priority>`	| |
|Setting bridge forward delay|	`brctl setfd <bridge> <time>`	| |
|Setting bridge 'hello' time|	`brctl sethello <bridge> <time>`| |	
|Setting bridge maximum message age|	`brctl setmaxage <bridge> <time>`	| |
|Setting cost of the port on bridge|	`brctl setpathcost <bridge> <port> <cost>`|	`bridge link set dev <port> cost <cost>`|
|Setting bridge port priority	|`brctl setportprio <bridge> <port> <priority>`|	`bridge link set dev <port> priority <priority>`|
|Should port proccess STP BDPUs	|	|`bridge link set dev <port > guard [on, off]`|
|Should bridge might send traffic on the port it was received|		|`bridge link set dev <port> hairpin [on,off]`|
|Enabling/disabling fastleave options on port|		|`bridge link set dev <port> fastleave [on,off]`|
|Setting STP port state	|	|`bridge link set dev <port> state <state>`|

### VLAN MANAGEMENT

|ACTION|	BRCTL|	BRIDGE|
|-|-|-|
|Creating new VLAN filter entry|		|`bridge vlan add dev <dev> [vid, pvid, untagged, self, master]`|
|Delete VLAN filter entry	|	|`bridge vlan delete dev <dev>` (parameters same as for vlan add)|
|List VLAN configuration|		|`bridge vlan show`|


***Lưu ý*** : Các ảnh hưởng của câu lệnh chỉ làm tạm thời cho đến khi máy host khởi động lại, sau khi khởi động lại, toàn bộ thông tin sẽ bị mất. 

## 2.3. Cấu hình vĩnh viễn

Cấu hình trong file /etc/network/interfaces

```
# This file describes the network interfaces available on your system
 # and how to activate them. For more information, see interfaces(5).
 # The loopback network interface
 auto lo br0
 iface lo inet loopback
 # Set up interfaces manually, avoiding conflicts with, e.g., network manager
 iface eth0 inet manual
 iface eth1 inet manual
 # Bridge setup
 iface br0 inet static
    bridge_ports eth0 eth1
        address 192.168.1.2
        broadcast 192.168.1.255
        netmask 255.255.255.0
        gateway 192.168.1.1
```

Tham khảo thêm cấu hình tại: http://manpages.ubuntu.com/manpages/xenial/man5/bridge-utils-interfaces.5.html

<a name = "3"></a>
# 3. LAB

<a name = "3.1"></a>
## 3.1. Chuẩn bị và mô hình

- Topology:

<img src = "http://imgur.com/KxxFRUB.jpg">


- Chuẩn bị:

\- Một máy tính với  card eth1 thuộc dải 10.10.10.0/24, cài HĐH ubuntu 14.04.

\- Máy tính đã cài đặt sẵn các công cụ để quản lý và tạo máy ảo KVM. 


- Nội dung bài lab: Tạo một switch ảo br1 và gán interface eth1 vào switch đó, tạo một máy ảo bên trong máy host, gắn vào tap interface của switch và kiểm tra địa chỉ được cấp phát. Tạo 2 VM trong host cùng gắn vào tap interface của switch, ping kiểm tra kết nối).

<a name = "3.2"></a>
## 3.2. Cấu hình

•	**Bước 1:** Tạo switch ảo br1. Nếu đã tồn tại có thể xóa switch này đi và tạo lại:

#brctl delbr br1 # xóa đi nếu đã tồn tại
#brctl addbr br1 # tạo mới

•	**Bước 2:** Gán eth1 vào swicth br1

#brctl addif br1 eth1
#brctl stp br1 on # enable tính năng STP nếu cần

•	**Bước 3:** Khi tạo một switch mới br1, trên máy host sẽ xuất hiện thêm 1 NIC ảo trùng tên switch đó (br1).

 Ta có thể cấu hình xin cấp phát IP cho NIC này sử dụng command hoặc cấu hình trong file /etc/network/interfacesđể giữ cấu hình cho switch ảo sau khi khởi động lại:

 - Cấu hình bằng command:

`ifconfig eth1 0 # xóa IP của eth1`

`dhclient br1`

 - Cấu hình trong file `/etc/network/interfaces`:

 Nếu trước đó trong file /etc/network/interfaces đã cấu hình cho NIC eth1, ta phải comment lại cấu hình đó hoặc xóa cấu hình đó đi và thay bằng các dòng cấu hình sau:

```
auto br1
iface br1 inet dhcp
bridge_ports eth1
bridge_stp on
bridge_fd 0
bridge_maxwait 0
```
•	Bước 4: Khởi động lại các card mạng và kiểm tra lại cấu hình bridge:

`ifdown -a && ifup -a # khởi động lại tất cả các NIC`
`brctl show # kiểm tra cấu hình switch ảo`

Kết quả kiểm tra cấu hình sẽ tương tự như sau:

```
Bridge	name		bridge id	STP	enabled	interfaces
br0		8000.000		c29586f24	yes	eth0
br1		8000.000		c29586f2e	yes     eth1
```

Kết quả cấu hình thành công gắn NIC eth1 vào switch ảo br1 sẽ hiển thị như đoạn mã trên.

•	**Bước 5:** Để kiểm tra, ta có thể tạo 2  máy ảo và kết nối với switch br1 như mô hình:


<img src = "http://imgur.com/uHuOQev.jpg">

Kết quả: Máy kvm1 và kvm2 cùng nhận được IP cùng dải 10.10.10.0/24 như hình. Thực hiện ping kiểm tra giữa 2 máy.


<img src = "http://imgur.com/aHcTU1J.jpg">


<img src = "http://imgur.com/kKzLmdo.jpg">


<a name = "4"></a>
# 4. Tham khảo

[1] - http://manpages.ubuntu.com/manpages/trusty/man5/bridge-utils-interfaces.5.html

[2] - https://github.com/thaihust/Thuc-tap-thang-03-2016/blob/master/ThaiPH/VirtualSwitch/Linux-bridge/ThaiPH_tim_hieu_linux_bridge.md

[3] - https://github.com/thaihust/Thuc-tap-thang-03-2016/blob/master/ThaiPH/VirtualSwitch/Linux-bridge/ThaiPH_tim_hieu_linux_bridge.md

[4] - https://wiki.debian.org/BridgeNetworkConnections#Bridging_Network_Connections 


