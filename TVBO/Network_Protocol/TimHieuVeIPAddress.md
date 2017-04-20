# Báo cáo tìm hiểu về `IP Public` và `IP Private`.


## 1. Mở đầu

- 1.1 IP là gì?
	
	IP là viết tắt của `Internet Protocol` được hiểu là Giao thức kết nối Internet.
	IP được biết đến như một loại địa chỉ để các thiết bị có thể nhận diện và liên lạc với nhau qua mạng internet.
    Có 2 loại IP đó là:
	+ IP version 4 (IPv4): 32 bit.
	+ IP version 6 (IPv6): 128 bit.

- 1.2 IPv4 có những loại nào?
	
	+ I`IP Private`

	+ `IP Public`

	+ IPv4 có 32 bit được chia làm 5 lớp: A, B, C, D và E.

		- Địa chỉ IP lớp A có các địa chỉ có 1 bit đầu là 0
		- Địa chỉ IP lớp B có các địa chỉ có 2 bit đầu là 10
		- Địa chỉ IP lớp C có các địa chỉ có 3 bit đầu là 110
		- Địa chỉ IP lớp D có các địa chỉ có 4 bit đầu là 1110
		- Địa chỉ IP lớp E có các địa chỉ có 4 bit đầu là 11110
## 2. Nội dung

- 2.1 `IP Public`
	
	- Là địa chỉ được gán tới mỗi máy tính khi nó được kết nối tới internet và nó phải là duy nhất trên hệ thống mạng internet.
	Chính điều này mới có thể giúp được một máy tính này có thể tìm ra được một máy tính khác trên hệ thống internet để trao đổi thông tin.
	Người sử dụng sẽ không thể kiểm soát được địa chỉ `IP Public` được sử dụng cho thiết bị của mình. `IP Public` được cung cấp bởi các nhà cung cấp dịch vụ mạng.

	- Một `IP Public` có thể là một địa chỉ động hoặc một địa chỉ tĩnh.
		+ IP tĩnh không được thay đổi trước và sau khi kết nối internet, thường được sử dụng cho các trang web hoặc các dịch vụi trên hệ thống internet.

		+ IP động được thay đổi mỗi lần khi kết nối internet, hầu hết mỗi thiết bị sẽ chỉ được gán một IP động cho tới khi thiết bị mất kết nối từ internet.
		Vì thế mà địa chỉ IP sẽ được cấp phát mới khi thiết bị được kết nối lại internet.

- 2.2 `IP Private`

	- Bạn có thể sẽ bắt gặp địa chỉ IP của 2 máy tính trong cùng 1 cơ quan là giống nhau bởi chúng nằm trong phạm vi của 2 mạng LAN riêng biệt - đó được xem như là `IP Private`. Vậy thực chất, `IP Private` là gì?

	- `IP Private` là địa chỉ IP nằm trong dải các địa chỉ sau:
		+ Lớp A: 10.0.0.0 - 10.255.255.255
		+ Lớp B: 172.16.0.0 - 172.31.255.255
	 	+ Lớp C: 192.168.0.0 - 192.168.255.255

	- `IP Private` dùng cho các thiết bị không trực tiếp kết nối tới hệ thống internet nhằm bảo đảm tính bảo mật. Vậy làm thế nào để các máy tính trong mạng LAN sử dụng `IP Private` có thể kết nối được internet?

	> Muốn kết nối được internet, các máy tính cần phải dụng `NAT` - một giao thức giúp chuyển đổi qua lại giữa `IP Public` và `IP Private`. Chỉ có như vậy, các máy tính sử dụng `IP Private` mới có thể kết nối được ra bên ngoài mạng.


	Tham khảo tại: [VNPT Website]()