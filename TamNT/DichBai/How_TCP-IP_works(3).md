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

## TCP/IP cỏe Protocols

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


