# Thêm một node mới tới cluster


# Mục lục

- [Tạo token để mời một node bất kỳ tham gia cluster](#add-node)
- [Các nội dung khác](#content-others)


# Nội dung

- #### <a name="add-node">Tạo token để mời một node bất kỳ tham gia cluster</a>

	- Trên máy đóng vai trò là cluster, ta thực hiện chạy câu lệnh sau để sinh ra token:

			sudo tctl nodes add
			
		kết quả nhận được tương tự như sau:

			The invite token: n92bb958ce97f761da978d08c35c54a5c
			Run this on the new node to join the cluster:
			teleport start --roles=node --token=n92bb958ce97f761da978d08c35c54a5c --auth-server=10.0.10.1

	- Thực hiện gửi chuỗi token nhận được cho người bạn muốn mời gia nhập cluster. Chuối token ở ví dụ này là: "n92bb958ce97f761da978d08c35c54a5c" hoặc cũng có thể yêu cầu họ chạy câu lệnh: 

			teleport start --roles=node --token=n92bb958ce97f761da978d08c35c54a5c --auth-server=10.0.10.1


	- Trên node muốn tham gia vào cluster thực hiện chạy câu lệnh sau:

			teleport start --roles=node --token="string" --auth-server=10.0.10.1

		thay giá trị *string* là chuổi token bạn nhận được từ người mời tham gia cluster.

	- Sau khi trên node mới thực hiện chạy câu lệnh, tại máy đóng vai trò cluster thực hiện chạy lệnh sau để kiểm tra xem người dùng đã gia nhập cluster thành công hay chưa:

			tsh --proxy=localhost ls

		kết quả tương tự như sau:

			Node Name     Node ID                     Address            Labels
			---------     -------                     -------            ------
			localhost     xxxxx-xxxx-xxxx-xxxxxxx     10.0.10.1:3022     
			new-node      xxxxx-xxxx-xxxx-xxxxxxx     10.0.10.2:3022     



- # <a name="content-others">Các nội dung khác</a>

	Sẽ cập nhật sau.

	+ [](#)