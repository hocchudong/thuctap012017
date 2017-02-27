#Mục Lục
- 1. Khái niệm giao thức ARP
- 2. Cấu trúc gói tin ARP
- 3. Cách thức hoạt động
- 4. Tài liệu tham khảo

##1. Khái niệm
- Trong mô hình OSI, ở tầng network, mỗi host cần có 1 địa chỉ IP và duy nhất trong một mạng để có thể giao tiếp được với các host khác. Địa chỉ IP có chức năng dùng để định tuyến. Loại địa chỉ này có thể thay đổi được.
- Các host trong mạng cần phải biết được địa chỉ MAC của nhau mới có thể truyền số liệu. Địa chỉ MAC nằm ở tầng Data-link.
- Chúng ta đã biết rằng khi một host muốn truyền dữ liệu sang host khác thì gói tin được chuyển từ tầng Application xuống dần các tầng dưới. Giả sử rằng các host đã biết được địa chỉ Ip của nhau. Khi gói tin xuống tầng Network, gói tin được đóng lại có chứa thông tin về địa chỉ nguồn và địa chỉ đích để có thể lưu thông trên mạng. Nhưng khi xuống tầng Data-link, host gửi chưa biết được địa chỉ MAC của host nhận thì không thể đóng gói để gửi đi. Câu hỏi đặt ra là làm thế nào để từ địa chỉ IP có thể ánh xạ sang địa chỉ MAC để thực hiện truyền tin?
- Như vậy, do nhu cầu thông tin về địa chỉ MAC ở tầng data-link mới có thể truyền dữ liệu. Giao thức ARP ra đời để giải quyết công việc đó.

=> Giao thức ARP (Address Resolution Protocol) là một giao thức dùng để phân giải địa chỉ từ địa chỉ IP sang địa chỉ MAC.

##2. Cấu trúc gói tin ARP
![Imgur](http://i.imgur.com/20mCdXF.png)

- Hardware type: 
	- Xác định kiểu bộ giao tiếp phần cứng máy gửi cần biết.
	- Ví dụ giá trị 1 là của Ethernet.
- Protocol type: 
	- Xác định kiểu giao thức địa chỉ cấp cao máy gửi cung cấp
	- ví dụ, địa chỉ IPv4 có mã 0x0800.
- Hardware Address Length: độ dài địa chỉ vật lý
- Operation: độ dài địa chỉ logic
	- 1: ARP request
	- 2: là một ARP reply
	- 3: là một RARP request 
	- 4: là một RARP reply
- Sender Hardware Address: địa chỉ MAC của máy gửi.
- Sender IP Address: địa chỉ IP của máy gửi
- Taget Hardware Address: địa chỉ vật lý của trạm nhận thông điệp.
- Taget IP Address: địa chỉ IP của trạm nhận

##3. Cách thức hoạt động
![Imgur](http://i.imgur.com/v6myh6s.png)  

- Bước 1: Thiết bị A sẽ kiểm tra cache của mình (giống như quyển sổ danh bạ nơi lưu trữ tham chiếu giữa địa chỉ IP và địa chỉ MAC). Nếu đã có địa chỉ MAC của IP 192.168.1.120 thì lập tức chuyển sang bước 9.
- Bước 2: Bắt đầu khởi tạo gói tin ARP Request. Nó sẽ gửi một gói tin broadcast đến toàn bộ các máy khác trong mạng với địa chỉ MAC và IP máy gửi là địa chỉ của chính nó, địa chỉ IP máy nhận là 192.168.1.120, và địa chỉ MAC máy nhận là ff:ff:ff:ff:ff:ff.
- Bước 3: Thiết bị A phân phát gói tin ARP Request trên toàn mạng. Khi switch nhận được gói tin broadcast nó sẽ chuyển gói tin này tới tất cả các máy trong mạng LAN đó.
- Bước 4: Các thiết bị trong mạng đều nhận được gói tin ARP Request. Máy tính kiểm tra trường địa chỉ Target Protocol Address. Nếu trùng với địa chỉ của mình thì tiếp tục xử lý, nếu không thì hủy gói tin.
- Bước 5: Thiết bị B có IP trùng với IP trong trường Target Protocol Address sẽ bắt đầu quá trình khởi tạo gói tin ARP Reply bằng cách:
lấy các trường Sender Hardware Address và Sender Protocol Address trong gói tin ARP nhận được đưa vào làm Target trong gói tin gửi đi.
Đồng thời thiết bị sẽ lấy địa chỉ MAC của mình để đưa vào trường Sender Hardware Address
- Bước 6: Thiết bị B đồng thời cập nhật bảng ánh xạ địa chỉ IP và MAC của thiết bị nguồn vào bảng ARP cache của mình để giảm bớt thời gian xử lý cho các lần sau (hoạt động cập nhật danh bạ).
- Bước 7: Thiết bị B bắt đầu gửi gói tin Reply đã được khởi tạo đến thiết bị A.
- Bước 8: Thiết bị A nhận được gói tin reply và xử lý bằng cách lưu trường Sender Hardware Address trong gói reply vào địa chỉ phần cứng của thiết bị B.
- Bước 9: Thiết bị A update vào ARP cache của mình giá trị tương ứng giữa địa chỉ IP (địa chỉ network) và địa chỉ MAC (địac chỉ datalink) của thiết bị B. Lần sau sẽ không còn cần tới request.

=> Như vậy máy A đã biết được địa chỉ MAC của máy B. khi A cần gửi một gói tin cho B thì sẽ điền địa chỉ này vào trường Target Hardware Address. Gói tin sẽ được gửi thằng đến B mà không cần gửi đến các máy khác trong mạng LAN nữa.

- Có giao thức RARP (Reverse Address Resolution Protocol) là một giao thức phân giải địa chỉ ngược, dùng để xác định địa chỉ IP thông qua địa chỉ MAC.

##4. Tài liệu tham khảo.
http://ipv6.com/articles/general/Address-Resolution-Protocol.htm

https://viblo.asia/pham.tri.thai/posts/mPjxMeZKG4YL

https://en.wikipedia.org/wiki/Address_Resolution_Protocol