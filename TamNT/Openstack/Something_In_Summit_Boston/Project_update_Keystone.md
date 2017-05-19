# Project Keystone Update

## 1) What is Openstack Identity

- Là dịch vụ quản lý và chia sẻ sự xác thực, ủy quyền của user và các service tới các thành phần trong Openstack

- CUng cấp thông tin định danh cho user và service 

- Là trung gian giữa Openstack và các dịch vụ xác thực khác (LDAP hay các identity provider khác)

- Chiếm 98% số người dùng Openstack sử dụng Keystone trong mô hình triển khai của họ (Keystone đóng vai trò quan trọng trong việc triển khai Openstack)


## 2) Những việc đã đạt được trong phiên bản Openstack Ocata

- Giải quyết vấn đề với các thao tác chiếm nhiều thời gian: khi thực hiện các thao tác mất nhiều thời gian, sự liên hệ giữa các dịch vụ có thể bị gián đoạn làm cho các thao tác đó bị ngừng do token hết hạn. Mọi người có thể giải quyết bằng cách tăng thêm thời gian hoạt động của token nhưng điều này chưa hoàn toàn làm việc hiệu quả và đôi khi còn tiềm ẩn nguy cơ liên quan tới bảo mật. Do đó, từ Ocata, Keystone và các dịch vụ cho phép người dùng thực hiện xong thao tác với token đã hết hạn kết hợp với một dịch vụ token đặc biệt và khi đó, người dùng có thể bắt đầu một công việc với một token có hiệu lực và kết thúc công việc  với cùng  token dù nó đã hết hạn hay chưa. 

- Fernet trở thành token mặc định của Keystone (Góp phần làm giảm tải tới database; được giới thiệu từ summit Austin, nhận được phản hồi tốt từ người sử dụng nên đã đưa trở thành token mặc định)

- Xử lý thông minh hơn token revocation (cắt giảm sự trả về token revocation, làm giảm lưu lượng truy cập xác thực token tới keystone => nâng cao hiệu suất hoạt động của Keystone)

- Nâng cấp khả năng sử dụng tính năng bảo mật  PCI DSS:

  - Mở rộng các thông báo về sự kiện PCI DSS về các lý do như: người dùng đã không đổi password sau một số ngày nhất định, user sẽ bị khóa sau bao nhiêu lần xác thực không thành công, sử dụng lại một mật khẩu gần đây đã được sử dụng, password không đạt một số tiêu chí theo yêu cầu hoặc người dùng thay đổi mật khấu quá thường xuyên. (Xem chi tiết [tại đây](https://docs.openstack.org/developer/keystone/event_notifications.html))

  - Thêm một API mới để lấy quy chuẩn chính thức cho password với khả năng linh hoạt hơn có thể truyền tải thông tin về yêu cầu password tới người dùng

  - Thêm truy vấn  `password_expires_at` để giúp lọc ra các user có password hết hạn vào thời gian nào đó (so sánh với timestamp) 

  - Thêm tính năng yêu cầu người dùng ngay lập tức thay đổi mật khẩu sau lần đầu sử dụng cho người dùng mới hoặc sau khi password của admin thay đổi. 

- Xác thực đa năng thông qua TOTP (Time-base One-Time Password): Keystone hỗ trợ xác thực thông qua Time-based One-time Password (TOTP) và password tùy theo nhu cầu về form password xác thực mà người dùng mong muốn. 

- Cơ chế mapping của Định danh Federated identity hỗ trợ khả năng tự động cung cấp project cho các federated user. Một role assignment sẽ được tự động tạo ra cho user trên project xác định, nếu project được mapping đến đó chưa tồn tại thì nó sẽ tự động được tạo ra trên domain mà gán với identity provider đó. 

- Version 3 API trở thành API mặc định trong cổng tích hợp testing (intergration gate testing)

Tham khảo: https://docs.openstack.org/releasenotes/keystone/ocata.html

## 3) Những điều đạt được trong Openstack Pike 

- **Registering và documenting những policy mặc định**

  - Bắt đầu thực hiện việc đăng kí (registering) và sử dụng các rule mặc định trong policy "in code". Các rule được định nghĩa trong các policy mới và được trả về trong file code `list__init__.py` . Các policy mặc định có thể được duy trì trong code và được đăng ký thông qua cơ chế liệt kê trong các module policy. Khi đó, chúng ta có thể xóa các policy mặc định được sao chép từ file policy.json. => do đó, ta có thể sử dụng các policy mà mình mong muốn, không bị ràng buộc với các policy mặc định.

  - Hỗ trợ tạo ra các policy từ các file định nghĩa policy mà người dùng tạo ra. (tạo ra dựa trên các policy mặc định đã có sẵn trước đó)

- **Inified limit** - Thống nhất phạm vi hạn chế truy cập của user trên các project khác nhau. 

- **Project tags** - Thêm khái niệm tag nên nếu như đã sử dụng Nova, Neutron hay các resource tags thì cũng giống như làm việc với project.

- **Federated intergration testing** -  Thử nghiệm tích hợp Federated.

- **Integrating rolling upgrade test**: ...

## 4) Looking ahead to Queens and Rockey

- **well-defined roles by default**: Cung cấp các tiêu chuẩn về các role mặc định.

- **improving policy security**- Cải thiện khả năng bảo mật policy...

- **hierarchical limits and qoutas** 

- **API keys**: cô lập sự xác thực từ dịch vụ identity, bảo mật hơn cho người dùng (user không cần cấu hình pasword trong file cấu hình...)

- **Native SAML support** 

- **Account linking** : Liên kết các tài khoản được xác thực thông qua nhiều backend khác nhau (LDAP, SQL, Federated...) mà không phải lưu trữ các bản sao của một người dùng.

- **Tiếp tục integrating testing** (thử nghiệm tích hợp các công nghệ khác vào Keystone)


---

***link video:*** https://www.openstack.org/videos/boston-2017/project-update-keystone




 

