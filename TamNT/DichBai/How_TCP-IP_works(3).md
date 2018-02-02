# How TCP/IP Works

### ***Mục lục***

[TCP/IP Protocol Architecture ](#1)

[IPv4 Addressing ](#2)

[Name Resolution ](#3)

[IPv4 Routing ](#4)

[Physical Address Resolution ](#5)

[Related Information ](#6)

---

TCP/IP cho IPv4 là giao thức mạng phù hợp với người sử dụng Microsoft Windows để kết nối thông qua Internet với các máy tính khác. Nó tương tác với dịch vụ tên miền Windows như DNS và các công nghệ bảo mật, chủ yếu như IPsec, bởi giúp tạo điều kiện thuận lợi cho chuyển thành công và bảo mật các gói tin giữa các máy.

Lý tưởng nhất là TCP/IP được sử dụng với bất cứ máy tính Window nào truyền thông qua mạng.

Chủ đề chính bài viết này là mô tả các thành phần của bộ giao thức TCP/IP, kiến trúc giao thức, chức năng TCP/IP thực hiện, cách các địa chỉ được cấu trúc và phân công, và các cách gói tin được tạo ra và định tuyến.

Microsoft Windows Server 2003 cung cấp sự hỗ trợ rộng rãi cho bộ giao thức TCP/IP (Transmission Control Protocol/Internet Protocol), như là một giao thức và tập hợp các dịch vụ cho kết nối và quản lý mạng IP. Kiến thức các khái niệm cơ bản của TCP/IP là một yêu cầu tất nhiên cho sự hiểu biết chính xác về cấu hình, triển khai và xử lý sự cố của máy chủ Window 2003 và mạng intranet Microsoft Windows 2003.

<a name = '1'></a>
# TCP/IP Protocol Architecture

Các giao thức TCP/IP được chia thành 4 layer (4 lớp) chính được biết tới là mô hình DAPRA - được đặt tên theo cơ quan Chính phú Mĩ hình thành và phát triển TCP/IP. 4 layer của mô hình DAPRA là: Application (tầng Ứng dụng), Transport (tầng Chuyển vận), Internet (tầng kết nối, Internet), và Network Interface layer. Mỗi lớp trong mô hình DAPRA có trách nhiệm cho 1 hoặc nhiều hơn một lớp của 7 lớp trong mô hình OSI.

Hình sau mô tả kiến trúc bộ giao thức TCP/IP:

![img](./images/3.1.png)

>> Lưu ý: Mô hình kiến trúc trên tưng ứng với giao thức mạng TCP/IP và không phản ánh tương tứng với IPv6. Để xem kiến trúc tương ứng IPv6, xem "How IPv6 Works" ở phần tham chiếu.

## Network Interface Layer

Lớp Network Interface (hay lớp Network Access) xử lý các gói tin TCP/IP vào phương tiện mạng (medium - môi trường truyền gói) và nhận gói tin từ medium. TCP/IP được thiết kế độc lập với các phương thức truy cập mạng, định dạng frame, và medium. Theo cách này, TCP/IP có thể được sử dụng để kết nối tới các loại mạng khác nhau; môi trường mạng LAN như Ethernet và Token Ring, công nghệ WAN như X.25 và Frame Relay. Sự độc lập với các phương tiện truyền thông mạng (medium) cho phép TCP/IP đáp ứng với các medium mới như mạng ATM (Asynchronouse transfer mode).

Network Interface layer gồm các lớp Data Link và Physical layer trong mô hình OSI. Lưu ý rằng lớp Internet không tận dụng các dịch vụ xác định tuần tự SEQ (sequencing) và ACK (acknowledgment) có thể có trong lớp Network Interface. Một Network interface layer không tin cậy được gia định, và truyền tin cậy thông qua sự thiết lập session và đánh thứ tự, ACK của gói tin là chức năng của lớp Transport. 

## Internet layer

Internetl layer xử lý việc đánh địa chỉ, đóng gói gói tin và định tuyến. Giao thức lõi của Internet layer là IP, ARP, ICMP và IGMP.

- Internet Protocol (IP) là một giao thức có thể định tuyến mà xử lý việc đánh địa chỉ, định tuyến, và phân mảnh cũng như ghép lại các gói tin.

- Giao thức phân giải địa chỉ (Address Resolution Protocol - ARP) xử lý phân giải ngược từ địa chỉ lớp Internet thành địa chỉ lớp Network Interface, như là địa chỉ phần cứng.

- Giao thức ICMP (Internet Control Message Protocol) có chức năng chẩn đoán và báo lỗi do việc truyền gói tin IP không thành công.

- Giao thức IGMP (Internet Group Management Protocol) quả lý các IP thuộc nhóm IP multicast.

Lớp Internet tương tự như lớp Network trong mô hình OSI.

## Transport Layer

Lớp Transport (hay được biết như là Host-to-Host layer) xử lý việc cung cấp cho lớp Application session và các dịch vụ truyền dữ liệu. Giao thức chính của Transport layer là Transmission Control Protocol (TCP) và User Datagram Protocol (UDP).

- TCP cung kết nối một - một, kết nối có hướng và truyền tin cậy. TCP thực hiện thiết lập một kết nối TCP, đánh số gói tin và xác nhận xem sự nhận được của gói tin đã gửi, và truyền lại các gói bị mất trên đường truyền. 

- UDP cung cấp kết nối một - một hoặc một - nhiều, không hướng kết nối, truyền không tin cậy. UDP được sử dụng khi số lượng dữ liệu cần truyền là nhỏ (như dữ liệu phù hợp với một gói duy nhất), khi bạn không muốn phải thực hiện quá trình thiết lập một kết nối TCP, hoặc khi các ứng dụng hoặc các giao thức lớp trên cung cấp sự truyền tin cậy. 

Lớp Transport trong mô hình TCP/IP tương ứng với lớp Transport trong mô  hình OSI.

## Application Layer

Lớp Ứng dụng _ Application layer cho phép các ứng dụng truy cập các dịch vụ của các lớp khác và định nghĩa các giao thức mà ứng dụng sử dụng để trao đổi dữ liệu. Có nhiều giao thức lớp Ứng dụng và nhiều giao thức mới đang được phát triển.

Các giao thức lớp Ứng dụng được biết đến rộng rãi là các giao thức dùng để trao đổi thông tin người dụng:

- HTTP (Hypertex Transfer Protocol) được sử dụng để truyền các file mà tạo nên trang web của www (World Wide Web).

- FTP (File Transfer Protocol) được sử dụng để tương tác truyền file.

- SMTP (Simple Mail Transfer Protocol) được sử dụng cho việc chuyển mail và đính kèm.

- Telnet - giao thức mô phỏng thiết bị đầu cuối, được sử dụng để đăng nhập từ xa đến các máy trong mạng.

Hơn nữa, các giao thức lớp Ứng dụng sau còn giúp tạo điều kiện cho việc sử dụng và quản lý các mạng TCP/IP:

- DNS (Domain Name System) được sử dụng để phân giải tên miền sang địa chỉ IP.

- RIP (Routing Information Protocol) là giao thức định tuyến mà router sử dụng để trao đổi thông tin định tuyến trong một mạng IP.

- SNMP (Simple Network management Protocol) được sử dụng giữa một trình điều khiển mạng và các thiết bị mạng (router, bridge, hub thông minh) để thu thập và trao đổi thông tin quản lý mạng. 

Các ví dụ về giao diện cho các ứng dụng TCP/IP là Window Sockets và NetBIOS. Windows Sockets cung cấp một giao diện chương trình ứng dụng (Application Programming Interface - API) dưới Windows Server 2003. NetBIOS là mọt giao diện chuẩn công nghiệp cho việc truy cập các dịch vụ giao thức như là session, datagram, và phân giải tên miền. Tìm hiểu kĩ hơn thông tin về Windows Sockets và NetBIOS ở phần sau.

Lớp Application có trách nhiệm tương đương như lớp Session, Presentation và lớp Application trong mô hình OSI.

## TCP/IP core Protocols

Các giao thức thành phần TCP/IP được cài đặt trên hệ điều hành mạng là một chuỗi các giao thức kết nối được gọi là giao thức lõi của TCP/IP. Tất cả các ứng dụng và giao thức khác trong bộ giao thức TCP/IP đều dựa trên các dịch vụ cơ bản được cung cấp bởi các giao thức: IP, ARP, ICMP, IGMP, TCP và UDP.

### IP

IP là giao thức không hướng kết nối và truyền không tin cậy, có nhiệm vụ chính là đánh địa chỉ và định tuyến gói tin giữa các host. Không hướng kết nối (Connectionless) nghĩa là phiên kết nối không được thiết lập trước khi truyền dữ liệu. Không tin cậy (Unreliable) nghĩa là việc truyền gói tin không được đảm bảo. IP luôn luôn thực hiện truyền tổng lực (best effort) một gói tin. Một gói tin IP có thẻ bị mất, truyền không đúng thứ tự, truyền gấp đôi hoặc bị trễ. IP không cố gắng phục hồi các lỗi này. Gói tin ACK được gửi và tìm ra sự mất gói là chức năng của giao thức lớp cao hơn, như là TCP. IP được định nghĩa trong RFC 791.

Một gói tin IP gồm IP header và IP payload. Bảng sau mô tả các trường chính trong phần IP header:

#### Key Fields in the IP Header

| Các trường IP header | Chức năng|
|----------------------|----------|
| Địa chỉ nguồn | Địa chỉ IP của máy nguồn sinh ra gói tin|
| Địa chỉ IP đích| Địa chỉ đích đến cuối cùng của gói tin |
| Identification | Được sử dụng để định danh datagram của gói tin và định danh tất cả các mảnh của một gói tin nếu có sự phân mảnh xảy ra.|
| Protocol | thông báo cho máy chủ đích gói tin IP đang chứa segment của giao thức TCP, UDP, ICMP hoặc các giao thức khác. |
| Checksum |  Phép toán đơn giản được sử dụng để xác minh sự toàn vẹn của IP header. |
| Tim-to-live (TTL) | Chỉ định số lượng segment mà gói tin được phép chuyển đi trước khi bị bỏ qua bởi router, TTL được thiết lập bởi máy gửi và được sử dụng để tránh các gói tin lưu thông không ngừng trong mạng IP.  chuyển tiếp một gói tin IP, các router sẽ được yêu cầu giảm TTL đi 1.|

#### Fragmentation and reassembly (Phân mảnh và ghép)

Nếu một router nhận được một gói tin IP mà nó quả lớn để chuyển trong mạng, gói tin sẽ bị phân mảnh từ gói tin ban đầu thành các gói tin nhỏ hơn phù hợp với băng thông của mạng. Khi các gói tin được chuyển tới đích cuối cùng, máy đích sẽ ghép các mảnh lại thành payload ban đầu. Quá trình xử lý này gọi là Fragmentation and Reassembly (Phân mảnh và ghép mảnh gói tin). Phân mảnh có thể xảy ra trong các môi trường kết hợp giữa các loại media mạng khác nhau như: Ethernet và Token Ring.
Phân mảnh và ghép mảnh làm việc như sau:

- Khi một gói tin được gửi bởi nguồn, nó được đánh dấu với một giá trị duy nhất trong trường Identification.

- Gói tin IP được nhận tại router. Router lưu ý về MTU của mạng mà gói tin sắp được chuyển tiếp có nhỏ hơn kích thước của gói tin hay không.

- Gói tin IP phần payload được phân thành các mảnh phù hợp với mạng kế tiếp. Mỗi mảnh được gửi với địa chỉ IP header của chính nó và bao gồm:

	- Trường **Identification** ban đầu đánh dấu giống nhau trên mọi mảnh của cùng một gói tin IP ban đầu.

	- Cờ **More Fragments Flag** chỉ ra rằng còn có mảnh nữa của gói tin theo sau mảnh này. Cờ **More Fragments Flag** không được set ở mảnh cuối cùng của gói tin bởi không còn mảnh nào theo sau nó nữa.

	- Trường **Fragment Offset** chỉ ra vị trí của mảnh so với payload ban đầu của gói tin.

Khi các mảnh được nhận bởi máy đích, chúng được định danh bởi trường **Identification** để xác định cùng thuộc về một gói tin. Rồi sau đó sử dụng trường **Fragment Offset**  để ghép các mảnh để được lại gói tin IP ban đầu.

### ARP

Khi gói tin IP được gửi trên một môi trường mạng chia sẻ sự truy nhập, truy nhập băng rộng - như Ethernet hoặc Token Ring - cần phải ánh xạ địa chỉ IP sang địa chỉ MAC để có thể chuyển tiếp các gói tin trong các môi trường này. ARP sử dụng broadcast tại lớp MAC để biết được địa chi MAC của địa chỉ IP tiếp theo forward tới. ARP được định nghĩa trong RFC 826.

### ICMP

Giao thức ICMP cung cấp sự thuận tiện cho việc xử lý sự cố và báo cáo lỗi khi gói tin không gửi đi được. Ví dụ, nếu IP không tìm được địa chỉ máy đích, ICMP gửi một bản tin Destination Unreachable về máy nguồn. Bảng sau mô tả một số bản tin ICMP hay gặp:

| ICMP message | Chức năng |
|--------------|-----------|
| Echo Request | Bản tin được sử dụng để kiểm tra kết nối tới máy đích. Công cụ `ping` sẽ gửi các bản tin ICMP Echo Request. |
| Echo Reply | Đáp trả cho một bản tin ICMP Echo Request. |
| Redirect | Gửi bởi một router để thông báo cho máy gửi một tuyến đường tốt hơn để tới địa chỉ đích. |
| Source Quench | Gửi bởi router dể thông báo tới máy gửi là IP datagram đã bị drop bởi sự tắc nghẽn xảy ra tại router. Máy gửi sẽ gửi lại với tốc độ chậm hơn. Source Quench là một bản tin ICMP tùy ý và thường không xuất hiện. |
| Destination Unreachable | Được gửi bưởi router hoặc máy đích để thông báo cho máy gửi rằng không thể gửi gói tin. |

Bảng sau mô tả các bản in ICMP Destination Unreachable hay gặp nhất:

| Destination Unreachable Message | Mô tả |
|---------------------------------|-------|
|Host Unreachable | Được gửi bởi router khi không tìm thấy định tuyến tới địa chỉ đích. |
| Protocol Unreachable | Được gửi bởi máy đích khi trường **Protocol** trong IP header không hợp với giao thức mà client hiện tại đã load. |
| Port Unreachable | Được gửi bởi máy đích khi Cổng đích trong UDP header không match với tiến trình sử dụng cổng đó. |
| Fragmentation Needed and DF Set | Được gửi bởi router khi phân mảnh phải xảy ra nhưng lại không được cho phép vì máy gửi thiết lập cờ **Dont't Fragment (DF)** trong IP header (không cho phép phân mảnh gói tin). |
| Source Route Failed | Được gửi bởi router khi gửi gói tin IP sử dụng thông tin định tuyến gốc (được lưu trữ dưới dạng định tuyến gốc ở các option của header) không thành công. |

ICMP không làm IP trở thành một giao thức đáng tin cậy. ICMP cố gắng báo lỗi và cung cấp phản hổi về các điều kiện cụ thể. Các bản tin ICMP được chuyển như là các gói tin ACK của gói tin IP và tự chúng cũng là không đáng tin cậy. ICMP được định nghĩa trong RFC 792. 

### IGMP

Internet Group management Protocol (IGMP) là một giao thức mà các bản tin từ các máy thành viên trong một nhóm IP multicast trong cùng một segment mạng. Một nhóm IP multicast được gọi là một nhóm máy chủ, là các máy được thiết lập cho lắng nghe các lưu lượng dành cho địa chỉ IP multicast cụ thể. Lưu lượng IP multicast được gửi đến từ một địa chỉ MAC duy nhất nhưng được xử lý bởi nhiều máy chủ IP. Một máy host cụ thể lắng nghe trên địa chỉ IP multicast cụ thể và nhận tất cả các gói tin được gửi tới địa chỉ đó.

Sau đây là một số thông tin bỏ sung về IP multicast:

- Các thành viên trong nhóm có thể thay đổi được, host có thể tham gia hoặc rời khỏi nhóm bất kì lúc nào.

- Một nhóm host có thể có bất kì kích thước nào.

- Các thành viên trong một nhóm group có thể  đi qua router qua nhiều mạng. Tình huống này yêu cầu IP multicast hỗ trợ trên router và có khả năng cho các host đăng kí thành thành viên nhóm với các local router. Sự đăng kí được thực hiện bằng cách sử dụng IGMP.

- Một host có thể gửi lưu lượng tới một địa chỉ IP multicast mà không cần thuộc về nhóm đó. 

Với một host khi nhận được IP multicast, một ứng dụng phải thông báo rằng nó sẽ nhận multicast tại địa chỉ IP multicast cụ thể đã chỉ định. Nếu công nghệ mạng hỗ trợ đa nhiệm dựa trên phần cứng, giao diện mạng được yêu cầu truyền các gói tin cho một IP multicast cụ thể. Trong trường hợp Ethernet, bộ chuyển đổi mạng (network adapter) được lập trình để đáp ứng một địa chỉ MAC multicst tương ứng với địa chỉ IP multicast đã chỉ định. 

Một host hỗ trợ IP multicast ở một trong các mức sau:

- Mức 0: Không hỗ trợ gửi và nhận các lưu lượng IP multicast.

- Mức 1: Hỗ trợ gửi nhưng không hỗ trợ nhận lương lượng IP multicast.

- Mức 2: Hỗ trợ cả gửi và nhận lưu lượng IP multicast. Windows Server 2003, Windows 2000, Mircrosoft Windows NT phiên bản 3.5 và sau đó, và TCP/IP hỗ trợ mức 2 cho IP multicast.

Giao thức được sử dụng để đăng ký tham gia vào nhóm multicast là IGMP, yêu cầu tất cả các host phải hỗ trợ IP multicast ở mức 2. Các gói tin IGMP được gử đu sử dụng một IP header. 

Bản tin IGMP có 3 form:

- **Host Membership Report**: Khi một host tham gia vào nhóm, nó sẽ gửi một bản tin IGMP Host Membership Report tới tất cả các host trong địa chỉ IP multicast (224.0.0.1) hoặc tới một địa chỉ IP multicast cụ thể để thông báo nó sẽ là thành viên của nhóm đang tham chiếu tới địa chỉ IP multicast đó. Một host có thể xác định các nguồn cụ thể từ lưu lượng multicast là cần thiết. 

- **Host Membership Query**: Khi một router thăm dò một mạng để đảm bảo rằng có các thành viên của một nhóm host cụ thể, nó gửi một bản tin IGMP Host Membership Query tới tất cả các host có địa chỉ IP multicast. Nếu không có phản hồi nào cho việc thăm dò sau vài lần, router sẽ giả định rằng không có thành viên của nhóm trong mạng đó và ngừng quảng bá thông tin nhóm multicast đó cho các router khác. 

- **Group Leave**: Khi một host không còn quan tâm đến việc nhận lưu lượng multicast được gửi đến từ một IP multicast cụ thể và nó đã gửi đi bản tin IGMP Host Membership Report trong phản hồi một IGMP Host Membership Query, nó gửi một bản tin IGMP Group Leave tới địa chỉ IP multicast cụ thể. Local router xác nhận rằng host gửi IGMP Group Leave là thành viên cuối cùng của nhóm cho địa chỉ IP multicast trên subnet đó. Nếu không cso phản hồi thăm dò sau khi thăm dò vài lần, router giả định rằng không còn thành viên nào trong nhóm trên subnet đó và ngừng quảng bá thông tin multicast tới các router khác.

Với IP multicast qua các router trong một mạng, các giao thức định tuyến multtcast được sử dụng để truyền thông tin các nhóm host để mỗi router hỗ trợ chuyển tiếp multicast biết được mạng nào đang có thành viên của nhóm nào. IGMP được định nghĩa trong RFCs 1112 và 2236.

### TCP 

TCP là dịch vụ truyền tin cậy và hướng kết nối. Dữ liệu được truyền trong các segment. Hướng kết nối có nghĩa là một kết nối phải được thiết lập trước khi các host trao đổi dữ liệu. Tin cậy đạt được bằng cách đánh số thứ tự trên mỗi segment được truyền đi, một Acknowledgment được sử đụng dể xác nhận rằng dữ liệu đã được nhận. Với mỗi segment được gửi, host nhận được phải gửi về một ACK xác nhận trong một khoảng thời gian xác định cho việc byte đã nhận được. Nếu không nhận được ACK, dữ liệu sẽ được gửi lại. TCP được định nghĩa trogn RFC 793.

TCP sử dụng kết nối byte-stream, trong đó, dữ liệu trong TCP segment được xử lý như một dãy các byte không có ranh giới dữ liệu. Bảng sau mô tả các trường chính trong TCP header:

| Trường | Chức năng |
|--------|-----------|
|Source Port | Cổng TCP của host gửi. |
| Destination Port | Cổng TCP của host đích. |
| Sequence Number | Số thứ tự của byte đầu tiên của dữ liệu trong TCP segment. |
| Acknowledgment Number | Số thử tự của byte mà người gửi mong muốn được nhận tiếp từ phía bên kia của kết nối. |
| Window | Kích thước hiện tại của bộ đệm TCP trên host gửi TCP segment này để lưu các segment đang đến. |
| TCP checksum | Xác nhận sự toàn vẹn bit dữ liệu của TCP header và TCP data. |

#### **TCP port**

TCP port cung cấp vị trí cụ thể để truyền các TCP segment. Số hiệu port dưới 1024 là các port đã được biết và đã được đăng kí bởi IANA (Internet Assigned Numbers Authority). bảng sau liệu kê một số TCP port đã sử dụng:

| TCP Port Number | Mô tả |
|-----------------|-------|
|20 | FTP (kênh truyền data)|
|21 | FTP (kênh điều khiển) |
| 23 | Telnet |
| 80 | HTTP được sử dụng cho WWW |
| 139 | dịch vụ của NetBIOS |

#### TCP three-way handshake (bắt tay 3 bước)

Một kết nối TCP được thiết lập thông qua quá trình bắt tay 3 bước. Mục đích của bắt tay 3 bước là đồng bộ số sequence number và ACK number giữa cả 2 bên kết nối và trao đổi kích thước cửa sổ (window) hoặc sử dụng kích thước cửa sổ lớn hơn hoặc TCP timestamps. Các bước xử lý như sau:

1. Bắt đầu thiết lập kết nối TCP, thường là một client, gửi một TCP segment tới server với một Sequence Number cho kết nối và một kích thước cửa sổ ban đầu ứng với kích thước bộ đệm của client để lưu các segment đến từ server. 

2. Phản hồi của kết nối TCP, thường là một server, gửi trả lại một TCP segment chứa số Sequence Number lựa chọn ban đầu, một ACK ứng với Sequence Number của client, và kích thước cửa sổ ban đầu được sinh ra ứng với kích thước bộ đệm mà server lưu các segment đang đến từ client. 

3. Phía đầu tiên gửi một TCP segment tới server chứa một ACK của Sequence Number của server. 


TCP sử dụng quá trình tương tự để xử lý đóng kết thúc kết nối. Việc này đảm bảo cho các host các bên đã hoàn thành truyền kết nối và tất cả data đều đã được nhận. 

### UDP

UDP cung cấp dịch vụ datagram không hướng kết nối mà cho phép sự không tin cậy nhưng truyền tổng lực (best-effort) các bản tin dữ liệu cần truyền đi. Điều này nghĩa là không có datagram cùng như không có cơ chế đánh thứ tự gói tin để việc truyền tin được đảm bảo. UDP không phục hồi lại dữ liệu đã mất bằng cách truyền lại. UDP được định nghĩa trong RFC 768.

UDP được sử dụng bưởi các ứng dụng mà không yêu cầu ACK cho những dữ liệu đã nhận được và thường truyền số lượng nhỏ dữ liệu trong cùng một thời điểm. NetBISO name service, NetBIOS datagram service, và SNMP là các dịch vụ và ứng dụng điển hình sử dụng UDP. Bảng sau mô tả các trường chính trong UDP header:

| Tên trường | Chức năng |
|------------|-----------|
| Source Port | UDP port của host gửi |
| Destination Port | UDP port của host đích |
|UDP checksum | Xác nhận độ toàn vẹn dữ liệu mức bit của UDP header và UDP  data |

**UDP port**

Để sử dụng UDP, một ứng dụng phải cung cấp địa chỉ IP và UDP port của ứng dụng đích cần gửi đến. Một port cung cấp vị trí cho việc gửi bản tin. Các chức năng của một port như là một hàng đợi bản tin đa kênh, nghĩa là nó có thể nhận nhiều bản tin trong cùng một thời điểm. Mọi port được định nghĩa bởi một số hiệu duy nhất. Quan trọng là các UDP port khác biệt và phân tách so với TCP port mặc dù một vài trong số chúng sử dụng port giống nhau. Bảng sau liệt kê một số UDP port đã biết:

| UDP port Number | Mô tả |
| 53 | Dành cho dịch vụ truy vấn DNS |
| 69 | Giao thức truyền file TFTP |
| 137 | dịch vụ NetBIOS name |
| 138 | NetBIOS datagram service |
| 161 | SNMP |


## TCP/IP Application Interfaces

Với các ứng dụng truy để cập các dịch vụ được cấp bởi các giao thức TCP/IP core theo cách tiêu chuẩn, hệ điều hành mạng như Windows Server 2003 thực hiện các giao diện lập trình ứng dụng (API) tiêu chuẩn có sẵn. Các API là các bộ chức năng và các lệnh lập trình được gọi bưởi code ứng dụng để thực hiện chức năng mạng. Ví dụ, một ứng dụng trình duyệt Web kết nối tới Web site cần truy cập vào dịch vụ thiết lập kết nối của TCP.

Hình sau cho thầy 2 thành phần chung của TCP/IP API, Windows Socket và NetBIOS, và quan hệ của chúng :

### Các API cho TCP/IP 

![img](./images/3.2.png)

#### **Windows Sockets Interface**

Windows Socket API là một chuẩn API dưới quyền hệ điều hành Windows Server 2003 cho các ứng dụng sử dụng TCP và UDP. Các ứng dụng được viết cho Windows Sockets API chạy trên nhiều phiên bản của TCP/IP, các tiện ích TCP/IP và dịch vụ SNMP là các ví dụ về các ứng dụng được viết cho Windows Socket interface.

Windows Socket cung cấp các dịch vụ cho phép các ứng dụng tìm được port cụ thể và địa chỉ IP trên một host, khởi tạo và chấp nhận một kết nối, gửi và nhận dữ liệu, và đóng một kết nối. Có 2 kiểu socket: 

- Stream socket cung cấp 2 chiều, tin cậy, tuần tự và ngăn sao chép luồng dữ liệu sử dụng TCP. 

- Datagram socket cung cấp luồng 1 chiều và 2 chiều dữ liệu sử dụng UDP.

Một socket được định nghĩa bằng một giao thức và một địa chỉ trên host. Định dạng địa chỉ được xác định tùy theo từng giao thức. Trong TCP/IP, địa chỉ là sự kết hợp giữa địa chỉ IP và port. 2 socket, một bên mỗi phía của kết nối, tạo ra một đường truyền hai hướng. 

Để truyền thông, một ứng dụng xác định giao thức, địa chỉ IP của host đích, và cổng của ứng dụng đích cần gửi đến. Sau khi ứng dụng được kết nối, thông tin có thể được gửi và nhận.

#### **NetBIOS interface**

NetBIOS cho phép các ứng dụng truyền thông trong một mạng. NetBIOS định nghĩa 2 thực thể, giao diện mức session và quản lý session và một giao thức truyền dữ liệu. 

NetBIOS interface là một API chuẩn cho các ứng dụng người dùng để chấp nhận các luồng I/O trong mạng và chỉ thị điều khiển cho giao thức phần mềm dưới lớp mạng. Một chương trình sứng dụng mà sử dụng NetBIOS interface API cho truyền thông qua mạng có thể chạy trên bất kì phần mềm giao thức nào mà hỗ trợ NetBIOS interface. 

NetBIOS cũng đĩnh nghĩa một giao thức mà các chức năng ở mức session/transport. Điều này được thực hiện bằng các phần mềm giao thức bên dưới (như NetBIOS Frames Protocol NBFP - một phần của NetBEUI hoặc NetBIOS qua TCP/IP (NetBT), thực hiện yêu cầu vào ra (I/O) của mạng đẻ đáp ứng lệnh NetBIOS interface). NetBIOS qua TCP/IP được định nghĩa trong RFC 1001 và 1002. NetBT mặc định được kích hoặc, tuy nhiên, Windows Server 2003 cho phép bạn vô hiệu NetBT trong một môi trường mà không chứa client hoặc ứng dụng dựa trên NetBIOS. 

NetBIOS cung cấp các lệnh và hỗ trợ cho NetBIOS Name Management, NetBIOS Datagrams, và NetBIOS Sessions.

#### **NetBIOS name management**

NetBIOS name management là dịch vụ cung cấp các chức năng sau: 

- **Name registration and release**: Khi một TCP/IP host khởi tạo, nó đăng kí với NetBIOS của chính nó bằng cách quảng bá hoặc chuyển hướng các yêu cầu đăng kí tới một NetBIOS Name Server như một WINS server. Nếu đã có host nào đó đã đăng kí cùng tên NetBIOS name, hoặc host hoặc NetBIOS Name Server phản hồi với một phản hồi đăng kí tên tiêu cực. Kết quả, host khởi tạo nhận được một lỗi khởi tạo. Khi dịch vụ máy trạm trên một host ngwngfm host không tiếp tục quảng bá phản hồi đăng kí tên tiêu cức khi một máy khác cố sử dụng tên và gửi release name tới một NetBIOS Name Server. NetBIOS name đã được sử dụng cho host khác. 

- **Name Resolution** : Khi một ứng dụng NetBIOS muốn liên kết với một ứng dụng NetBIOS khác, địa chỉ IP của ứng dụng NetBIOS phải được phân giải. NetBT đảm nhận chức năng này bằng cách quản bá truy vấn tên NetBIOS trên mạng cục bộ hoặc gửi một truy vấn tên NetBIOS tới một NetBIOS Name Server. 

Dịch vụ NetBIOS name sử dụng UDP cổng 137.

#### **NetBIOS datagram**

Dịch vụ NetBIOS datagram cung cấp việc chuyển các datagram không hwogns kết nối, không tuần tự và không tin cậy, Datagram có thể được chuyển hướng tới một NetBIOS name hoặc quảng bá tới một nhóm tên. Việc chuyển này là không tin cậy mà chỉ các user đăng nhập vào mạng nhận được bản tin. Datagram service cả quản bá và chuyển hướng bản tin. NetBIOS datagram seervice sử dụng UDP port 138.

#### **NetBIOS sessions***

Dịch vụ NetBIOS session cung cấp việc chuyển các bản tin NetBIOS có hướng liên kết, tuần tự và đáng tin cậy. NetBIOS session sử dụng kết nối TCP và cung cấp thiết lập kết nối, keepalive và giải phóng. Dịch vụ NetBIOS cho phép truyền dữ liệu đồng thời theo cả 2 hướng sử dụng TCP port 139. 