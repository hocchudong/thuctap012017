# Project Keystone Update

# MỤC LỤC
- [1.What is Openstack Identity](#1)
- [2.Kết quả đã đạt được trong phiên bản Openstack Ocata](#2)
- [3.Kết quả đã đạt được trong phiên bản Openstack Pike](#3)
- [4.Looking ahead to Queens and Rockey](#4)
- [Tài liệu tham khảo](#thamkhao)







<a name="1"></a>
# 1.What is Openstack Identity
\- Là dịch vụ quản lý và chia sẻ authentication, authorization của user.  
\- Cung cấp thông tin identity cho end user và services.  
\- Là trung gian giữa Openstack và các identity services khác (LDAP hay các identity provider khác).  
\- 98% số người dùng Openstack sử dụng Keystone project trong mô hình triển khai của họ.  

<a name="2"></a>
# 2.Kết quả đã đạt được trong phiên bản Openstack Ocata
\- Cho phép **long running operation** để hoàn thành service: Điều này có nghĩa là những tiến trình cần thời gian dài sẽ được sử dụng token hết hạn.  
**VD:** Chúng ta upload image từ local lên glance, mà image đó khoảng vài chục GB, giả sử khi quá trình upload chưa hoàn thành thì token đã hết hạn thì keystone sẽ vẫn cho phép hoàn thành quá trình upload với token đã hết hạn.  
\- **fernet token** đã trở thành default.  
\- **smater use revocation** : Giảm bớt số lượng **revocation events** trả về, chỉ trả về một subset của events thích hợp với token. Qua đó, cải thiện hiệu suất **token validation**.  
\- Cải thiện tính năng bảo mật PCI DSS.  
- Cho phép chỉ định time hết hạn password đối với account.
- Thêm một API mới cho việc yêu cầu nhập password đối với user.
- Thêm truy vấn để giúp lọc ra các user có password hết hạn.

\-  **Keystone** hỗ trợ authenticating thông qua Time-based One-time Password (TOTP).  
\- **federated auto-provisioning**: *federated identity mapping* hỗ trợ tự động cung cấp project cho **federated users**. Role assignment sẽ tự động được tạo cho user trên project chỉ định.  
\- **version v3 API** là default cho **gate testing**.  

<a name="3"></a>
# 3.Kết quả đã đạt được trong phiên bản Openstack Pike
\- **Registering và documenting những default policy**  
\- **Unified limit**: Thống nhất phạm vi truy cập của user trên các project khác nhau. 
\- **Project tags**: Thêm khái niệm tag nên nếu như đã sử dụng Nova, Neutron hay các resource tags thì cũng giống như làm việc với project.
\- **Federated intergration testing** : Thử nghiệm tích hợp Federated.
\- **Integrating rolling upgrade test**

<a name="4"></a>
# 4.Looking ahead to Queens and Rockey
\- **well-defined roles by default**: Cung cấp các tiêu chuẩn về các role mặc định.  
\- **improving policy security**: Cải thiện khả năng bảo mật policy.  
\- **hierarchical limits and qoutas**  
\- **API keys**: cô lập sự xác thực từ dịch vụ identity, bảo mật hơn cho người dùng (user không cần cấu hình pasword trong file cấu hình...)
\- **Native SAML support**  
\- **Account linking**: Liên kết các tài khoản được xác thực thông qua nhiều backend khác nhau (LDAP, SQL, Federated...) mà không phải lưu trữ các bản sao của user.  
\- **Tiếp tục integrating testing**: thử nghiệm tích hợp các công nghệ khác vào Keystone  

<a name="thamkhao"></a>
# Tài liệu tham khảo
https://www.openstack.org/videos/boston-2017/project-update-keystone  
https://docs.openstack.org/releasenotes/keystone/ocata.html  
https://docs.openstack.org/releasenotes/keystone/unreleased.html  







