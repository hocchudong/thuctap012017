# Storage policies

- Swift sử dụng mã băm rings để xác định nơi dữ liệu sẽ được lưu. Có các ring riêng biệt cho cơ sở dữ liệu account, cho cơ sở dữ liệu container và có một object ring cho mỗi chính sách lưu trữ. Mỗi object ring đều có cách xử lý giống nhau, cùng được quản lý trong cùng một phương pháp, nhưng với các policies, các thiết bị khác nhau thuộc các ring khác nhau. Sau đây là một số lý do sử dụng các policies lưu trữ:
	- Chia các mức độ lâu dài của dữ liệu khác nhau: Nếu nhà cung cấp muốn cung cấp, ví dụ 2x hoặc 3x bản sao nhưng không muốn bảo trì ở trên 2 cụm riêng biệt, họ muốn thiết lập một chinh sách 2x, một chính sách 3x và chỉ định các nodes vào các ring tương ứng của họ.
	- Hiệu năng: ví dụ như SSDs có thể được sử dụng như các thành viên độc quyền của một account ring hoặc database ring, một SSD object ring chỉ được tạo ra và sử dụng để thực hiện các chính sách lưu trữ yêu cầu về hiện năng, có độ trễ thấp.
	
# Containers and Policies
- Các policies được thực hiện ở mức container. Nó đảm bảo rằng các chính sách lưu trữ vẫn còn là một tính năng cốt lõi của Swift, độc lập với xác thực. 
- Các chính sách không được triển khai ở tầng account hoặc auth bởi vì nó yêu cầu thay đổi tất cả cho hệ thống xác thức được sử dụng bởi người triển khai Swift. 
- Mỗi container có một thuộc tính mới metadata không thay đổi được được gọi là `storage policy index`. Chú ý rằng, bên trong swift sẽ dựa vào policy index chứ không phải tên policy. Tên policy là để cho con người có khả năng đọc và sự dịch (từ index <=> tên) được quản lý trong policy. 
- Khi một container được tạo, một tùy chọn header mới được hỗ trợ để chỉ định tên policy. Nếu không có tên được chỉ định thì policy mặc định được sử dụng (và nếu không có policy được đinh nghĩa, thì Policy-0 được coi là mặc định).
- Các policies sẽ được gán khi một container được tạo. Một khi container đã được ấn định policy thì sẽ không thể thay đổi (trừ khi nó bị xóa đi và tạo lại).
- Quan hệ giữa containers và policies là n-1 có nghĩa là nhiều container chia sẻ cùng 1 policy. Không có giới hạn về số lượng container trên một policy.

# `Default` so với `Policy-0`
- Storage policies là tính năng linh hoạt ý định để hỗ trợ cả hệ thống mới và hệ thống có từ trước cùng mức độ linh hoạt.
- Khái niệm `Policy-0` không giống `default` policy.
- Khi chúng ta bắt đầu cấu hình các policies, mỗi policy có một tên riêng và một số tùy ý để xác định như là index.
- `Default` policy là chính sách mặc định khi một container tạo ra mà không chỉ rõ là thuộc policy nào
- `Policy-0` là chính sách mặc định trong Swift có index là 0.

# Cấu hình policy
### Định nghĩa policy
- Mỗi policy được định nghĩa bởi một section trong file `/etc/swift/swift.conf`.
- Tên của section phải theo mẫu `[storage-policy:<N>]`. N là index của policy.
- Trong mỗi section policy chứa các option sau:
	- `name = <policy name>`: option này phải có
		- tên của policy
		- tên của policy phải là duy nhất
		- tên policy có thể thay đổi
		- tên `Policy-0` chỉ có thể được sử dụng với index 0
	- `default = [true|false]`: (optional)
		- Nếu `true` thì policy này sẽ được sử dụng khi client không chỉ rõ.
		- Giá trị mặc định là false
		- Nếu không có policy nào khai báo là policy mặc định thì policy với index 0 là policy mặc định
		- `Deprecated` policy không thể là `default` policy
	- `deprecated = [true|false]`: (optional)
		- Nếu `true` thì các containers mới được tạo ra không thể sử dụng policy này.
		- Giá trị mặc định là `false`
		
### Ví dụ:
- Trong file `/etc/swift/swift.conf`, ta khai báo thêm một policy nữa như sau:

	```sh
	[storage-policy:1]
	name = silver
	policy_type = replication
	```
	- policy có index 1
	- tên là silver

- Tiếp đến chúng ta cần tạo một object ring cho policy này.

	```sh
	cd /etc/swift
	
	swift-ring-builder object-1.builder create 10 3 1
	```
	
- Sau đó thêm các devices vào object ring này.

	```sh
	swift-ring-builder object-1.builder add \
	--region 1 --zone 1 --ip 10.10.10.100 --port 6200 --device sdb --weight 10
	
	swift-ring-builder object-1.builder add \
	--region 1 --zone 1 --ip 10.10.10.100 --port 6200 --device sdc --weight 10

	swift-ring-builder object-1.builder add \
	--region 1 --zone 1 --ip 10.10.10.101 --port 6200 --device sdb --weight 10

	swift-ring-builder object-1.builder add \
	--region 1 --zone 1 --ip 10.10.10.101 --port 6200 --device sdc --weight 10
	```
	
- Kiểm tra lại ring:

	```sh
	swift-ring-builder object-1.builder
	```
	
- Tái cân bằng ring
	
	```sh
	swift-ring-builder object.builder rebalance
	```
	
- copy file `object-1.ring.gz` đến các node mà chứa các thiết bị đã được thêm vào ring ở bước trước.

	```sh
	scp /etc/swift/object-1.ring.gz root@10.10.10.100:/etc/swift
	scp /etc/swift/object-1.ring.gz root@10.10.10.101:/etc/swift
	```
	
- Restart các services

	```sh
	service memcached restart
	service swift-proxy restart
	```
	
- Tạo một container mới với policy là có tên là silver.

	```sh
	curl -v -X PUT -H 'X-Auth-Token: <your auth token>' \
  -H 'X-Storage-Policy: silver' http://127.0.0.1:8080/v1/AUTH_07032571cca84854b4116a7be846089d/container_silver
	```
	
- Sử dụng lệnh sau để lấy metadata của container vừa tạo:

	```sh
	curl -i -X HEAD -H 'X-Auth-Token: <your auth token>' \
  http://127.0.0.1:8080/v1/AUTH_07032571cca84854b4116a7be846089d/container_silver
	Warning: Setting custom HTTP method to HEAD with -X/--request may not work the
	Warning: way you want. Consider using -I/--head instead.
	HTTP/1.1 204 No Content
	Content-Length: 0
	X-Container-Object-Count: 0
	Accept-Ranges: bytes
	X-Storage-Policy: silver
	Last-Modified: Tue, 10 Oct 2017 16:06:17 GMT
	X-Container-Bytes-Used: 0
	X-Timestamp: 1507651575.76753
	Content-Type: text/plain; charset=utf-8
	X-Trans-Id: tx80a5052350b943458fb05-0059dcf204
	X-Openstack-Request-Id: tx80a5052350b943458fb05-0059dcf204
	Date: Tue, 10 Oct 2017 16:15:00 GMT
	```
	
	- như vậy container có `X-Storage-Policy: silver`
	
## Tham khảo
https://docs.openstack.org/swift/latest/overview_policies.html