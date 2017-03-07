#Dùng Tcpdump phân tích quá trình hoạt động của DHCP

#Mục lục
- 1. Tcpdump
- 2. Chặn bắt gói tin DHCP bằng Tcpdump
- 3. Dùng phần mềm wireshark để đọc các gói tin bắt được.

##1. Tcpdump
- Tcpdump: là công cụ phân tích các gói dữ liệu mạng theo dòng lệnh. Nó cho phép khách hàng chặn và hiển thị các gói tin được truyền đi hoặc được nhận trên một mạng mà máy tính có tham gia.
- Tcpdump xuất ra màn hình nội dung các gói tin (chạy trên card mạng mà máy chủ đang lắng nghe) phù hợp với biểu thức logic chọn lọc mà khách hàng nhập vào.
- Nhìn thấy được các bản tin dump trên terminal
- Bắt các bản tin và lưu vào định dạng PCAP (có thể đọc được bởi Wireshark)

có thể tham khảo bài viết về công cụ Tcpdump [ở đây](http://securitydaily.net/phan-tich-goi-tin-15-lenh-tcpdump-duoc-su-dung-trong-thuc-te/)

##2. Chặn bắt gói tin DHCP bằng Tcpdump
- Chúng ta chạy tcpdump trên máy DHCP Server để xem quá trình gửi nhận các gói tin như thế nào.
`tcpdump -i eth1 -w dhcppacket.pcap`
- Lệnh tcpdump cần chạy với quyền root, tùy chọn **-i** chỉ muốn lắng nghe trên card mạng *eth1* và ghi vào file có tên là **dhcppacket.pcap** (có phần mở rộng pcap để có thể đọc được bằng phần mềm wireshark)
- Sử dụng phần mềm **WinSCP** để download file **dhcppacket.pcap** về máy tính (để có thể download file từ server bằng phần mềm WinSCP thì server cần được kết nối từ xa qua ssh).
- Mở file đó bằng phần mềm wireshark để đọc.
- đăng nhập vào server để tải file vê![Imgur](http://i.imgur.com/5eYZk46.png):
	- 1: chọn giao thức truyền file
	- 2: chỉ rõ tên server hoặc địa chỉ IP
	- 3: tên người dùng
	- 4: mật khẩu
	
- đăng nhập vào server ta thấy file vừa ghi. click và kéo về máy là có thể tải  xong ![Imgur](http://i.imgur.com/ZWsymGr.png)
- Mở gói tin bằng wireshark ta thấy được các gói tin DHCP mà tcpdump bắt được như sau ![Imgur](http://i.imgur.com/YOFcuQ0.png)
- Phân tích các gói đó:![Imgur](http://i.imgur.com/gzUF01a.png)
	- gói tin DHCP Discover:
		- gói tin DHCP Discover là một gói tin broadcast
		- có src: 0.0.0.0  Dst: Broadcast
		- chứ thông tin địa chỉ MAC của client
		- sử dụng srt port: 68, dst port: 67

	![Imgur](http://i.imgur.com/0659kdV.png)
	- gói tin DHCP Offer: gói tin DHCP Offer là một gói tin unicast. server gửi trực tiếp gói tin đến cho client thông qua địa chỉ MAC ở trong gói tin DHCP Discover mà client đã cung cấp
	
	![Imgur](http://i.imgur.com/xgUyZjq.png)
	- Sau khi client nhận được gói tin DHCP Offer thì nó sẽ gửi một gói broadcast có tên là DHCP Request để chấp nhận địa chỉ IP mà DHCP Server đã cung cấp. Đồng thời gói tin này để báo cho các DHCP Server khác thu hồi gói tin DHCP Offer đã gửi để cấp phát cho client khác.
	
	![Imgur](http://i.imgur.com/yXy3jJU.png)
	- Sau khi DHCP Server nhận được gói tin DHCP Request, Server trả lời bằng gói tin DHCP ACK để chính thức cấp phát địa chỉ IP đã đưa ra từ gói tin DHCP Offer. Lúc này client vẫn chưa có địa chỉ IP nên việc truyền tin thông qua địa chỉ MAC của client. Khi client nhận được gói tin DHCP ACK thì quá trình "xin xỏ" địa chỉ IP kết thúc. Client chính thức lấy địa chỉ đó để kết nối vào mạng.
	
=> Như vậy thông qua công cụ Tcpdump và wireshark, một lần nữa ta kiểm chứng lại lý thuyết về cách hoạt động của DHCP.