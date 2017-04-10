# KVM basic


# MỤC LỤC
- [1.Khái niệm](#1)
- [2.KVM Stack](#2)
- [3.KVM - QEMU](#3)
- [4.Các tính năng của KVM](#4)
  - [4.1. Security](#4.1)
  - [4.2. Memory Management](#4.2)
  - [4.3. Storage](#4.3)
  - [4.4. Live migration]()
  - [4.5. Performance and scalability](#4.4)
- [5.Install KVM on Ubuntu Server 16.04](#5)
- [6.Directory KVM+QEMU VM on Ubuntu Server 16.04](#6)
  - [6.1. Configuration directory](#6.1)
  - [6.2.Storage pools](#6.2)
- [7. Note](#7)
  - [7.1. KVM + LinuxBridge,Openvswitch + Libvirt](#7.1)
  - [7.2.Image Cirros](#7.2)
  - [7.3.File log KVM](#7.3)


<a name="1"></a>
# 1.Khái niệm
\- KVM (Kernel-based virtual machine) là giải pháp ảo hóa cho hệ thống linux trên nền tảng phần cứng x86 có các module mở rộng hỗ trợ ảo hóa (Intel VT-x hoặc AMD-V).  
\- Về bản chất, KVM không thực sự là một hypervisor có chức năng giả lập phần cứng để chạy các máy ảo. Chính xác KVM chỉ là một module của kernel linux hỗ trợ cơ chế mapping các chỉ dẫn trên CPU ảo (của guest VM) sang chỉ dẫn trên CPU vật lý (của máy chủ chứa VM). Hoặc có thể hình dung KVM giống như một driver cho hypervisor để sử dụng được tính năng ảo hóa của các vi xử lý như Intel VT-x hay AMD-V, mục tiêu là tăng hiệu suất cho guest VM.  

<a name="2"></a>
# 2.KVM Stack

<img src="http://i.imgur.com/EFzCHAE.png" >  

\- Trên đây là KVM Stack bao gồm 4 tầng:  
- User-facing tools: Là các công cụ quản lý máy ảo hỗ trợ KVM. Các công cụ có giao diện đồ họa (như virt-manager) hoặc giao diện dòng lệnh như (virsh).  
- Management layer: Lớp này là thư viện libvirt cung cấp API để các công cụ quản lý máy ảo hoặc các hypervisor tương tác với KVM thực hiện các thao tác quản lý tài nguyên ảo hóa, vì tự thân KVM không hề có khả năng giả lập và quản lý tài nguyên như vậy.  
<img src="http://i.imgur.com/jnKpAyY.png" >  

- Virtual machine: Chính là các máy ảo người dùng tạo ra. Thông thường, nếu không sử dụng các công cụ như virsh hayvirt-manager, KVM sẽ sử được sử dụng phối hợp với một hypervisor khác điển hình là QEMU.
- Kernel support: Chính là KVM, cung cấp một module làm hạt nhân cho hạ tầng ảo hóa (kvm.ko) và một module kernel đặc biệt hỗ trợ các vi xử lý VT-x hoặc AMD-V (kvm-intel.ko hoặc kvm-amd.ko)

<a name="3"></a>
# 3.KVM - QEMU
\- Hệ thống ảo hóa KVM hay đi liền với QEMU. Về mặt bản chất, QEMU là một emulator. QEMU có khả năng giả lập tài nguyên phần cứng, trong đó bao gồm một CPU ảo. Các chỉ dẫn của hệ điều hành tác động lên CPU ảo này sẽ được QEMU chuyển đổi thành chỉ dẫn lên CPU vật lý nhờ một translator là TCG(Tiny Core Generator) nhưng TCG hiệu suất ko cao.  
\- Do KVM hỗ trợ ánh xạ CPU vật lý sang CPU ảo, cung cấp khả năng tăng tốc phần cứng cho máy ảo và hiệu suất của nó nên QEMU sử dụng KVM làm accelerator tận dụng tính năng này của KVM thay vì sử dụng TCG.  

<a name="4"></a>
# 4.Các tính năng của KVM

<a name="4.1"></a>
## 4.1. Security
<img src="http://i.imgur.com/91GVgMM.png" >  

\- Trong kiến trúc KVM, máy ảo được xem như các tiến trình Linux thông thường, nhờ đó nó tận dụng được mô hình bảo mật của hệ thống Linux như SELinux, cung cấp khả năng cô lập và kiểm soát tài nguyên.  
\- Bên cạnh đó còn có SVirt project - dự án cung cấp giải pháp bảo mật MAC (Mandatory Access Control - Kiểm soát truy cập bắt buộc) tích hợp với hệ thống ảo hóa sử dụng SELinux để cung cấp một cơ sở hạ tầng cho phép người quản trị định nghĩa nên các chính sách để cô lập các máy ảo. Nghĩa là SVirt sẽ đảm bảo rằng các tài nguyên của máy ảo không thể bị truy cập bởi bất kì các tiến trình nào khác; việc này cũng có thể thay đổi bởi người quản trị hệ thống để đặt ra quyền hạn đặc biệt, nhóm các máy ảo với nhau chia sẻ chung tài nguyên.  

<a name="4.2"></a>
## 4.2. Memory Management
\- KVM thừa kế tính năng quản lý bộ nhớ mạnh mẽ của Linux. Vùng nhớ của máy ảo được lưu trữ trên cùng một vùng nhớ dành cho các tiến trình Linux khác và có thể swap. KVM hỗ trợ NUMA (Non-Uniform Memory Access - bộ nhớ thiết kế cho hệ thống đa xử lý) cho phép tận dụng hiệu quả vùng nhớ kích thước lớn.  
\- KVM hỗ trợ các tính năng ảo của mới nhất từ các nhà cung cấp CPU như EPT (Extended Page Table) của Microsoft, Rapid Virtualization Indexing (RVI) của AMD để giảm thiểu mức độ sử dụng CPU và cho thông lượng cao hơn.  
\- KVM cũng hỗ trợ tính năng Memory page sharing bằng cách sử dụng tính năng của kernel là Kernel Same-page Merging (KSM).  

<a name="4.3"></a>
## 4.3. Storage
\- KVM có khả năng sử dụng bất kỳ giải pháp lưu trữ nào hỗ trợ bởi Linux để lưu trữ các Images của các máy ảo, bao gồm các ổ cục bộ như IDE, SCSI và SATA, Network Attached Storage (NAS) bao gồm NFS và SAMBA/CIFS, hoặc SAN thông qua các giao thức iSCSI và Fibre Channel.  
\- KVM tận dụng được các hệ thống lưu trữ tin cậy từ các nhà cung cấp hàng đầu trong lĩnh vực Storage.  
\- KVM cũng hỗ trợ các images của các máy ảo trên hệ thống tệp tin chia sẻ như GFS2 cho phép các images có thể được chia sẻ giữa nhiều host hoặc chia sẻ chung giữa các ổ logic.  

<a name="4.4"></a>
## 4.4. Live migration
\- KVM hỗ trợ live migration cung cấp khả năng di chuyển ác máy ảo đang chạy giữa các host vật lý mà không làm gián đoạn dịch vụ. Khả năng live migration là trong suốt với người dùng, các máy ảo vẫn duy trì trạng thái bật, kết nối mạng vẫn đảm bảo và các ứng dụng của người dùng vẫn tiếp tục duy trì trong khi máy ảo được đưa sang một host vật lý mới. KVM cũng cho phép lưu lại trạng thái hiện tại của máy ảo để cho phép lưu trữ và khôi phục trạng thái đó vào lần sử dụng tiếp theo.  

<a name="4.5"></a>
## 4.5. Performance and scalability
\- KVM kế thừa hiệu năng và khả năng mở rộng của Linux, hỗ trợ máy ảo với 16 CPUs ảo, 256GB RAM và hệ thống máy host lên tới 256 cores và trên 1TB RAM.  

<a name="5"></a>
# 5.Install KVM on Ubuntu Server 16.04
\- Trước khi bạn tiến hành cài đặt bạn phải xác nhận rằng hệ thống của bạn hỗ trợ KVM. Như đã đề cập trước đó, nó yêu cầu hỗ trợ ảo hóa phần cứng trong CPU. Gõ lệnh sau để kiểm tra khả năng tương thích:  
```
egrep -c '(vmx|svm)' /proc/cpuinfo  
```

Nếu đầu ra là 0, sau đó KVM sẽ không hoạt động như hệ thống không hỗ trợ VMX cũng không SVM ảo hóa phần cứng. Nếu đầu ra là 1 hoặc lớn hơn 1 có nghĩa là hệ thống của bạn là tất cả các thiết lập và sẵn sàng để đi để cài đặt KVM.
Nếu bạn dùng VMWare Workstation có thể kích hoạt chức năng support virtualization tại :

<img src="http://i.imgur.com/V3LR8MC.png" >  

\- Cài đặt KVM với command line :  
```
sudo apt-get install qemu-kvm 
```

<a name="6"></a>
# 6.Directory KVM+QEMU VM on Ubuntu Server 16.04

<a name="6.1"></a>
## 6.1. Configuration directory
\- Path directory :  
```
/etc/libvirt/qemu
```

<a name="6.2"></a>
## 6.2.Storage pools 
\- Chúng ta cần tạo pool chứa VM.  
\- Defualt pool :  
```
/var/lib/libvirt/images
```

<a name="7"></a>
# 7. Note

<a name="7.1"></a>
## 7.1. KVM + LinuxBridge,Openvswitch + Libvirt
Với các công nghệ :  
- VM : Dùng KVM
- Virtual Switch : Dùng LinuxBridge or Openvswitch
- Virtual Network : Dùng Libvirt

<a name="7.2"></a>
## 7.2.Image Cirros
Cirros là image rút gọn của Ubuntu Server nên tập lệnh khá hạn chế . Bạn nên chú ý 1 số điều sau :  
- Cirros chỉ dhcp cho card mặc định eth0 , còn các card # phải cấu hình tĩnh .
- Chỉ dùng được 1 số lệnh như : `poweroff` , `reboot` , `ifdown –a` , `ifup –a` , `ifconfig`  .

<a name="7.3"></a>
## 7.3.File log KVM
\- On Ubuntu Server 16.04 :  
Thư mục :  
```
/var/log/libvirt/qemu
```












