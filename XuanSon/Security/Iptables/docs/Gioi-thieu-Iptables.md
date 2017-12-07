# Giới thiệu về Netfilter/Iptables


# MỤC LỤC


<a name="1"></a>
# 1.Netfilter
\- Netfilter là framework được cung cấp bởi Linux cho phép thực hiện các hoạt động liên quan đến mạng dưới dạng các trình xử lý tùy chỉnh. Netfilter cung cấp các chức năng và hoạt động khác nhau cho packet filtering, network address translation và port translation.  
\- Netfilter thể hiện một bộ hooks trong Linux kernel, cho phép các modules cụ thể đăng kí các chức năng với networking stack của kernel. Các chức năng này được áp dụng cho lưu lượng truy cập dưới dạng rules lọc và sửa đổi.  
\- Netfilter components  

<img src="images/1.png" />

<a name="2"></a>
# 2.Iptables
\- Iptables là chương trình tiện ích user-space cho phép người quản trị hệ thống cấu hình tables được cung cấp bởi Linux kernel firewall (được thực hiện bởi các modules Netfilters khác nhau) và chains và rules nó lưu trữ. Modules kernels và chương trình khác nhau được sử dụng cho các giao thức khác nhau: iptables áp dụng cho IPv4, ip6tables áp dụng cho IPv6, arptables áp dụng cho ARP và ebtables cho Ethernet frames.  
\- Netfilter/Iptables được tích hợp vào Linux kernel 2.3.x. Trước iptables, Linux dùng ipchains trong Linux kernel 2.2.x và ipfwadm trong Linux kernel 2.0.x.  
\- Iptables yêu cầu quyền ưu tiên được vận hành và phải được thực hiện bởi user root.  

<a name="3"></a>
# 3.Stateless và Statefil Packet Filtering
\- **Stateless Packet Filtering**
là dạng bộ lọc không biết được quan hệ của những packet vào với packet đi trước nó hoặc đi sau nó, gọi là cơ chế lọc không phân biệt được trạng thái của các packet, trong kernel 2.0 và 2.2 thì ipfwadm và ipchains chỉ thực hiện được đến mức độ này.
Loại firewall này khó có thể bảo vệ được mạng bên trong trước các kiểu tấn công phá hoạt như DoS, SYN flooding, SYN cookie, ping of death, packet fragmentaion hay các hacker chỉ cần dùng công cụ nmap chẳng hạn là có thể biết được trạng thái của các host nằm sau firewall. Điều này không xảy ra với Stateful firewall.  

\- **Stateful Packet Filtering**
Với mọi packet đi vào mà bộ lọc có thể biết được quan hệ của chúng như thế nào đối với packet đi trước hoặc đi sau nó, ví dụ như các trạng thái bắt tay 3 bước trước khi thực hiện 1 phiên kết nối giao thức TCP/IP (SYN, SYN/ACK, ACK) gọi là firewall có thể phân biệt được trạng thái của các packet. Với loại firewall này, chúng ta có thể xây dựng các quy tắc lọc để có thể ngăn chặn được ngay cả các kiểu tấn công phá hoại như SYN flooding hay Xmas tree...
Iptables thuộc loại firewall này. Hơn thế nữa Iptables còn hỗ trợ khả năng giới hạn tốc độ kết nối đối với các kiểu kết nối khác nhau từ bên ngoài, cực kỳ hữu hiệu để ngăn chặn các kiểu tấn công từ chối phục vụ (DoS) mà hiện nay vẫn là mối đe doạ hàng đầu đối vói các website trên thế giới. Một đặc điểm nổi bật nữa của Iptables là nó hỗ trợ chức năng dò tìm chuỗi tương ứng (string pattern matching), chức năng cho phép phát triển firewall lên một mức cao hơn, có thể đưa ra quyết định loại bỏ hay chấp nhận packet dựa trên việc giám sát nội dung của nó. Chức năng này có thể được xem như là can thiệp được đến mức ứng dụng như HTTP, TELNET, FTP... mặc dù thực sự Netfilter Iptables vẫn chỉ hoạt động ở mức mạng (lớp 3 theo mô hình OSI 7 lớp).  

<a name="4"></a>
# 4.Sự khác biệt trên các distro khác nhau.
\- Trên CentOS, 7 iptables được mặc định cài đặt với hệ điều hành.  
\- Trên Ubuntu 16.04, ufw được mặc định cài đặt với hệ điều hành.  
Về bản chất, ufw is a frontend for iptables. Tức có nghĩa là thay vì gõ lệnh iptables, thì các bạn gõ lệnh ufw. Sau đó, ufw sẽ chuyển các lệnh của ufw sang tập lệnh của iptables. Tất nhiên, iptables sẽ xử lý các quy tắc, chính sách đó. 
Lệnh ufw là dễ dàng hơn cho những người mới bắt đầu tìm hiểu về firewall.  
\- **So sánh iptables trên ubuntu và centos**  

|Đặc điểm|CentOS|Ubuntu|
|---|---|---|
|Thư mục cấu hình|/etc/sysconfig/iptables-config|/etc/iptables/|
|default policy|DENY|ACCEPT|


