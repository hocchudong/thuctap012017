# Báo cáo: Tìm hiểu về NAT

> NAT là viết tắt của cụm từ: Network Address Translation



## 1. Mở đầu

> Các thiết bị kết nối internet ngày nay trong các cơ quan, trường học thường được gán bởi 2 địa chỉ IPv4 với 2 loại là:

- IP Private.
- IP Public

> IP Private được sử dụng trong các hệ thống mạng LAN. Ngược lại IP Public được gán tới các thiết bị khi chúng được kết nối tới mạng internet toàn cầu. Trong thực tế, nếu một thiết bị chỉ có IP Private thì không thể kết nối tới internet phía ngoài mạng LAN được. Nó buộc phải sử dụng một công nghệ nào đó để giúp chuyển đổi IP Private thành IP Public và ngược lại để truy cập internet.
NAT được sinh ra để phục vụ cho mục đích này!

> NAT giúp một hay nhiều địa chỉ IP Private ánh xạ tới một hay nhiều IP Public và ngược lại. Hình thành nên sự kết nối internet giữa hai hay nhiều mạng LAN. Trong thực tế ngày nay, mọi thiết bị máy vi tính khi kết nối tới internet đều cần ít nhất một kỹ thuật NAT.

## 2. Các chức năng của NAT

> NAT hoặt động giống như một Router, nó chuyển tiếp các gói tin giữa những mạng khác nhau trong một hệ thống mạng lớn. Phía bên trên, bạn cũng có thể thấy, NAT chuyển đổi địa chỉ của một mạng riêng thành địa chỉ của một mạng công cộng.
Ngoài ra, NAT cũng có thể coi là một Firewall cơ bản. Bởi NAT có chứa một bảng thông tin duy trì về mỗi gói tin được gửi qua. Khi một máy tính trên internet kết nối đến một địa chỉ nào đó thì địa chỉ IP nguồn được thay thế bằng một địa chỉ Public đã được cấu hình sẵn trên NAT server.
> Sau khi có một gói tin trở về, NAT sẽ thực hiện chuyển đổi địa chỉ IP đích thành địa chỉ của thiết bị trong mạng và tiếp tục quá trình gửi tin. Nhờ vậy, ta có thể biết được một gói tin được gửi đến hay gửi đi từ một địa chỉ IP bằng việc xem thông tin trong bảng NAT hoặc ngăn truy cập đến một port cụ thể.

## 3. Lợi ích của NAT

- Giải quyết các thiếu hụt về địa chỉ IPv4
- Chia sẻ kết nối internet với nhiều máy trong mạng LAN chỉ với 1 IP Public duy nhất.
- Che giấu IP Private phía bên trong mạng LAN, làm tăng tính bảo mật.
- Cho phép lọc các gói tin được gửi đến, cấm truy cập đến một port cụ thể.
- Lưu giữ các thông tin trạng thái của một địa chỉ IPv4, port để giảm tải traffic.

## 4. Các khái niệm cơ bản liên quan đến NAT

> Loanh quanh tìm hiểu về NAT và phân tích cách hoạt động của NAT, bạn sẽ bắt gặp các thuật ngữ như SA Inside Local, DA Outside Local, ...
Đó là các thuật ngữ mà ta cần phải biết trước khi đi sâu vào kỹ thuật NAT. Vậy, chúng là những gì?


> Trước hết `SA` là cụm từ viết tắt của `Source Address` được biết đến như là một `địa chỉ nguồn` và tương tự `DA` được hiểu là `Destination Address` có nghĩa là `địa chỉ đích`.


> Ngoài ra, ta còn bắt gặp `SP` là cụm từ viết tắt của `Source Port` và `DP` viết tắt của `Destination Port`.

> Khi xem xét một NAT table ta còn bắt gặp các khái niệm:
+ `Inside Local Address`:
	> Đây là mục lưu trữ, định danh cho địa chỉ IP được gán cho một host của mạng trong. Đây là địa chỉ được cấu hình như là một tham số của hệ điều hành trong máy tính hoặc được gán một cách tự động bởi DHCP. Địa chỉ này không phải là những địa chỉ IP hợp lệ được cấp bởi NIC hoặc nhà cung cấp dịch vụ internet.

+ `Inside Global Address`:
	> Đây là mục định danh cho các địa chỉ hợp lệ được cấp bởi NIC hoặc nhà cung cấp dịch vụ internet. Địa chỉ này đại diện cho một hay nhiều địa chỉ IP Inside Local trong việc giao tiếp với mạng bên ngoài.

+ `Outside Local Address`:
	> Đây là mục định danh cho địa chỉ IP của một host thuộc mạng bên ngoài, các host thuộc mạng bên trong sẽ nhìn thấy host thuộc mạng bên ngoài thông qua địa chỉ này. Outside Local không nhất thiết phải là một địa chỉ hợp lệ trên mạng. (có thể là một địa chỉ Private)

+ `Outside Global Address`:
	> Là mục định danh cho các địa chỉ Ip được gán cho một host thuộc mạng bên ngoài bởi một cá nhân sở hữu host đó. Địa chỉ này được gán bằng một địa chỉ IP hợp lệ treeng mạng internet.

- Dưới đây là hình ảnh sẽ giúp bạn phân biệt rõ ràng 4 khái niệm trên.
	>![Hình ảnh phân biệt phạm vi](http://www.cisco.com/c/dam/en/us/support/docs/ip/network-address-translation-nat/4606-8a.gif)
> Nhìn vào hình ảnh trên, bạn sẽ nhận thấy:

1. Các gói tin trong phần mạng `Inside Network` sẽ có `SA` là kiểu `Inside Local` và `DA` là kiểu `Outside Local`. Cũng gói tin đó khi đi qua kỹ thuật NAT, được NAT xử lý và gửi tới mạng phía ngoài `Outside Network` thì gói tin đã chứa `SA` thuộc kiểu `Inside Global` và `DA` thuộc kiểu `Outside Global`. Vì vậy, một địa chỉ được gọi là `Local` khi nó còn đang nằm trong vùng mạng `Inside Network`.

2. Cũng gói tin đó phía bên mạng `Outside Network` được đóng tin gửi ngược trở lại với nội dung `DA` là kiểu `Inside Global` và `SA` là kiểu `Outside Global` bởi đây là một gói tin đáp trả lên có sự ngược nhau về vị trí giữa `DA` và `SA`. Gói tin này sau khi được gửi qua Router và xử lý bởi kỹ thuật NAT thì phía bên phần mạng `Inside Network` 