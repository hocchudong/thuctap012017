# Kiến trúc của Openstack Swift.

## Mục lục.
- [1. Kiến trúc logic](#1)
- [2. Kiến trúc vật lý](#2)
- [3. Tổng quan về kiến trúc phần mềm trong Swift](#3)

<a name=1></a>
# 1. Kiến trúc logic
- Tổ chức logic.

	![](./images/swift_logic.png)

	
- Mỗi tenant được gán một **Account**. 
- Trong account, có thể chứa nhiều **container** (tương tự như folder).
- Container sẽ chứa các **Object**.
- Người dùng lưu trữ các đối tượng mà không phải quan tâm đến phần cứng.
- Vấn đề đặt tên: các account phải có tên khác nhau và là duy nhất. Trong một account, tên của các containers cũng phải khác nhau, nhưng trên 2 account khác nhau thì tên container có thể trùng nhau. Với object cũng tương tự như thế.
- Trong lưu trữ swift, các containers là ngang hàng nhau. Như vậy sẽ không có tạo subcontainer. Tuy nhiên, swift hỗ trợ cơ chế giả thư mục để hỗ trợ cho việc quản lý.

<a name=2></a>
# 2. Kiến trúc vật lý
- Tổ chức vật lý.

	![](./images/swift_logic.png)

- Hệ thống phân cấp trong tổ chức vật lý của Swift như sau:
	- Region: Tại mức cao nhất, Swift lưu trữ dữ liệu trong các regions (gọi là khu vực) bị chia cắt về mặt vật lý - phân chia theo địa lý.
	- Zone: Bên trong các regions là các zones. Zone là tập các máy chủ riêng biệt, các máy chủ này được gọi là node storage. Khi có máy chủ xảy ra lỗi, Swift sẽ tách biệt các zone có máy chủ bị lỗi đó với các zone khác.
	- Storage server (máy chủ lưu trữ): Trong các zones sẽ chứa các máy chủ để lưu trữ.
	- Disk (ổ đĩa hoặc là thiết bị lưu trữ): Là một phần của storage server, có thể là các đĩa cứng cắm trực tiếp bên trong storage server hoặc được liên kết qua mạng.
	
<a name=3></a>
# 3. Tổng quan về kiến trúc phần mềm trong Swift.
- Trong Swift có 4 service chính. Document của swift gọi là Servers:
	- Proxy server
	- Account server
	- Container server
	- Object server
	
- Thông thường, proxy server được cài đặt trên một node riêng, còn 3 server còn lại sẽ được cài đặt trên cùng một node gọi là storage server.

	![](./images/swift_servers.png)
	
- Chức năng chính của từng server:
	- Proxy server: Thịu trách nhiệm nhận các yêu cầu HTTP từ người dùng. Nó sẽ tìm kiếm vị trí của storage server nơi mà yêu cầu cần được chuyển tiếp bằng cách sử dụng ring phù hợp. Proxy server tính toán các node bị hư hại bằng cách tìm kiếm các handoff node và thực hiện đọc/ghi.
	
	- Account server: Theo dõi tên các containers có trong account. Dữ liệu được lưu trữ trong cơ sở dữ liệu SQL, các files cơ sở dữ liệu sẽ được lưu trong filesystem. Server này cũng theo dõi thống kê nhưng không có bất kỳ thông tin nào về vị trí của các containers. Proxy server xác định vị trí container dựa trên container ring. Thông thường, account server sẽ được cài đặt với container server và object server trên cùng một máy chủ vật lý. Tuy nhiên, với một hệ thống lớn thì có thể cài đặt các server trên các máy chủ riêng biệt.
	
	- Container server: Giống như account server, ngoại trừ container server quản lý các objects bên trong nó.
	
	- Object server: Đơn giản là server quản lý lưu trữ đối tượng. Trên các ổ đĩa có các filesystem, và các đối tượng được lưu trên đó.
	
<a name=4></a>
# 4. Kiến trúc xác thực trong Swift
- Xác thực là một phần quan trọng trong swift. 
- Các thành phần trong swift đều dạng module, do vậy thành phần xác thực cũng là một project riêng.
- Người dùng có thể lựa chọn các hệ thống xác thực khác nhau. Keystone là project xác thực ở trong Openstack mà có thể được sử dụng cho Swift.

	![](../images/swift_keystone.png)
	
- Luồng làm việc của Swift với keystone.
	- 1. Người dùng cung cấp thông tin xác thực cho hệ thống xác thực. Điều này được thực hiện bằng cách thực hiện thông qua lời gọi HTTP REST API.
	- 2. Hệ thống xác thực cung cấp cho người dùng một mã (token) thông báo AUTH.
	- 3. Mã thông báo AUTH không phải là duy nhất cho mọi yêu cầu và hết hạn sau một khoảng thời gian nhất định (trong trường hợp TempAuth, thời gian mặc định thời gian sống là 86.400 giây). Mọi yêu cầu được gửi cho Swift đều phải kèm theo mã thông báo AUTH.
	- 4. Swift kiểm tra mã thông báo với hệ thống xác thực và lưu trữ kết quả vào bộ nhớ đệm. Kết quả được làm sạch khi hết hạn.
	- 5. Thông thường, hệ thống xác thực có khái niệm tài khoản quản trị và không quản trị. Các yêu cầu của quản trị viên rõ ràng sẽ được thông qua.
	- 6. Các yêu cầu không quản trị được kiểm tra dựa vào danh sách kiểm soát truy cập mức kho chứa (ACL – access control lists). Các danh sách này cho phép quản trị viên thiết lập các quyền đọc ghi cho người dùng không phải quản trị.
	- 7. Như vậy, với các yêu cầu không phải quản trị, ACL được kiểm tra trước khi proxy server có các bước xử lý tiếp theo với yêu cầu này.