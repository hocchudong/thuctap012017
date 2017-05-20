# Project Update - Keystone

### 1. Openstack Identity là gì?
- Keystone Project là dịch vụ chia sẻ xác thực, ủy quyền, và kiểm toán.
- Và chịu trách nhiệm tạo các user, các user này được xác định có quyền truy cập vào tài nguyên cloud nhất định. Sau này họ sẽ nó cho keystone biết rằng họ có quyền truy cập vào tài nguyên cloud và thực hiện những gì mà họ muốn (muốn trong những quyền của họ) và để lại một audit trail (dấu vết để kiểm toán) cho các công cụ quản lý an toàn (security managers) rà soát lại.
- Là trung gian giữa Openstack và các dịch vụ xác thực khác (LDAP hay các identity provider khác)
- Chiếm 98% số người dùng Openstack sử dụng Keystone trong mô hình triển khai của họ (Keystone đóng vai trò quan trọng trong việc triển khai Openstack)

### 2. Những gì đã hoàn thành được trong OCATA:

- Giải quyết được vấn đề với các thao tác chiếm nhiều thời gian: Các nhà điều hành cần thực hiện một số thao tác cần nhiều thời gian mà có thể liên quan đến giao tiếp giữa các dịch vụ. Và trong quá trình thực hiện thì token có thể bị hết hạn, đây là nguyên nhân toàn bộ thao tác bị gián đoạn. Mọi người giải quyết vấn đề này bằng cách tăng thời gian tồn tại cho token nhưng cách làm này không hoàn toàn có hiệu quả và bản thân cách giải quyết này kém an toàn.
- Phiên bản Ocata đã giải quyết vấn đề này dễ dàng hơn. Nó cho phép các dịch vụ hiện tại sử dụng token đã hết hạn kết hợp với các dịch vụ khác liên kết với một dịch vụ token đặc biệt. Theo cách này, nếu người dùng bắt đầu công việc với 1 token hợp lệ thì họ có thể hoàn thành công việc đó với cùng một token.
- Một trong những thay đổi lớn trong đợt này là sử dụng fernet-token là định dạng mặc định. Định dạng cũ UUID là một chuỗi ngẫu nhiên và được lưu trong database. Khi có yêu cầu cần xác nhận token thì phải đọc từ database để kiểm tra. Fernet đã được giới thiệu trong phiên bản Kilo và đó là một định dạng không bền và không sử dụng database. Sử dụng fernet-token yêu cần phải thiết lập thêm một chút. 
- Xử lý thông minh hơn với thu hồi token, xác minh token, làm giảm lưu lượng đến keystone.
- Cải thiện khả năng sử dụng tính năng PCI DSS:
	- Mở rộng các thông báo về sự kiện PCI DSS về các lý do như: người dùng đã không đổi password sau một số ngày nhất định, user sẽ bị khóa sau bao nhiêu lần xác thực không thành công, sử dụng lại một mật khẩu gần đây đã được sử dụng, password không đạt một số tiêu chí theo yêu cầu hoặc người dùng thay đổi mật khấu quá thường xuyên. (Xem chi tiết [tại đây](https://docs.openstack.org/developer/keystone/event_notifications.html))
	- Tạo ra một API cho các yêu cầu phức tạp về mật khẩu, cũng như để làm một số công việc xác thực mà từ phía khách hàng muốn.
	- API cho phép công cụ dành cho quản trị viên truy vấn `password_expires_at` để giúp xác định người dùng có mật khẩu hoặc mật khẩu đã hết hạn sắp hết hạn để họ có thể giúp thông báo cho người dùng.
	- Thêm tính năng yêu cầu người dùng thay đổi mật khẩu sau lần đầu sử dụng cho người dùng mới hoặc sau khi password của admin thay đổi.
	- Xác thực đa yếu tố. Bây giờ chúng ta có khả năng tăng cường bảo mật tài khoản người dùng bằng cách ghi lại yêu cầu mỗi người dựa trên nhiều cơ chế xác thực.
	- Thực hiện liên kết giữa người dùng và project thông qua các roles. Nâng cao các quy tắc mapping giữa user và project.
	- Sử dụng API v3 mặc định.

### 3. Những điều đạt được trong Openstack Pike
- Đăng ký rule trong file policy mặc định:
	- Thực hiện việc đăng kí (registering) và sử dụng các rule mặc định trong policy. Các rule được định nghĩa trong các policy mới và được trả về trong file code list__init__.py . Các policy mặc định có thể được duy trì trong code và được đăng ký thông qua cơ chế liệt kê trong các module policy. Do đó mà chúng ta có thể xóa các file định nghĩa rule mặc định và thay vào đó sử dụng các file policy do chúng ta định nghĩa ra.
	- Có thể tạo ra các file policy để định nghĩa các rule dựa trên file policy mặc định.
- Inified limit - Thống nhất phạm vi hạn chế truy cập của user trên các project khác nhau.
- Project tags - Thêm khái niệm tag nên nếu như đã sử dụng Nova, Neutron hay các resource tags thì cũng giống như làm việc với project.
- Federated intergration testing - Thử nghiệm tích hợp Federated.
- Integrating rolling upgrade test: ...

### 4. Looking ahead to Queens and Rockey
- well-defined roles by default: Cung cấp các tiêu chuẩn về các role mặc định.
- improving policy security- Cải thiện khả năng bảo mật policy...
- hierarchical limits and qoutas
- API keys: cô lập sự xác thực từ dịch vụ identity, bảo mật hơn cho người dùng (user không cần cấu hình pasword trong file cấu hình...)
- Native SAML support
- Account linking : Liên kết các tài khoản được xác thực thông qua nhiều backend khác nhau (LDAP, SQL, Federated...) mà không phải lưu trữ các bản sao của một người dùng.
- Tiếp tục integrating testing (thử nghiệm tích hợp các công nghệ khác vào Keystone)
---
**source video**: https://www.openstack.org/videos/boston-2017/project-update-keystone