# Tìm hiểu về KVM

## Mục lục
[1. Giới thiệu chung về KVM](#1)

[2. KVM Stack](#2)

[3. Kiến trúc của KVM](#3)

[4. Luồng hoạt động của mô hình KVM ](#4)

<a name ="1"></a>

## 1. Giới thiệu chung về KVM

-KVM (Kernel-based virtual machine) là giải pháp ảo hóa cho hệ thống Linux trên nền tảng phần cứng x86 có các mở rộng hỗ trợ ảo hóa (Intel VT-x hoặc AMD-V)

-KVM ra đời phiên bản đầu tiên vào năm 2007 bởi công ty Qumranet tại Isarel, KVM được tích hợp sẵn vào nhân của hệ điều hành Linux bắt đầu từ phiên bản 2.6.20. Năm 2008, RedHat đã mua lại Qumranet và bắt đầu phát triển, phổ biến KVM Hypervisor.

-KVM đi liền với QEMU. QEMU là 1 hyperviosr hoàn chỉnh thuộc loại 2 có khả năng giả lập tài nguyên phần cững, trong đó bao gồm 1 CPU ảo

<img src="http://i.imgur.com/jVIHt1s.png" >


<img src="http://i.imgur.com/v4eU5wK.png" >


-Một số đặc điểm của KVM:

     -Là giải pháp ảo hóa dạng toàn phần và hoàn toàn nguồn mở, miễn phí.

     -Hỗ trợ các loại công nghệ phần cứng đa dạng và thông dụng như Intel-VT, AMD-V

     -Cung cấp các máy ảo đa dạng, hỗ trợ nhiều loại hệ điều hành và không cần tinh chỉnh lại các ảnh của hệ điều hành

     -Sử dụng cơ chế quản lý vùng nhớ của Linux (KSM) và các cơ chế bảo mật có sẵn của Linux (SELinux)

-Với ưu điểm nguồn mở và độ tùy biến cao, KVM hypervisor được lựa chọn là nền tảng ảo hóa chính khi lựa chọn công nghệ ảo hóa nguồn mở. KVM cũng đồng thời là nền tảng của giải pháp điện toán đám mây nguồn mở nổi tiếng nhất hiện nay là OpenStack.

<a name ="2"></a>

## 2. KVM Stack

-KVM Stack bao gồm 4 tầng:

<img src="http://i.imgur.com/rq3IFd9.png" >


     -Tầng User-facing tools: là các công cụ quản lý máy ảo hỗ trợ KVM. Các công cụ có giao diện đồ họa như virt-manager hay công có giao diện dòng lệnh như virsh

     -Tầng Management layer: là thư viện libivrt cung cấp API để các công cụ quản lý máy ảo hay hypervisor tương tác với KVM để thực hiện các thao tác quản lý tài nguyên ảo hóa, vì tự thân KVM không hề có khả năng giả lập tài nguyên như vậy.

     -Tầng Virtual machine: chính là các máy ảo mà người dùng tạo ra.

     -Tầng Kernel support: cung cấp 1 module làm hạt nhân cho hạ tầng ảo hóa mà 1 module đặc biệt hỗ trợ các vi xử lý VT-X và AMD-V


<a name ="3"></a>

## 3. Kiến trúc của KVM 

### 3.1 Về tính bảo mật

-Trong kiến trúc KVM, máy ảo được xem như các tiến trình Linux thông thường, nhờ đó nó tận dụng được mô hình bảo mật của hệ thống Linux như SELinux, cung cấp khả năng cô lập và kiểm soát tài nguyên

-SVirt project - dự án cung cấp giải pháp bảo mật MAC (Mandatory Access Control - Kiểm soát truy cập bắt buộc) tích hợp với hệ thống ảo hóa sử dụng SELinux để cung cấp một cơ sở hạ tầng cho phép người quản trị định nghĩa nên các chính sách để cô lập các máy ảo.

### 3.2 Về việc quản lý vùng nhớ

-KVM thừa kế tính năng quản lý bộ nhớ mạnh mẽ của Linux. Vùng nhớ của máy ảo được lưu trữ trên cùng một vùng nhớ dành cho các tiến trình Linux khác và có thể swap. KVM hỗ trợ NUMA (Non-Uniform Memory Access - bộ nhớ thiết kế cho hệ thống đa xử lý) cho phép tận dụng hiệu quả vùng nhớ kích thước lớn. 

### 3.3 Về mặt lưu trữ

-KVM có khả năng sử dụng bất kỳ giải pháp lưu trữ nào hỗ trợ bởi Linux để lưu trữ các Images của các máy ảo, bao gồm các ổ cục bộ như IDE, SCSI và SATA, Network Attached Storage (NAS) bao gồm NFS và SAMBA/CIFS, hoặc SAN thông qua các giao thức iSCSI và Fibre Channel. 

-KVM cũng hỗ trợ các images của các máy ảo trên hệ thống tệp tin chia sẻ như GFS2 cho phép các images có thể được chia sẻ giữa nhiều host hoặc chia sẻ chung giữa các ổ logic. 

### 3.4 Về mặt hiệu năng

-KVM kế thừa hiệu năng và khả năng mở rộng của Linux, hỗ trợ máy ảo với 16 CPUs ảo, 256GB RAM và hệ thống máy host lên tới 256 cores và trên 1TB RAM. 

### 3.5 Về mặt khả năng tương thích với các môi trường

-KVM hỗ trợ live migration cung cấp khả năng di chuyển ác máy ảo đang chạy giữa các host vật lý mà không làm gián đoạn dịch vụ. Khả năng live migration là trong suốt với người dùng, các máy ảo vẫn duy trì trạng thái bật, kết nối mạng vẫn đảm bảo và các ứng dụng của người dùng vẫn tiếp tục duy trì trong khi máy ảo được đưa sang một host vật lý mới. KVM cũng cho phép lưu lại trạng thái hiện tại của máy ảo để cho phép lưu trữ và khôi phục trạng thái đó vào lần sử dụng tiếp theo. 

<a name="4"></a>

## 4. Luồng hoạt động của mô hình KVM 

<img src="http://i.imgur.com/zFLSCq9.png" >

<img src="http://i.imgur.com/hdNg06X.png" >

## Tài liệu tham khảo:

http://blogit.edu.vn/gioi-thieu-ao-hoa-va-ao-hoa-ma-nguon-kvm-hypervisor/

https://github.com/hocchudong/thuctap032016/blob/master/ThaiPH/KVM/ThaiPH_timhieuKVM.md

https://vi.scribd.com/document/208116796/KVM-Architecture-LK2010