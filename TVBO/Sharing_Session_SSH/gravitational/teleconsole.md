# Hướng dẫn sử dụng Teleconsole

# Mục lục:

- [Teleconsole là gì?](#whatis)
- [Cài đặt Teleconsole](#settings)
- [Cách sử dụng teleconsole](#used)



# Nội dung
		Lưu ý: Các lệnh phía dưới được thực hiện với quyền của user root.


- # <a name="whatis">Teleconsole là gì</a>

	+ Teleconsole là một dịch vụ miễn phí cho phép chia sẻ các phiên hoạt động trên terminal với những người khác. Họ có thể join từ một command line thông qua SSH hoặc thông qua trình duyệt sử dụng giao thức HTTPS. Tính năng này cho phép yêu cầu kết nối hoặc trợ giúp tới các thiết bị của bạn.
	+ Bạn cũng có thể `forward local TCP ports` tới họ - người được bạn chia sẻ phiên hoạt động terminal của bạn. Sử dụng tính năng này để cho phép họ truy cập thông qua một ứng dụng web chạy trên localhost khi bạn và họ đang ở trong cùng một mạng LAN.

- # <a name="settings">Cài đặt Teleconsole</a>

	+ Cách nhanh nhất và dễ nhất để cài đặt Teleconsole là sử dụng kịch bản có sẳn được cung cấp. Bạn hãy nhập câu lệnh này trên terminal của bạn và thực thi nó:
		> `curl https://www.teleconsole.com/get.sh | sh`

	+ Nếu bạn muốn được kiểm soát về việc làm thế nào Teleconsole được cài đặt thì có thể download bản [latest binaries](https://github.com/gravitational/teleconsole/releases) từ Github.

- # <a name="used">Cách sử dụng teleconsole</a>
	
	+ Sau khi đã cài đặt teleconsole trên máy của bạn. Bạn có thể tiến hành chạy câu lệnh sau để chia sẻ, yêu cầu bạn của bạn giúp đỡ bạn thông tuan terminal. Đơn giản, hãy nhập câu lệnh sau trên terminal:
		> `teleconsole`

	+ Ta được một nội dung cụ thể như sau:

          ~$ teleconsole
          Starting local SSH server on localhost...
          Requesting a disposable SSH proxy on as.teleconsole.com for reministry...
          Checking status of the SSH tunnel...

          Your Teleconsole ID: asd9e65ecbcfa20231ee421e1ebd718e643605303d
          WebUI for this session: https://as.teleconsole.com/s/d9e65ecbcfa20231ee421e1ebd718e643605303d
          To stop broadcasting, exit current shell by typing 'exit' or closing the window.
		
		> ![teleconsole](../../Pictures/Teleport/Quickstart/teleconsole.png)

	+ Bước tiếp theo, bạn cần cho người bạn của biết được đường link chứa token phiên truy cập ssh. Ở đây ta, được sử dụng một dịch vụ có sẵn và cung cấp miễn phí. Theo ví dụ trên thì đường link đó sẽ là: 

		  	https://as.teleconsole.com/s/d9e65ecbcfa20231ee421e1ebd718e643605303d

	+ Xin hãy lưu ý rằng: Mỗi đường link được cung cấp chỉ có thể truy cập một lần duy nhất. Kết quả của việc truy cập đường link được cung cấp sẽ là một phiên làm việc ssh mới tới máy của bạn:
      > ![web-service](../../Pictures/Teleport/Quickstart/web-ser.png)

    + Bạn cũng có thể gửi `Teleconsole ID` cho bạn của bạn để họ có thể sử dụng nó truy cập tới terminal của bạn bằng terminal của họ khi họ có cài đặt teleconsole trên thiết bị đó qua câu lệnh:
		> `teleconsole join Teleconsole_ID`.

	+ Cả hai cách sử dụng trên sẽ cho phép bạn và họ có chung một phiên bản việc trên terminal. Điều này có thể nói dễ hiểu là họ làm gì trên terminal của bạn như nhập câu lệnh, kết quả trả về ra sao, bạn đều có thể nhìn thấy được ngay trên thiết bị của bạn và ngược lại.



# Các tính năng khác của Teleconsole

- [Forwarding local TCP ports](../forwarding-local-tcp-ports.md) - how to let joining parties access TCP ports on your localhost.
- [Using Secure Sessions](../teleconsole/using-secure-sessions) - how to invite specific people, like Github users or owners of a specific public SSH key.
- [Private Proxies](../teleconsole/private-proxies.md) - how to set up your own proxy servers without having to rely on https://teleconsole.com.

# Nội dung liên quan

- [Giới thiệu về Teleport](../README.md#about)
- Quickstart
	- [Cài đặt và sử dụng](installation.md)
	- [Thêm một Node mới vào Cluster](add-nodes.md#add-nodes)
	- [Tạo label cho Node](add-nodes.md#add-label)
	- [Chia sẻ phiên đăng nhập SSH](sharing-ssh)
	- [Teleconsole](teleconsole.md)
- Kiến trúc của Teleport
	> Sẽ cập nhật sau
- Hướng dẫn dành cho user
	> Sẽ cập nhật sau
- Hướng dẫn dành cho admin
	> Sẽ cập nhật sau