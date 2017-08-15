# GNS3


# MỤC LỤC
- [1.Giới thiệu](#1)
- [2.Thành phần của GNS3](#2)
- [3.Cài đặt GNS3](#3)
	- [3.1.Cài GNS3 all-in-one](#3.1)
	- [3.2.Cài GNS3 VM](#3.2)
	- [3.3.Kết nối GNS3 all-in-one với GNS3 VM](#3.3)
- [4.Thiết bị sử dụng cho GNS3](#4)
	- [4.1.Dynamip](#4.1)
	- [4.2.IOU (IOS on Unix)](#4.2)
	- [4.3.QEMU](#4.3)
- [5.LAB](#5)
	- [5.1.Topotology đơn giản](#5.1)
	- [5.2.VLAN](#5.2)
		- [5.2.1.Topology](#5.2.1)
		- [5.2.2.Cấu hình](#5.2.2)
		- [5.2.3.Kiểm tra kết nối](#5.2.3)
- [Tài liệu tham khảo](#tailieuthamkhao)



<a name="1"></a>

# 1.Giới thiệu
\- GNS3 là phần mềm để mô phỏng, cấu hình, kiểm thử và sửa chữa mạng ảo và mạng thật. GNS3 cho phép bạn tạo 1 topology nhỏ gồm 1 vài thiết bị trên laptop, với những thiết bị trên nhiều máy chủ hoặc trên cloud.  
\- GNS3 là phần mềm mã nguồn mở miễn phí.  
\- GNS3 có tác dụng tương tự như Cisco Packet Tracer nhưng đây là công cụ mạnh mẽ hơn, cho phép cả 2 việc là giả lập và mô phỏng.  
\- Trang chủ của GNS3: http://gns3.com/  

<a name="2"></a>

# 2.Thành phần của GNS3  
\- GNS3 gồm 2 phần mềm:  
- GNS3-all-in-one software (GUI)
- GNS3 virtual machine (VM)

\- GNS3-all-in-one là phần client của GNS3 và là giao diện người dùng đồ họa (graphical user interface). Bạn có thể cài đặt all-in-one software trên máy tính của bạn (Windows, MAC, Linux) và tạo topology của bạn bằng cách sử dụng phần mềm này. Ví dụ 1 topo như sau:

<img src="images/1.png" />

\- Khi tạo topology trong GNS3 bằng phần mềm **all-in-one GUI client**, thiết bị được tạo cần lưu trữ và chạy bởi tiến trình server. Bạn có 1 vài lựa chọn cho phần server của phần mềm:  
- Local GNS3 server
- Locol GNS3 VM
- Remote GNS3 VM

\- Trong đó, local GNS3 server chính là PC cài đặt GNS3 all-in-one software.  
VD: Sử ụng Windows PC, ca2 GNS3 GUI và local GNS3 server đang chạy như các tiến trình của Windows.  
\- Nếu thiết bị của bạn sử dụng GNS3 VM (nên sử dụng), bạn có thể chạy GNS3 VM trên PC sử dụng phần mềm ảo hóa như VMWare Workstation hoặc Virtualbox, hoặc bạn có thể chạy GNS3 VM remote trên server sử dụng VMWare ESXi hoặc ngay cả trên cloud.  
\- **TIP**  
Bạn có thể sử dụng GNS3 mà không sử dụng GNS3 VM, nhưng nó sẽ có giới hạn và không cung cấp nhiều lựa chọn liên quan đến kích thước topology và hỗ trợ được nhiều thiết bị. Nếu bạn muốn tạo GNS3 topology chi tiết, hoặc muốn bao gồm các thiết bị như  thiết bị Cisco VIRL hoặc 1 vài thiết bị khác mà yêu cầu Qemu thì bạn phải sử dụng GNS3 VM.  
\- GNS3 hỗ trọ cả thiết bị giả lập và thiết bị mô phỏng ( emulated device và simulated devices):  
- **Emulation**: GNS3 bắt chước hoặc giả lập phần cứng của thiết bị và bạn có thể chạy các image thực tế trên thiết bị ảo.  
VD: Bạn có thể copy Cisco IOS từ real, physical Cisco router và chạy trên virtial, emulated Cisco router trong GNS3.  
- **Simulation**: GNS3 mô phỏng các tính năng và chức năng của thiết bị như switch, etc. Bạn không chạy các hệ điều hành thực như Cisco IOS, mà là 1 thiết bị mô phỏng được phát triển bởi GNS3 như GNS3 layer 2 switch.  

<a name="3"></a>

# 3.Cài đặt GNS3
Ở đây, mình cài GNS3 all-in-one trên Windows 10 và GNS3 VM trên VMWare Workstation Pro 12 (local GNS3 VM).  
\- Download GNS3 all-in-one và GNS3 VM ở đây: https://github.com/GNS3/gns3-gui/releases  
Chú ý: phải download 2 phần mềm cùng phiên bản. Ở đây mình cài phiên bảng GNS3 2.02.  

<img src="images/2.png" />

<a name="3.1"></a>

## 3.1.Cài GNS3 all-in-one
\- Cài GNS3 all-in-one theo hướng dẫn tại:  https://docs.gns3.com/11YYG4NQlPSl31YwvVvBS9RAsOLSYv0Ocy-uG2K8ytIY/index.html 

<a name="3.2"></a>

## 3.2.Cài GNS3 VM
\- Cài GNS3 VM: (Tham khảo: http://docs.gns3.com/1wdfvS-OlFfOf7HWZoSXMbG58C4pMSy7vKJFiKKVResc/ )  
Sau khi download **GNS3.VM.VMWare.Workstation.2.0.2.zip**, ta giải nén được phần mềm sau:  

<img src="images/3.png" />

Ta mở VMWare lên và làm như sau:  
- Kích vào Open.

<img src="images/4.png" />

- Kích đúp vào file như trong hình dưới, sau đó kích Open.

<img src="images/5.png" />

- Đặt tên cho virtual machine và thư mục lưu trữ cho virtual machine, sau đó kích Import.

<img src="images/6.png" />

- Vậy là ta đã được GNS3 VM.

<img src="images/7.png" />

- Khởi động GNS3 VM, xuất hiện như sau:

<img src="images/8.png" />

- Ta thấy địa chỉ để truy cập VM là 10.10.10.10, đây là địa chỉ IP do DHCP server cấp, nếu muốn đặt địa chỉ tĩnh, ta chọn Ok.  

<img src="images/9.png" />

- Chọn Networking như trong hình.

<img src="images/10.png" />

- Cấu hình như sau:

<img src="images/11.png" />

- Lưu lại và GNS3 VM sẽ tự động reboot.  
=> Vậy là ta đã cài thành công GNS3 VM.  

<a name="3.3"></a>

## 3.3.Kết nối GNS3 all-in-one với GNS3 VM
\- Bật giao diện GNS3 all-in-one và chọn “Edit”, sau đó chọn "Preferences":  

<img src="images/12.png" />

\- Màn hình xuất hiện hộp thoại.  

<img src="images/13.png" />

\- Đây là nơi lưu trữ mặc định về các projects và thư mục cấu hình của GNS3.  

<img src="images/14.png" />

\- Ta chọn “Server” và làm như hình sau:  
Cấu hình cho GNS3 GUI client kết nối Windows.  

<img src="images/15.png" />

Thiết lập kết nối GNS3 VM và khởi động GNS3 VM mỗi khi bật GNS3 GUI client.

<img src="images/16.png" />

\- Note: Nếu cài GNS3 all-in-one và remote GNS3 VM, ta có thể cấu hình kết nối như sau:  

<img src="images/17.png" />

<a name="4"></a>

# 4.Thiết bị sử dụng cho GNS3
\- GNS3 có thể sử dụng cả thiết bị giả lập (Dynamip – IOS routers) và thiết bị mô phỏng (IOU – IOS on Unix).  Ngoài ra GNS3 còn có thể sử dụng các phần mềm ảo hóa như QMEMU, VMWare, Virtualbox.  

<a name="4.1"></a>

## 4.1.Dynamip
\- Download tại đây:  http://www.careercert.info/2009/05/new-cisco-ios-version-124-collection.html  
\- Thêm thiết bị mới như sau:

<img src="images/17.png" />

<img src="images/18.png" />

<img src="images/19.png" />

<img src="images/20.png" />

<img src="images/21.png" />

<img src="images/22.png" />

<img src="images/23.png" />

<img src="images/24.png" />

<img src="images/25.png" />

<img src="images/26.png" />

<img src="images/27.png" />

<img src="images/28.png" />

=> Vậy là ta đã thêm thiết bị Router C2600 thành công.  

<img src="images/29.png" />

\- Chọn "OK" để lưu.  

<img src="images/30.png" />

<a name="4.2"></a>

## 4.2.IOU (IOS on Unix)
\- Download tại đây:  https://drive.google.com/drive/u/0/folders/0B6VuDLpyDgnHMWhBNXlWQjFIcXM  
\- Thêm thiết bị mới như sau:  

<img src="images/31.png" />

\- Thêm license cho thiết bị (đi kèm với thiết bị):  

<img src="images/32.png" />

\- Thêm thiết bị:

<img src="images/33.png" />

<a name="4.3"></a>

## 4.3.QEMU
\- Thêm virtual machine, làm theo hướng dẫn trong hình dưới đây.  

<img src="images/34.png" />

<img src="images/35.png" />

<img src="images/36.png" />

<img src="images/37.png" />

<img src="images/38.png" />

<img src="images/39.png" />

<img src="images/40.png" />

<a name="5"></a>

# 5.LAB

<a name="5.1"></a>

## 5.1.Topotology đơn giản
<img src="images/41.png" />

\- Mục đích: Kiểm tra kết nối giữa PC1 và PC2, giữa PC, PC2 với R1.  
\- Cấu hình tên các thiết bị, địa chỉ IP như trong hình.  
\- Đầu tiên ta bật các thiết bị lên.  
\- Cấu hình cho PC1, ta chạy các command sau:  
- Thiết lập địa chỉ IP.  
```
ip 10.10.10.10 255.255.255.0 10.10.10.1
```

<img src="images/42.png" />

- Kiểm tra địa chỉ IP:  
```
show ip all
```

<img src="images/43.png" />

- Lưu lại cấu hình:  
```
save
```

\- Cấu hình cho PC2, tương tự PC1.  

<img src="images/44.png" />

\- Cấu hình cho R1, thực hiện các câu lệnh sau:  
- Truy terminal để cấu hình:  
```
configure terminal
```

- Chọn cổng để cấu hình, ở đây là 0:  
```
interface FastEthernet 0
```

- Thiết lập địa chỉ IP  
```
ip address 10.10.10.1 255.255.255.0
```

- Kích hoạt interface này, vì mặc định các interface của thiết bị Cisco ở chế độ down.  
```
no shutdown
```

- Thoát ra, chú ý: 2 lần exit  
```
exit
exit
```

- Kiểm tra địa chỉ IP được thiết lập:  
```
show run interface FastEthernet 0
```

<img src="images/45.png" />

- Lưu lại cấu hình:  
```
save memory
```

\- Kiểm tra kết nối:  
- PC1 với PC2  

<img src="images/46.png" />

=> Thành công!  
- PC1 và R1

<img src="images/47.png" />

=> Thành công!

<a name="5.2"></a>

## 5.2.VLAN

<a name="5.2.1"></a>

### 5.2.1.Topology
<img src="images/48.png" />

\- Cấu hình:  
- Swich SW1 và SW2 đều gồm 9 port, trong đó port 0 làm port trunking, port 1-4 thuộc VLAN1, port 5-8 thuộc VLAN2.
- Các PC có địa chỉ IP và VLAN như hình.
- Nối port 0 của SW1 và port 2 của SW2.
- PC1 nối với port 1 của SW1, PC2 nối với port 5 của SW1.
- PC3 nối với port 1 của SW2, PC4 nối với port 5 của SW2.

\- Mục tiêu: Kiểm tra kết nối giữa các PC.  

<a name="5.2.2"></a>

### 5.2.2.Cấu hình
\- SW1 và SW2:  
Cấu hình như sau:  
```
conf t
interface ethernet 0/0
switchport trunk encapsulation dot1q
switchport mode trunk
exit
interface ethernet 0/1
switchport mode access
switchport access vlan 10
exit
interface ethernet 0/2
switchport mode access
switchport access vlan 20
exit
```

<img src="images/49.png" />

Kiểm tra cấu hình:  

<img src="images/50.png" />

\- SW2:  
Cấu hình tương tự switch SW1.  

\- PC1, thực hiện các command sau:  
```
ip 10.10.10.1 255.255.255.0 10.10.10.100
show ip all
save
```

<img src="images/51.png" />
 
\- Thực hiện tương tự đối với PC2, PC3, PC4.  
\- Thực hiện nối dây giữa PC và Switch như topo.  

<a name="5.2.3"></a>

### 5.2.3.Kiểm tra kết nối
\- Ping thử giữa PC1 và PC2, PC1 và PC3.  

<img src="images/52.png" />

Vậy kết nối thành công giữa PC1 và PC3, kết nối thất bại giữa PC1 và PC2.  
\- Ping thử PC4 và PC3, PC4 với PC2.  

<img src="images/53.png" />

Vậy kết nối thành công giữa PC4 và PC2, kết nối thất bại giữa PC4 và PC3.  

<a name="tailieuthamkhao"></a>

# Tài liệu tham khảo
- https://docs.gns3.com/
- https://docs.gns3.com/1FFbs5hOBbx8O855KxLetlCwlbymTN8L1zXXQzCqfmy4/index.html
- https://docs.gns3.com/11YYG4NQlPSl31YwvVvBS9RAsOLSYv0Ocy-uG2K8ytIY/index.html  
- https://docs.gns3.com/1Bn-s1Izkjp13HxcPF4b8QSGfkWJYG_dpMt9U1DQjvZ4/index.html
- https://github.com/GNS3/gns3-gui/releases
- http://docs.gns3.com/1wdfvS-OlFfOf7HWZoSXMbG58C4pMSy7vKJFiKKVResc/
- https://en.wikipedia.org/wiki/Dynamips
- http://www.careercert.info/2009/05/new-cisco-ios-version-124-collection.html
- https://drive.google.com/drive/u/0/folders/0B6VuDLpyDgnHMWhBNXlWQjFIcXM
- https://github.com/hocchudong/thuctap032016/blob/master/ThaiPH/CiscoNetworkLab/ThaiPH_gns3_network_bonding.md









