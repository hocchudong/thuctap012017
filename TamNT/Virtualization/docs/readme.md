# 1. Tìm hiểu về ảo hóa KVM

- [ Tìm hiểu tổng quan về ảo hóa KVM, cách cài đặt và một số tính năng của KVM.](./KVM/1.Tim_hieu_KVM.md)

- [ Tìm hiểu một số công cụ quản lý KVM: Virt-manager, WebVirtMgr, `virt - virsh` tool command.](./KVM/2.Cong_cu_quan_ly_KVM.md)

- [ Attach interface vào VM đang chạy.](./KVM/9.Attack_interface_to_running_VM.md)

# 2. Tìm hiểu các chế độ mạng ảo trong Libvirt

[Tìm hiểu một số chế động mạng được tạo và quản lý bởi Libvirt](./Virtual_network_in_Libvirtmd#1)

- [Bridged network](./Virtual_network_in_Libvirtmd#2)

- [Routed network](./Virtual_network_in_Libvirtmd#3)

- [NAT-based network](./Virtual_network_in_Libvirtmd#4)

- [Isolated network](./Virtual_network_in_Libvirtmd#5)


# 3. Tìm hiểu các virtual switch 

## 3.1. Linux Bridge

### Lý thuyết

- [Tìm hiểu tổng quan Linux Bridge.](./Virtual_Switch/1.Linux-Bridge.md#1)

- [Các thao tác quản lý Linux bridge](./Virtual_Switch/1.Linux-Bridge.md#3)

- [Một số ghi chép về Linux Bridge](./Virtual_Switch/1.Linux-Bridge.md#4)

### Lab cơ bản

- [Lab basic với Linux bridge](./Virtual_Switch/1.Linux-Bridge.md#5)



## 3.2. Open vSwitch

### Lý thuyết

- [Tìm hiểu tổng quan Openvswitch, các thành phần và tính năng của nó](./Virtual_Switch/2.Tim_hieu_Open_Vswitch.md#1)

- [Một số thao tác sử dụng và quản lý Openvswitch](./Virtual_Switch/2.Tim_hieu_Open_Vswitch.md#2)

    - [Sử dụng câu lệnh `ovs-vsctl`](./Virtual_Switch/2.Tim_hieu_Open_Vswitch.md#2.1)

    - [Định nghĩa các thành phần của Openvswitch trong file /etc/network/interfaces](./Virtual_Switch/2.Tim_hieu_Open_Vswitch.md#2.2)

- [Một số ghi chép về OpenvSwitch](./Virtual_Switch/2.Tim_hieu_Open_Vswitch.md#3)

    - [Cấu trúc OpenVswitch](./Virtual_Switch/8.Cau_truc_OVS.md)

### LAB với Openvswitch

- [ Thực hành lab Vlan với Openvswitch](./Virtual_Switch/3.LAB-VLAN-OVS-KVM.md)

- [Lab VXLAN với Openvswitch](./Virtual_Switch/5.LAB-VXLAN-OVS-KVM.md)

- [Lab GRE với OpenvSwitch](./6.Tim_hieu_GRE.md#2)

- [Lab Linux network namespace với Openvswitch](./7.Linux_network_namespace.md#2)

- [Cấu hình mirror port với Openvswitch](./Virtual_Switch/Cau_hinh_mirror_port.md)

# 4. Tìm hiểu một số virtual network

## 4.1. VXLAN

- [Tìm hiểu VXLAN](./4.Tim_hieu_VXLAN.md)

    - [Tìm hiểu VXLAN là gì? và các khái niệm trong VXLAN](./4.Tim_hieu_VXLAN.md#2)

    - [Cách thức hoạt động trong VXLAN](./4.Tim_hieu_VXLAN.md#2)

## 4.2. GRE

- [Tìm hiểu GRE](./6.Tim_hieu_GRE.md)

	- [GRE là gì? Cách hoạt động của GRE và GRE frame format](./6.Tim_hieu_GRE.md#1)
	
	- [LAB tính năng của GRE tạo tunnel cho các VLAN sử dung OpenvSwitch](./6.Tim_hieu_GRE.md#2)
	
## 4.3. Linux network namespace

- [Tìm hiểu Linux network namespace là gì?](./7.Linux_network_namespace.md#1)

    - [Một số thao tác quản lý network namespace](./7.Linux_network_namespace.md#1.2)

- [Lab một số tính năng của network namespace](./7.Linux_network_namespace.md#2)

    - [Kết nối 2 namespace sử dụng Openvswitch](./7.Linux_network_namespace.md#2.1)

    - [Cấu hình cấp DHCP cho 2 namespace khác nhau](./7.Linux_network_namespace.md#2.2)