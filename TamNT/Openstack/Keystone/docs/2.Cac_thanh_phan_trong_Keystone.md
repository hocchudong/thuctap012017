# CÁC THÀNH PHẦN VÀ NHIỆM VỤ CỦA KEYSTONE

## ***Mục lục***

[1. Các khái niệm cần biết trong Keystone](#1)

- [1.1. Project](1.1)

- [1.2. Domain](#1.2)

- [1.3. User và User Group (Actor)](#1.3)

- [1.4. Role](#1.4)

- [1.5. Assigment](#1.5)

- [1.6.	Targets](#1.6)

- [1.7. Token](#1.7)

- [1.8.	Catalog	](#1.8)

[2.	Identity](#2)

- [2.1.	SQL](#2.1)

- [2.2.	LDAP](#2.2)

- [2.3.	Multiple backends](#2.3)

- [2.4.	Identity Providers](#2.4)

- [2.5.	Các trường hợp sử dụng Identity backend](#2.5)

[3.	Authentication](#3)

- [3.1.	Password](#3.1)

- [3.2.	Token](#3.2)

[4.	Access management and Authorization](#4)

[5.	Backends và Services](#5)

[6.	Một số lưu ý](#6)

[7. Tham khảo](#7)

--- 

<a name = "1"></a>
# 1. Các khái niệm cần biết trong Keystone

<a name = "1.1"></a>
## 1.1. Project
-	Trong Keystone, một **project** là một khái niệm được sử dụng bởi các dịch vụ khác của OPS để nhóm và cô lập các tài nguyên (server, image…)
  
-	Trong những ngày đầu của OPS, khái niệm này được gọi ban đan đầu là Tenant nhưng sau đó được đổi thành Project – một các tên trực quan hơn cho khái niệm này. 

-	Công bằng mà nói rằng, mục đích nền tảng nhất của Keystone là đăng ký các Project và khớp nối xem ai có thể truy cập vào các Project đó.

-	Các project tự nó không phải là chủ của các User, nhưng User hoặc User Groups có thể truy cập Project bằng cách sử dụng khai niệm kết nối với Role – Role Asignments. 

-	Có một role được kết nối tới User hoặc User Group trên một Project chứng tỏ rằng User hoặc User group có thể truy cập tài nguyên trong Project, và một role xác định được chọn quyết định loại và khả năng truy cập của User và User group có quyền có.

-	Kết nối một Role tới User đôi khi hiểu như là ***gán quyền*** trong các tài liệu của OPS. 

<a name = "1.2"></a>
## 1.2. Domain

-	Trong những ngày đầu của OPS, không có cơ chế nào để hạn chế sự truy cập Project giữa những tổ chức người dùng khác nhau. Điều này có thể gây ra sự xung đột trên Project bởi tên khác nhau của các tổ chức. Tên của User cũng có phạm vi truy cập global và có thể làm xung đột user name nếu 2 tổ chức khác nhau đều có các user có user name giống nhau. 

-	Để cho OPS cloud hỗ trợ rõ ràng hơn cho các tổ chức user trong cùng thời điểm, Keystone đưa ra khái niệm Domain – cung cấp khả năng cô lập sự truy cập được đặt cho các Project và User (và user Group) tới một tổ chức xác định. 

-	Một Domain được xác định là ***một tập hợp các user, groups và các project***. 

- Các domain cho phép bạn phân chia tài nguyên trong cloud của bạn thành các silos mà để sử dụng cho các tổ chức xác định. Một domain có thể phục vụ như  một sự phân chia hợp lý giữa các thành phần khác nhau của một doanh nghiệp hoặc mỗi domain có thể đại diện hoàn toàn cho một doanh nghiệp riêng biệt.

-	Ví dụ: một cloud có thể có 2 domain, *IBM* và *Acme Inc*. IBM có thể có tập hợp các group, user và project của họ và Acm Inc cũng thể. 


<a name = "1.3"></a>
## 1.3. User và User Group (Actor)

-	User và User group là các thực thể được đưa ra để truy cập vào tài nguyên mà được cô lập trong Domain và Project. 

-	Group là một nhóm các User. Các user là cá nhân sẽ kết thúc sử dụng Cloud của bạn. 

-	User và User group (hay Actors) được hiểu là những thực thể được kết nối tới role. 

-	Mối quan hệ giữa các domain, project, user và group được mô tả như hình sau:

<img src ="http://imgur.com/lg4aIQC.jpg">

-	Các user, group và project có sẽ luôn trong “domain scoped” (giới hạn của domain), nghĩa là một tên của một user, group, hay project có thể phổ biến hay trùng nhau trong các domain. Nghĩa là có thể có người dùng tên Jim trong nhóm admin trong cả 2 domain là IBM và Acme Inc. 

-	Tuy nhiên, mỗi thực thể là sự đảm bảo để có một mã định danh duy nhất (UUID). Điều này chỉ ra rằng cố tìm một tài nguyên chỉ với ID thì sẽ có thể được. Tuy nhiên, vì các tên thôi không đảm bảo được sự duy nhất, cung cấp cả domain sẽ là các để tìm ra được tài nguyên.


<a name = "1.4"></a>
## 1.4. Role

-	Các role (hay rule) được sử dụng trong Keystone để truyền tải về sự ủy quyền. Một actor có thể có nhiều rolw trên một target.

-	Các thực ủy quyền của Role sẽ tìm hiểu sau. 

-	Ví dụ, một role của admin là được gán cho user Bob và gán trên project deverlopment.

<a name = "1.5"></a>
## 1.5. Assignment

-	Một role assignment thì gồm 3 thành phần: sự kết hợp của một actor, một target và một role. 

-	Role assignment thì được gán, thu hồi và có thể kế thừa giữa các group và user và domain và project. 

<a name = "1.6"></a>
## 1.6. Targets 

-	Các project và cá domain rất giống nhau vì cả 2 cùng là thực thể mà role “assignment on”. Hay nói cách khác, một user hay user group đựa đưa ra truy cập tới project hoặc domain bằng cách gán với một role xác định cho User và User group đó tới domain hoặc project xác định. 

-	Bởi project và domain có nhiều điểm khá là giống nhau nên khi cần cả 2 thực thể này thì ta thườn gọi chúng là Targets. 

<a name = "1.7"></a>
## 1.7. Token

- Để một user gọi tới bất kì API nào của OPS, họ cần được chứng minh rằng họ là ai và họ nên được phép gọi API nào. Cách làm được điều đó là cần một OPS token để gọi API – và Keystone là dịch vụ đáp trả lại việc sinh ra các token này. 

- Một user nhận được token này khi đã được Keystone xác thực thành công. Token cũng mang trong nó sự ủy quyền của user trên cloud. 

- Mỗi token đều có một ID và payload. ID của token được đảm bảo là duy nhất trên mỗi cloud, và payload chứa dữ liệu về user. 

- Một payload có thể được được show như sau: 

<img src ="http://imgur.com/nygbLX9.jpg">

Token payload chứa các thông tin về thời gian tạo, thời gian hết hạn, sự xác thực người dùng và do đó cho phép sử dụng token trên project mà token có hiệu lực, và cuối cùng là catalog – mang đến điểm tới tiếp theo.

<a name = "1.8"></a>
## 1.8 Catalog 

- Dịch vụ catalog là cần thiết cho cloud OPS. Nó chứa các URL và các enpoint của các dịch vụ OPS khác nhau.

- Nếu không có catalog, người dùng và các ứng dụng không biết được cách request để tạo các VM hay lưu trữ các object. 

- Dịch vụ catalog thì được chia thành một list các endpoints, và mỗi endpoint lại được chia thành admin URL, internal URL và public URL – cái mà có thể hiểu là giống nhau. 

- Đây là một catalog đơn giản chỉ với 2 dịch vụ, Identity và Object Storage. Các endpoints là cần thiết để cho phép người dùng tìm được nơi lưu trữ của các dịch vụ khác nhau.

<img src ="http://imgur.com/nyM7iOo.jpg">


<a name = "2"></a>
# 2. Identity

Dịch vụ Identity trong Keystone cung cấp các Actor. Identity trong Keystone có thể đến từ nhiều vị trí khác nhau, nhưng bao gồm không giới hạn tới SQL, LDAP, và Federated Identity Providers. 

<a name = "2.1"></a>
## 2.1. SQL

- Keystone bao gồm các tùy chọn để lưu trữ Actor (User và Groups) trong SQL; hỗ trợ các database : MySQL, PostgreSQL, và DB2.

- Keystone sẽ lưu thông tin như tên , mật khẩu và mô tả. Việc thiết lập cho database phải được xác định ở trong file cấu hình của Keystone. Về bản chất, Keystone làm việc như một Identity Provider – không phải là trường hợp tốt nhất cho tất cả mọi người, và dĩ nhiên không phải trường hợp tốt nhất cho các khách hàng doanh nghiệm. 

- **Ưu điểm**: 

  - Dễ dàng cài đặt

  - Quản lý người dùng và group thông qua API của OPS.

- **Nhược điểm**:

  - Keystone sẽ không là một Identity provider.

  - Hỗ trợ password yếu (Không luân chuyển pasword để xác thực và không hỗ trợ lấy lại password)

  - Hầu hết các doanh nghiệp đều có một LDAP server mà họ muốn sử dụng.

  - Identity silo: không nhớ username và password của người dùng phải nhớ. 

<a name = "2.2"></a>
## 2.2. LDAP

- Keystone cũng có một cách để lấy và lưu trữ thông tin Actor của bạn trong Lightweight Directory Access Protocol (LDAP). Keytone sẽ truy cập LDAP như là một ứng dụng muốn sử dụng LDAP (System login, Email. Ứng dụng Web, … )

- Việc cài đặt cho kết nối tới LDAP phải được xác định trong file cấu hình của Keystone. 

- Những tùy chọn này cũng bao gồm khả năng viết lên LDAP hoặc đơn giản là đọc thông tin dữ liệu LDAP. 

- Một các lý tưởng thì LDAP nên chỉ thực hiện thao tác đọc – như là tìm kiếm user và group và xác thực (via bind).

- Nếu sử dụng LDAP như là một Identity backend chỉ đọc, Keystone  nên cần một lượng nhỏ quyền để sử dụng LDAP. Ví dụ, nó cần đọc truy cập tới các thông số của user và group được định nghĩa trong keystone.conf, một tài khoản không có quyền (người dùng ẩn danh truy cập) và nó không yêu cầu truy cập với password hashes. 

- Keystone nên sử dụng một internal LDAP cho các ứng dụng khác:

<img src ="http://imgur.com/7aDwDRw.jpg">

- **Ưu điểm:** 

  - Không cần duy trì các bản coppy của tài khoản người dùng. 

  - Keystone không hoạt động như một Identity Provider.

- **Nhược điểm:**

  - Các tài khoản dịch vụ vẫn cần lưu trữ ở đâu đó, và damin LDAP có thể không muốn những tài khoản này trong LDAP.

  - Keystone vẫn “thấy” được password của người dùng, vì pasword nằm trong yêu cầu xác thực. Keystone đơn giản chi chuyển tiếp các request này, nhưng lý tưởng hơn vẫn là Keystone không nhìn thấy password của người dùng. 

<a name = "2.3"></a>
## 2.3. Multiple backends

- Từ bản Julo, Keystone hỗ trợ multiple Identity backend cho V3 Identity API. Tác động của việc này là triển khai một nguồn identity (backen) cho mỗi Keystone domain.

- Domain default thì thường sử dụng SQL backend, vì nó được sử dụng để lưu trữ các tài khoản dịch vụ. các tìa khoản dịch vụ là các tài khoản của các dịch vụ OPS khác nhau mà sử dụng để tương tác với Keystone.

- Các tùy chọn cho LDAP backend có thể được lưu trữ trong từng domain của họ. Cảm hứng của việc hỗ trợ nhiều công nghệ Identity backend là một thiết lập của doanh nghiệp. nhà quản trị LDAP có thể không cùng tổ chức nhưng đội triển khai OPS, nên tạo các tài khoản dịch vụ trong LDAP thì rất khó xảy ra. LDAP thông thường bị hạn chế để sử dụng chỉ cho các thông tin của nhân viên. 

- Lợi ích khác của việc phân chia hợp lý giữa các Identity backend và domain là bây giờ, nhiều LDAP có thể được sử dụng. Do vậy, trong trường hợp một công ty với nhiều văn phòng khác nhau có thể có LDAP khác nhau.

<img src ="http://imgur.com/8DDG68x.jpg">

- **Ưu điểm:**

  - Có thể đồng thời hỗ trợ nhiều LDAP cho các tài khoản người dùng và SQL backend cho các tài khoản dịch vụ.

  - Tận dụng được Identity LDAP hiện có mà không làm ảnh hưởng tới nó. 

- **Nhược điểm:**

  - Rõ ràng là phưc tạp hơn cho việc thiết lập.

  - Việc xác thực cho tài khoản user có thể bị hạn chế trong domain.

<a name = "2.4"></a>
## 2.4. Identity providers

Từ phiên bản Icehose, Keystone đã hỗ trợ xác thực kiểu liên kết thông qua modul của Apache cho việc tin vào một số nhà cung cấp việc định danh (Identity Provider) tin cậy. 

<img src ="http://imgur.com/wVOBfeC.jpg">

- Những user này không được lưu trữ trong Keystone, và được coi là không bền vững. Các user liên kết này sẽ có các thông số của họ được map vào trong một nhóm dựa trên role assignment. Từ quan điểm của Keystone, một identity provider là một nguồn dành cho việc định danh. Nó có thể là phần mềm mà được hỗ trợ bởi nhiều loại backend (LDAP, AD, MongoDB) hoặc các liên kết mạng xã hội (Google, Facebook, twitter).

- Về cơ bản, nó là một phần mềm (ví dụ như Tivoli Federated Identity Manager của IBM) mà lấy ra các backend và translates các thông số của người dùng ra một định dạng giao thức định danh liên kết (SAML, OpenID Connect). 

- Lợi ích này trong Keystone là một kế hoạch lớn để giảm tải sự xác thực và định danh liên quan tới các dịch vụ định danh mà đã tồn tại sẵn trong doanh nghiệp. Tuy nhiên nó cũng có một số ưu và nhược điểm sau: 


- **Ưu điểm:** 

  - Có thể tận dụng các kiến trúc và phần mềm xác thực người dùng đã tồn tại và lấy thông tin của user.

  - Tách biệt Keystone và việc xử lý các thông tin định danh.

  - Mở ra cánh cửa mới cho khả năng liên kết, như giữa hệ thống cloud và hệ thống hybrid cloud.

  - Keystone không thấy được bất kì pass word nào của user.

  - Identity Provider hoàn toàn xử lý quá trình định danh, nên dù nó có là password, certificate hoặc dựa trên cả 2 thì cũng không liên quan tới Keystone.

- **Nhược điểm:** Gây phức tạp nhất trong quá trình thiết lập.

<a name = "2.5"></a>
## 2.5. Các trường hợp sử dụng Identity backend

<img src ="http://imgur.com/VPWaAcu.jpg">

<a name = "3"></a>
# 3. Authentication

Có nhiều cách để xác thực với dịch vụ keystone – nhưng có 2 cách thông thường nhất là thực hiện bởi pasword hoặc sử dụng token. 

Sau đây sẽ tìm hiểu kĩ hơn về 2 phương pháp xác thực bởi cách show ra dữ liệu trong POST request tới Keystone và luồng làm việc giữa các User, Keystone và các dịch vụ khác của OPS.

<a name = "3.1"></a>
## 3.1. Password

- Đây là cách thông thường nhất cho một user hoặc dịch vụ xác thực bằng pasword. Payload được show ra sau đây là POST request tới Keystone. 

- Nó thì hữu ích để show ra cá thông tin payload để người đọc nhận ra thông tin cần thiết để xác thực:

<img src ="http://imgur.com/DfbG4b1.jpg">

- Payload của request phải chứa đủ thông tin để tìm ra được sự tồn tại, xác thực user, và thêm vào đó – lấy và các catalog dịch vụ dựa trên quyền hạn truy cập của user trong phạm vi (project)

- Section `user` mà định danh thông tin user tới nên có thông tin về **domain** (tên hoặc ID của domain), trừ khi thông tin định danh ID của **user** là duy nhất trên global, trong trường hợp đó vừa đủ để định danh được cho user. Bởi vì trong môi trường triển khai nhiều **domain**, có thể có nhiều user có tên giống nhau, do đó cung cấp phạm vi phù hợp là cần thiết để quyết định xác thực cho user. 

- Section `scope` là tùy chọn nhưng thường được sử dụng, vì nếu không có **scope**, user sẽ không thế lấy được **catalog** các service. Phạm vi scope được sử dụng để chỉ ra project nào mà user được phép làm việc. Nếu user không có role trên project đó, thì request sẽ bị từ chối. giống như trong section user, section scope phải đủ thông tin về project để tìm được nó, do vậy phần domain phải được xác định. Vì trong trường hợp của các user và các group, tên project có thể xung đột giữa các domain (có thể trùng tên nhau). Id của project được đảm bảo là duy nhất và nếu được xác định, thông tin về domain là không cần thiết.

<img src ="http://imgur.com/mSEiAOu.jpg">

<a name = "3.2"></a>
## 3.2. Token

- Giống như trên, một user có thể cũng yêu cầu một token mới bằng cách cung cấp token hiện tại. payload của POST request này thì ít hơn đáng kể so với phần của pasword. Có nhiều lý do tại sao một token sẽ được sử dụng cho nhiều mục đích khác nhau như là refresh lại một token mà sắp hết hạn hoặc bị đổi thành token không còn giá trị phạm vi sang token còn giá trị phạm vi truy cập. 

<img src ="http://imgur.com/pWbUhqc.jpg">

- 

<img src ="http://imgur.com/mAZyhgF.jpg">

- Một user request một token bằng cách sử dụng token đang tồn tại. Kết quả là token sẽ có cùng scope và role với token ban đầu.

<a name = "4"></a>
# 4. Access management and Authorization

- Việc quản lý truy cập và xác thực những API nào mà user có thể sử dụng là một trong những nhiệm vụ chính của Keystone trong OPS. Cách tiếp cận của keystone tới  vấn đề này là tạo một Role-based Access Control (RBAC – chính sách kiểm soát truy cập dựa trên vai trò) và thực hiện trên mọi public API endpoind. Những chính sách này được lưu trữ dưới dạng một file trên ổ đĩa, thông thường được đặt tên là policy.json.

- Sau đây là tóm tắt một ví dụ về file policy.json của keystone, bao gồm các target và rule.

- Targets là các giá trị ở bên trái và rule là các giá trị ở bên phải. Ở đầu file, các targets được thiết lập để có thể được sử dụng cho việc đánh giá của các target khác nhau. Dưới đây chúng ta định nghĩa như nào là admin, owner ..

<img src ="http://imgur.com/lFADIgR.jpg">

- Mỗi rule mà bắt đầu với identity: và chỉ định một protected controller để quản lý một API. 

- Bảng sau mô tả sự mapping full 1:1 cho các thông tin có thể tìm thấy trong Keystone: 

<img src ="http://imgur.com/CPAtnwT.jpg">

- Quan trọng phải lưu ý sự khác nhau giữa việc liệt kê các project và liệt kê các user của project. Liệt kê tất cả các project có thể chỉ hoạt động với quyền admin, và chính sách của nó là được phép ghi. Liệt kê tất cả các project mà một user được phép truy cập không chỉ hạn chế với quyền của admin, mà còn tới user mà có role trên project đó. 

<a name = "5"></a>
# 5. Backends và Services

Các dịch vụ Keystone cung cấp và hệ thống backend hỗ trợ triển khai các dịch vụ đó thể hiện trong hình sau:

<img src ="http://imgur.com/EPX24C9.jpg">


<a name = "6"></a>
# 6. Một só lưu ý

### Region và Domain

\- Region được hiểu là đại diện cho vị trí Địa lý: ví dụ: một doanh nghiệp có thể có văn phòng miền Đông Mỹ và môt văn phòng ở Bắc Mỹ. 

\- Domain là sự phân tách hợp lý giữa việc làm chủ các project và tài nguyên định danh. 

### Một user chỉ có thể tồn tại trong một domain

\- Mỗi user chỉ được một domain làm chủ.

\- Các domain khác nhau có thể có các người dùng có tên trùng nhau (nghĩa là có thể có user stevemar trong domain IBM và user stevemar trên domian Acme Inc). Nhưng mỗi user chỉ có một định danh ID duy nhất.

### Tenants và project 

\- Trong những ngày đầu, tenant được sử dụng bởi dịch vụ của OPS để là thực thể cho việc gom nhóm và cô lập tài nguyên. 

\- Qua thời gian, project đã trờ nên trực quan hơn cho khái niệm này. Thật không may, không phải tất cả của project có thể truyền tải đầy đủ tenant sang project. 

\- Do đó, trong một vài trường hợp, các dịch vụ và tài liệu của OPS bạn vẫn có thể nhìn thấy tenant.


### Scoped và unscoped token

\- Một **Unscoped token** là khi người dùng được xác thực nhưng lại không xác định được domain hoặc project, loại này hữu ích khi sử dụng làm truy vấn như quyết định xem project nào mà user được phép truy cập.

\- **Scoped token** được tạo khi user được xác thực cho một project hoặc một domain. Scoped token có thông tin về role được kết nối với chúng và là loại token được sử dụng bởi các dịch vụ khác nhau của OPS để kiểm tra xem các hoạt động nào là được phép thực hiện. 

<a name = "7"></a>
# 7. Tham khảo

[1] Book: Identity, Authentication, and Access Management in OpenStack – Author: Steve Martinelli, Henry Nash, and Brad Topol - Copyright © 2016 Steve Martinelli, Henry Nash, and Brad Topol. All rights reserved.

