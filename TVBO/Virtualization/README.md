# Báo cáo: Tìm hiểu, cài đặt và sử dụng KVM

# Mục lục

- [Giới thiệu về KVM](#about)
- [Cài đặt KVM](QEMU-KVM/Installation.md)
- [Cấu hình mạng briding](QEMU-KVM/Networking.md)
- [Tạo một máy ảo kvm](QEMU-KVM/Guest-creation.md)
- [Quản lý các máy ảo kvm](QEMU-KVM/Guest-management.md)
- [Truy cập, sử dụng các máy ảo](QEMU-KVM/Guest-console-access.md)




___

# Nội dung

- ## <a name="#about">Giới thiệu về KVM</a>

	+ KVM (Kernel-based Virtual Machine) là một công nghệ ảo hóa cho nền tảng phần cứng được cung cấp riêng tài nguyên để sử dụng tránh việc tranh chấp tài nguyên sử dụng trên máy chủ gốc cài đặt Linux. Đây là một công nghệ ảo hóa mặc định được hỗ trợ trong Ubuntu
	
	+ KVM yêu cầu các phần mở rộng ảo được tích hợp trong phần cứng của Intel hoặc AMD. QEMU là một giải pháp phổ biến cho phần cứng không có hỗ trợ phần mở rộng ảo hóa. Nói cách khác, QEMU là một giải pháp tạo ra môi trường giả lập cho phép KVM ảo hóa toàn phần.