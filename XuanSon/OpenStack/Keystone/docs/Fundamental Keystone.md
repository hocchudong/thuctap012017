# Fundamental Keystone


# MỤC LỤC
- [1.Keystone Concepts](#)1
	- [1.1.Projects](#1.1)
	- [1.2.Domain](#1.2)
	- [1.3.User và User Group(Actors)](#1.3)
		- [1.3.1.Graphical representation](#1.3.1)
	- [1.4.Roles](#1.4)
	- [1.5.Assignment](#1.5)
	- [1.6.Targets](#1.6)
	- [1.7.Token](#1.7)
	- [1.8.Catalog](#1.8)
	- [1.9.Note](#1.9)
- [2.Identity](#2)
	- [2.1.SQL](#2.1)
	- [2.2.LDAP](#2.2)
	- [2.3.Multiple Backends](#2.3)
	- [2.4.Identity Providers](#2.4)
	- [2.5.Use Cases for Identity Backends](#2.5)
	- [2.6.Các Token Backend khác](#2.6)
- [3.Authentiaction](#3)
	- [3.1.Password](#3.1)
	- [3.2.Token](#3.2)
- [4.Access Management and Authorization](#4)
- [5.Backends and Services](#5)
- [6.FAQs](#6)





<a name="1"></a>
# 1.Keystone Concepts
Keystone là Openstack project cung cấp Identity and Authorization service.  

<a name="1.1"></a>
## 1.1.Projects
\- In Keystone, a Project is an abstraction used by other OpenStack services to group and isolate resources (e.g., servers, images, etc.).  
\- Ban đầu, Project được gọi là Tenants, sau đó thay đổi là Projects.  
\- Mục đích cơ bản của Keystone là registry của Projects và chỉ rõ ai có thể access vào Projects đó. Projects themselves don’t own Users,but Users or User Groups are given access to a Project using the concept of Role Assignments.  

<a name="1.2"></a>
## 1.2.Domain
\- Domain cung cấp khả năng isolate the visibility của một tập hợp Projects và User (User Group) , tránh việc user có khung nhìn toàn cục gây ra xung đột không mong muốn về user name giữa các tổ chức khác nhau trong cùng một hệ thống cloud.  
\- Domain định nghĩa là một tập hợp users, groups, and projects. Domain cho phép phân chia resources trong cloud.  
\- Mỗi domain có thể được coi là sự phân chia về mặt logic giữa các enterprise trên cloud.  

<a name="1.3"></a>
## 1.3.User và User Group(Actors)
Trong Keystone, User và User Groups là entities để access resources được isolated trong Doamins và Projects. Group là tập hợp User. User là các nhân riêng lẻ sử dụng cloud. Chúng ta nhắc đến User và Groups as Actors , khi assigning a role, đây là những entities mà role được “assignes to”.  

<a name="1.3.1"></a>
### 1.3.1.Graphical representation
\- Mối quan hệ giữa domain, projects, user, và groups. 
\- Users, Groups và projects được hiểu ở “domain scoped”, nghĩa là name của user, group, và project có thể giống nhau trên domains khác nhau.   
\- As of Liberty,roles are not domain scoped, but this could change in the future.  

<img src="http://i.imgur.com/SVdWrgq.png" />

<a name="1.4"></a>
## 1.4.Roles
\- Roles are used in Keystone to convey a sense of Authorization. An actor may have numerous roles on a target.  
\- For example, the role of admin is “assigned to” the user “bob” and it is “assigned on” the project “development.  

<a name="1.5"></a>
## 1.5.Assignment
A role assignment is a ternary (or triple): the combination of an actor, a target, and a role. Role assignments are granted and revoked, and may be inherited between groups and users and domains and projects.  

<a name="1.6"></a>
## 1.6.Targets 
Projects and Domain được gọi chung Targets, nơi mà role được “assigned on”.  

<a name="1.7"></a>
## 1.7.Token
\- User call to any OpenStack API họ cần đề phải :  
- (a) prove who they are 
- (b) they should be allowed to call the API in question  
Cách họ đạt được đó là chuyển Openstack token đến API call – Keystone là Openstack service chịu trách nhiệm generating token này. A user nhận được token sau khi autehntication thành công đối với Keystone. Token chứa authorization a user has on the cloud. A token has both an ID and a payload.   
- ID: định danh duy nhất của token trên cloud, The ID of a token is guaranteed to be unique per cloud, and the payload contains data about the user.
- payload: là dữ liệu về người dùng (user được truy cập trên project nào, danh mục các dịch vụ sẵn sàng để truy cập cùng với endpoints truy cập các dịch vụ đó), thời gian khởi tạo, thời gian hết hạn, etc.  

\- The payload can be seen below:  
An Identity V3 Scoped Token consists of many felds that indicate Identity and Authorization attributes about the user on a project.  

<img src="http://imgur.com/HJ2TXcN.png" />

<a name="1.8"></a>
## 1.8.Catalog
\- Service catalog là cần thiết cho OpenStack cloud. Nó chứa URLs and endpoint của các Cloud services khác nhau. Không có catalog, users và applications không biết nơi để route các requests để tạo VMs hoặc store objects. Service catalog chia thành a list of endpoint, mỗi endpoint chia nhỏ thành admin URL, internal URL, và public URL, có thể giống nhau.  
\- Example: A simple Catalog of just two services, Identity and Object Storage.Endpoints are essential to allow the user to discover where diﬀerent services are hosted.  

<img src="http://imgur.com/uXOWiBB.png" />

<a name="1.9"></a>
## 1.9.Note
\- User ID, Group ID, Project ID có phạm vi global.  
\- User name, Group name, Project name có phạm vi domain.  
\- Role ID và Role name đều có phạm vi global.  

<a name="2"></a>
# 2.Identity
The Identity Service in Keystone provides the Actors. Identities in the Cloud may come from various locations, including but not limited to SQL, LDAP, and Federated Identity Providers.  

<a name="2.1"></a>
## 2.1.SQL
\- Keystone bao gồm tùy chọn lưu trữ your actors (Users và Groups) trong SQL; hỗ trợ databases bao gồm MySQL, PostgreSQL, và DB2. Keystone sẽ lưu trữ information như name, password, và description.  
\- Setting cho database phải được chỉ định trong Keystone’s configuration file. Về bản chất, Keystone hoạt động như Identity Provider.  
\- Ưu và nhược điểm của SQL Indentity option:  
Ưu:  
- Dễ cài đặt
- Quản lý users và groups thông qua OpenStack APIs

Nhược:  
- Keystone không thể trở thành Identity Provider.
- Hỗ trợ weak password ( no password rotation và no password recovery)
- Most enterprises have an LDAP server they want to use
- Identity silo: yet another username and password users must remember

<a name="2.2"></a>
## 2.2.LDAP
\- LDAP (Lightweight Directory Access Protocol) là một tùy chọn khác của Keystone để lưu trữ actors (Users và Groups). Keystone sẽ access LDAP giống như bất kì application nào khác sử dụng LDAP (System Login, Email, Web Application, etc.).  
\- Cài đặt kết nối đến LDAP là được chỉ định trong Keystone’s configuration file.  
\- LDAP thiết lập cho Keystone có quyền “write” dữ liệu vào LDAP hay chỉ có quyền “read” LDAP data.  
\- Trường hợp, lý tưởng LDAP chỉ có quyền “read”, nghĩa là hỗ trợ tìm kiếm user và group và thực hiện authentication.  

<img src="http://imgur.com/bk1HIa6.png" />

\- Ưu điểm:  
- Không cần duy trì bản sao của user accounts.  
- Keystone does not act as an Identity Provider.  

\- Nhược điểm:  
- Các service accounts (nova, glance, swift, etc.) vẫn cần lưu trữ ở đâu đó, bởi LDAP admin không muốn những account này lưu trữ trong LDAP
- Keystone vẫn có thể thấy được user password, bởi mật khẩu nằm trong authentication request. Keystone chỉ đơn giản forward những requests này, nhưng trong trường hợp lý trưởng nhất, Keystone không được thấy “user password” nữa.

<a name="2.3"></a>
## 2.3.Multiple Backends
\- Từ phiên bản Juno, Keystone hỗ trợ multiple Identity backend cho V3 Identity API.   
\- Triển khai các backend riêng biệt cho mỗi Keystone domain. Default domain thông thường sử dụng SQL backend, nó được sử dụng để lưu trữ service accounts (Serviec account là account của Openstack service sử dụng tương tác với Keystone).  
\- Ngoài ra, LDAP backends may be hosted in their own domain. Thông thường LDAP của quản trị hệ thống cloud OpenStack khác với LDAP của từng công ty. Do đó trên mỗi domain của công ty riêng biệt thường triển khai quản lý thông tin nhân viên của họ.  

<img src="http://imgur.com/zDRSTUo.png" />

\- Ưu điểm và nhược điểm của multiple backend :  
Ưu:
- Hỗ trợ multiple LDAPs cho nhiều user account và SQL backend cho service account.
- Tận dụng lợi thế LDAP. 

Nhược:  
- Cài đặt phức tạp
- Authentication cho user accounts dùng trong “domain scoped”

<a name="2.4"></a>
## 2.4.Identity Providers
\- Từ Icehouse release, Keystone có thể federated authentication thông qua Apache modules cho nhiều Identity Providers tin cậy. Những users này không được lưu trữ trong Keystone, được xem như user ephemeral. The federated users will have their attributes mapped into group-based role assignments.  
\- Đứng về góc nhìn của Keystone, identity provider là source cho identities; nó có thể là hệt hống backends như (LDAP, AP, MongoDB) hoặc Social Logins( Google, Facebook, Twitter). Thông qua hệ thống Identity Manager trên mỗi domain, các user attribuites sẽ được đưa về các federated identity  có định dạng tiêu chuẩn như SAML, OpenID Connect.  
\- Identity Provider có nhiều ưu điểm và ít nhược điểm:  
Ưu:  
- Tận dụng hạ tầng và phần mềm có sẵn để authenticate user và thu thập information ablout user
- Tách biệt Keystone và vấn đề xử lý identity information.
- Mở cửa cho mục đích liên kết giữa các hệ thống cloud, hybrid cloud.
- Keystone không còn "thấy" được user password nữa
- Identity provider hoàn toàn thực hiện việc xác thực

Nhược :  
- Cài đặt identity source rất phức tạp.

<a name="2.5"></a>
## 2.5.Use Cases for Identity Backends
The use cases for the different identity backends are organized

<img src="http://imgur.com/MshHMXm.png" />

<a name="2.6"></a>
## 2.6.Các Token Backend khác
Ngoài các Backend trên, còn các backend khác như KVS Backend, PAM Backend, Templated Backend.  

<img src="http://imgur.com/y3KG7Cb.png" />

<a name="3"></a>
# 3.Authentiaction
\- Có nhiều phương pháp để authenticate với Keystone service, 2 phương pháp phổ biến nhất được cung cấp là thông qua password hoặc sử dụng token.  
\- In this section we will be highlighting those two methods of authentication by showing the data required in a POST request to Keystone and their usual flow between the User, Keystone, and other OpenStack services.  

<a name="3.1"></a>
## 3.1.Password
\- Password là phương pháp phổ biến nhất để authenticate user hoặc service.  
\- Được gửi thông qua “POST” request đến Keystone.Request sẽ có payload dạng như sau :  
\- An example of an authentication payload request that contains a scope.  

<img src="http://imgur.com/fQec6fs.png" />

\- About the payload, and a note about domains :  
- Payload của request phải chứa đủ information để xác định user có tồn tại hay không, authenticate user, thu thập service catalog dựa trên user’s permissions trên một scope (project).
- Trong user section phải xác định thông tin domain(domain name hoặc ID), trừ khi user’s globally unique ID là được sử dụng. 
- Trong scope section là tùy chọn nhưng thường được sử dụng, nếu không có scope user sẽ không thu thập service catalog. Scope được sử dụng để xác định project nào user được làm việc. Nếu user không có role on the project, request sẽ bị loại bỏ. Tương tự như user section, scope section phải có đủ information về project để tìm nó, domain phải được chỉ định, bởi project name cũng có thể trùng nhau giữa các domain khác nhau. Trừ khi cung cấp project ID(duy nhất trên tất cả các domain), khi đó không cần thông tin domain nữa.

<img src="http://imgur.com/0alnBcG.png" />

<a name="3.2"></a>
## 3.2.Token
\- Tương tự như trên, user request một new token bằng cách cung cấp current token.  
\- Có nhiều lý do để xin cấp phát một token mới, như refreshing một token sắp hết hạn hoặc thay đổi từ unscoped token sang scoped token.  

<img src="http://imgur.com/HekMABw.png" />  


<img src="http://imgur.com/gd9lImm.png" />  

<a name="4"></a>
# 4.Access Management and Authorization
\- Keystone managing access và authorizing user được phép sử dụng APIs nào.  
\- Keystone giải quyết vấn đề này bằng cách tạo ra Role-Based Access Control (RBAC) policy thực thi trên mỗi public API endpoint. Các polocies được lưu trữ tron file trên disk, thông thường có tên “policy.json”.  
\- Keystone’s policy.json file bao gồm: targets và rules.  

<img src="http://imgur.com/EhyNVF9.png" />

- Targets refer to the left-hand key, and rules refer to the right-hand value.
- Phần đầu của file thiết lập các targets với role cụ thể. Nó có thể là admin, owner, or either.
- Mỗi rule bắt đầu với identity: và chỉ định proteced controller dùng để quản API. 
- Full 1:1 mapping for this information role và API thể hiện như sau :

|Policy Target|API|
|---|---|
|identity:list_projects|GET /v3/projects|
|identity:create_project|POST /v3/projects|
|identity:delete_project|DELETE /v3/projects/{project_id}|
|identity:list_user_projects|GET /v3/users/{user_id}/projects|

<a name="5"></a>
# 5.Backends and Services
Sau đây là tổng hợp backends và services trong hình sau. Phần màu Green cho biết backends thường được sử dụng là SQL, phần màu Pink cho biết backends thường được sử dụng là LDAP hoặc SQL, phần màu Blue thường được sử dụng là SQL hoặc Memcache, và kết thúc, policy là service lưu trong file. Có một số Keystone services khác, tuy nhiên, đây là service được sử dụng phổ biến nhất.  

<img src="http://imgur.com/FD1Bbkj.png" />
	
<a name="6"></a>
# 6.FAQs
\- What’s the diﬀerence between a Domain and a Region?  
- Domain tách biệt về mặt tài nguyên giữa các chủ sở hữu của các project và identity source (LDAP, SQL)
- Region đại diện bởi vị trí địa lý như: US-West, USS-East

\- Can users exist in multiple domains?  
Mỗi user được sở bởi 1 domain. User name có thể trùng nhau giữa các domain khác nhau. Mỗi user có định danh ID duy nhất.  

\- What is the diﬀerence between a scoped and unscoped token?  
- An unscoped token is one where the user is authenticated but not for a specific project or domain. This type of token is useful for making queries such as determining what projects a user has access to.
- A scoped token is created when the user is authenticated for a specific project or domain. Scoped tokens have role information associated with them and are the types of tokens used by the other OpenStack services to determine what types of operations are permitted.

\- What about Active Directory support?  
It’s there! Keystone’s LDAP support extends to Active Directory. In its earlier releases, there were bugs in the LDAP backend that were related to AD, but since then multiple enterprises have been able to configure Keystone to communicate with their AD.  

\- What are the other authentication methods?  
Keystone also provides support for authenticating through a certificate. The only caveat here is that the user name associated with the certificate must exist in an Identity backend.  































