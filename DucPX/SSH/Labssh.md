# Lab SSH

## Lab 1: 

- Đổi port 22 mặc định truy cập vào SSH Server
- Bỏ quyền ssh với tài khoản root.
- Không cho ssh tới server bằng mật khẩu.

## Thực hành.
Trên **Server**, thông tin cấu hình của ssh nằm ở trong file `/etc/ssh/sshd_config`. Chúng ta sẽ thay đổi cấu hình ssh trong file này để phù hợp với yêu cầu bài lab.

`root@ubuntu:~# vi /etc/ssh/sshd_config`

```sh
# Package generated configuration file
# See the sshd_config(5) manpage for details

# What ports, IPs and protocols we listen for
Port 22 	//port mặc định của ssh là 22
# Use these options to restrict which interfaces/protocols sshd will bind to
#ListenAddress ::
#ListenAddress 0.0.0.0
Protocol 2
# HostKeys for protocol version 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
#Privilege Separation is turned on for security
UsePrivilegeSeparation yes

# Lifetime and size of ephemeral version 1 server key
KeyRegenerationInterval 3600
ServerKeyBits 1024

# Logging
SyslogFacility AUTH
LogLevel INFO

# Authentication:
LoginGraceTime 120
PermitRootLogin yes		//có cho phép tài khoản root đăng nhập qua ssh không
StrictModes yes

RSAAuthentication yes		//sử dụng thuật toán RSA để xác thực
PubkeyAuthentication yes	//có cho phép xác thực bằng public key không
#AuthorizedKeysFile     %h/.ssh/authorized_keys		// đường dẫn lưu public key.

# Don't read the user's ~/.rhosts and ~/.shosts files
IgnoreRhosts yes
# For this to work you will also need host keys in /etc/ssh_known_hosts
RhostsRSAAuthentication no
# similar for protocol version 2
HostbasedAuthentication no
# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
#IgnoreUserKnownHosts yes

# To enable empty passwords, change to yes (NOT RECOMMENDED)
PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# Change to no to disable tunnelled clear text passwords
PasswordAuthentication no	//có cho phép xác thực bằng mật khẩu không

# Kerberos options
#KerberosAuthentication no
#KerberosGetAFSToken no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no

#MaxStartups 10:30:60
#Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

Subsystem sftp /usr/lib/openssh/sftp-server

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes
```                                                                                                                                                       

---

- để đổi port mặc định 22 của ssh, tại dòng **5** thay bằng một port khác: `Port 2048`
- để bỏ quyền ssh với tài khoản root, tại dòng **28** cho giá trị yes bằng `without-password`: `PermitRootLogin without-password`
- không cho ssh tới server bằng mật khẩu, tại dòng **52** cho giá trị `no`: `PasswordAuthentication no`

Sau khi thiết lập các giá trị xong, khởi động lại dịch vụ ssh để cập nhật lại cấu hình mới `service ssh restart`

## Lab 2:
#### Cấu hình cho hai user đăng nhập vào server bằng host key.
#### Mô hình bài LAB, với 2 user sử dụng hai nền tảng khác nhau: một user sử dụng linux và một sử dụng windows. User dùng win sẽ thông qua phần mềm Putty để đăng nhập, user dùng linux cần được cài đặt `Openssh-client`

![Imgur](http://i.imgur.com/n3eSwiv.png)

- Cấu hình cho phép các user đăng nhập vào server bằng ssh.
	Ban đầu ssh phải cho phép user đăng nhập bằng mật khẩu:
	- Trên Server, khai báo dòng này `PasswordAuthentication yes` trong file `/etc/ssh/sshd_config` tại dòng 52.

<h5>Cấu hình cho User: pxduc</h5>

- Trên máy client chạy windows, sử dụng phần mềm puttygen để sinh ra cặp key.

- Khởi động phần mềm lên ta thấy giao diện sau

![Imgur](http://i.imgur.com/eCaxiGD.png) 

- Chọn **RSA** và click vào `Generate` để sinh key, trong quá trình sinh key cần di chuyển chuột trong khoảng trống của phần mềm
- Sau khi sinh cặp key xong, chúng ta có thể nhập `Key passphrase` hoặc để trống. Sau đó click `Save private key` để sau này khi đăng nhập dùng cho việc xác thực, `Save public key` để copy lên server (public key không cần lưu cũng được vì phần mềm có thể load lại khi có private key)

![Imgur](http://i.imgur.com/Hfu80yf.png)

- Sử dụng phần mềm Moba đăng nhập vào server để copy public key lên (hoặc có thể sử dụng winscp để đẩy file chứa public key lên server). Public key nằm trong ô màu đỏ

![Imgur](http://i.imgur.com/JWR9Bt4.png)

- Quay lại phía Server, tạo file authorized_keys có nội dung là public key vừa tạo: `vi /home/pxduc/.ssh/authorized_keys`.
- Trong file cấu hình ssh (file `/etc/ssh/sshd_config`), chỉ rõ thư mục chứa public key của user. Tại dòng 33, chỉ cần bỏ dấu `#` ở đầu dòng là được.
- ![Imgur](http://i.imgur.com/lUQA5rw.png)
- Khởi động lại dịch vụ ssh.
- Như vậy, Server đã được cấu hình xong cho phép user **pxduc** đăng nhập vào Server bằng host key.
- Để kiểm tra cấu hình đã đúng hay chưa, trên client sử dụng phần mềm putty để đăng nhập vào server.
- Cần chỉ rõ địa chỉ ip của server và port kết nối ssh. 

![Imgur](http://i.imgur.com/2tlLhEJ.png).

- Sau đó chỉ đường dẫn đến private key mà chúng ta đã lưu lúc trước 
![Imgur](http://i.imgur.com/gZh86ms.png)

- Click vào Open ta sẽ thây giao diện yêu cầu nhập username và Key passphrase 
![Imgur](http://i.imgur.com/JWpgaS1.png)

- Như vậy đã cấu hình thành công cho phép user pxduc đăng nhập vào ssh bằng host key.

#### Cấu hình cho User: user1
- User1 cần phải tồn tại trên server trước.

- Đăng nhập vào client để tạo key. Lệnh tạo key `ssh-keygen -t rsa`
![Imgur](http://i.imgur.com/7vql9te.png)
	- chọn vị trí lưu key.
	- vì ở trong thư mục này đã tồn tại một key trước rồi, hệ thống sẽ hỏi có muốn thay đổi key không? chọn y để thay đổi key mới.
	- key public được lưu trong file `id_rsa.pub`
	- key private lưu trong file `ip_rsa`

- sử dụng lệnh `ssh-copy-id user1@172.16.69.137 -p 2048` để copy public key lên server cho user1 
![Imgur](http://i.imgur.com/y2zCfWY.png).
	- Vì port đã được đổi nên cần có tham số `-p 2048`. Sau đó nhập mật khẩu của user1 và ta thấy kết quả `Number of key(s) added: 1`

- Chúng ta thử đăng nhập vào user1 qua ssh (lúc này server vẫn đang cho phép đăng nhập bằng mật khẩu). Thông báo đã đăng nhập thành công.
 
![Imgur](http://i.imgur.com/QS5Lvke.png) 


### Cấu hình Trên Server không cho phép đăng nhập bằng mật khẩu
- Tại dòng **52** trong file cấu hình ssh (`/ect/ssh/sshd_config`), ta cho giá trị là `no`: `PasswordAuthentication no`
- ![Imgur](http://i.imgur.com/iysTryT.png)
- restart lại ssh.
- Chúng ta sẽ kiểm tra file log của ssh để xem các phiên truy cập vào server qua ssh. 

![Imgur](http://i.imgur.com/ua66WAA.png)

- Như vậy file log đã ghi lại thông tin truy cập từ client và đã được đồng ý truy cập bằng key.
- Chúng ta có thể giới hạn những user được phép truy cập vào server qua ssh bằng cách thêm dòng  `AllowUsers pxduc` vào cuối file `/ect/ssh/sshd_config` (ở đây chỉ cho user pxduc đăng vào)
- Chúng ta thử đăng nhập user1 qua ssh và xem file log ghi lại thông tin gì?
- Client đã bị từ chối đăng nhập 

![Imgur](http://i.imgur.com/QyFzpF6.png)

- Thông tin từ file log của server 

![Imgur](http://i.imgur.com/srP4LZz.png)
