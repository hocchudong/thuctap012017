# TỔNG QUAN VỀ SSH

## Mục lục
- [1. Khái niệm](#1)
- [2. SSh làm việc như thế nào.](#2)
- [3. SSh xác thực người dùng như thế nào.](#3)

<a name="1"></a>
## 1. Khái niệm

SSH là một trong những cách phổ biến nhất để truy cập vào các Remote Linux Server. SSH là viết tắt của Secure Shell và cung cấp một cách an toàn và an toàn để thực hiện các lệnh, thay đổi và cấu hình các dịch vụ từ xa. Khi kết nối thông qua SSH, bạn đăng nhập bằng tài khoản tồn tại trên máy chủ từ xa.

<ul>
	<li>SSH (Secure Shell) là một giao thức mạng dùng để thiết lập kết nối mạng 1 cách bảo mật. Hoạt động ở tầng ứng dụng trong mô hình TCP/IP.</li>
	<li>Các công cụ ssh (OpenSSH, PuTTy, Moba, etc) giúp người dùng tạo kết nối đến các máy tính từ xa sử dụng SSH.</li>
	<li>Tính năng tunneling (port forwarding) cho phép chuyển tải các giao vận theo các giao thức khác.</li>
</ul>

<a name="2"></a>
## 2. SSh làm việc như thế nào.
<ul>
	<li>Khi bạn kết nối thông qua ssh, bạn sẽ được vào một Shell section dựa trên giao diện văn bản, nơi mà ban có thể tương tác với server của bạn.</li>
	<li>Kết nối ssh được thực hiện bằng mô hình Client/server. Có nghĩa là khi một kết nối ssh được thiết lập, máy tính từ xa phải được chạy một phần mềm được gọi là SSH daemon. Phần mềm này sẽ nghe kết nối này trên một cổng mạng riêng biệt, xác thực yêu cầu kết nối và tạo ra môi trường thích hợp nếu người dùng cung cấp đúng các thông tin. </li>
	<li>Người sử dụng máy tính phải có SSH client. Một phần mềm biết được giao tiếp sử dụng giao thức ssh như thế nòa và có thể nhận được thông tin về máy tính từ xa để kết nối đến, sử dụng username và các loại giấy phép khác để xác thực.</li>
</ul>

<a name="3"></a>
## 3. SSh xác thực người dùng như thế nào.

<ul>
	<li>Client có thể sử dụng passowrd (kém bảo mật và không được khuyến khích) hoặc SSH keys để xác thực (rất bảo mật và được khuyến khích sử dụng).</li>
	<li>Mật khẩu đăng nhập được mã hóa và là điều dễ hiểu cho người dùng mới. Tuy nhiên, các hacker sẽ sử dụng các công cụ tự động để thử lại nhiều lần, có thể chiếm được quyền truy cập của chúng ta. Do đó, chúng ta được khuyến khích cấu hình ssh chứng thực bằng SSH key.</li>
	<li>SSh key là một cặp key. Một cặp key bao gồm public key và private key. Public key có thể được chia sẻ, trong khi private key phải được giữ cẩn trọng và không chia sẻ nó cho bất cứ ai.</li>
	<li>Để xác thực sử dụng SSh keys, user phải có cặp key trên máy tính của họ. Trên remote Server, public key phải được copy tới file bên trong thư mục /home của người đó tại **~/.ssh/authorized_keys**.</li>
	<li>Khi Client kết nối đến server, muốn sử dụng xác thực key, client phải thông báo đến server về key public để sử dụng. Server sau khi kiểm tra file `authorized_keys` (chứa public key), sẽ sinh ra một chuỗi ngẫu nhiên và mã hóa bằng public key. Thông điệp đã mã hóa này chỉ có thể được giải mã bằng private key tương ứng. Server sẽ gửi cho client bản mã này.</li>
	<li>Client nhận được bản mã này, nó sẽ giải mã bằng private key tương ứng mà client đang giữ. Client sẽ kết hợp với session ID và chuỗi vừa giải mã để tính hàm băm MD5 rồi gửi lại cho server. Server có chuỗi gốc ban đầu (chuỗi mà đã được mã hóa rồi gửi cho client) kết hợp với sesstion ID để tính hàm băm MD5. Server sẽ kiểm tra giá trị MD5 do nó tính ra và giá trị do client gửi. Nếu hai giá trị trùng nhau thì connect được thiết lập.</li>
</ul>
