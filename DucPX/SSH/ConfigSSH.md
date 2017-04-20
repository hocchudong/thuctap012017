# CẤU HÌNH XÁC THỰC SSH BẰNG HOST KEY.

## Mục lục
- [1. Sinh cặp key ssh.](#1)
- [2. Copy public key lên server sử dụng ssh-copy-id.](#2)
- [3. Cấu hình server cho phép đăng nhập.](#3)
- [4. Một số vấn đề liên quan đến key SSH.](#4)

# Chúng ta sẽ sinh ra cặp key trên client và sẽ đầy public lên cho server.

<a name="1"></a>
## 1. Sinh cặp key ssh.
- trên client sử dụng hệ điều hành ubuntu, dùng lệnh `ssh-keygen -t rsa` để sinh ra cặp key. 

![Imgur](http://i.imgur.com/ge4ZaUy.png)

- cặp key sẽ được lưu mặc định ở thư mục  `/home/*user*/.ssh/`
- có thể nhập **passphrase** hoặc để trống. 
- public key được lưu trong file  `/home/*user*/.ssh/id_rsa.pub`
- private key được lưu trong file  `/home/*user*/.ssh/id_rsa`
- chúng ta có thể sinh ra cặp kia với số lượng bit khác. ví dụ  `ssh-keygen -t rsa -b 4096` sẽ tạo ra cặp key theo thuật toán rsa có độ dài 4096 bit.
- Passphrase có thể thay đổi hoặc xóa bỏ. Dùng lệnh `ssh-keygen -p`. 
- ngoài ra, chúng ta còn có thể sinh cặp key này trên hệ điều hành windows với phần mềm sinh key là puttygen.

<a name="2"></a>
## 2. Copy public key lên server sử dụng ssh-copy-id.
- File cấu hình mặc định của ssh sẽ cho phép bạn truy cập bằng mật khẩu. Như vậy chúng ta có thể sử dụng lệnh `ssh-copy-id` một cách dễ dàng để copy public key lên server. 

![Imgur](http://i.imgur.com/PX0ifPl.png)

	- `pxduc@172.16.69.137`: pxduc là user mà chúng ta cấu hình để đăng nhập bằng cặp key đó. 172.16.69.137 là địa chỉ ip của server.

- sau đó thử chạy lệnh `ssh 'pxduc@172.16.69.137'` để kiểm tra kết quả. 

![Imgur](http://i.imgur.com/QFWnzWI.png)

 đã ssh thành công.

<a name="3"></a>
## 3. Cấu hình server cho phép đăng nhập .

- Chúng ta sẽ cấu hình trên server để cho phép users đăng nhập mà không sử dụng password, cho phép đăng nhập bằng host key và không cho phép tài khoản root ssh.
- Vào file config của ssh tại `/etc/ssh/sshd_config`
- tìm và chỉnh sửa các thông tin như sau 

![Imgur](http://i.imgur.com/vlVN5QG.png)

- sau đó `service ssh restart` để khởi động lại ssh.

<a name="4"></a>
## 4. Một số vấn đề liên quan đến key SSH.
- Về mặt lý thuyết, chỉ cần chúng ta có một cặp key public và private thì chúng ta hoàn toàn có thể cấu hình như trên, không cần biết cặp key sinh ra từ đâu.
- Như vậy, vấn đề đặt ra là có thể sinh ra cặp key này từ server được không? Và vấn đề gì xảy ra khi cặp cấu hình nếu key được sinh ra từ server?
- Theo quan điểm cá nhân thì câu trả lời là có. Chúng ta hoàn toàn có thể sinh ra cặp key này ngay trên server. Lấy key public cho file authorized_keys theo đường dẫn như đã cấu hình ở trên và private key sẽ được đẩy về cho client.
- Vấn đề xảy ra khi cấu hình như sau: với thuật toán mã hóa sử dụng khóa công khai (RSA) thì nguyên tắc là phải giữ bí mật khóa private, khóa public thì có thể chia sẻ tự do trên môi trường internet. Như vậy, nếu như trong quá trình server đẩy private key về cho client thông qua môi trường internet không an toàn, rất dễ xảy ra vấn đề bị đánh cắp. Khi đó, user bị chiếm quyền truy cập vào server của mình. Đây là vấn đề liên quan đến bảo mật.
- Còn một tình huống nữa: nếu user là một người đi thuê các server trên khắp thế giới, thì việc sinh key tập trung tại client sẽ là phương án tốt hơn là sinh key từ nhiều nơi.

---


### Về cơ bản cấu hình cho phép users đăng nhập qua ssh đến server như vậy đã xong. Bài viết sẽ cập nhật thêm một số lưu ý trong file cấu hình của SSH.