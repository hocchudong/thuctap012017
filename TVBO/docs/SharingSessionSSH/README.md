# Báo cáo: Tìm hiểu vể Teleport v2.0


___

# Mục lục

- [Giới thiệu về Teleport](#about)
- Quickstart
	- [Cài đặt và sử dụng](gravitational/installation.md)
	- [Tạo người sử dụng](gravitational/create-user.md)
	- [Thêm một Node mới vào Cluster](gravitational/add-nodes.md#add-nodes)
	- [Tạo label cho Node](gravitational/add-nodes.md#add-label)
	- [Chia sẻ phiên đăng nhập SSH](gravitational/sharing-ssh)
	- [Teleconsole](gravitational/teleconsole.md)
- Kiến trúc của Teleport
	> Sẽ cập nhật sau
- Hướng dẫn dành cho user
	> Sẽ cập nhật sau
- Hướng dẫn dành cho admin
	> Sẽ cập nhật sau



___

# Nội dung

- # <a name="#about">Giới thiệu về Teleport v2.0</a>

	+ Teleport là một công cụ cho phép tạo và quản lý các phiên đăng nhập sử dụng ssh. Hỗ trợ xác thực 2 bước sử dụng api của Google Authencators.

	+ Với teleport, bạn có thể đồng bộ các hoạt động trên console giữa client và server dựa trên real time. Tức là mọi hoạt động được thực hiện trên một trong hai máy sẽ được đồng bộ và hiển thị ngay lập tức đến máy còn lại. Điều này rất là hữu ích khi mà bạn làm việc nhóm và nhờ ai đó giúp bạn làm thực hiện một công việc nào đó mà bạn muốn thấy được cách mà họ làm.

	+ Teleport cho phép ghi lại mọi hoạt động đã thực hiện trên phiên ssh đó để dễ dàng có thể xem lại qua web hoặc console của máy server quản lý các phiên đăng nhập với tài khoản root. Cho phép nhanh chóng thực hiện remote tới server hoặc client trong cluster thông qua web hoặc console sử dụng token. Mỗi token này có thời gian tồn tại tối đa 30 phút kể từ khi được tạo ra cho đến khi bạn thực hiện đăng nhập sử dụng nó.

	+ Ngoài ra, teleport còn có nhiều chức năng khác mà sẽ được đề cập đến trong các nội dung sau. Phía dưới chính là một chức năng nhỏ của teleport mà bạn có thể dàng nhận ra khi mới đầu làm quen và sử dụng nó.
		> [![Teleport Features](images/Teleport/Quickstart/ScreenShot.png)](https://www.youtube.com/watch?v=bprRpX-4R_0)
	
	+ Tóm lại, Teleport có chức năng tương tự như TeamView của Windows với Teleconsole
___

# Nội dung liên quan

- Quickstart
	- [Cài đặt và sử dụng](gravitational/installation.md)
	- [Tạo người sử dụng](gravitational/create-user.md)
	- [Thêm một Node mới vào Cluster](gravitational/add-nodes.md#add-nodes)
	- [Tạo label cho Node](gravitational/add-nodes.md#add-label)
	- [Chia sẻ phiên đăng nhập SSH](gravitational/sharing-ssh)
	- [Teleconsole](gravitational/teleconsole.md)
- Kiến trúc của Teleport
	> Sẽ cập nhật sau
- Hướng dẫn dành cho user
	> Sẽ cập nhật sau
- Hướng dẫn dành cho admin
	> Sẽ cập nhật sau