# Tổng quan về Keystone Project

## Mục lục
- [I. Tổng về về các chức năng Identity, Authentication and Access Management của keystone](#I)
	- [1. Identity](#1)
	- [2. Authentication](#2)
	- [3. Access Management (Authorization)](#3)
- [II. Các khái niệm trong keystone](#II)
	- [1. Project](#project)
	- [2. Domain](#domain)
	- [3. User và User Group](#user)
	- [4. Roles](#role)
	- [5. Assignment](#assignment)
	- [6. Target](#target)
	- [7. Token](#token)
	- [8. Catalog](#catalog)
- [III. Back end của mỗi chức năng](#III)
	- [1. Identity](#identity)
		- [1.1 SQL](#sql)
		- [1.2 LDAP](#ldap)
		- [1.3 Multiple Backends](#mbackend)
		- [1.4 Identity provider](#provider)
		- [1.5 Use case for identity backend](#uc)
	- [2. Authentication](#auth)
		- [2.1 Authentication password](#authupass)
		- [2.2 Authentication token](#authtoken)
	- [3. Access management and authorization](#access)
	- [4. Backends and Services](#backendservice)
- [IV. Keystone Workflow.](#workflow)

<a name=I></a>
## I. Tổng về về các chức năng Identity, Authentication and Access Management của keystone
---
Các môi trường Cloud với mô hình Infrastructure-as-a-Service cung cấp cho người dùng truy cập đến các tài nguyên quan trọng như các máy ảo, lượng lớn lưu trữ và băng thông mạng. Một tính năng quan trọng của bất kỳ một môi trường cloud là cung cấp bảo mật, kiểm soát truy cập tới những tài nguyền có trên cloud. Trong môi trường Openstack, dịch vụ **keystone** có trách nhiệm đảm nhận việc bảo mật, kiểm soát truy cập tới tất cả các tài nguyên của cloud. Keystone là một thành phần không thể để bảo mật cho cloud.

<a name=1></a>
### 1. Identity
- Identity là xác định người đang cố gắng truy cập vào tài nguyên cloud.
- Identity là đại diện cho [User](#user)

<a name=2></a>
### 2. Authentication
- Authentication là xử lý nhận dạng User.
- Xác thực có thể bằng password hoặc token
- Keystone tạo ra token, cho phép User sử dụng token để thay thế cho mật khẩu. Làm giảm thiểu truy cập vào các tài nguyên bằng mật khẩu. Mật khẩu cần được quản lý và được đảm bảo không bị lộ.
- Token có giới hạn về thời gian được phép sử dụng. Khi token hết hạn thì user sẽ được cấp một token mới. Cơ chế này làm giảm nguy cơ user bị đánh cắp token.
- Hiện tại, keystone đang sử dụng cơ chế `bearer token`. Có nghĩa là bất cứ ai có token thì sẽ có khả năng truy cập vào tài nguyên của cloud. Vì vậy việc giữ bí mật token rất quan trọng.

<a name=3></a>
### 3. Access Management (Authorization)
- Authorization xử lý xác định những tài nguyên nào user được phép truy cập.
- Quản lý truy cập vào tài nguyên của cloud, keystone sử dụng khái niệm [role](#role)

<a name=II></a>
## II. Các khái niệm trong keystone
---
<a name=project></a>
### 1. Project
- Trong những ngày đầu của Openstack, có một khái niệm là **Tenants**. Sau đó người ta sử dụng khái niệm Project để thay thế cho trực quan hơn.
- Project là nhóm và cô lập lại các tài nguyên.
- Keystone đăng ký các project và sẽ xác định ai nên được phép truy cập vào những project này.
- Project không phải là của riêng user hay user group. Nhưng user được cho phép truy cập tới project sử dụng khái niệm `Role assignment`.
- Có một Role được gán cho user hoặc user group trên một project. Có nghĩa là user có một vài cách để tiếp cận tới tài nguyên trong project. Và các vai trò cụ thể đã gán cho user sẽ xác định loại quyền truy cập và các khả năng mà user được quyền có.
- Việc gán role cho user đôi khi còn được gọi là "grant" trong Openstack Document.
- Ví dụ minh họa

![Imgur](http://i.imgur.com/qowaF3i.png)

<a name=domain></a>
### 2. Domain
- Trong những ngày đầu của Openstack chưa có cơ chế giới hạn khả năng "hiện thị" project của các tổ chức người dùng khác nhau. Điều này có thể gây ra các xung đột không mong muốn đối với tên project của các tổ chức khác nhau.
- Username cũng có tính toàn cụ và cũng có thể dẫn đến xung đột về tên.
- Để openstack có thể hỗ trợ các tổ chức một các rõ ràng trong việc đặt tên, người ta đã sử dụng một khái niệm `Domain`.
- Domain sẽ giới hạn khả năng hiện thị các project và user của các tổ chức.
- Domain là một tập hợp các user, group và project

![Imgur](http://i.imgur.com/GbzunJs.png)

<a name=user></a>
### 3. User và User Group (Actor)
- User Group là nhóm các user
- Chúng ta gọi user và user group là actor

![Imgur](http://i.imgur.com/0IqbLpZ.png)

<a name=role></a>
### 4. Roles
- Chỉ ra vai trò của người dùng trong project hoặc trong domain,...
- Mỗi user có thể có vai trò khác nhau đối với từng project.

<a name=assignment></a>
### 5. Assignment
- Thể hiện sự kết nối giữa một actor(user và user group) với một actor(domain, project) và một role.
- Role assignment được cấp phát và thu hồi, và có thể được kế thừa giữa các user và group trên project của domains.

<a name=target></a>
### 6. Target
- Chính là project nào hoặc domain nào sẽ được gán Role cho user.

<a name=token></a>
### 7. Token
- Để cho user gọi đến bất kỳ một API nào đó, họ cần chứng tỏ được **họ là ai** và họ được phép truy cập đến API nào trong request. 
- User cần chuyển 1 Token vào API mà họ gọi.
- Keystone là dịch vụ có trách nhiệm tạo ra token này. 
- User sẽ nhận token này khi xác thực thành công bởi keystone. 
- Token nãy cũng được ủy quyền (nó đại diện cho user). Nó chứa sự ủy quyền của user có trên cloud. 
- Một token có cả 1 ID và 1 payload. ID của token là duy nhất trên mỗi cloud, và payload chứa data về user.
	
<a name=catalog></a>
### 8. Catalog
- Chứa URLs và endpoints của các dịch vụ trong cloud.
- Với catalog, người dùng và ứng dụng có thể biết ở đâu để gửi yêu cầu tạo máy ảo hoặc storage objects.
- Dịch vụ catalog chia thành danh sách các endpoint, mỗi endpoint chi thành các admin URL, internal URL, public URL.

<a name=III></a>
## III. Chi tiết về chức năng của keystone và Back end của mỗi chức năng.
- Các thành mà Keystone đảm nhận quản lý:
	- Projects (hoặc Tenants)
	- Users or User Groups
	- Roles
	- Tokens
	- Endpoints: là một địa chỉ, có thể là URLs, nơi mà có thể tạo các request đến các Service trong openstack.
	- Services: Cung cấp 1 hoặc nhiều endpoint. Thông qua các endpoint này mà user có thể truy cập tới các tài nguyên và thực hiện các hoạt động của mình trên tài nguyên mà user có.
---

<a name=identity></a>
### 1. Identity.
##### Dịch vụ Identity trong môi trường Cloud có thể đến từ các vị trí khác nhau, bao gồm SQL, LDAP, và Federated Identity Provider.

<a name=sql></a>
### 1.1 SQL
- Keystone có tùy chọn để lưu thông tin các **actors** trong SQL.
- Các database được hỗ trợ: MySQL, PostgreSQL, DB2.
- Keystone sẽ lưu các thông tin như là: name, password, và description.
- Database sử dụng để lưu trữ cần được chỉ rõ trong file cấu hình của keystone.
- Ở đây sử dụng SQL để lưu trữ, như vậy keystone đang hoạt động như một nhà cung cấp dịch vụ Identity (Identity Provider).
	- Không phải là lựa chọn tốt cho mọi người.
	- Cần sử dụng một Identity Provider khác.
- Ưu điểm:
	- Dễ dàng cài đặt
	- Quản lý users và groups thông qua Openstack APIs
- Nhược điểm:
	- Keystone không nên là Identity Provider.
	- Hỗ trợ mật khẩu yếu:
		- Không khôi phục mật khẩu.
		- Không xoay mật khẩu.
	- Hâu hết các doanh nghiệp sử dụng LDAP server.
	- Cần phải ghi nhớ username và password.

<a name=ldap></a>
### 1.2 LDAP
- Keystone sử dụng tùy chọn sử dụng LDAP (Lightweight Directory Access Protocol ) để khôi phục và lưu trữ các Actor.
- Keystone sẽ truy cập đến LDAP giống như các ứng dụng sử dụng LDAP.
- Cài đặt kết nối đến LDAP phải được chỉ rõ trong file cấu hình keystone.
- LDAP chỉ nên thực hiện đọc như là tìm kiếm user và group (thông qua search) và xác thực (thông qua bind).
- Nếu sử dụng LDAP là một Identity backend chỉ để đọc thì keystone cần có quyền để sử dụng LDAP.
- Ưu điểm:
	- không duy trì bản sao của tài khoản người dùng.
	- Keystone không hành động như một nhà cung cấp nhận dạng (identity provider).
- Nhược điểm:
	- Account của các dịch vụ sẽ lưu ở đâu đó và người quản trị LDAP không muốn có tài khoản này trong LDAP.
	- Keystone có thể thấy mật khẩu người dùng, lúc mật khẩu được yêu cầu authentication.
	- Keystone đơn giản thì chuyển các yêu cầu, nhưng tốt nhất là Keystone không nhìn thấy mật khẩu.

<a name=mbackend></a>
### 1.3 Multiple Backends
- Kể từ phiên bản Juno, Keystone hỗ trợ nhiều Identity backends cho APIv3.
- Identity service có thể có nhiều backend cho mỗi domain.
- Ưu điểm:
	- Hỗ trợ nhiều backend đồng thời.
	- Sử dụng lại LDAP đã có.
- Nhược điểm
	- Phức tạp trong cài đặt.
	- Xác thực tài khoản người dùng phải trong miền scoped

<a name=provider></a>
### 1.4 Identity provider
- Sử dụng một bên thứ ba đảm nhận chức năng xác thực.

<a name=uc></a>
### 1.5 Use case for identity backend
- Bảng sau cho biết trường hợp nào nên sử dụng backend nào cho hợp lý.

![Imgur](http://i.imgur.com/zAujbHe.png)

<a name=auth></a>
### 2. Authentication
- Trong keystone có một vài cách khác nhau để xác thực. Có hai cách phổ biến nhất đó là sử dụng **Password** và **Token**.

<a name=authupass></a>
### 2.1 Authentication password
- Sử dụng Password là cách phổ biến nhất để xác thực user và các service.
- Payload của request phải chứa đầy đủ thông tin để tìm kiếm user đã tồn tại nằm ở đâu, xác thực đúng user, các tùy chọn, khôi phục lại danh mục các service dựa trên phạm vi quyền hạn của user (trong project nào).
- Ví dụ về một payload

![Imgur](http://i.imgur.com/62Dw9T3.png)

<a name=authtoken></a>
### 2.2 Authentication token
- User có thể yêu cầu 1 token mới dựa vào token hiện tại đang có.
- Định dạng một token:

![Imgur](http://i.imgur.com/rHEP8rA.png)

- Quá trình user một token mới. Token mới sẽ có scope và role giống với token cũ.

![Imgur](http://i.imgur.com/LGT8ShG.png)

<a name=access></a>
### 3. Access management and authorization
- Quản lý truy cập và cho phép chính là keystone cung cấp APIs nào mà user có thể sử dụng.
- Keystone tạo ra các chính sách Role-Based Access Controll (RBAC) được thực thi trên mỗi public API endpoint.
- Các chính sách được lưu trữ trong một file, tên thường là `policy.json`.

<a name=backendservice></a>
### 4. Backends and Services
- Góc nhìn tổng quát về các thành phần trong keystone được quản lý và sử dụng các loại backend khác nhau.

![Imgur](http://i.imgur.com/YZDaevo.png)

<a name=workflow></a>
### IV. Keystone Workflow.
- Lưu đồ về tổng quan về các bước mà người dùng tương tác với các service trong Openstack

![Imgur](http://i.imgur.com/mDMBskO.png)

- Keystone Workflow

![Imgur](http://i.imgur.com/FOorZrU.png)