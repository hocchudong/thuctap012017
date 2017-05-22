#Timf hiểu giao thức ARP

##1.Giới thiệu chung
  Trong hệ thống mạng máy tính có 2 loại địa chỉ được gán cho 1 máy tính:
-Địa chỉ vật lý MAC (Media Address Controll): là địa chỉ tuyệt đối, "ghi chết" vào
thiết bị giao tiếp. Thực tế, các NIC (Network Interface Card) chỉ có thể liên lạc
với nhau bằng địa chỉ này.

-Địa chỉ logic (IP Address): địa chỉ này mang tính chất tương đối, có thể thay đổi
theo người sử dụng và được chia ra làm 2 thành phần là phần Host, phần Network.
Trong đó phần Host dùng để phân biệt các máy trong cùng 1 mạng còn phần Network để
phân định hoạt động của máy trong mạng khác nhau và giúp dễ dàng định tuyếtn cho các
gói tin cần chuyển đi giữa các interface của các router

-Các máy muốn liên lạc với nhau trong môi trường mạng cần phải có cơ chế để giúp diễn
giải địa chỉ giữa địa chỉ IP và địa chỉ MAC => giao thức ARP (Address Resolution Protocol)
ra đời

##2.Nội dung phương thức

- ###2.1 Cơ chế hoạt động.
Quá trình hoạt động của giao thức ARP giữa máy A và máy B(máy B có địa chỉ IP là
192.168.1.100):

1.Bước 1: Thiết bị A kiểm tra cache của mình(giống như cuốn sổ ghi chép những tham chiếu
giữa địa chỉ MAC và địa chỉ IP). Nếu đã có địa chỉ 192.168.1.100 thì chuyển ngay tới bước 9.

2.Bước 2: Bắt đầu khởi tạo gói tin ARP Request. Nó sẽ gửi 1 gói tin broadcast đến toàn bộ
các máy khác nhau trong mạng với địa chỉ MAC và IP máy gửi là địa chỉ chính nó, địa chỉ IP
máy nhận là 192.168.0.100

3.Bước 3: Thiết bị A phân phát gói tin ARP Request trên toàn mạng. Khi switch nhận được gói
tin broadcast nó sẽ chuyển gói tin này đến tất các máy trong mạng LAN đó.

4.Bước 4: Các thiết bị trong mạng đều nhận được gói tin ARP Request. Máy tính sẽ kiểm tra trường
Target Protocol Address. Nếu trùng địa chỉ với mình thì sẽ tiếp tục xử lý, nếu không thì sẽ
huỷ gói tin đó.

5.Bước 5: Thiết bị B có trùng IP vs trường Target Protocol Address sẽ bắt đầu quá trình khởi tạo
gói tin ARP Reply.

6.Bước 6: Thiết bị B đồng thời cập nhật bảng ánh xạ IP và MAC của thiết bị nguồn vào bảng ARP
cache của mình để giảm bớt thời gian xử lý cho quá trình sau.

7.Bước 7: Thiết bị B gửi gói tin ARP Reply đã khởi tạo đến thiết bị A.

8.Bước 8: Thiết bị A nhận được gói tin ARP Reply và xử lý gói tin đó

9.Bước 9: Thiết bị A cập nhận lại ARP cache của mình.

- ###2.2 Cấu trúc của gói tin sử dụng ARP

Ý nghĩa của các gói tin trong header gói tin ARP là:
- Hardware Type
    + Xác định bộ giao tiếp phần cứng máy gửi cần biết.
  + Có giá trị là 1 với đường truyền Ethernet.
  + Nằm trong 16 bit đầu tiên của gói tin
- Protocol Type
  + Chiếm 16 bit của gói tin.
    + Xác định kiểu giao thức máy gửi cung cấp.
    + Có giá trị là 080016 cho giao thức IP
- HLEN (`Hardware Address Length`)
  + Độ dài địa chỉ vật lý tính theo bit.
- PLEN (`Protocol Address Length`)
  + Độ dài địa chỉ logic tính theo bit.
    - Giá trị là 1: cho biết đây là một gói tin ARP request.
    - Giá trị là 2: cho biết đây là một goi tin ARP reply.
    - Giá trị là 3: cho biết đây là một gói tin RARP request.
    - Giá trị là 4: cho biết đây là một gói tin RARP reply.
- Sender Hardware Address
  + Chứa địa chỉ MAC của máy gửi.
- Sender Protocol Address
  + Chứa địa chỉ IP của máy nhận.
- Target Hardware Address
+ Chứa địa chỉ MAC của máy nhận.
- Target Hardware Address
+ Chứ địa chỉ IP cuar máy nhận.
