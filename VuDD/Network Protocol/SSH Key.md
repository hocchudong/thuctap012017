#Tìm hiểu về kĩ thuật SSH Key (RSA Authentication)

##1.Giới thiệu về SSH key

- SSH key đơn giản là 1 phương thức chứng thực người dùng truy cập bằng cách đối chiếu
giữa key cá nhân(Private Key) và key công khai (Public Key)
- Private key và Public key luôn có liên hệ chặt chẽ với nhau để nó có thể nhận diện lần nhau
- Khi tạo SSH key thì bạn sẽ có cả 2 loại key này. Nội dung của private key và public key
khác nhau nhưng chúng sẽ nhận diện được nhau bằng các thuật toán được cài đặt trước. Hình
dung Private key là chìa khoá còn public key là ổ khoá
- Sau đó bạn sẽ mang public key bỏ vào máy chủ còn private key thì bạn sẽ lưu ở máy tính và
khi đăng nhập vào server, bạn sẽ gửi yêu cầu đăng nhập, kèm theo private key này để gửi tín
hiệu đến server, server sẽ kiểm tra xem private key của bạn có khớp với public key có trên
server không, nếu có bạn sẽ đăng nhập được.

##2. Thành phần chính của 1 SSH key
Khi tạo 1 SSH key, có 3 thành phần quan trọng:
- Public key(dạng file và string): bạn sẽ copy kí tự này và bỏ vào file ~/.ssh/authorized_keys
- Private key(dạng file và string): bạn sẽ lưu file này vào máy tính sau đó sẽ thiết lập cho Putty,
WinSCP, Terminal,... để có thể login
-Keyphase(dạng sting cần ghi nhớ): Mật khẩu để nhớ private key, khi đăng nhập nó sẽ hỏi keyphase này.

##3. Cách tạo SSH key (Trên Mac/Ubuntu)
Trên Ubuntu(Mac) bạn sẽ sử dụng Terminal để cài đặt bằng dòng lệnh như sau:
- Vào Terminal và gõ ssh-keygen -t rsa
- Nó sẽ hỏi bạn muốn lưu private key này vào đâu, mặc định nó sẽ lưu vào /home/user/.ssh. Bạn có thể
để trống rồi Enter
- Tiếp tục nó sẽ hỏi bạn có muốn thiết lập Keyphase không, nếu muốn thì hãy nhập keyphase của bạn vào
(yêu cầu từ 5 kí tự trở lên) sau đó nhấn Enter
- Bạn có thể thấy nó sẽ hiển thị đường dẫn lưu file private key (id_rsa) và file public key(id_rsa.pub)
- Để xem public key này bạn sẽ mở file đó lên và đọc: cat ~/.ssh/id_rsa.pub
- Và bạn sẽ đem public key này lưu vào Ubuntu Server

###Thêm public key vào Ubuntu Server
- Đăng nhập vào Ubuntu Server của bạn
- Sau đó tạo thư mục .ssh và file authorized_keys trong thư muc đó
        mkdir ~/.ssh
        chmod 700 ~/.ssh
        touch ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys
- Sau đó mở file authorized_key trong thư mục /.ssh và copy toàn bộ public key vào
        cat /home/vulee/.ssh/authorized_keys
        nano /home/vulee/.ssh/authorized_keys
- Sau đó reboot là server: sudo reboot
