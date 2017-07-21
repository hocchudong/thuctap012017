# Linux bridge basic


# MỤC LỤC
- [1.Khái niệm ](#1)
- [2.Các thành phần](#2)
- [3.Các tính năng](#3)
- [4.Install tool quản lý linuxbridge on Ubuntu Server 16.04](#4)
- [5.Linux bridge command ](#5)
  - [5.1.Tổng quát](#5.1)
  - [5.2.Một số command hay dùng](#5.2)
    - [5.2.1.Bridge](#5.2.1)
    - [5.2.2.Ports](#5.2.2)
    - [5.2.3.AGEING](#5.2.3)
    - [5.2.4.STP](#5.2.4)
- [6.Note quan trọng với linux bridge technology](#6)
  - [6.1.Create bridge](#6.1)
  - [6.2.Port](#6.2)
    - [6.2.1.Port](#6.2.1)
    - [6.2.2.tap interface and uplink port](#6.2.2)
  - [6.3.Bridge network với linux bridge](#6.3)
- [7.Network mode](#7)
  - [7.0.Introduction](#7.0)
  - [7.1.Bridged Network](#7.1)
    - [7.1.1.Giới thiệu](#7.1.1)
    - [7.1.2.Hạn chế](#7.1.2)
    - [7.1.3.Cấu hình bridged network on Ubuntu server 16.04](#7.1.3)
  - [7.2.NAT,Routed,Isolated mode](#7.2)


<a name="1"></a>
# 1.Khái niệm 
\- Linux bridge là một soft-switch, một trong ba công nghệ cung cấp switch ảo trong hệ thống Linux (bên cạnh macvlan và OpenvSwitch), giải quyết vấn đề ảo hóa network bên trong các máy vật lý.  
\- Bản chất, linux bridge sẽ tạo ra các switch layer 2 kết nối các máy ảo (VM) để các VM đó giao tiếp được với nhau và có thể kết nối được ra mạng ngoài. Linux bridge thường sử dụng kết hợp với công nghệ create VM là KVM-QEMU.  
\- Linux bridge là Linux kernel module.  

<a name="2"></a>
# 2.Các thành phần

<img src="http://i.imgur.com/KCl8wN0.png" />

Kiến trúc linux bridge minh họa như hình vẽ trên. Một số khái niệm liên quan tới linux bridge:  
- **Port**: tương đương với port của switch thật
- **Bridge**: tương đương với switch layer 2.
- **Tap**: hay tap interface có thể hiểu là port để các VM kết nối với bridge cho linux bridge tạo ra.
- **fd**: forward data - chuyển tiếp dữ liệu từ VM tới bridge.

<a name="3"></a>
# 3.Các tính năng
\- STP: Spanning Tree Protocol - giao thức chống loop gói tin trong mạng.  
\- VLAN: chia switch (do linux bridge tạo ra) thành các virtual LAN, cô lập traffic giữa các VM trên các VLAN khác nhau của cùng một switch.  
\- FDB: chuyển tiếp các gói tin theo database để nâng cao hiệu năng switch.  

<a name="4"></a>
# 4.Install tool quản lý linuxbridge on Ubuntu Server 16.04
\- Run command :  
```
$sudo apt-get install bridge-utils
```

<a name="5"></a>
# 5.Linux bridge command 

<a name="5.1"></a>
## 5.1.Tổng quát
http://manpages.ubuntu.com/manpages/xenial/man8/brctl.8.html

<a name="5.2"></a>
## 5.2.Một số command hay dùng

<a name="5.2.1"></a>
### 5.2.1.Bridge
\- Show all current virtual switch :  
```
brctl show
```

\- Add , delete virtual switch :  
```
brctl addbr <brname>
brctl delbr <brname>
```

<a name="5.2.2"></a>
### 5.2.2.Ports
\- Show information on the bridge :  
```
brctl show <brname>
```

\- Add , delete port :  
```
brctl addif <brname> <ifname>
brctl delif <brname> <ifname>
```

<a name="5.2.3"></a>
### 5.2.3.AGEING
\- Show forwarding table of bridge :  
```
brctl showmacs <brname>
```

<img src="http://i.imgur.com/0nnFmsM.png" />

\- Set RTT :  
```
brctl setageing <brname> <time>
```

<a name="5.2.4"></a>
### 5.2.4.STP
\- Show bridge stp info :  
```
brctl showstp <bridge>
```

\- Turn { on | off } spanning tree protocol :  
```
brctl stp <bridge> {on|off}
```

\- Set bridge forward delay :  
```
brctl setfd <bridge> <time>
```

\- Set bridge priority để chọn root bridge :  
```
brctl setbridgeprio <bridge> <prio>
```

\- Set port priority để chọn root port :  
```
brctl setportprio <bridge> <port> <prio>
```

<a name="6"></a>
# 6.Note quan trọng với linux bridge technology

<a name="6.1"></a>
## 6.1.Create bridge

<a name="6.1.1"></a>
### 6.1.1.Create bridge by command brctl addbr
\- Tạo bridge bằng command `brctl addbr` thì bridge là **non-persistent bridge** .  
\- Khi create bridge bằng command, ví dụ :  
```
brctl addbr br1 
```

`br1` sẽ có MAC address như sau :  
<img src="http://i.imgur.com/ALNrYxG.png" />  

Đây là MAC addess mặc định của br1, nhưng khi ta add virtual network card gắn vào bridge thì bridge sẽ hiện MAC address của virtual network card đó.  
Ta có thể add IP address cho `br1` :  
```
ip a add 10.10.5.2/24 dev br1
```

<img src="http://i.imgur.com/LvtKVSl.png" />

<a name="6.1.2"></a>
### 6.1.2.Create bridge bằng file .xml
\- Tạo bridge bằng file thì bridge sẽ là persistent bridge .(Vì file sẽ boot cùng system )  
\- Khi create bridge bằng file .xml sử dụng libvirt thì ta có thể chỉ định MAC address cố định cho bridge và không thay đổi.  

<img src="http://i.imgur.com/PMzPMhm.png" />

\- Bridge được tạo bằng file sẽ có default port cùng MAC address với bridge như sau :  

<img src="http://i.imgur.com/aRJYS4x.png" />

<a name="6.2"></a>
## 6.2.Port

<a name="6.2.1"></a>
### 6.2.1.Port
\- Khi vNIC hoặc pNIC được gắn vào vport on vswitch , vport sẽ show ra như interface của host.  
\- Với câu lệnh :  
```
brctl addif <bridge> <port>
```

thì <port>  ( chính là NIC ) phải là đã có trong host , câu lệnh này chính là gắn NIC vào vswitch.  

<a name="6.2.2"></a>
### 6.2.2.tap interface and uplink port
<img src="http://i.imgur.com/M2sjhzH.png" />

<img src="http://i.imgur.com/TgVyOjx.png" />

\- **Note1** : VM connected vswitch thì Port của Virtual Switch gọi là tap interface , khi VM power on thì host sẽ hiện lện là vnet -> gọi là vnet tap inteface.  
- **Note 2** : Virtual switch để chế độ bridging network với physical network card ( eth0 ) thì port trên vswitch gọi là virtual uplink port.  

#### 6.2.2.1.tap interface
\- tap interface có MAC address khác vNIC on VM.  
\- Chú ý RX và TX trên vNIC và vnet tap internet xấp xỉ = nhau .  

<img src="http://i.imgur.com/ujTVyCw.png" />


#### 6.2.2.2.uplink port
\- Khi gắn 1 pNIC on host với vswitch thì on host chỉ hiện lên duy nhất một interface.  

<img src="http://i.imgur.com/lwL1W2d.png" />

<a name="6.3"></a>
## 6.3.Bridge network với linux bridge
\- Tạo virtual network chế độ bridged network thì dùng command brctl hoặc configrure in file `/etc/network/interfaces` .  
\- Tạo virtual switch bằng command brctl thì khi restart lại máy , các virtual switch sẽ mất .  
\- Tạo virtual switch bằng configure file /etc/network/interface thì sẽ tồn tại vĩnh viễn .  

<a name="7"></a>
# 7.Network mode

<a name="7.0"></a>
## 7.0.Introduction
\- Có 4 network mode :  
- Bridge 
- NAT
- Routed
- Isolated

<a name="7.1"></a>
## 7.1.Bridged Network

<a name="7.1.1"></a>
### 7.1.1.Giới thiệu
1 bridge network chia sẻ 1 thiết bị Ethernet thực với virtual machines . Mỗi VM có thể có 1 địa chỉ IPv4 hoặc IPv6 sẵn có trên mạng LAN như 1 máy physical computer . Bridging là tốt hơn về performace and đỡ rắc rối hơn các loại network trong libvirt.  

<a name="7.1.2"></a>
### 7.1.2.Hạn chế
The libvirt server buộc phải được kết nối LAN qua Ethernet . Nếu kết nối bằng wirelessly , 1 Router network hoặc NAT-based network là lựa chọn duy nhất.  

- Limitations for dedicated servers  
A bridge is only possible when there are enough IP addresses to allocate one per VM. This is not a problem for IPv6, as hosting providers usually provide many free IPv6 addresses. However, extra IPv4 addresses are rarely free. If you only have one public IPv4 address (and need to serve clients over IPv4), either buy more IPv4 addresses or create a NAT-based network.  
Hosting providers often only allow the MAC address of the server to bind to IP addresses on the LAN, which prevents bridging. Your provider may let you rent a private VLAN that allows VMs to bind directly to IP addresses, but if this is too costly then consider a Routed network.  

<img src="http://i.imgur.com/7PWJyhe.png" />

<a name="7.1.3"></a>
### 7.1.3.Cấu hình bridged network on Ubuntu server 16.04 
#### a.Sử dụng command ( khi restart lại máy sẽ mất ) 
Sau đây là ví dụ  
```
brctl addbr br # tạo mới
brctl addif br ens33 # Gán port ens33 vào swith br1
brctl stp br on # enable tính năng STP nếu cần
brctl setfd br 2
ifconfig esn33 0 # có thể dụng command : ip address flush ens33 
#xin cấp phát ip cho br0 
dhclient br
#or tự cấu hình
ifconfig br 172.16.69.10
```

#### b.Cấu hình trong file  `/etc/network/interfaces` (restart lại máy không mất )
\- Tham khảo : http://manpages.ubuntu.com/manpages/xenial/man5/bridge-utils-interfaces.5.html  

Sau đây là ví dụ  
```
#config ens33
auto ens33
iface ens33 inet manual
#config br
auto br
iface br inet dhcp
bridge_ports ens33
bridge_stp on
bridge_fd 2
or :
#config ens33
auto ens33
iface ens33 inet manual
#config br
auto br
iface br inet static
address 172.16.69.101/24
gateway 172.16.69.1
dns-nameservers 8.8.8.8
bridge_ports ens33
bridge_stp on
bridge_fd 2
```

<a name="7.2"></a>
## 7.2.NAT,Routed,Isolated mode
3 mode này libvirt đều hỗ trợ linux_bridge.  







































