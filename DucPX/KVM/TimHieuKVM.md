# Tổng quan về KVM (Kernel-based Virtual Machine)

## [1. Giới thiệu KVM](#1)

## [2. Kiến trúc KVM](#2)

## [3. KVM và QEMU](#3)

<a name=1></a>
### 1. Giới thiệu KVM
- KVM (Kernel-based virtual machine) là giải pháp ảo hóa cho hệ thống linux trên nền tảng phần cứng x86 có các module mở rộng hỗ trợ ảo hóa (Intel VT-x hoặc AMD-V).
- KVM hỗ trợ cài đặt các hệ điều hành khác nhau mà không cần phụ thuộc vào hệ điều hành của máy chủ vật lý.

<a name=2></a>
### 2. Kiến trúc KVM
#### KVM trong Linux

![Imgur](http://i.imgur.com/wZEjAel.png)

- Khi sử dụng KVM, máy ảo sẽ chạy như một tiến trình trên máy chủ Linux.
- Các CPU ảo (Virtual CPUs) được xem như các tiến trình bình thường khác và được xử lý theo lập lịch của Linux.

#### Kiến trúc stack của KVM

![Imgur](http://i.imgur.com/k7yZSE7.png)

- **User-facing tools**: Là các công cụ quản lý máy ảo hỗ trợ KVM. Các công cụ có giao diện đồ họa (như virt-manager) hoặc giao diện dòng lệnh như (virsh)
- **Management layer**: Lớp này là thư viện **libvirt** cung cấp API để các công cụ quản lý máy ảo hoặc các hypervisor tương tác với KVM thực hiện các thao tác quản lý tài nguyên ảo hóa, vì tự thân KVM không hề có khả năng giả lập và quản lý tài nguyên như vậy.
- **Virtual machine**: Chính là các máy ảo người dùng tạo ra. Thông thường, nếu không sử dụng các công cụ như virsh hay virt-manager, KVM sẽ sử được sử dụng phối hợp với một hypervisor khác điển hình là QEMU.
- **Kernel support**: Chính là KVM, cung cấp một module làm hạt nhân cho hạ tầng ảo hóa (kvm.ko) và một module kernel đặc biệt hỗ trợ các vi xử lý VT-x hoặc AMD-V (kvm-intel.ko hoặc kvm-amd.ko)

<a name=3></a>
### 3. KVM và QEMU

![Imgur](http://i.imgur.com/ixR3iTM.png)

- QEMU đã là một hypervisor hoàn chỉnh. QEMU có khả năng giả lập tài nguyên phần cứng, trong đó bao gồm một CPU ảo. Các chỉ dẫn của hệ điều hành tác động lên CPU ảo này sẽ được QEMU chuyển đổi thành chỉ dẫn lên CPU vật lý nhờ một **translator** là **TCG(Tiny Core Generator)**. Tuy nhiên các bộ dịch này hiệu suất không lớn. 
- Do KVM hỗ trợ ánh xạ CPU vật lý sang CPU ảo, cung cấp khả năng tăng tốc phần cứng cho máy ảo và hiệu suất của nó nên QEMU sử dụng KVM làm **accelerator** tận dụng tính năng này của KVM thay vì sử dụng TCG.
- Như vậy chúng ta có thể thấy KVM thực chất là một module được sử dụng kết hợp với một hypervisor là QEMU.

