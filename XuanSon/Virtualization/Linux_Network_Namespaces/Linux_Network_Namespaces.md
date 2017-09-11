# Linux Network Namespaces


# MỤC LỤC
- [1.Giới thiệu](#1)
	- [1.1. Linux Namespaces](#1.1)
	- [1.2.Linux Network Namespaces](#1.2)
- [2.Làm việc với network namespace](#2)
- [3.LAB](#3)
	- [3.1.veth pair](#3.1)
	- [3.2.Linux bridge và 2 veth pairs](#3.2)
	- [3.3.Openvswitch và 2 veth pairs](#3.3)
	- [3.4.Openvswitch và 2 openvswitch ports](#3.4)
	- [3.5.Lab DHCP cấp IP cho các host thuộc các namespaces khác nhau](#3.5)
- [Tài liệu tham khảo](#tailieuthamkhao)


<a name="1"></a>
# 1.Giới thiệu
<a name="1.1"></a>
## 1.1. Linux Namespaces
\- Namespaces là tính năng của Linux kernel để cô lập và ảo hóa tài nguyên hệ thống. Các tài nguyên ở đây bao gồm include process IDs, hostnames, user IDs, network access, interprocess communication, and filesystems.  
\- Linux kernel version 4.10 có 7 loại namespaces:  
- Mount (mnt)
- Process ID (pid)
- Network (net)
- Interprocess Communication (ipc)
- UTS
- User ID (user)
- Control Group (cgroup)

Chức năng của mỗi loại là như nhau: mỗi process được liên kến với 1 namespace và chỉ có thể nhìn thất hoặc sử dụng tài nguyên liên quan đến namespaces, và namespaces con của namespaces đó nếu có. Bằng cách này, mỗi process có thể có 1 cái nhìn độc lập về tài nguyên.  

<a name="1.2"></a>
## 1.2.Linux Network Namespaces
\- Network namespaces là 1 trong 7 loại đã nói ở phần trên. Network namespaces ảo hóa mạng. Trên mỗi network namespaces chứa duy nhất 1 loopback interface.  
\- Mỗi network interface (physical hoặc virtual) có duy nhất 1 namespaces và có thể di chuyển giữa các namespaces.  
\- Mỗi namespaces có 1 bộ địa chỉ IP, bảng routing, danh sách socket, firewall và các nguồn tài nguyên mạng riêng.  
\- Khi network namespaces bị hủy, nó sẽ hủy tất cả các virtual interfaces nào bên trong nó và di chuyển bất kỳ physical interfaces nào trở lại network namespaces root.  

>Ghi chú:  
Trong networking, khái niệm tương tự network namespaces của Linux là VRF - Virtual Routing and Forwarding, là một tính năng cấu hình được trên các router như của Cisco hoặc Alcatel-Lucent, Juniper,...VRF là một công nghệ IP cho phép tồn tại cùng một lúc nhiều routing instance trong cùng 1 router ở cùng một thời điểm (multiple instances of a routing table). Do các routing instances này là độc lập nên nó cho phép sự chồng lấn về địa chỉ IP subnet trên các intefaces của router mà không gặp tình trạng xung đột. Có thể hiểu VRF giống như VMWare cho router vậy, còn các routing instances tương tự như các VMware guest instances, hoặc cũng có thể hiểu nó tương tự như VLANs tuy nhiên VRF hoạt động ở layer 3.

<a name="2"></a>
# 2.Làm việc với network namespace
<img src="images/1.png" />

\- Khi bắt đầu Linux, bạn sẽ có 1 namespaces mặc định trên hệ thống gọi là root namespaces. Vì vậy mọi quy trình kế thừa network namespaces được sử dụng bởi init (PID 1).  
\- List namespaces  
```
ip netns 
```

Đầu ra có thể là empty do namespaes mặc định ko bao gồm trong đầu ra câu lệnh `ip netns`.  
\- Add namespaces  
```
ip netns add <namespaces_name>
```

\- Ví dụ:  
```
ip netns add mario
ip netns add luigi
```

<img src="images/2.png" />

Với mỗi namespace được thêm bào, một file mới sẽ được tạo ra trong thư mục `/var/run/netns`.  
Sau khi restart lại host, namespaces sẽ mất.  
\- Xóa 1 namespaces:  
```
ip netns delete <namespaces_name>
```

\- Thực thi command trong namespace:  
```
ip netns exec <namespaces_name> <command>
```

Thực thi command trong tất cả các namespaces:  
```
ip -all netns exec <namespaces_name> <command>
```

\- Truy cập 1 namespaces:  
```
ip netns exec <namespaces_name> bash
```

\- Set 1 NIC đến 1 namespaces:  
```
ip link set <NIC> netns <namespaces_name>
```

VD: Set 1 NIC đến namespaces root (default namepsaces):  
```
ip link set ens38 netns 1
```

<a name="3"></a>
# 3.LAB
<a name="3.1"></a>
## 3.1.veth pair
\- Dùng 1 veth pair để kết nối 2 network namespaces.  
<img src="images/3.png" />

\- Tạo 2 namespaces ns1 và ns2  
```
ip netns add ns1
ip netns add ns2
```

\- Tạo veth pair tap1 và tap2  
```
ip link add tap1 type veth peer name tap2
```

\- Di chuyển interface tap1 đến namespaces ns1 và interface tap2 đến namespaces ns2  
```
ip link set tap1 netns ns1
ip link set tap2 netns ns2
```

\- bring up tap1 và tap2  
```
ip netns exec ns1 ip link set dev tap1 up
ip netns exec ns2 ip link set dev tap2 up
```

\- Gắn địa chỉ IP cho tap1 và tap2  
```
ip netns exec ns1 ip a add 10.0.0.1/24 dev tap1
ip netns exec ns2 ip a add 10.0.0.2/24 dev tap2
```

<img src="images/4.png" />

\- Ping thử giữa tap1 và tap2 interface  
<img src="images/5.png" />

=> Thành công!

<a name="3.2"></a>
## 3.2.Linux bridge và 2 veth pairs
\- Dùng 2 veth pair và 1 switch để kết nối 2 namespaces.  
<img src="images/6.png" />

\- Tạo 2 namespaces ns1 và ns2  
```
ip netns add ns1
ip netns add ns2
```

\- Tạo switch sử dụng linux bridge  
```
brctl addbr br-test
ip link set dev br-test up
```

\- Tạo port pair thứ nhất  
```
ip link add tap1 type veth peer name br-tap1
```

\- Gắn 1 phía đến linuxbridge  
```
brctl addif br-test br-tap1 
```

\- Gắn 1 phía đến namespace  
```
ip link set tap1 netns ns1
```

\- Set ports đến up  
```
ip netns exec ns1 ip link set dev tap1 up
ip link set dev br-tap1 up
```

\- Tạo port pair thứ hai  
```
ip link add tap2 type veth peer name br-tap2
```

\- Gắn 1 phía đến linuxbridge  
```
brctl addif br-test br-tap2
```

\- Gắn 1 phía đến namespace  
```
ip link set tap2 netns ns2
```

\- Set ports đến up  
```
ip netns exec ns2 ip link set dev tap2 up
ip link set dev br-tap2 up
```

\- Gắn địa chỉ IP vào tap1 và tap 2 interface  
```
ip netns exec ns1 ip a add 10.0.0.1/24 dev tap1
ip netns exec ns2 ip a add 10.0.0.2/24 dev tap2
```

<img src="images/7.png" />

<img src="images/8.png" />

- Ping thử giữa tap1 và tap2 interface  
<img src="images/9.png" />

<a name="3.3"></a>
## 3.3.Openvswitch và 2 veth pairs
\- Dùng 2 veth pair và 1 switch để kết nối 2 namespaces.  
<img src="images/10.png" />

\- Làm tương tự như đối với bài lab "Linux bridge và 2 veth pairs".  

<a name="3.4"></a>
## 3.4.Openvswitch và 2 openvswitch ports

<img src="images/11.png" />

\- Tạo 2 namespaces ns1 và ns2  
```
ip netns add ns1
ip netns add ns2
```

\- Tạo switch sử dụng openvswitch  
```
ovs-vsctl add-br ovstest
ip link set dev ovstest up
```

\- Tạo internal ovs port tap1:  
```
ovs-vsctl add-port ovstest tap1 -- set Interface tap1 type=internal
```

Gắn vào namespaces ns1:  
```
ip link set tap1 netns ns1
```

Set ports đến up  
```
ip netns exec ns1 ip link set dev tap1 up
```

\- Set thêm lo interface (loopback)  
```
ip netns exec ns1 ip link set dev lo up
```

\- Tạo internal ovs port tap2:  
```
ovs-vsctl add-port ovstest tap2 -- set Interface tap2 type=internal
```

Gắn vào namespaces ns1:  
```
ip link set tap2 netns ns2
```

Set ports đến up  
```
ip netns exec ns2 ip link set dev tap2 up
```

\- Set thêm lo interface (loopback)  
```
ip netns exec ns2 ip link set dev lo up
```

\- Gắn địa chỉ IP cho 2 tap1 và tap2 interface:  
```
ip netns exec ns1 ip a add 10.0.0.1/24 dev tap1
ip netns exec ns2 ip a add 10.0.0.2/24 dev tap2
```

<img src="images/12.png" />

\- Ping thử giữa 2 namespaces:  
<img src="images/13.png" />

=> Thành công!

<a name="3.5"></a>

## 3.5.Lab DHCP cấp IP cho các host thuộc các namespaces khác nhau
<a name="3.5.1"></a>

### 3.5.1.Topology
Topology sau đây lấy ý tưởng từ hệ thống OpenStack. Trên mỗi máy Compute, các máy ảo thuộc về mỗi vlan đại diện cho các máy của một tenant. Chúng tách biệt về layer 2 và được cấp phát IP bởi các DHCP server ảo cùng VLAN (các DHCP server ảo này thuộc về các namespaces khác nhau và không cùng namespace với các máy ảo của các tenant, được cung cấp bởi dịch vụ dnsmasq). Các DHCP server này hoàn toàn có thể cấp dải địa chỉ trùng nhau do tính chất của namespace. Sau đây là mô hình:  
<img src="images/14.png" />

Mô hình bài lab bao gồm 2 DHCP namespace (dhcp-r, dhcp-g) và hai namespaces dành cho các máy ảo của 2 tenant (red, green), các máy ảo trên 2 tenant này thuộc về hai vlan khác nhau (vlan 100 và vlan 200). DHCP server trên các namespace dhcp-r, dhcp-g sẽ cấp địa chỉ IP cho các máy ảo của 2 tenant trên 2 namespace tương ứng là red và green.  
<a name="3.5.2"></a>

### 3.5.2.Cấu hình
\- Tạo 4 namespaces red ,dhcp-r và green, dhcp-g:  
```
ip netns add red
ip netns add green
ip netns add dhcp-r
ip netns add dhcp-g
```

\- Tạo switch ovs1:  
```
ovs-vsctl add-br ovs1
```

\- Tạo 4 cặp veth pair:  
```
ip link add eth0-r type veth peer name veth-r
ip link add eth0-g type veth peer name veth-g
ip link add tag-r type veth peer name veth-tag-r
ip link add tag-g type veth peer name veth-tag-g
```

\- các port của switch ovs1 như trong hình:  
```
ovs-vsctl add-port ovs1 veth-r
ovs-vsctl add-port ovs1 veth-g
ovs-vsctl add-port ovs1 veth-tag-r
ovs-vsctl add-port ovs1 veth-tag-g
```

\- Thiết lập interface vào các namespaces như trong hình:  
```
ip link set eth0-r netns red
ip link set eth0-g netns green
ip link set tag-r netns dhcp-r
ip link set tag-g netns dhcp-g
```

\- Up switch và các interface trên root namespaces:  
```
ip link set ovs1 up
ip link set veth-r up
ip link set veth-g up
ip link set veth-tap-r up
ip link set veth-tag-g up
```

\- Up interface trên các namespaces khác:  
```
ip netns exec red ip link set lo up
ip netns exec red ip link set eth0-r up
ip netns exec green ip link set lo up
ip netns exec green ip link set eth0-g up
ip netns exec dhcp-r ip link set lo up
ip netns exec dhcp-r ip link set tag-r up
ip netns exec dhcp-g ip link set lo up
ip netns exec dhcp-g ip link set tag-g up
```

\- Cấu hình địa chỉ IP cho interface tag-r, sau đó cấu hình dhcp server (dùng dnsmasq) trên namespaces dhcp-r:  
```
ip netns exec dhcp-r ip a add 10.10.100.2/24 dev tag-r
ip netns exec dhcp-r dnsmasq --interface=tag-r --dhcp-range=10.10.100.50,10.10.100.200,255.255.255.0
```

Sau đó dùng lệnh:  
```
ip netns exec dhcp-r ps aux | grep dnsmasq
```

để kiểm tra:  
<img src="images/15.png" />

\- Cấu hình địa chỉ IP cho interface tag-g, sau đó cấu hình dhcp server (dùng dnsmasq) trên namespaces dhcp-g:  
```
ip netns exec dhcp-g ip a add 10.10.200.2/24 dev tag-g
ip netns exec dhcp-g dnsmasq --interface=tag-g --dhcp-range=10.10.200.50,10.10.200.200,255.255.255.0
```

Sau đó dùng lệnh:  
```
ip netns exec dhcp-g ps aux | grep dnsmasq
```

để kiểm tra:  
<img src="images/16.png" />

\- Xin cấp phát địa chỉ IP cho interface eth0-r trên namespace red:  
```
ip netns exec red dhclient eth0-r
```

Kiểm tra địa chỉ IP sau khi được cấp phát:  
```
ip netns exec red ip a
```

<img src="images/17.png" />

Ping thử đến interface tag-r trên namespace dhcp-r:  
```
ip netns exec red ping 10.10.100.2
```

<img src="images/18.png" />

=> Thành công!
\- Xin cấp phát địa chỉ IP cho interface eth0-g trên namespace green:  
```
ip netns exec green dhclient eth0-g
```

Kiểm tra địa chỉ IP sau khi được cấp phát:  
```
ip netns exec green ip a
```

<img src="images/19.png" />

Ping thử đến interface tag-g trên namespace dhcp-g:  
```
ip netns exec green ping 10.10.200.2
```

<img src="images/20.png" />

=> Thành công!


<a name="tailieuthamkhao"></a>
# Tài liệu tham khảo
- https://en.wikipedia.org/wiki/Linux_namespaces
- http://manpages.ubuntu.com/manpages/xenial/en/man8/ip-netns.8.html
- http://abregman.com/2016/09/29/linux-network-namespace/
- http://blog.scottlowe.org/2013/09/04/introducing-linux-network-namespaces/
- http://www.opencloudblog.com/?p=42
- LAB: http://www.opencloudblog.com/?p=66
- https://www.youtube.com/watch?v=_WgUwUf1d34
- http://www.packetu.com/2012/07/12/vrfing-101-understing-vrf-basics/








