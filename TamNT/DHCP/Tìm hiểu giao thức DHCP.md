# TÌM HIỂU GIAO THỨC DHCP

## ***Mục lục***

[1. Giới thiệu DHCP](#1)

- [1.1. Đặt vấn đề](#1.1)

- [1.2. Đặc điểm DHCP](#1.2)

- [1.3. Cơ chế phân giải bổ địa chỉ của DHCP server](#1.3)

- [1.4. Vòng đời và thời gian "thuê" địa chỉ IP của client](#1.4)

[2. Tiến trình hoạt động của DHCP](#2)

- [2.1. Các loại bản tin DHCP](#2.1)

- [2.2. Tiến trình hoạt động của DHCP](#2.2)

  - [2.2.1.  Quá trình cấp phát địa chỉ IP](#2.2.1)

  - [2.2.2. Quá trình xin cấp phát lại địa chỉ IP](#2.2.2)

  - [2.2.3. Quá trình Renew và Rebind](#2.2.3)


[3. Cấu trúc gói tin DHCP](#3)

[4. Phân tích bản tin DHCP bằng Wireshark](#4)

- [4.1. Chuẩn bị](#4.1)

- [4.2. Phân tích](#4.2)

[5. Tham khảo](#5)

---

<a name = '1'></a>
# 1. Giới thiệu DHCP

<a name="1.1"></a>
## 1.1. Đặt vấn đề

- DHCP là giao thức phân giải địa chỉ động, lịch sử phát triển của nó phát triển ban đầu từ giao thức RARP, phát triển lên BOOTP và cuối cùng được cải tiến lên DHCP do nhu cầu cải tiến kĩ thuật mạng.

- **RARP** là một giao thức mạng sơ khai được dùng bởi các máy client để yêu cầu có một địa chỉ Ipv4 để sử dụng cho mục đích liên lạc với các máy khác trong trạm. (thời kì đầu, khi mới có địa chỉ IP và các máy bắt đầu dùng địa chỉ IP để liên lạc thay cho địa chỉ MAC). Hạn chế của RARP là giao thức lớp 2, chỉ cấp địa chỉ IP và không cấp thêm một thông tin nào khác, là giao thức cấp địa chỉ tĩnh sơ khai và còn cần nhiều sự tương tác của người quản trị mạng khi phải cấu hình thông tin trên RARP server trước.

- **BOOTP**: 

  - RARP rõ ràng là không đủ sức cung cấp thông tin cấu hình TCP/IP cho các máy tính. Để hổ trợ vừa cho các máy tính không có đĩa cứng vừa cho việc cấu hình TCP/IP tự động, vì thế mà BOOTP (Bootstrap) được tạo ra. BOOTP được tạo ra để giải quyết các hạn chế của RARP.

  - Nó vẫn còn dựa vào quan hệ client/server, nhưng nó được triển khai ở tầng cao hơn, dùng UDP cho việc vận chuyển. Nó không còn phụ thuộc vào phần cứng đặc biệt nào của nhà sản xuất như là RARP.

  - Hỗ trợ gởi thêm thông tin tới máy client ngoài địa chỉ IP.Thông tin thêm này thường được gởi trong một thông điệp duy nhất.

  - Nó có thể sử dụng trong môi trường client và server ở trong những hệ thống mạng gồm nhiều NetID khác nhau. Điều này cho phép quản lý địa chỉ IP tập trung ở một server. 

  - Sử dụng IP/UDP (port 67 cho địa chỉ đích của server, và port 68 cho địa máy client) và do đó, có thể di chuyển qua router. Đây là một lợi thế vì có thể dùng giao thức phân giải địa chỉ qua môi trường liên mạng LAN.

  - Nhưng bên cạnh đó, nó vẫn còn một số hạn chế là không cấp được địa chỉ IP động khi mà nhu cầu cấp địa chỉ động trở thành rõ rệt hơn bao giờ hết khi Internet thực sự khởi đầu cất cánh vào cuối thập niên 1990 và việc gán địa chỉ IP tĩnh và dùng mãi cho mỗi máy để chúng kết nối vào mạng là một phí phạm.

  ***=>*** Cải tiến BOOTP thành DHCP. 

- **DHCP (Dynamic Host Configuration Protocol)**  được tạo nên từ phần mở rộng của giao thức Boot Protocol (BOOTP). Từ cái tên DHCP đã mô tả một khả năng quan trọng mới được thêm vào BOOTP: khả năng gán địa chỉ IP một cách ***dynamically***. Chuyển từ cấp phát địa chỉ IP tĩnh sang cấp phát địa chỉ IP động là cách mà DHCP làm.

  - DHCP là giao thức cấu hình host động được thiết kế làm giảm thời gian cấu hình cho mạng TCP/IP bằng cách tự động gán các địa chỉ IP cho client khi họ vào mạng.

  - DHCP ngày nay là giao thức cấu hình host được sử dụng ở hầu khắp mọi nơi trong mô hình mạng gia đình tới mạng doanh nghiệp.

<a name="1.2"></a>
## 1.2. Đặc điểm DHCP

Do là giao thức được tạo nên từ phần mở rộng trong phần tùy chọn của BOOTP, nên DHCP gần giống với BOOTP.

  - Cũng làm việc theo mô hình Client/Server.

  - Sử dụng cổng đặc biệt cho DHCP server là cổng 67. Các DHCP server lắng nghe trên cổng 67 cho các bản tin broadcast request được gửi bởi client. Sau khi xử lý bản tin request, server gửi một bản tin reply lại cho client.

  - Các DHCP client lắng nghe bản tin reply lại từ DHCP server trên cổng 68.


- **Chức năng**:

  - Mỗi thiết bị trên mạng cơ sở TCP/IP phải có một địa chỉ IP duy nhất để truy cập mạng các các tài nguyên của nó. Không có DHCP, cấu hình IP phải được thực hiện một các thủ công cho các máy tính mớ, các máy tính di chuyển từ mạng con này sang mạng con khác, và các máy tính đợc lại bỏ khỏi mạng.

  - Bằng việc phát triển DHCP trên mạng, toàn bộ tiến trình này được quản lý tự động và tập trung. DHCP server bảo quản vùng của các địa chỉ IP và giải phóng một địa chri với bất cứ DHCP client có theer khi nó có thể ghi lên mạng. bởi vì các địa chri IP là động hơn tĩnh, các địa chri không còn được trả lại một cách tự động trong sử dụng đối với các vùng cấp phát lại.

- **Ưu điểm**:

  -	Tập trung quản trị thông tin cấu hình IP.
  - Cấu hình động các máy 
  -	Cấu hình IP cho các máy một cách liền mạch.
  -	Sự linh hoạt
  -	Khả năng mở rộng.
  -	Đơn giản hóa vài trò quản trị của việc cauas hình địa chỉ IP của client.

<a name="1.3"></a>
## 1.3. Cơ chế phân giải bổ địa chỉ của DHCP server 

2 chức năng chính của DHCP là cung cấp một cơ chế gán địa chỉ cho các máy host và phương thức mà client có thể yêu cầu một địa chỉ IP và các thông tin cấu hình cho nó từ server. 

DHCP gồm 3 cơ chế phân bổ địa chỉ khác nhau:

- **Manual Allocation:** Một địa chỉ IP cụ thể được cấp phát trước cho một thiết bị duy nhất bởi người quản trị. DHCP chỉ truyền IP tới các thiết bị đó (hiểu như là server, router, gateway, ... ). Nó cũng thích hợp cho các thiết bị khác mà vì lý do gì phải có một địa chỉ IP cố định ổn định.

- **Automatic Allocation:** DHCP tự động gán một địa chỉ IP vĩnh viễn với một thiết bị, chọn từ một pool IP có sẵn. Sử dụng trong trường hợp có đủ địa chỉ IP cho mỗi thiết bị có thể kết nối vào mạng, nhưng mà thiết bị không thực sự cần quan tâm đến địa chỉ mà nó sử dụng. Khi một địa chỉ được gán cho một client, thiết bị sẽ tiếp tục sử dụng nó. Automatic Allocation được coi là một trường hợp đặc biệt của Dynamic Allocation – dùng trong trường hợp các giới hạn thời gian sử dụng các địa chỉ IP của một client gần như là “mãi mãi”.

- **Dynamic Allocation:** DHCP gán một địa chỉ IP từ một pool các địa chỉ trong một khoảng thời gian hạn chế được lựa chọn bởi server, hoặc cho đến khi client nói với DHCP server là nó không cần địa chỉ này nữa. 

  -	Server sẽ quyết định số lượng thừi gian mà hợp đồng cho thuê IP sẽ kéo dài. Khi hết thời gian, client hoặc phải xin phép tiếp tục sử dụng các địa chỉ (đổi mới thuê) hoặc phải có được một cấu hình mới. 

  -	Phương pháp này cung cấp nhiều lợi ích như: 

      - *Automation*: mỗi client có thể được tự động gán IP khi nó cần mà không cần tới sự can thiệp của người quản trị viên để quyết định địa chỉ cho client đó.

      - *Quản lý tập trung*: tất cả các IP được quản lý bởi DHCP server. Người quản trị có thể dễ dàng tìm tháy những thiết bị đang sử dụng mà giải quyết và thực hiện nhiệm vụ bảo trì mạng.

      - *Tái sử dụng và chia sẻ địa chỉ IP*: bằng cách giới hạn thười gian mà mỗi client được phép thuê IP, DHCP server có thể đảm bảo rằng các pool IP chỉ được sử dụng bởi các thiết bị đang hoạt động. Sau một khoảng thời gian, IP nào không được sử dụng nữa sẽ được trở về lại pool để cho phép các client khác sử dụng chúng. Điều này cho phép một liên mạng để hỗ trợ một số lượng thiết bị lớn hơn số địa chỉ IP sẵn có, miễn là tất cả các thiết bị kết nối mạng cùng lúc. 

      - *Khả năng di chuyển giữa các mạng*: với việc dynamic allocation, không có sự phân bổ địa chỉ IP nào được xác định trước, do đó bất kỳ client nào đều có thể yêu cầu một IP. Điều này làm cho nó trở thành một lựa chọn lý tưởng cho việc hỗ trợ các thiết bị di động và di chuyển giữa các mạng.

      - *Tránh các vấn đề xung đột*: Vì địa chỉ IP đều được xác định từ một pool và quản lý bởi máy chủ DHCP nên việc xung đột IP là có thể tránh được.

    - Đây là cơ chế được sử dụng nhiều nhất trong các mô hình mạng hiện nay.

<a name="1.4"></a>
## 1.4. Vòng đời và thời gian "thuê" địa chỉ IP của client

Khi một client được thiết lập để sử dụng DHCP, nó sẽ không bao giờ có quyền hạn sở hữu IP đó lâu dài. Mỗi lần có quyền hạn sử dụng, nó phải thỏa thuận liên kết với một DHCP server để bắt đầu hoặc xác nhận thuê một IP. Nó cũng phải thực hiện các hoạt động khác theo thời gian để quản lý việc thuê địa chỉ này và có thể chấm dứt nó.

Vòng đời thuê IP của DHCP gồm các bước sau:

- **Allocation:** Một client bắt đầu khi chưa từng thuê IP và do đó chưa có địa chỉ được cấp từ DHCP server. Nó yêu cầu thuê thông qua một quá trình phân bổ Allocation.

- **Reallocation**: Nếu client đã có sẵn địa chỉ IP lần thuê hiện tại, và sau đó khi nó khởi động lại sau khi tắt, nó sẽ liên lạc với DHCP server để xác nhận việc thuê và dùng lại các thông số vận hành. Điều này được gọi là Reallocation, nó tương tự như Allocation nhưng ngắn hơn.

- **Normal Operation:** Khi một hợp đồng cho thuê đang hoạt động, client được gán vào một địa chỉ mà DHCP server cấp phát, cho thuê.

- **Renewal**: Sau một phần thời gian nhất định của thời gian cho thuê, client sẽ cố gắng liên lạc với máy chủ cho thuê ban đầu, gia hạn thêm hợp đồng để nó có thể tiếp tục sử dụng IP đó sau khi thời gian cho thuê kết thúc (thường sau nửa thời gian được phép sử dụng IP, client sẽ liên lạc với DHCP server để gia hạn thêm hợp đồng)

- **Rebind:** Nếu việc renewal không thành (giả sử máy server bị tắt), sau đó client sẽ cố gắng kết nối lại với bất kì máy chủ DHCP nào đang hoạt động, cố gắng mở rộng thời gian cho thuê hiện tại.

- **Release:** client có thể quyết định ở bất kì thời điểm nào đó nó không còn muốn sử dụng địa chỉ IP được cấp từ DHCP nữa, và có thể chấm dứt hợp đồng cho thuê, giải phóng địa chỉ IP. 

- Hình sau mô tả vòng đời hoạt động của DHCP:

<img src="http://imgur.com/JAl1JIe.jpg">



Renewal timer thông thường bằng 50% thời gian client thuê IP (Lease time).

Rebind timer thông thường bằng 87.5% lease time.


<a name="2"></a>
# 2. Các loại bản tin DHCP

<a name="2.1"></a>
## 2.1. Các loại bản tin DHCP

-	**DHCP DISCOVER**: Ban đầu, một máy tính DHCP Client muốn gia nhập mạng, nó yêu cầu thông tin địa chỉ IP từ DHCP Server bằng cách gửi broadcast một gói DHCP Discover. Địa chỉ IP nguồn trong gói là 0.0.0.0 bởi vì client chưa có địa chỉ IP.

-	**DHCP OFFER**: Mỗi DHCP server nhận được gói DHCP Discover từ client đáp ứng với gói DHCP Offer chứa địa chỉ IP cho thuê và thông tin định cấu hình TCP/IP bổ sung(thêm vào), chẳng hạn như subnet mask và gateway mặc định. Nhiều hơn một DHCP server có thể đáp ứng với gói DHCP Offer. Client sẽ chấp nhận gói DHCP Offer đầu tiên nó nhận được.

-	**DHCP REQUEST:** Khi DHCP client nhận được một gói DHCP Offer, nó đáp ứng lại bằng việc broadcast gói DHCP Request mà chứa yêu cầu địa chỉ IP mà server cung cấp trong bản tin offer - thể hiện sự chấp nhận của địa chỉ IP được yêu cầu từ một server xác định.

-	**DHCP ACK:**  DHCP server được chọn lựa chấp nhận DHCP Request từ Client cho địa chỉ IP bởi việc gửi một gói DHCP Acknowledge (ACK). Tại thời điểm này, Server cũng định hướng bất cứ các tham số định cấu hình tuỳ chọn. Sự chấp nhận trên của DHCP Acknowledge, Client có thể tham gia trên mạng TCP/IP và hoàn thành hệ thống khởi động. (Bản tin này gần như giống nội dung bản tin OFFER)

-	**DHCP NAK:** Nếu địa chỉ IP không thể được sữ dụng bởi client bởi vì nó không còn giá trị nữa hoặc được sử dụng hiện tại bởi một máy tính khác, DHCP Server đáp ứng với gói DHCP Nak, và Client phải bắt đầu tiến trình thuê bao lại. Bất cứ khi nào DHCP Server nhận được yêu cầu từ một địa chỉ IP mà không có giá trị theo các Scope mà nó được định cấu hình với, nó gửi thông điệp DHCP Nak đối với Client.

-	**DHCP DECLINE:** Khi client nhận được thông tin cấu hình từ DHCP server, nhưng có thể xảy ra vấn đề là IP mà DHCP server cấp đã bị sử dụng bởi một thiết bị khác thì nó gửi gói DHCP Decline đến các Server và Client phải bắt đầu tiến trình thuê bao lại từ đầu. 

-	**DHCP RELEASE:** Một DHCP Client khi không còn nhu cầu sử dụng IP hiện tại nữa nó sẽ  gửi một gói DHCP Release đến server quản lý để giải phóng địa chỉ IP và xoá bất cứ hợp đồng thuê bao nào đang tồn tại.

-	**DHCP INFORM:** Các thiết bị không sử dụng DHCP để lấy địa chỉ IP vẫn có thể sử dụng khả năng cấu hình khác của nó. Một client có thể gửi một bản tin DHCP INFORM để yêu cầu bất kì máy chủ có sẵn nào gửi cho nó các thông số để mạng hoạt động. DHCP server đáp ứng với các thông số yêu cầu – được điền trong phần tùy chọn của DHCP trong bản tin DHCP ACK.

 Quá trình hoạt động của DHCP và FSM của client:

<img src="http://imgur.com/ijagCba.jpg">

Mô tả các trạng thái của client tham khảo thêm tại: http://www.tcpipguide.com/free/t_DHCPGeneralOperationandClientFiniteStateMachine.htm


<a name="2.2"></a>
## 2.2. Các tiến trình hoạt động của DHCP

3 tiến trình của DHCP là: Lease Allocation Process (Quá trình cấp phát địa chỉ IP), Lease Reallocation Process (Quá trình xin cấp phát lại IP đã xác định trước) và quá trình Renew and Rebind (Quá trình gia hạn thêm thời gian được phép sử dụng IP)

<a name="2.2.1"></a>
### 2.2.1. Quá trình cấp phát địa chỉ IP

Quá trình xử lý quan trọng nhất trong DHCP là quá trình Lease Allocation, được sử dụng bởi client để yêu cầu một hợp đồng thuê IP. Client gửi broadcast một request tới DHCP server. Mỗi DHCP server sẵn sàng cung cấp cho client một hợp đồng thuê và gửi lại cho nó một bản tin Offer. Client chọn bản hợp đồng mà nó nhận được và gửi lại tới tất cả các server về sự lựa chọn của nó. Server được chọn sẽ gửi lại cho client thông tin và hợp đồng thuê. Các bước được thực hiện như sau:

<img src="http://imgur.com/idvUI3q.jpg">

**Bước 1**: Client tạo bản tin DHCPDISCOVER 

  Ban đầu, Client chưa có địa chỉ IP và nó có thể biết hoặc không biết vị trí của DHCP server trong mạng. Để tìm DHCP server, nó tạo bản tin DHCP DISCOVER, bao gồm các thông tin như sau:

  - Điền địa chỉ MAC vào trường CHAddr để xác nhận nó.

  - Sinh ra một số định danh transaction ngẫu nhiên và điền vào trường XID.

  - Client có thể yêu cầu một địa chỉ IP xác định sử dụng trường tùy chọn Request IP Address trong phần DHCP option.


**Bước 2**: Client gửi bản tin DHCP DISCOVER

Client gửi broadcast bản tin DHCP DISCOVER trên mạng nội bộ. (Broadcast lớp 2 và lớp 3)


**Bước 3**: Server nhận và xử lý bản tin DHCP DISCOVER

Mỗi DHCP server trên mạng LAN nhận được bản tin DHCP DISCOVER của client và kiểm tra nó. Server tìm kiếm phần địa chỉ MAC của client trong database và chọn cho nó một IP phù hợp đồng thời các thông số liên quan. Nếu client yêu cầu một IP xác định thì server sẽ xử lý yêu cầu nó. Server có thể quyết định việc nó dùng địa chỉ IP chỉ định kia là hợp lệ hay không để gửi reply về.

**Bước 4**: Server tạo bản tin DHCP OFFER

Mỗi server được chọn trả lời lại cho client tạo bản tin DHCP OFFER bao gồm các thông tin sau:

  - Địa chỉ IP cấp phát cho client trong trường YIAddr. Nếu trước đó, client đã "thuê" một địa chỉ IP và thời hạn dùng của nó vẫn còn thì sẽ sử dụng địa chỉ cũ đó cho client. Nếu không thì nó sẽ chọn một IP có sẵn bất kì cho client.

  - Thời hạn được sử dụng IP.

  - Các thông số cấu hình khác mà client yêu cầu.

  - Định danh của DHCP server trong phần tùy chọn DHCP Server Identifier option.

  - Cùng số  XID được sử dụng trong bản tin DHCP DISCOVER.

**Bước 5**: Server dò tìm xem địa chỉ IP mà cấp phát cho client đã được một thiết bị nào khác sử dụng hay chưa.

Trước khi gửi bản tin DHCP OFFER cho client, server nên kiểm tra lại xem địa chỉ IP cấp cho client đã được sử dụng hay chưa bằng cách gửi bản tin ICMP. 

Nếu IP đó đã được sử dụng thì nó sẽ chọn lại địa chỉ IP khác cho client. 

Nếu IP chưa được sử dụng, server sẽ cấp phát IP cho client.

**Bước 6**: Các Server gửi bản tin DHCPOFFER

Mỗi server gửi bản tin DHCP OFFER của nó. Chúng có thể được gửi unicast hoặc broadcast tùy thuộc vào client (Nếu client cho phép nhận bản tin unicast khi chưa được cấu hình IP thì nó sẽ set bit B trong bản tin DHCP DISCOVER là 0, còn nếu không thì nó sẽ set bit B là 1 để biểu thị nhận bản tin broadcast)

**Bước 7**: Client nhận và xử lý bản tin DHCPOFFER

Client nhận bản tin DHCP OFFER và nó sẽ chọn lựa server nào mà nó nhận được bản tin DHCP OFFER đầu tiên. Nếu không nhận được bản tin DHCP OFFER nào sau một thời gian, client sẽ tạo lại bản tin DHCP DISCOVER và gửi lại từ đầu.

**Bước 8**: Client tạo bản tin DHCP REQUEST

Client tạo bản tin DHCP REQUEST cho server mà nó chọn nhận bản tin OFFER. Bản tin này sẽ gồm 2 mục đích chính là nói với server mà cho phép cấp phát IP cho nó là nó đồng ý dùng IP đó trong trường hợp IP đó vẫn còn dành cho nó và cũng thông báo với các DHCP server còn lại là bản tin OFFER của chúng không được nhận. 

Trong bản tin này bao gồm các thông tin: 

- Định danh của server được chọn trong phần SEerver Identifier option.

- Địa chỉ IP mà DHCP server cho phép client trong bản tin DHCP OFFER, client để vào phần Request IP Address DHCP option.

- Và một số thông tin cấu hình mà nó muốn trong phần Parameter Request List option.

**Bước 9:** Client gửi bản tin DHCP REQUEST 

Client gửi broadcast bản tin DHCP REQUEST. Sau đó chờ reply từ server. 

**Bước 10**: Các server nhận và xử lý bản tin DHCP REQUEST

Mỗi server nhận được bản tin REQUEST của client. Các server không được chọn sẽ bỏ qua bản tin này.


**Bước 11:** Server gửi bản tin DHCPACK hoặc DHCPNAK.

Server được chọn sẽ kiểm tra xem địa chỉ IP nó OFFER cho còn sử dụng được hay không. Nếu không còn, nó sẽ gửi lại DHCPNAK (negative acknowledgment). Thông thường, server sẽ vẫn dành địa chỉ IP đó cho client, server sẽ gửi lại bản tin DHCPACK để xác nhận và cấp các thông số mà client yêu cầu.

**Bước 12**: Client nhận bản tin DHCPACK hoặc DHCPACK

Client sẽ nhận lại bản tin DHCPACK hoặc DHCPNAK từ server.

  -  Nếu là DHCPNAK, client sẽ bắt đầu gửi lại DISCOVER từ bước 1.

  - Nếu là DHCPACK, client đọc địa chỉ IP trong trường YIAddr, ghi lại các thông số khác trong phần DHCP option.

  Nếu không nhận được bản tin nào, client sẽ gửi lại DHCP REQUEST một hoặc vài lần nữa. Sau một khoảng thời gian vẫn không nhận được gì, nó sẽ bắt đầu lại từ Bước 1.

**Bước 13**: Client kiểm tra xem IP được sử dụng hay chưa.

Client sẽ kiểm tra lần cuối trước khi xác định chắc chắn IP chưa được thiết bị khác sử dụng trước khi sử dụng nó. Bước này sẽ được thực hiện bởi giao thức ARP trên mạng LAN.

  - Nếu có bất kì thiết bị nào phản hồi lại ARP, client sẽ gửi bản tin DHCP DECLINE lại server để thông báo với server rằng IP đó đã được máy khác sử dụng. Và client trở lại Bước 1. 

  -  Nếu không có phản hồi, client sẽ sử dụng IP. Kết thúc quá trình Lease Allocation.


<a name="2.2.2"></a>
### 2.2.2. Quá trình xin cấp phát lại địa chỉ IP

Có 2 trường hợp mà client thực hiện quá trình Reallocation hơn là Allocation: 
-	Power on with Existing Lease.
-	Reboot

Nếu client khởi động lại và nó đã có sẵn một hợp đồng thuê, nó không cần phải thực hiện lại quá trình full lease allocation, thay vào đó, nó có thể sử dụng quá trình ngắn hơn là Reallocation. Client broadcast một request để tìm server hiện tại đang quản lý thông tin về hợp đồng mà nó đang thuê. Server đó gửi lại để xác nhận xem hợp đồng của client còn hiệu lực hay không.

<img src="http://imgur.com/ITu1HJj.jpg">


Các bước thực hiện tham khảo thêm tại: http://www.tcpipguide.com/free/t_DHCPLeaseReallocationProcess.htm

<a name="2.2.3"></a>
### 2.2.3. Quá trình Renew và Rebind

Do thời hạn của mỗi client khi thuê IP thường đều là có hạn (trừ trường hợp Automatication Allocation) nên cần có quá trình gia hạn (renewal) lại với DHCP server quả lý và nếu quá trình renewal không thành công thì sẽ rebind lại (gửi request) tới bất kì DHCP server khác đang hoạt động để gia hạn hợp đồng.

<img src="http://imgur.com/kqVbTwg.jpg">

Các bước thực hiện tham khảo thêm tại: http://www.tcpipguide.com/free/t_DHCPLeaseRenewalandRebindingProcesses-2.htm 

<a name="3"></a>
# 3. Cấu trúc bản tin DHCP

- DHCP là giao thức được cải tiến từ giao thức BOOTP nên cấu trúc gói tin cũng tương tự như bản tin của BOOTP, nhưng phần dành cho nhà sản xuất của BOOTP được thay thế bằng tùy chọn của DHCP.  

- Một client tạo ra một bản tin sử dựa trên chuẩn định dạng của DHCP, cũng gần giống nhau BOOTP. Khi server reply lại client thì nó không hoàn toàn tạo ra bản tin mới mà chỉ đơn giản là copy lại bản tin request và thay đổi một số field và gửi lại cho client. Một mã đặc biệt là transaction identifier (XID) được thay thế được đặt trong request và duy trì trong reply, cái mà cho phép client biết reply đi với một request xác định.

<img src="http://i.imgur.com/8Hau7Yr.png" >  

| Trường | Dung lượng | Mô tả|
|------- |-------|------|
| Opcode | 1 bytes | Xác định loại message . Giá trị “1” là request message , “2” là reply message|
| Hardware type | 1 bytes | Quy định cụ thể loại hardware.   <img src="http://i.imgur.com/w8uaKb6.png" >|
| Hardware length | 1 bytes | Quy định chiều dài của hardware address |
|Hop counts |1 bytes|Set bằng “0” bởi client trước khi truyền request và được sử dụng bởi relay agent để control forwarding của BOOTP và DHCP messages .|
|Transaction Identifier	|4 bytes|Được tạo bởi client, dùng để liên kết giữa request và replies của client và server.|
|Number of seconds |2 bytes|được định nghĩa là số giây trôi qua kể từ khi client bắt đầu cố gắng để có được 1 IP hoặc thuê 1 IP mới . Điều này có thể được sử dụng khi DHCP Server bận , để sắp xếp thứ tự ưu tiên khi có nhiều request từ client chưa được giải quyết .|
|Flags |2 bytes|<img src="http://i.imgur.com/Fd4cj0G.png" >|
|Client IP address |4 bytes|Client sẽ đặt IP của mình trong field này nếu và chỉ nếu nó đang có IP hay đang xin cấp lại IP, không thì mặc định = 0|
|Your IP address |4 bytes|IP address được server cấp cho client|
|Server IP address |4 bytes|IP address của Sever|
|Gateway IP address	|4 bytes|Sử dụng trong DHCP relay agent|
|Client hardware address |16 bytes|Địa chỉ lớp 2 của client, dùng để định danh|
|Server host name |64 bytes|Khi DHCP server gửi DHCPOFFER hay DHCPACK thì sẽ đặt tên của nó vào trường này, nó có thể là “nickname” hoặc tên DNS domain|
|Boot filename |128 bytes|Option được sử dụng bởi client khi request 1 loại boot file trong DHCPDISCOVER message.  Được sử dụng bởi server trong DHCPOFFER để chỉ định path đến boot file directory và filename .|
|Options |Variable||

Các giá trị phần Options tham khảo thêm tại: http://www.tcpipguide.com/free/t_SummaryOfDHCPOptionsBOOTPVendorInformationFields.htm


<a name="4"></a>
# 4. Phân tích bản tin DHCP bằng Wireshark 

<a name="4.1"></a>
## 4.1. Chuẩn bị

- Sử dụng máy Window đã cài đặt Wireshark.

- Release địa chỉ IP đang sử dụng bằng cách gõ các lệnh sau trong cmd:

```
> ipconfig release
> ipconfig renew 
```

  Hoặc đơn giản là tắt card mạng đi bật lại. 

- Capture gói tin trên card đang sử dụng mạng. Lọc các bản tin theo giao thức BOOTP (do DHCP là phần mở rộng cải tiến từ BOOTP nên để lọc DHCP ta vẫn phải lọc gói BOOTP) như sau:

<img src="http://imgur.com/cnBXFSV.jpg">

<a name="4.2"></a>
## 4.2. Phân tích

- **DHCP DISCOVER:** 

Ban đầu khi máy chưa được cấu hình, máy sẽ gửi bản tin DHCP DISCOVER để yêu cầu DHCP server cấp cho một địa chỉ IP: 

<img src="http://imgur.com/B1hx3DS.jpg">

Thông tin phần giao thức DHCP: 

<img src="http://imgur.com/HUaiqJq.jpg">

- **DHCP OFFER**: 

Bản tin DHCP OFFER gửi về từ server cung cấp IP 172.16.79.203 và một số thông tin cho client: 


<img src="http://imgur.com/CjnYzSg.jpg">


- **DHCP REQUEST**: Client gửi request yêu cầu được cấp IP 172.16.79.203 lại cho server và yêu cầu cung cấp thêm một số thông tin trong phần Options: 

<img src="http://imgur.com/Fd9oFmh.jpg">
<img src="http://imgur.com/iNOg1vq.jpg">

- **DHCP ACK**: Server gửi ACK về cho client chấp nhận việc client đã được sử dụng IP 172.16.79.203 và các thông số mà client yêu cầu: 

<img src="http://imgur.com/3SKx5GN.jpg">
<img src="http://imgur.com/7UTWSpK.jpg">


<a name="5"></a>
# 5. Tham khảo

[1] http://quantrimang.edu.vn/he-thong/he-thong-mang-lan/tu-bootp-den-dhcp.htm

[2] http://vdo.vn/cong-nghe-thong-tin/cac-khai-niem-co-ban-ve-dhcp.html

[3] http://www.tcpipguide.com/free/t_DHCPAddressAssignmentandDynamicAddressAllocationan.htm


