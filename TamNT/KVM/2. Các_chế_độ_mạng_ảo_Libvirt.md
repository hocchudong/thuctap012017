# MỘT SỐ CHẾ ĐỘ MẠNG ẢO VỚI LIBVIRT

## Mục lục

[1. Giới thiệu](#1)


[2. Bridged network](#2)

- [2.1. Hạn chế](#2.1)

- [2.2. Cấu hình tạo mạng bridged network](#2.2)

- [2.3. Cấu hình máy ảo ](#2.3)

[3. Routed network](#3)

- [3.1. Giới thiệu](#3.1)

- [3.2. Cấu hình tạo mạng Routed network](#3.2)

- [3.3. Cấu hình máy ảo](#3.3)

- [3.4. Cấu hình định tuyến tĩnh tại router](#3.4)

[4. NAT-based network](#4)

[5. Isolated network](#5)

[6. Tổng kết](#6)

[7. Tham khảo](#7)


---

<a name = "1"></a>
# 1. Giới thiệu

## 1.1. Đặt vấn đề

- Mỗi máy ảo VM tạo ra cần được kết nối tới một mạng để liên lạc với các máy ảo khác, liên lạc với host hoặc ra ngoài Internet. Vì vậy, nhu cầu tạo ra các mạng phù hợp với yêu cầu kết nối của mỗi VM là cần thiết.

- libvirt là thư viện các API tương tác và quản lý các hypervisor, trong đó hỗ trợ KVM. Và do đó, nó cũng sẽ có vai trò quản lý các mạng ảo trong host server. 

- Một số loại mạng ảo trong libvirt: 

  -	Bridged network

  -	Routed network

  -	NAT-based network

  -	Isolated network

  -	Custom routed network

  -	Custom NAT-based network

  -	Multiple networks

Trong phần này mình sẽ chỉ tìm hiểu bốn chế độ mạng chính trong libvirt.


## 1.2. Virtual network Switch 

Trước hết, libvirt sử dụng khái niệm là virtual network switch:

<img src = "http://imgur.com/eYPfap2.jpg">

Đây đơn giản là một phần mềm chạy trên host server, mà cho phép các máy ảo của bạn “cắm vào” (plug-in) và chuyển hướng lưu lượng.

<img src = "http://imgur.com/bcMEuj1.jpg">

Trên máy chủ Linux, virtual network switch được show lên như là một network interface.

Mặc định, khi libvirt được cài đặt và khởi động sẽ tạo một switch ảo có tên virbr0.

<img src = "http://imgur.com/f7GC8S6.jpg">

<a name = "2"></a>
# 2. Bridged network


Mạng Bridged network chia sẽ một thiết bị Ethernet thật với các máy ảo VM. Mỗi VM có thể gán trực tiếp bất kì địa chỉ IP trên mạng LAN, như một máy tính vật lý. Bridging cho phép hiệu năng cao nhất và là kiểu mạng ít gây vấn đề nhất trong Libvirt.


<a name = "2.1"></a>
## 2.1. Hạn chế

- Libvirt server **phải được kết nối trực tiếp tới LAN thông qua Ethernet**. Nếu nó được kết nối không dây, thì nên sử dụng mạng Routed network hoặc NAT-based network.

- Hạn chế cho các server chuyên dụng.

- Yêu cầu phải đủ địa chỉ IPv4 cung cấp cho các máy ảo.

- Các nhà cung cấp thường chỉ cho phép các địa chỉ MAC gán tới địa chỉ IP trong mạng LAN. Nếu nhà cung cấp của bạn cho phép bạn thuê VLAN private mà cho phép kết nối trực tiếp tới địa chỉ IP, nhưng nếu điều này quá tốn thì cân nhắc tới mạng Routed network.

<a name = "2.2"></a>
## 2.2. Cấu hình tạo mạng bridged network

Sử dụng virt-manager, hoặc webvirtmgr hoặc dùng file xml để tạo một mạng bridged network.

Mạng bridged network yêu cầu phải tạo trước 1 switch ảo để có thể bridging vào. Do đó, đầu tiên phải tạo bridge trước (ở đây sử dụng linux bridge)

`brctl addbr brdige`


#### 1) Tạo từ webvirtmgr:

Làm theo các bước sau:

<img src = "http://imgur.com/nVYJCYj.jpg">


<img src = "http://imgur.com/LFJWyM1.jpg">

<img src = "http://imgur.com/YkK7J03.jpg">

#### 2) Tạo từ file xml:

  Vào thư mục `/etc/libvirt/qemu/networks/` tạo file mạng bridge.xml như sau: (ví dụ tạo mạng có tên bridge)

```
<network>
  <name>bridge</name>
  <uuid>bd3974f3-71d8-480c-9575-bab8b9afa9fb</uuid>
  <forward mode='bridge'/>
  <bridge name='bridge'/>
</network>
```

  Sau đó, dùng các câu lệnh sau để tạo mạng từ file  bridge.xml:

  `virsh net-define bridge.xml`
  `virsh net-autostart bridge`
  `virsh net-start bridge`

Được kết quả như sau là ok!

<img src = "http://imgur.com/v9PT1cd.jpg">

<a name = "2.3"></a>
## 2.3. Cấu hình máy ảo

Máy ảo VM muốn kết nối tới một mạng Bridged network thì chỉnh sửa cấu hình trong file xml như sau:

``` 
<interface type="network">
   <source network="default"/>
   <mac address="52:54:00:4f:47:f2"/>
</interface>
```

Sửa lại section `<interface>` thành như sau:

```
<interface type="bridge">
  <source bridge="br0"/>
  <mac address="52:54:00:4f:47:f2"/>
</interface>
```

- Khi đó, máy ảo sẽ được kết nối thông qua bridge **bridge** như mạng cắm vào switch ở ngoài thực tế. 

- Khởi động lại máy ảo là ok. 

- Khi đó, máy ảo sẽ có địa chỉ IP cùng dải mạng LAN vật lý kết nối host server.

<a name = "3"></a>
# 3. Routed network

<a name = "3.1"></a>
## 3.1. Giới thiệu

- Với **Routed mode**, virtual switch được kết nối tới mạng LAN vật lý của máy chủ, các lưu lượng của máy ảo guest sẽ được xử lý ra ngoài mà không thông qua NAT.

- Virtual switch sẽ thấy được IP trong mỗi gói tin, sử dụng thông tin đó để quyết định sẽ làm gì với nó.

- Trong chế độ này, tất cả máy ảo VM trong cùng một mạng con được định tuyến thông qua virtual switch. Tuy không máy ảo nào trong mạng vật lý biết sự tồn tại của mạng con này hoặc làm sao để tìm được ra nó. Đây là điều cần thiết để cấu hình định tuyến trong mạng vật lý (ví dụ sử dụng định tuyến tĩnh)

<img src = "http://imgur.com/EAZybdH.jpg">

- Mạng routed network thường chỉ được sử dụng khi mà mạng ***Bridged network không thể thực hiện được***, hoặc các nhà cung cấp hạn chế bởi vì libvirt server chỉ được kết nối không dây trong mạng LAN. Các máy ảo VM có địa chỉ IP của chính nó, nhưng không thể gán trực tiếp vào chúng. Thay vào đó, các gói tin dành cho những địa chỉ này được định tuyến tĩnh tới libvirt server và chuyển tiếp tới các máy ảo (mà không sử dụng NAT)

- Sử dụng chế độ Routed, có thể tạo các vùng mạng con CIDR – đây là một ưu điểm của routed so với bridge.

<a name = "3.2"></a>
## 3.2. Cấu hình tạo mạng Routed network

- Khi tạo mạng routed network, bạn cần phải định tuyến tĩnh tại router vật lý của mạng LAN thực sự mà kết nối với máy chủ host server. Dải mạng cấp phát trong vùng mạng routed network cũng là mạng con CIDR. (Ví dụ, máy host có địa chỉ IP trong vùng 192.168.1.0/24, địa chỉ IP host là 192.168.1.100. Khi đó, cấu hình cho mạng routed network cấp phát địa chỉ trong mạng CIDR 192.168.1.224/27)

- Ở chế độ này, khi tạo một mạng routed network mới thì libvirt sẽ **tự động** tạo thêm một bridge mới gán với mạng mà không cần tạo trước như mạng bridged network.


#### 1) Tạo với webvirtmgr: 

Chọn chế độ mạng là route, và cấu hình IP như hình:

<img src = "http://imgur.com/6qfLtjP.jpg">


<img src = "http://imgur.com/gbcHAgz.jpg">


#### 2) Tạo bằng virt-manager: 

<img src = "http://imgur.com/LmBCMdn.jpg">


<img src = "http://imgur.com/PyTIT8H.jpg">


#### 3) Tạo bằng file xml: 

Tạo file route.xml trong thư mục `/etc/libvirt/qemu/networks/` có nội dung như sau:

```
<network>
  <name>route</name>
  <uuid>5e275ec6-5c18-4397-a77d-c2b152b4715a</uuid>
  <forward dev='ens33' mode='route'>
    <interface dev='ens33'/>
  </forward>
  <bridge name='virbr1' stp='on' delay='0'/>
  <mac address='52:54:00:91:3c:9e'/>
  <domain name='route'/>
  <ip address='192.168.1.225' netmask='255.255.255.224'>
    <dhcp>
      <range start='192.168.1.240' end='192.168.1.254'/>
    </dhcp>
  </ip>
</network>
```
Sau đó dùng 3 câu lệnh virsh ở trên để tạo và khởi động mạng hoạt động.

### Lưu ý: Khi sử dụng mạng routed network, thì bạn có thể chọn routed tới card mạng không dây. (wlan)


<a name = "3.3"></a>
## 3.3. Cấu hình máy ảo

Sửa lại cấu hình section `<interface>` trong file cấu hình xml của máy ảo sử dụng mạng route network như sau: 

```
	<interface type='network'>
      <mac address='02:55:66:f1:6b:4f'/>
      <source network='route'/>
      <model type='rtl8139'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
```

( Sửa source network = ‘tên mạng’)

<a name = "3.4"></a>
## 3.4. Cấu hình định tuyến tĩnh tại router

\- Tại router: thêm một đường định tuyến để các thiết bị trong mạng LAN có thể liên lạc được với máy ảo:

(ví dụ đang sử dụng router tenda, chỉ hỗ trợ định tuyến tĩnh cụ thể từng địa chỉ mạng nên thao tác thêm định tuyến như sau. Có thể một số router khác có thể thêm định tuyến cả vùng địa chỉ)

<img src = "http://imgur.com/DBxgikU.jpg">

Sau đó, máy ảo sử dụng mạng routed network có địa chỉ IP 192.168.1.244 có thể liên lạc ra ngoài.

<a name = "4"></a>
# 4.	NAT-based network

- Mặc định, một switch mạng ảo vận hành trong chế độ ***NAT mode*** (sử dụng **IP masquerading** hơn là SNAT hoặc DNAT)

- Điều này có nghĩa là bất kì máy ảo nào được kết nối tới nó, sử sử dụng địa chỉ IP của máy host để liên lạc ra bên ngoài. Các máy ở mạng ngoài không thể liên lạc với máy guest ở bên trong khi swtich ảo hoạt dộng trong chế độ NAT.

<img src = "http://imgur.com/btDyCxU.jpg">

- Chế độ NAT-based network coi libvirt server như là một router, các lưu lượng của máy ảo xuất hiện từ địa chỉ của server để ra ngoài.

- Đây là chế độ hoạt động mặc định khi cài đặt libvirt và bạn không cần cấu hình gì thêm.

- ***Hạn chế***: Virtual network mặc định hoạt động ở chế độ NAT-baased. Không may, nó thường tự động thêm các rule iptable cho dù bạn có muốn hay không – để cho khó để điều khiển – trừ khi bạn disable mạng default hoàn toàn.

<img src = "http://imgur.com/55tdT1e.jpg">

- Để tạo mạng NAT-based network có thể sử dụng 3 công cụ như các cách đã nêu trên,chọn mode="nat" và cấp phát dải ip tùy ý. 

- Cấu hình máy ảo cũng tương tự như trình bày trên.

<a name = "5"></a>
# 5. Isolated network

- Trong mode này, các máy guuest kết nối tới switch ảo có thể liên lạc với nhau và với host, nhưng lưu lượng của chúng sẽ không được đi ra ngoài host – cũng như không thể nhận các kết nối từ bên ngoài vào:

<img src = "http://imgur.com/iANkvQe.jpg">

- Việc sử dụng dnsmasq trong mode này là có thể  và thực tế vì nó được sử dụng để trả lời cho DHCP request.

- Việc cấu hình và tạo mạng isolate sẽ tự tạo thêm bridge ảo mới cho mạng. không cần tạo trước như mạng bridge network.

- Việc cấu hình cho máy ảo và cấu hình tạo mạng cũng tương tự như các loại mạng đã kể trên, thay mode=isolate trong section forward của file xml cấu hình mạng.

<a name="6"></a>
# 6. Tổng kết

Nếu bạn đã quen với làm việc trên Vmware thì có thể hình dung như sau: 

-	Mạng **bridged network** và **routed network** giống như chế độ mạng bridge của Vmware. Trong đó, bridge phải tạo bridge trước khi gán vào mạng bridge network và dùng trong trường hợp nối ra một card mạng của host là card ethernet. Còn mạng routed network hoạt động thêm tính năng là chia mạng con CIDR và dùng trong trường hợp nối với một card mạng của host là card wireless, và cần phải cấu hình tại router vật lý để định tuyến tĩnh cho mạng.

-	Mạng **NAT-based network** giống như chế độ mạng NAT của Vmware. (và là chế độ mạng mặc định của libvirt, sử dụng iptables để hoạt động)

-	Mạng **isolated network** giống như mạng host-only trong Vmware.

-	Các siwtch ảo tạo ra gán với mạng là các switch kiểu linux bridge, nên có thể dùng câu lệnh [`brctl`](http://manpages.ubuntu.com/manpages/xenial/man8/brctl.8.html) để kiểm tra. 

-	Tham khảo thêm các câu lệnh virsh với mạng tại : http://wiki.libvirt.org/page/VirtualNetworking#Basic_command_line_usage_for_virtual_networks

<a name = "7"></a>
# 7. Tham khảo

[1] http://wiki.libvirt.org/page/VirtualNetworking

[2] https://libvirt.org/formatnetwork.html

[3] https://jamielinux.com/docs/libvirt-networking-handbook/ 

