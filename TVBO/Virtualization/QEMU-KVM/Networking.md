# Cấu hình Networking trong KVM

# Mục lục

- [Usermode Networking](#usermode-networking)
- [Bridged Networking](#bridging-networking)
- [Private Virtual Switch](#pvs)

# Nội dung

- Có 2 cách khác nhau để cho phép một máy ảo truy cập ra mạng phía bên ngoài:
	
	+ Sử dụng cấu hình mạng ảo mặc định được biết đến như với tên gọi "Usermode Networking". NAT sẽ được thực hiện để đưa dữ liệu thông qua host interface tới mạng bên ngoài.

	+ Sử dụng cấu hình "Bridged Networking" để cho phép các host ảo trực tiếp truy cập các dịch vụ trên hệ điều hành máy chủ.


- Usermode Networking


# Nội dung khác

- [Giới thiệu về KVM](../README.md#about)
- [Cài đặt KVM](Installation.md)
- [Tạo một máy ảo kvm](Guest-creation.md)
- [Quản lý các máy ảo kvm](Guest-management.md)
- [Truy cập, sử dụng các máy ảo](Guest-console-access.md)