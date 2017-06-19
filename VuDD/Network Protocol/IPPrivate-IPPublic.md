#Tìm hiểu về IP Public và IP Private

##1.Địa chỉ IP Public
-Được gắn tới với mỗi máy tính mà nó kết nối tới internet và địa chỉ đó là duy nhất.
-Cơ chế này của địa chỉ IP giúp máy tính này có thể tìm thấy máy tính kia và trao đổi
thông tin.
-Người dùng sẽ không kiểm soát địa chỉ IP Public mà được gán với mỗi thiết bị. Địa chỉ
IP Public được gán tới mỗi thiết bị bởi nhà cung cấp dịch vụ internet.
-Có 2 loại địa chỉ IP Public đó là: địa chỉ IP tĩnh và địa chỉ IP động
-Địa chỉ IP tĩnh không thay đổi và chủ yếu được sử dụng để lưu trữ các trang web và các
dịch vụ internet
-Hầu hết người sử dụng internet sẽ chỉ có 1 địa chỉ IP động được gán với thiết bị của họ
và nó sẽ mất đi nếu thít bị đó mất kết nối với internet. Khi thiết bị đó kết nối lại với
internet, thì thiết bị đó sẽ được cấp 1 IP mới.

##2. Địa chỉ IP Private
-Một địa chỉ IP là IP Private nếu địa chỉ IP nằm trong dãy địa chỉ IP dành cho 1 mạng riêng
như mạng LAN.
-Có 3 khối không gian của địa chỉ IP Private.
  + Lớp A: 10.0.0.0 - 10.255.255.255
  + Lớp B: 172.16.0.0 - 172.31.255.255
  + Lớp C: 192.168.0.0 - 192.168.255.255
-Địa chỉ IP Private được sử dụng cho các máy tính trong 1 mạng riêng bao gồm mạng gia định,
mạng nhà trường, cơ quan, văn phòng, doanh nghiệp,...
-Nó sẽ giúp cho các máy tính trong mạng này kết nối được với nhau.
-Không giống như IP Public, người quản trị của mạng riêng có thể tự do gán địa chỉ IP như
yêu cầu và mong muốn.
-Các máy tính sử dụng địa chỉ IP Private không kết nối trực tiếp với internet được. Tương tự
các máy tính bên ngoài mạng cũng không thể kết nối được với các thiết bị sử dụng IP Private
của mạng riêng đó.
-IP Private được sử dụng để kết nối bên trong mạng còn IP Public được sử dụng cho kết nối
bên ngoài internet.
-Nó có thể liêng mạng giữa 2 mạng riêng với nhau với sự giúp đỡ của router hoặc thiết bị tương tự
mà nó hỗ trợ Network Address Translation (NAT)
