# Tìm hiểu về giao thức HTTP

### Mục lục
- 1. Khái niệm.
- 2. Http request.
- 3. Http code response.
- 4. Phân tích gói tin HTTP bằng tcpdump

## 1. Khái niệm
- HTTP (HyperText Transfer Protocol-Giao thức truyển tải siêu văn bản) dùng để giao tiếp giữa máy cung cấp dịch vụ (web server) và máy sử dụng dịch vụ (web client).
- Hoạt động dựa theo mô hình client/server.
- Hoạt động ở tầng application trong mô hình tham chiếu OSI.
- HTTP là giao thức connectionless (kết nối không liên tục): client tạo một kết nối để đẩy request lên server. Khi đẩy xong request thì kết nối sẽ bị ngắt và client chờ response từ server.
- HTTP là stateless: vì http là giao thức connectionless nên client và server chỉ biết nhau khi đang kết nối. Kết nối ngắt đi thì cả hai không còn biết gì về nhau. Do đó client sẽ giữ lại một số thông tin (ví dụ như thông tin đăng nhập) giữa các yêu cầu.
- Sơ đồ về cấu trúc của một ứng dụng web cho thấy vị trí của http ![Imgur](http://i.imgur.com/qd2loyQ.png)

## 2. Http request
#### Http request có một số phương thức mà chúng ta hay gặp như sau:
- GET: GET được sử dụng để lấy thông tin từ Server. Yêu cầu được chỉ rõ trên URI. Các yêu cầu sử dụng GET nên chỉ nhận dữ liệu và nên không có ảnh hưởng gì tới dữ liệu tại Server.
- POST: Một yêu cầu POST được sử dụng để gửi dữ liệu tới Server, ví dụ, thông tin khách hàng, file tải lên, …, bởi sử dụng các mẫu HTML.
- DELETE: Xóa dữ liệu trên server.
- CONNECT: Thiết lập một tunnel tới Server được xác định bởi URI đã cung cấp.

## 3. Http code response.
#### Mã trạng thái HTTP được server phản hồi lại mỗi khi nhận được http resquest
- 1xx: Thông tin (yêu cầu đã được nhận và đang được xử lý)
	- 100: continue
	- 101 Switching Protocols
	- 102 Processing
- 2xx: mã này cho biết yêu cầu đã được nhận, hiểu, đồng ý và thực hiện thành công.
	- 200 OK
	- 201 Created: yêu cầu đã được thực hiện, kết quả là một resource đã được tạo.
	- 202 Accepted: yêu cầu đã được đồng ý, nhưng quá trình thực hiện chưa hoàn thành.
	- 203 Non-Authoritative Information
	- 204 No Content
	- 205 Reset Content
	- 206 Partial Content
	- 207 Multi-Status
	- 208 Already Reported
	- 226 IM Used

- 3xx: Chuyển hướng

- 4xx Client errors
	- 400 Bad Request: máy chủ không hiểu yêu cầu
	- 401 Unauthorized: máy chủ gửi phản hồi về yêu cầu client cung cấp thông tin để xác thực
	- 403 Forbidden: máy chủ từ chối yêu cầu.
	- 404 Not Found: file không tìm thấy.
	- 405 Method Not Allowed.
	- 406 Not Acceptable.
	- 407 Proxy Authentication Required.
	- 408 Request Time-out.
	- còn nhiều mã khác.

- 5xx Server error
	- 500 Internal Server Error: máy chủ gặp lỗi, không thể xử lý yêu cầu.
	- 501 Not Implemented: 
	- 502 Bad Gateway
	- 503 Service Unavailable
	- 504 Gateway Time-out
	- 505 HTTP Version Not Supported
	- 506 Variant Also Negotiates
	- 507 Insufficient Storage 
	- 508 Loop Detected 
	- 510 Not Extended
	- 511 Network Authentication Required 

## 4. Phân tích gói tin HTTP bằng tcpdump
#### Đứng tại Web Server thực hiện lệnh chặn bắt gói tin http.
- Các gói tin bặt được trong bài Lab như sau ![Imgur](http://i.imgur.com/6ozaqPd.png)
- Chúng ta sẽ phân tích từng gói tin http.
- Một gói tin request có một số thông tin như sau ![Imgur](http://i.imgur.com/gmhksge.png)
	- Destination port 80: giao thức http có port mặc định là 80
	- gói tin request sử dụng phương thức GET

- Server trả lời gói tin request trên ![Imgur](http://i.imgur.com/uHGz3aL.png)
	- yêu cầu gửi đến Server đã được xử lý và trả về thành công, client nhận được mã 200

- Khi Client yêu cầu một resource không có trên server thì kết quả nhận được sẽ như thế nào?
	- client yêu cầu đến một resource `duc.php` không có trên server, dùng phương thức GET ![Imgur](http://i.imgur.com/YZPI9xZ.png)
	- Response từ server trả về như sau ![Imgur](http://i.imgur.com/QvvQqrS.png)
		- Servr trả về mã 404 thông báo cho client file not found
		

- Đọc file log của apache2 để xem server ghi lại những gì?
- Sử dụng lệnh `tail /var/log/apache2/access.log`, kết quả như sau ![Imgur](http://i.imgur.com/0GN3FPR.png)
	- file log ghi lại các thông tin như địa chỉ ip của client, phương thức yêu cầu, mã trả về, client sử dụng cái gì để thực hiện request. Ở đây có 2 client thực hiện request:
		- client 10.10.10.1 sử dụng trình duyệt 
		- client 10.10.10.10 sử dụng lệnh `curl`
		
- Đọc file log theo chế độ real time để kiểm tra liên tục các kết nối đến apache, ta dùng lệnh `tailf /var/log/apache2/access.log`
		
## 5. Thực hành cấu hình lại một số thông tin của apache2 
- Chuyển đường dẫn root document vi `/etc/apache2/sites-enabled/000-default.conf` tại dòng 12, thay đổi đường dẫn đến thư mục root document cần thiết ![Imgur](http://i.imgur.com/JW1nKCA.png)
- file cấu hình port của apache tại `/etc/apache2/ports.conf`. Ta thay bằng cổng `8080` và restart lại apache và cùng xem kết quả 
	- Nội dung file cấu hình port ![Imgur](http://i.imgur.com/8oNnJtZ.png)
	- Kết quả ![Imgur](http://i.imgur.com/FvLm9YZ.png) 