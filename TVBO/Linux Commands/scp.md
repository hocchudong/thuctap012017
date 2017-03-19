# Báo cáo tìm hiểu câu lệnh SCP trong Linux

## 1. Giới thiệu
- 1.1 SCP command là gì? (#deter)
- 1.2 Chức năng của scp? (#chucnang)
- 1.3 Cách cài đặt (#caidat)
## 2. Chi tiết về câu lệnh (#chitiet)
- 2.1 Đưa file từ host tới remote server (#host-to-server)
- 2.2 Lấy file từ host về server (#server-to-host)
- 2.3 Mở rộng (#extend)


## 1. Giới thiệu
### 1.1 scp command là gì?
<a name="deter"></a>
- scp là câu lệnh sử dụng trong linux cho phép bạn đưa hoặc lấy một file, thư mục bất kỳ từ một máy linux về một máy linux nào đó bằng hình thức copy từ xa.
- Sử dụng ssh làm đường truyền dữ liệu, vì vậy mà việc sử dụng cũng cần phải chứng thực và được bảo mật giống như ssh.

### 1.2 Chức năng của scp
<a name="chucnang"></a>
- Cho phép copy 1 file, thư mục qua lại giữa 2 máy linux một cách bảo mật qua ssh

### 1.3 Cài đặt scp
<a name="caidat"></a>
- Thường thì scp đã được cài đặt sẵn trong hệ thống máy linux của chúng ta. Nếu scp chưa được cài đặt, bạn hãy sử dụng câu lệnh sau:
	+ Nhóm Debian Platform
		> `sudo apt-get install scp`

	+ Nhóm RedHat Platform
		> `sudo yum install scp`

## 2. Chi tiết về câu lệnh scp
<a name="chitiet"></a>
- Câu lệnh chung cho scp có thể được tóm tắt như sau:
	> `scp [options] source_file_path destination_file_path`

- Trong đó destination_file_path là một giá trị quy định đường dẫn máy chủ mà chúng ta copy file tới. ví dụ cụ thể như sau:
    > `scp [options] source_file_path username@ip_remote_host:file_dir`

- Các option của scp mà bạn cần chú ý bao gồm:
	+ `-c cipher`: Cho phép bạn lựa chọn loại mã hóa cho cho quá trình truyề tin. Mặc định thì scp sử dụng thuật toán mã hóa aes cho quá trình truyền tin.
	+ `-l bandwidth`: Giới hạn băng thông truyền tải
	+ `-P port`: Quy định cổng kết nối đến máy chủ từ xa
	+ `1`: Bắt buộc scp sử dụng giao thức 1
	+ `2`: Bắt buộc scp sử dụng giao thức 2
	+ `4`: Bắt buộc scp sử dụng địa chỉ IPv4
	+ `6`: Bắt buộc scp sử dụng địa chỉ IPv6
	+ `-B`: Ngăn không cho scp hỏi mật khẩu
	+ `-p`: Có chức năng giữ nguyên giá trị thuộc tính của tập tin ban đầu. Ví dụ: lấn sửa đổi cuối cùng, ... 
	+ `-r`: Cho phép bạn copy toàn bộ thư mục
	+ `-C`: Cho phép nén file để truyền tải
	+ `-v`: In ra thông tin các lỗi và tiến độ truyền tải file
	+ `-q`: Không cho phép in ra các thông báo trong quá trình truyền tải

### 2.1 Đưa file từ host tới remote server
<a name="host-to-server"></a>
- Để copy file `f-transfer.txt` từ host A có địa chỉ ip là: 192.168.10.128 tới host B có địa chỉ 192.168.10.126 với người dùng là remini qua cổng 89996. Ta làm như sau:
	> `scp -P 89996 f-transfer.txt remini@192.168.10.126:`

	Kết quả:
	> `f-transfer.txt                                                                                         100%   12     69.8KB/s   00:01`

### 2.2 Lấy file từ host về server
<a name="server-to-host"></a>
- Để lấy file `f-transfer.txt` từ host A có địa chỉ ip là: 192.168.10.128 tới server B có địa chỉ 192.168.10.126 với người dùng là remini qua cổng 89996. Ta làm như sau:
	> `scp -P 89996 remini@192.168.10.128:f-transfer.txt .`

	Kết quả:
	> ` ```f-transfer.txt                                                                                         100%   12     69.8KB/s   00:01``` `

### 2.3 Mở rộng
<a name="extend"></a>
- Thực hiện SCP với cả thư mục (gồm nhiều file và thư mục rỗng ở trong)
- Giả sử tại host A là client với địa chỉ `IP: 192.192.168.10.128`, `username: remini` có cấu trúc thư mục `home/remini`như sau:
    - Downloads
		+ latest.tar.gz
		+ Documents
		    - f-transfer.txt
		+ Music

- Giả sử host B là server với địa chỉ `IP: 192.168.10.126`, `username: reministry` có cấu trúc thư mục `home/reministry` rỗng:

- Để scp lấy file từ host A về B, ta làm như sau:
	> `scp -vrC remini@192.18.10.128: .`
- Để đưa file từ host A tới B, ta làm như sau:
	> `scp -vrC . reministry@192.192.168.10.126:`

Chúc các bạn thành công.