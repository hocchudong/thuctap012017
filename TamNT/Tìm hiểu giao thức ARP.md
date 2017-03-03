# **TÌM HIỂU GIAO THỨC ARP**

## <u> ***Mục lục***</u>

[1. Giới thiệu giao thức ARP](#1)

- [1.1. Đặt vấn đề](#1.1)

- [1.2. ARP là gì?](#1.2)

[2. Cấu trúc bản tin ARP](#2)

[3. Cách thức hoạt động của ARP](#3)

- [3.1. Hoạt động của ARP trong mạng LAN](#3.1)

- [3.2. Hoạt động của ARP trong môi trường liên mạng](#3.2)

[4. Các loại bản tin ARP và ARP Caching](#4)

- [4.1. Các loại bản tin ARP](#4.1)

- [4.2. ARP caching](#4.2)

- [4.3. Proxy ARP](#4.3)

[5. Phân tích gói tin ARP sử dụng Wireshark](#5)

[6. Tham khảo](#6)

---


<a name="1"></a>
# 1. Giới thiệu giao thức ARP

## 1.1. Đặt vấn đề

Trong một hệ thống mạng máy tính, có 2 địa chỉ được gán cho máy tính là: 

- **Địa chỉ logic**: là địa chỉ của các giao thức mạng như IP, IPX, ... Loại địa chỉ này chỉ mang tính chất tương đói, có thể thay đổi theo sự cần thiết của người dùng. Các địa chỉ này thường được phân thành 2 phần riêng biệt là phần địa chỉ mạng và phần địa chỉ máy. Cách đánh địa chỉ như vậy nhắm giúp cho việc tìm ra các đường kết nối từ hệ thống mạng này sang hệ thống mạng khác dễ dàng hơn. 

- **Địa chỉ vật lý**: hay còn gọi là địa chỉ **MAC - Medium Access Control address** là địa chỉ 48 bit, dùng để định danh ***duy nhất*** do nhà cung cấp gán cho mỗi thiết bị. Đây là loại địa chỉ phẳng, không phân lớp, nên rất khó dùng để định tuyến.

Trên thực tế, các card mạng (NIC) chỉ có thể kết nối với nhau theo địa chỉ MAC, địa chỉ cố định và duy nhất của phần cứng.

**=>** Do vậy phải có một cơ chế để ánh xạ địa chỉ logic - lớp 3 sang địa chỉ vật lý - lớp 2 để các thiết bị có thể giao tiếp với nhau.

Từ đó, ta có **giao thức phân giải địa chỉ ARP - Address Resolution Protocol** giải quyết vấn đề trên.

<a name="1.2"></a>
## 1.2. ARP là gì?

– ARP là phương thức phân giải địa chỉ động giữa địa chỉ lớp network và địa chỉ lớp datalink. Quá trình thực hiện bằng cách: một thiết bị IP trong mạng gửi một gói tin local broadcast đến toàn mạng yêu cầu thiết bị khác gửi trả lại địa chỉ phần cứng ( địa chỉ lớp datalink ) hay còn gọi là Mac Address của mình.

– ARP là giao thức lớp 2 - Data link layer trong mô hình OSI và là giao thức lớp Link layer trong mô hình TCP/IP.

– Ban đầu ARP chỉ được sử dụng trong mạng Ethernet để phân giải địa chỉ IP và địa chỉ MAC. Nhưng ngày nay ARP đã được ứng dụng rộng rãi và dùng trong các công nghệ khác dựa trên lớp hai.


<a name="2"></a>
# 2. Cấu trúc bản tin ARP

Kích thước bản tin ARP là 28 byte, được đóng gói trong frame Ethernet II nên trong mô hình OSI, ARP được coi như là giao thức lớp 3 cấp thấp.

Cấu trúc bản tin ARP được mô tả như hình sau:

<img src="http://imgur.com/ZmKo5pU.jpg">

- **Hardware type:** 

  - Xác định kiểu bộ giao tiếp phần cứng cần biết.

  - Xác định với kiểu Ethernet giá trị 1.

- **Protocol type:**

  - Xác định kiểu giao thức cấp cao (layer 3) máy gửi sử dụng để giao tiếp.

  - Giao thức dành cho IP có giá trị 0x0800.

- **Hardware address length:** Xác định độ dài địa chỉ vật lý (tính theo đơn vị byte). Địa chỉ MAC nên giá trị của nó sẽ là 6.

- **Protocol address length:** Xác định độ dài địa chỉ logic được sử dụng ở tầng trên (layer 3). Tùy thuộc vào IP sử dụng mà có giá trị khác nhau, hiện tại IPv4 được sử dụng rộng rãi nên trường này sẽ có giá trị là 4 (byte).

- **Operation code:** Xác định loại bản tin ARP mà máy gửi gửi. Có một số giá trị phổ biến:

  - 1 : bản tin ARP request.

  - 2 : bản tin ARP rely.

  - 3 : bản tin RARP request.

  - 4 : bản tin RARP reply.

- **Sender hardware address (SHA):** Xác định địa chỉ MAC máy gửi. 

  - Trong bản tin ARP request: trường này xác định địa chỉ MAC của host gửi request.

  - Trong bản tin ARP reply: trường này xác định địa chỉ MAC của máy host mà máy gửi bên trên muốn tìm kiếm.

- **Sender protocol address (SPA):** Xác định địa chỉ IP máy gửi.

- **Target hardware address (THA):** Xác định địa chỉ MAC máy nhận mà máy gửi cần tìm.

  - Trong bản tin ARP request: Trường này chưa được xác định (nên sẽ để giá trị là: 00:00:00:00:00:00)

  - Trong bản tin ARP reply: Trường này sẽ điền địa chỉ của máy gửi bản tin ARP request.

- **Target protocol address (PTA):** Xác định địa chỉ IP máy gửi (máy cần tìm).

    ***Tìm hiểu thêm một số giá trị cho từng trường [tại đây](http://www.networksorcery.com/enp/protocol/arp.htm).***

<a name="3"></a>
# 3. Cách thức hoạt động của ARP

<a name="3.1"></a>
## 3.1. Hoạt động của ARP trong mạng LAN

<img src="http://imgur.com/LuAg0wt.jpg">

<u> ***Bước 1:*** </u> Máy gửi kiểm tra cache của mình. Nếu đã có thông tin về sự ánh xạ giữa địa chỉ IP và địa chỉ MAC thì chuyển sang <u>***Bước 7***</u>.

<u> ***Bước 2:*** </u> Máy gửi khởi tạo gói tin ARP request với địa chỉ SHA và SPA là địa chỉ của nó, và địa chỉ TPA là địa chỉ IP của máy cần biết MAC. (Trường THA để giá trị toàn 0 để biểu hiện là chưa tìm được địa chỉ MAC)

<u> ***Bước 3:*** </u> Gửi quảng bá gói tin ARP trên toàn mạng (Địa chỉ MAC đích của gói tin Ethernet II là địa chỉ MAC quảng bá ff:ff:ff:ff:ff:ff).

<u> ***Bước 4:*** </u> Các thiết bị trong mạng đều nhận được gói tin ARP request. Gói tin được xử lý bằng cách các thiết bị đều nhìn vào trường địa chỉ Target Protocol Address. 

- Các thiết bị không trùng địa chỉ TPA thì hủy gói tin.

- Thiết bị với IP trùng với IP trong trường Target Protocol Address sẽ bắt đầu quá trình khởi tạo gói tin ARP Reply bằng cách lấy các trường Sender Hardware Address và Sender Protocol Address trong gói tin ARP nhận được đưa vào làm Target trong gói tin gửi đi. Đồng thời thiết bị sẽ lấy địa chỉ MAC của mình để đưa vào trường Sender Hardware Address. Đồng thời cập nhất giá trị ánh xạ địa chỉ IP và MAC của máy gửi vào bảng ARP cache của mình để giảm thời gian xử lý cho các lần sau.

<u> ***Bước 5:*** </u> Thiết bị đích bắt đầu gửi gói tin Reply đã được khởi tạo đến thiết bị nguồn vừa gửi bản tin ARP request. Gói tin reply là gói tin gửi unicast.

<u> ***Bước 6:*** </u> Thiết bị nguồn nhận được gói tin reply và xử lý bằng cách lưu trường Sender Hardware Address trong gói reply như địa chỉ phần cứng của thiết bị đích cần tìm.

<u> ***Bước 7:*** </u> Thiết bị nguồn update vào ARP cache của mình giá trị tương ứng giữa địa chỉ IP và địa chỉ MAC của thiết bị đích. Lần sau sẽ không còn cần tới ARP request.

<a name="3.2"></a>
## 3.2. Hoạt động của ARP trong môi trường liên mạng

Hoạt động của ARP trong một môi trường phức tạp hơn đó là hai hệ thống mạng gắn với nhau thông qua một Router.

- Máy A thuộc mạng A muốn gửi gói tin tới máy B thuộc mạng B. 2 mạng này kết nối với nhau thông qua router C.

- Do các broadcast lớp MAC không thể truyền qua Router nên khi đó máy A sẽ xem Router C như một cầu nối hay một trung gian (Agent) để truyền dữ liệu. Trước đó, máy A sẽ biết được địa chỉ IP của Router C (địa chỉ Gateway)  và biết được rằng để truyền gói tin tới B phải đi qua C.

- Để tới được router C thì máy A phải gửi gói tin tới port X của router C (là gateway trong LAN A). Quy trình truyền dữ liệu được mô tả như sau:

  - Máy A gửi ARP request để tìm MAC của port X.

  - Router C trả lời, cung cấp cho A địa chỉ MAC của port X.

  - Máy A truyền gói tin tới port X của router C (với địa chỉ MAC đích là MAC của port X, IP đích là IP máy B).

  - Router C nhận được gói tin của A, forward ra port Y. Trong gói tin có chứa địa chỉ IP máy B, router C sẽ gửi ARP request để tìm MAC của máy B.

  - Máy B sẽ trả lời router C MAC của mình, sau đó router sẽ gửi gói tin của A tới B.

  <img src="http://imgur.com/XXIaITr.jpg">


 Trên thực tế ngoài dạng bảng định tuyến này người ta còn dùng phương pháp **proxy ARP** (sẽ tìm hiểu phần sau), trong đó có một thiết bị đảm nhận nhiệm vụ phân giải địa chỉ cho tất cả các thiết bị khác. Theo đó các máy trạm không cần giữ bảng định tuyến nữa Router C sẽ có nhiệm vụ thực hiện, trả lời tất cả các ARP request của tất cả các máy.

<a name="4"></a>
# 4. Các bản tin ARP và ARP Caching

<a name="4.1"></a>
## 4.1. Các bản tin ARP

- **ARP probe**: Đây là loại bản tin ARP dùng để máy thăm dò xem địa chỉ mà máy được cấp phát (cấu hình manual hoặc DHCP, ...) có bị trùng với địa chỉ IP của máy nào trong cùng mạng hay không. Khi mới ban đầu, các máy đều thực hiện broadcast bản tin ARP này.

  - Bản tin này có cấu trúc địa chi IP của máy gửi là 0.0.0.0 (thể hiện máy gửi bản tin này chưa xác định IP, đồng thời cũng là để các máy khác trong mạng không cập nhật MAC của máy vào ARP caching - vì nó chưa được gán IP cụ thể nào)

  - Địa chỉ MAC đích là 00:00:00:00:00:00

  - Địa chỉ IP đích là địa chỉ IP mà máy gửi được cấp phát.

  - Thông thường bản tin ARP request này sẽ không có reply.

  - Hình minh họa: [Bản tin ARP probe bắt được từ wireshark.](#5.3) 

- **ARP announcements**: ARP cũng sử dụng một cách đơn giản để thông báo tới các máy trong mạng khi địa chỉ IP hoặc địa chỉ MAC của nó thay đổi. Đó chính là bản tin **gratuitous ARP**

  - Bản tin Gratuitous ARP được gửi broadcast request trong mạng với địa chỉ MAC và IP máy gửi là địa chỉ sau khi thay đổi.

  - Địa chỉ MAC đích là 00.00.00.00.00.00. Địa chỉ IP đích là chính nó. Điều này đảm bảo các máy trong mạng khi nhận được bản tin này sẽ chỉ cập nhật địa chỉ MAC và IP của máy gửi vào trong ARP caching của mình => không có bản tin reply cho bản tin này.

  - Hình minh họa: [Bản tin Gratuitous ARP bắt được từ Wireshark.](#5.4)
  
- **ARP request**: Là bản tin ARP request mà máy gửi gửi broadcast để tìm địa chỉ MAC của máy nhận.

  - Địa chỉ MAC và IP gửi là địa chỉ của máy gửi.

  - Địa chỉ MAC nhận được set là 0 hết.

  - Địa chỉ IP nhận là địa chỉ IP của máy cần tìm. 

  - Hình minh họa: [Một bản tin request của máy 192.168.1.100 tìm MAC của gateway trong mạng: 192.168.1.1.](#5.1)

- **ARP reply**: Là bản tin mà máy nhận sau khi nhận được ARP request sẽ đóng gói lại MAC của mình và gửi bản tin reply về cho máy gửi.

  - Nó sẽ đóng gói là địa chỉ IP và MAC của mình vào địa chỉ SHA và PHA.

  - Địa chỉ mà máy gửi gửi tới nó sẽ được đóng gói và phần địa chỉ THA và TPA.

  - Gửi bản tin unicast.

  - Hình minh họa: [Bản tin do gateway gửi địa chỉ MAC của mình về cho máy 192.168.1.100 trong mạng.](#5.2)


<a name="4.2"></a> 
## 4.2. ARP Caching

ARP là một giao thức phân giải địa chỉ động. Quá trình gửi gói tin Request và Reply sẽ tiêu tốn băng thông mạng. Chính vì vậy càng hạn chế tối đa việc gửi gói tin Request và Reply sẽ càng góp phần làm tăng khả năng họat động của mạng. 

**=>** Từ đó sinh ra nhu cầu của ARP Caching.

Ngoài việc làm giảm lưu lượng mạng, ARP cache cũng đảm bảo độ phân giải các địa chỉ thường dùng là nhanh chóng, đảm bảo hiệu suất hoạt động tổng thể của mạng. 

ARP Cache có dạng giống như một bảng tương ứng giữa địa chỉ hardware và địa chỉ IP. 

 (Trong Window: dùng câu lệnh `arp -a` trong Command Prompt để show ra ARP cache trong máy)

<img src="http://imgur.com/shN0JQo.jpg">

- Có hai cách đưa các thành phần tương ứng vào bảng ARP :

  - **Static ARP Cache Entries:** Đây là cách mà các thành phần tương ứng trong bảng ARP được đưa vào lần lượt bởi người quản trị. Công việc được tiến hành một cách thủ công.
   
    - Sử dụng trong trường hợp mà các workstation nên có static ARP entry đến router và file server nằm trong mạng. Điều này sẽ hạn chế việc gửi các gói tin để thực hiện quá trình phân giải địa chỉ.

    - Sử dụng câu lệnh `arp -s ip_addr mac_addr`để thêm một Static ARP entri vào ARP cache.

    - Nhược điểm: ngoài hạn chế của việc phải nhập bằng tay, static cache còn thêm hạn chế nữa là khi địa chỉ IP của các thiết bị trong mạng thay đổi thì sẽ dẫn đến việc phải thay đổi ARP cache.

  - **Dynamic ARP Cache Entries:** Đây là quá trình mà các thành phần địa chỉ hardware/IP được đưa vào ARP cache một cách hoàn toàn tự động bằng phần mềm sau khi đã hoàn tất quá trình phân giải địa chỉ. 

    - Chúng được lưu trong cache trong một khoảng thời gian và sau đó sẽ được xóa đi.

    - Dynamic Cache được sử dụng rộng rãi hơn vì tất cả các quá trình diễn ra tự động và không cần đến sự tương tác của người quản trị.

- Trong môi trường mạng thực tế, có nhiều lý do tác động dẫn tới sự ảnh hưởng làm thay đổi các thông tin về việc ánh xạ IP và MAC nên các thông tin trong dynamic cache sẽ được tự động xóa sau một khoảng thời gian nhất định. Quá trình này được thực hiện một cách hoàn toàn tự động khi sử dụng ARP với khoảng thời gian thường là 10 hoặc 20 phút (hoặc lâu hơn tùy vào loại thiết bị mà mình sử dụng, phụ thuộc nhà cung cấp). Sau một khoảng thời gian nhất định được lưu trong cache , thông tin sẽ được xóa đi. Lần sử dụng sau, thông tin sẽ được update trở lại. (đây là lúc mà các bản tin **ARP announcements** phát huy tác dụng).

*Sử dụng thêm một số câu lệnh với ARP caching [tại đây](https://technet.microsoft.com/en-us/library/cc940021.aspx)*.

<a name="4.3"></a>
## 4.3. Proxy ARP

ARP được thiết kế cho các thiết bị nằm trong nội mạng, có tính chất local. Tuy nhiên nếu hai thiết bị A và B bị chia cắt bởi 1 router thì chúng sẽ được coi như là không local với nhau nữa. Khi A muốn gửi thông tin đến B, A sẽ không gửi trực tiếp được đến B theo địa chỉ lớp hai, mà phải gửi qua router và được coi là cách nhau 1 hop ở lớp ba.

- Công nghệ này nhắm đáp ứng cho việc gửi bản tin trong môi trường liên mạng. Router nằm giữa 2 mạng local sẽ được cấu hình để đáp ứng các gói tin broadcast gửi từ A thay cho B.

- Công nghệ này được mô tả như ở trong phần mô tả hoạt động của ARP trong môi trường liên mạng ở mục [3.2](#3.2)

<a name="5"></a>
# 5. Phân tích bản tin ARP sử dụng wireshark 

Sau đây là một số bản tin ARP bắt được từ Wireshark. (trước khi bắt gói tin, bạn nên xóa hết bộ nhớ ARP cache trong máy của mình bằng câu lệnh `arp -d *`, nhưng theo mình thì ARP hầu hết được cấu hình dynamic nên tắt card mạng đi là được)

- Thực hiện lọc những gói tin ARP:

<img src="http://imgur.com/IqJupQd.jpg">

<a name="5.1"></a>
  - Gói tin số 2 là gói tin ARP request mà máy gửi (192.168.1.100) hỏi để tìm MAC của gateway.

  <img src="http://imgur.com/rfBDDCz.jpg">

<a name="5.2"></a>
  - Gói tin số 3 là gói tin ARP reply mà gateway trả về.

    <img src="http://imgur.com/cnxe7TI.jpg">

<a name="5.2"></a>
  - Các gói tin 23, 79 và 159 là các gói tin ARP probe.

  <img src="http://imgur.com/CTT3CdK.jpg">

<a name="5.2"></a>
  - Gói tin 185 chính là gói tin ARP announcements.

  <img src="http://imgur.com/4sDsa8v.jpg">


<a name="6"></a>
# 6. Tham khảo

[1] Wiki - ARP: https://en.wikipedia.org/wiki/Address_Resolution_Protocol#External_links

[2] http://www.erg.abdn.ac.uk/users/gorry/course/inet-pages/arp.html

[3] https://letonphat.wordpress.com/2010/11/25/t%E1%BB%95ng-quan-arp-arp-cache-proxy-arp/

[4] ARP format: http://www.networksorcery.com/enp/protocol/arp.htm

[5] https://quantrimang.com/arp-va-nguyen-tac-lam-viec-trong-mang-lan-17302

[6] http://riotit.tistory.com/29

[7] https://crnetpackets.com/2015/08/28/special-type-of-arp-packets/

[8] ARP caching: http://www.tcpipguide.com/free/t_ARPCaching.htm

[9] http://sumankedala.blogspot.com/2011/06/types-of-arp.html







