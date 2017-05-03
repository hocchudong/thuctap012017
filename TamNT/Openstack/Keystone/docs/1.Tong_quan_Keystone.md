# TỔNG QUAN VỀ KEYSTONE

## ***Mục lục***

[1. Giới thiệu](#1)

[2. Các thành phần của Keystone](#2)

[3. Các chức năng chính của Keystone](#3)

[4. Quá trình làm việc với token trong Openstack](#4)

[5. Tham khảo](#5)

---

<a name = "1"></a>
# 1. Giới thiệu

-	Môi trường cloud theo mô hình ***Infrastructure-as-a-Service (IaaS)** cung cấp cho người dùng nguồn tài nguyên chính như má ảo, lượng lớn block và object storage, và băng thông mạng. 

-	Một tính năng quan trọng của môi trường cloud là nó cung cấp tài nguyên một cách bảo mật, truy cập điều khiển an toàn vào các tài nguyên có giá trị. Trong Openstack (OPS) Keystone là dịch vụ có khả năng cung cấp sự truy cập an toàn tới tất cả các tài nguyên cloud. Keystone đã chứng minh được sự cần thiết của nó trong môi trường cloud bảo mật.

-  Hình sau cho thấy, 90 – 95% người dùng OPS sử dụng Kestone trong mô hình triển khai của họ:

<img src ="http://imgur.com/YSBnC5J.jpg">

<a name = "2"></a>
# 2. Các thành phần của Keystone

- **Server**
	Máy chủ tập trung cung cấp các dịch vụ xác thực (Authentication) và xác thực (Authorization) sử dụng các giao tiếp RESTful API

- **Drivers**

  - Drivers hoặc một service back end được tích hợp trong máy chủ Keystone.

  - Được sử dụng cho phép truy cập các thông tin định danh trong OPS, và có thể đã tồn tại trong nền tảng triển khai của OPS (Như SQL database hoặc máy chủ LDAP,… ). 

- **Modules**

  - Các Middleware modules chạy trên các thành phần của OPS ma sử dụng dịch vụ Identity – Keystone. 

  - Những module này chặn các request tới các service và trích xuất lấy thông tin của user, và gửi chúng tới máy chủ tập trung để xác thực. 

  - Sự tích hợp giữa các module middleware và các thành phần của OPS sử dụng Python Web Serve Gateway Interface.

<a name = "3"></a>
# 3. Các chức năng chính của Keystone

Trong môi trường Openstack, điểm quan trọng trong bảo mật cloud chính là Keystone – dịch vụ định danh Identity của Openstack. Keystone cung cấp rất nhiều chức năng:

- **Identity – Định danh**: 

  - Đề cập tới việc định danh cho người dùng đang truy cập vào tài nguyên của Openstack, định danh đơn giản được hiểu là đại diện cho một user. 

  - Trong mô hình triển khai đơn giản, định danh cho user có thể được lưu trong database của Keystone.

  -  Trong mô hình doanh nghiệp, lớn, cần đến một nhà cung cấp định danh thường được sử dụng.

- **Authentication – Xác thực**: 

  - Là quá trình xử lý sự hợp lệ của định danh user. 

  - Trong nhiều trường hợp, sự xác thực là việc thực hiện đầu tiên cho user bằng cách login vào hệ thống với user identity và mật khấu. 

  - Trong môi trường OPS thô sơ,  Keystone có khả năng tự tạo ra các bước xác thực bởi chính nó. 

- **Access Management (Authorization)**:

  -  Một user identity đã được xác thực và được tạo, cấp phát token, mọi thức bắt đầu thú vị.Đến đây đã có đủ nền tảng để bắt đầu Access management. 

  - Access Management cũng như là xác thực, là quá trình kiểm tra xem những tài nguyên nào user được phép truy cập. Môi trường cloud cung cấp cho user khả năng truy cập lượng lớn tài nguyên. 

  - Ví dụ, cần phải có một cơ chế để kiểm tra xem những user nào được phép tạo những loại máy ảo đặc biệt, người dùng nào được phép gán hoặc xóa volumn trong khối lưu trữ, người dùng nào được phép tạo mạng ảo, …. 

  - Trong OPS, Keystone maps ***User*** tới ***Project*** hoặc ***Domain*** bằng cách liên kết ***Role*** cho người dùng tới các Project và Domain đó. Các project khác trong OPS như Nova, Cinder và Neutron kiểm tra Project của User và xem Role được gán cùng, đánh giá cá thông tin này sử dụng một cơ chế chính sách.. Cơ chế này sẽ kiểm tra những thông tin này và quyết định về những hành động mà user được phép thực hiện .


- **Một số chức năng khác**: Trong khi Keystone hầu hết tập trung và việc cung cấp khả năng định danh, xác thực và ủy quyền, nó còn cung cấp nhiều lợi ích khác cho OPS như:

  -	***Cung cấp sự xác thực và ủy quyền cho tất cả các dịch vụ khác của OPS***: Keystone giải quyết vấn đề phức tạp trong việc kết hợp xác thực hệ thống external và cũng cung cấp sự xác thực giống nhau cho tất cả các dịch vụ khác của OPS như Nova, Glance, Cinder, Neutron, … và do đó cô lập tất cả các dịch vụ từ việc biết cách làm thế nào để phân biệt định danh và xác thực giữa các dịch vụ.

  -	***Cung cấp sự đăng ký cho các container (Project)*** để các dịch vụ khác của OPS cần sử dụng để phân chia tài nguyên.

  -	***Cung cấp việc đăng ký các domain*** được sử dụng để định nghĩa phân chia namespace cho các user, group và các project để cho phép phân chia giữa các khách hàng.

  -	***Tạo các role*** sẽ được sử dụng để xác thực giữa Keystone và các file chính sách trong mỗi dịch vụ của OPS.

  -	***Tạo sự kết nối*** cho phép user và group được kết nối với các role trên project và domain.

  -	***Catalog - mục lục*** lưu trữ các các dịch vụ, enpoints, và regions của OPS, cho phép các clients tìm ra dịch vụ hoặc enpoint mà họ cần.

<a name = "4"></a>
# 4. Quá trình làm việc với token trong Openstack

Các quá trình xử lý các tiến trình trong OPS với sự xác thực của Keystone được miêu tả như hình sau:

<img src ="http://imgur.com/7MLfrLQ.jpg">


<a name = "5"></a>
# 5. Tham khảo

[1] https://github.com/thaihust/Thuc-tap-thang-03-2016/blob/master/ThaiPH/OpenStack/Keystone/ThaiPH_Keystone_General_Info.md 

[2] Book: Identity, Authentication, and Access Management in OpenStack – Author: Steve Martinelli, Henry Nash, and Brad Topol - Copyright © 2016 Steve Martinelli, Henry Nash, and Brad Topol. All rights reserved.

[3] https://docs.openstack.org/ocata/install-guide-ubuntu/common/get-started-identity.html# 



