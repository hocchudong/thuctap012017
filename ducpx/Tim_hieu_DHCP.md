#Tìm hiểu về giao thức DHCP

#Mục lục
- 1. Khái niệm
- 2. Các thuật ngữ 
- 3. Cấu trúc gói tin
- 4. Cách thức hoạt động
- 5. Tài liệu tham khảo

##1. Khái niệm
- Nhu cầu sử dụng dịch vụ DHCP: 
	- một host cần phải có một địa chỉ IP và duy nhất để có thể tham gia vào một mạng.
	- Công việc cấu hình địa chỉ IP cho các host có thể được thực hiện bằng tay hoặc tự động
	- việc cấu hình bằng tay có một số vấn như đánh sai địa chỉ => dẫn đến tìm ra lỗi khó khăn, đánh trùng địa chỉ, công việc của admin nhiều hơn (ví dụ như khi phải cấu hình cho mạng có trên 100 host), tốn thời gian ...
	
	=> Nhu cầu thay thế công việc cấu hình IP bằng tay bằng một dịch vụ cấu hình một cách tự động. Dẫn đến sự ra đời của dịch vụ DHCP (Dynamic Host Configuration Protocol)

- Dịch vụ DHCP là một dịch vụ tự động cấu hình IP cho một host một cách tự động, chính xác, nhanh chóng, đáp ứng nhu cầu sử dụng mạng, tự động cập nhật những thay đổi trong cấu trúc mạng mà không cần thay đổi cấu hình từng host trong mạng.
- DHCP hỗ trợ 3 cơ chế cấp địa chỉ IP:
	- Cấp tự động: DHCP gán 1 địa chỉ IP thường trực → 1 Client
	- Cấp động: DHCP gán địa chỉ IP cho 1 khoảng thời gian hữu hạn nào đó
	- Cấp thủ công: 1 địa chỉ IP được gán bời người quản trị. DHCP chỉ để đưa địa chỉ này đến Client  
	=> cấp động là cơ chế duy nhất có khả năng thu hồi địa chỉ đã cấp phát cho host này để cấp phát cho host khác.
##2. Các thuật ngữ
- DHCP Server: là máy chủ chạy dịch vụ DHCP.
- DHCP Client: là host yêu cầu được cung cấp địa chỉ IP.
- Scope: là dải địa chỉ IP dùng đề cấp phát cho Client.
- Exclusion Scope: dải chỉ chỉ bị loại ra không cấp cho client ở trong Scope.
- Reservation: những đỉa chỉ dành riêng cho một số máy tính hoặc thiết bị.
- Scope Option: các thông tin cấu hình thêm cho client như DNS.
- DHCP Replay Agent: DHCP Replay Agent là một máy tính hoặc một Router được cấu hình để lắng nghe và chuyển tiếp các gói tin giữa DHCP Client và DHCP Server từ subnet này sang subnet khác.

 
##3. Cấu trúc gói tin
![Imgur](http://i.imgur.com/WnVrOjQ.png)


| Field | size(byte) | description |
|-------|------------|-------------|
| Operation code | 1 | Có hai giá trị: 1 là gói tin request, 2 là gói tin reply |
| Hardware type | 1 | chỉ rõ kiểu hardware được sử dụng cho mạng. Ví dụ: 1-Ethernet(10Mb), 6 IEEE 802 Networks |
| Hardware Address length | 1 | chỉ rõ độ dài của địa chỉ hardware |
| Hops | 1 | dùng cho relay agents |
| Transaction identifier | 4 | được tạo bởi client, dùng để liên kết giữa request và replies của server và client |
| Number of seconds | 2 | quy định số giây kể từ khi client bắt đầu thuê hoặc xin cấp lại IP |
| Flags | 2 | B, broadcast: 1 bits = 1 khi client không biết được Ip của mình khi gửi yêu cầu |
| Client IP address | 4 | client sẽ đặt địa của nó trong trường này khi nó đã có hoặc yêu cầu lại IP, nếu không sẽ mặc định là 0|
| Your IP address | 4 | IP được cấp bởi server để đăng ký cho client |
| Server IP address | 4 | địa chỉ IP của server |
| Gateway IP address | 4 | sử dụng trong relay agent |
| Client hardware address | 16 | địa chỉ MAC của client dùng để định danh |
| Server host name | 64 | Khi server gửi các gói tin trả lời client thì sẽ đặt trường này, có thể là nicknam hoặc tên miềm dns |
| Boot filename | 128 | Sử dụng bời client để yêu cầu loại tập tin khởi động cụ thể trong gói tin discover.Sử dụng bởi server để chỉ rõ toàn bộ đường dẫn, tên file của file khởi động trong gói tin offer |


http://www.tcpipguide.com/free/t_DHCPMessageFormat.htm

##4. Cách thức hoạt động
- DHCP thông qua 4 bước để thực hiện cung cấp địa chỉ IP cho client: 
	- 1. IP lease request
	- 2. IP lease offer
	- 3. IP lease selection
	- 4. IP lease acknowledgement

![Imgur](http://i.imgur.com/EKd5p9T.png)

Quá trình gửi nhận các tin như hình. Quá trình gửi nhận các gói tin được thực hiện như sau: 

- IP Lease Request:
	- client sẽ **broadcast** một message tên là **DHCPDISCOVER**
	- client lúc này chưa có địa chỉ IP cho nên nó sẽ dùng một địa chỉ source(nguồn) là **0.0.0.0** 
	- client không biết địa chỉ của DHCP server nên nó sẽ gửi đến một địa chỉ broadcast là **255.255.255.255**. 
	- Gói tin này cũng chứa một địa chỉ MAC (Media Access Control) và đồng thời nó cũng chứa computer name của máy client để DHCP server có thể biết được client nào đã gởi yêu cầu đến.   

- IP Lease Offer:
	- Nếu có một DHCP hợp lệ (nghĩa là nó có thể cấp địa chỉ IP cho một client) nhận được gói tin DHCPDISCOVER của client thì nó sẽ trả lời lại bằng một gói tin DHCPOFFER, gói tin này đi kèm theo những thông tin sau: 
		+ MAC address của client
		+ Một IP address cấp cho (offer IP address)
		+ Một subnet mask
		+ Thời gian thuê (mặc định là 8 ngày)
		+ Địa chỉ IP của DHCP cấp IP cho client này
		Lúc này DHCP server sẽ được giữ lại một IP đã offer (cấp) cho client để nó không cấp cho DHCP client nào khác. 
	- DHCP client chờ một vài giây cho một offer, nếu nó không nhận một offer nó sẽ **rebroadcast** (broadcast gói DHCPDISCOVER) trong khoảng thời gian là 2-, 4-, 8- và 16- giây, bao gồm một khoảng thời gian ngẫu nhiên từ 0 – 1000 mili giây.
	- Nếu DHCP client không nhận một offer sau 4 lần yêu cầu, nó sử dụng một địa chỉ IP trong khoảng 169.254.0.1 đến 169.254.255.254 với subnet mask là 255.255.0.0. Nó sẽ sử dụng trong một số trong khoảng IP đó và việc đó sẽ giúp các DHCP client trong một mạng không có DHCP server thấy nhau. DHCP client tiếp tục cố gắng tìm kiếm một DHCP server sau mỗi 5 phút.

- IP Lease Selection
DHCP client đã nhận được gói tin DHCPOFFER thì nó sẽ phản hồi broadcast lại một gói **DHCPREQUEST** để chấp nhận cái offer đó. DHCPREQUEST bao gồm thông tin về DHCP server cấp địa chỉ cho nó. Sau đó, tấc cả DHCP server khác sẽ rút lại các offer (trường hợp này là trong mạng có nhiều hơn 1 DHCP server) và sẽ giữ lại IP address cho các yêu cầu xin IP address khác.

- IP Lease Acknowledgement
DHCP server nhận được DHCPREQUEST sẽ gởi trả lại DHCP client một DHCPACK để cho biết là đã chấp nhận cho DHCP client đó thuê IP address đó. Gói tin này bao gồm địa chỉ IP và các thông tin cấu hình khác (DNS server, WINS server… ). Khi DHCP client nhận được DHCPACK thì cũng là lúc kết thúc quá trình cấp phát yêu cầu và nhận IP.

##5. Tài liệu tham khảo
https://vi.wikipedia.org/wiki/DHCP

http://vdo.vn/cong-nghe-thong-tin/cac-khai-niem-co-ban-ve-dhcp.html

https://blogitvn.wordpress.com/2007/10/08/dhcp-ly-thuy%E1%BA%BFt-toan-t%E1%BA%ADp/