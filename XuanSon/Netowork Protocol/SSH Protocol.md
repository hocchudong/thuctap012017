# SSH Protocol


# MỤC LỤC
- [1.Giới thiệu](#1)
- [2.Đặc điểm của SSH](#2)
- [3.Cách thức làm việc của SSH](#3)
  - [3.1.Giới thiệu](#3.1)
    - [3.1.1.Symmetrical encryption](#3.1.1)
    - [3.1.2.Asymmetrical Encryption](#3.1.2)
    - [3.1.3. Hashing](#3.1.3) 
  - [3.2.SSH làm việc như thế nào ?](#3.2)
    - [3.2.1.Dàn xếp Encryption cho Session ](#3.2.1)
    - [3.2.2. Authenticating the User's Access to the Server](#3.2.2)
  - [3.3.Chú ý](#3.3)
- [4.Install SSH Client and SSH Server on the Ubuntu  14.04](#4)
- [5.File config in SSH client and SSH server](#5)
  - [5.1.File in Openssh-client](#5.1)
    - [5.1.1.~/.ssh/know_hosts file](#5.1.1)
    - [5.1.2. ~/.ssh/config](#5.1.2)
  - [5.2.File in openssh-server ](#5.2)
    - [5.2.1.File /etc/ssh/sshd_config](#5.2.1)
- [6.Command](#6)
  - [6.1.SSH client command](#6.1)
  - [6.2.scp](#6.2)
  - [6.3.ssh-keygen command](#6.3)
- [7.Intermediate SSH](#7)
  - [7.1.Remote command](#7.1)
  - [7.2.X11 forwarding](#7.2)
- [8.SSH key](#8)
  - [8.1.Giới thiệu SSH key và Cách làm việc của SSH key](#8.1)
    - [8.1.1.Giới thiệu SSH key](#8.1.1)
    - [8.1.2.Cách làm việc của SSH key](#8.1.2)
  - [8.2.Tạo key](#8.2)
  - [8.3.Removing or Changing the Passphrase on a Private Key](#8.3)
  - [8.4.Displaying the SSH Key Fingerprint](#8.4)
  - [8.5. Copying your Public SSH Key to a Server](#8.5)
- [9.SSH agent](#9)
- [THAM KHẢO](#thamkhao)




<a name="1"></a>
# 1.Giới thiệu
\- SSH (Secure Shell) là secure protocol để kết nối server remotely . Nó cung cấp interface bởi remote shell . Sau khi kết nối , all command của bạn trên local terminal sẽ được gửi tới remote server và thực thi .  
\- SSH hoạt động ở lớp application của model TCP/IP. SSH lắng nghe trên port 22 của TCP .  
\- SSH được thiết kế để thay thế Telnet ( Telnet là protocol thiết lập kết nối không bảo mật ) .  

<a name="2"></a>
# 2.Đặc điểm của SSH
\- Các đặc điểm chính của giao thức SSH là:  
- Tính bí mật (Privacy) của dữ liệu thông qua việc mã hoá mạnh mẽ
- Tính toàn vẹn (integrity) của thông tin truyền, đảm bảo chúng không bị biến đổi.
- Chứng minh xác thực (authentication) nghĩa là bằng chứng để nhận dạng bên gửi và bên nhận
- Giấy phép (authorization) :dùng để điều khiển truy cập đến tài khoản.
- Chuyển tiếp (forwarding) hoặc tạo đường hầm (tunneling) để mã hoá những phiên khác dựa trên giao thức TCP/IP .SSH hỗ trợ 3 kiểu chuyển tiếp:
  - TCP port forwarding 
  - X forwarding
  - Agent forwarding

<a name="3"></a>
# 3.Cách thức làm việc của SSH
<a name="3.1"></a>
## 3.1.Giới thiệu
\- Để bảo đảm tính secure trong truyền information , SSH sử dụng symmetrical encryption, asymmetrical encryption, và hashing.  
<a name="3.1.1"></a>
### 3.1.1.Symmetrical encryption
\- Symmetrical encryption là loại encryption mà một key có thể được sử dụng để encryt messages rồi gửi đến bên nhận , và cũng để decrypt messages nhận được . Điều này có nghĩa bất cứ ai có key đều có thể encrypt và decrypt messages .  
\- Loại encryption này thường được gọi là “shared secret” encryption , hoặc “secret key” encryption . Thường chỉ cos một key được sử dụng cho tất cả các hoạt động ,hoặc một key pair , mơi mối quan hệ giữa chúng dễ dàng để phát hiện và dễ dàng lấy được key còn lại từ key đã có .  
\- Symetric keys được sử dụng bởi SSH để encrypt toàn bộ connection .  
\- SSH được cấu hình để sử dụng một loạt các hệ thống mật mã symetric key khác nhau , bao gồm : AES , Blowfish,3DEC,CAST128 và Arcfour .  

<a name="3.1.2"></a>
### 3.1.2.Asymmetrical Encryption
\- Asymmetrical Encryption khác symmetrical encryption trong đó data được gửi theo một hướng duy nhất . Một key gọi là private key , khóa kia gọi là public key .  
\- Public key có thể được shared tự do với bất kỳ bên nào . Data sẽ được encrypt bằng public key và chỉ được decrypt bằng private key . Đây là một chiều , có nghĩa là public không có khả năng decrypt message nó viết .  
\- Private key được giữ bí mật và không bao giờ được share .  
\- SSH sử dụng asymmetrical encryption trong một vài trường hợp khác nhau . Trong quá trình trao đổi key ban đầu để thiết lập symmetrical ( được sử dụng encrypt session ) , asymmetrical encryption là được sử dụng .  
Trong giai đoạn này , server sẽ key pair và gửi public key cho client , client sẽ tạo symmetrical encryption và được encrypt bằng public key , sau đó gửi lại cho server , server dùng private key để decrypt . Vậy là quá trình thỏa thuận encryption key để encrypt session đã xong .
/- Asymmetrical Encryption cũng có thể được sử dụng để authenticate client kết nối đến server . Client tạo key pair và upload public key lên remote server mà nó truy cập .  

<a name="3.1.3"></a>
### 3.1.3. Hashing
Tham khảo :
https://www.digitalocean.com/community/tutorials/understanding-the-ssh-encryption-and-connection-process  

<a name="3.2"></a>
## 3.2.SSH làm việc như thế nào ?
\- SSH protocol sử dụng model client-server để authenticate và encrypt data giữa chúng .  
\- Một session của SSH được thành lập qua 2 bước .  
- Bước 1 : Đầu tiên là thỏa thuận và thiết lập encryption để bảo vệ thông tin liên lạc trong tương lai .
- Bước 2 : Authenticate user .

<a name="3.2.1"></a>
### 3.2.1.Dàn xếp Encryption cho Session 
\- Khi TCP connection được thực hiện bởi client , server đáp ứng với protocol mà nó hỗ trợ . Server cung cấp một public host key .  
\- Tại thời điểm này , cả 2 bên thương lượng một session key sử dụng thuật toán Diffie-Hellman .  
\- Session key sẽ được sử dụng để encrypt toàn bộ session . Public và private key pair được sử dụng như một phần của quy trình và hoàn toàn không liên quan đến SSH key .  

\- Các bước như sau :  
- Đầu tiên , client gửi yêu cầu kết nối đến SSH server .
- SSH server đồng ý yêu cầu và tạo ra một key pair gồm public key và private key , sau đó gửi lại client public key .
- Client nhận được public key , sau đó client sinh một session key ngẫu nhiên ( là symmetrical encryption , thường là AES ) và mã hóa session key bằng public key rồi gửi lại server .
- Server nhận được session key đã mã hóa bởi public key , sau đó encrypt bằng private key .
- Vậy là client và server đã thỏa thuận với nhau session key , key này được sử dụng encrypt data toàn bộ phiên kết nối 
>Note : session key còn gọi là host key .

<a name="3.2.2"></a>
### 3.2.2. Authenticating the User's Access to the Server
\- Ở giai đoạn này liên quan đến việc authenticating user và quyết định access. Có một vài phương pháp khác nhau để authentication .  
\- Đơn giản nhất là authentication bằng password . password sẽ được encrypt và gửi lên server , vì vậy password tương đối khó bị đánh cắp .  
\- Mặc dụ password được encrypt , phương pháp này thường không nên sử dụng do sự phức tạp của password .  
\- Phương pháp được khuyên thay thế là sử dụng SSH key pair .Authentication sử dụng SSH key pair bắt đâuù sau khi symmetric encryption được thiết lập như mô tả trong phần trước . Thủ tục xảy ra như sau :  
- The client begins by sending an ID for the key pair it would like to authenticate with to the server.
- The server check's the authorized_keys file of the account that the client is attempting to log into for the key ID.
- If a public key with matching ID is found in the file, the server generates a random number and uses the public key to encrypt the number.
- The server sends the client this encrypted message.
- If the client actually has the associated private key, it will be able to decrypt the message using that key, revealing the original number.
- The client combines the decrypted number with the shared session key that is being used to encrypt the communication, and calculates the MD5 hash of this value.
- The client then sends this MD5 hash back to the server as an answer to the encrypted number message.
- The server uses the same shared session key and the original number that it sent to the client to calculate the MD5 value on its own. It compares its own calculation to the one that the client sent back. If these two values match, it proves that the client was in possession of the private key and the client is authenticate

<a name="3.3"></a>
## 3.3.Chú ý
\- Nếu lần đầu tiên ssh đến remote host thì ssh client sẽ đưa ra cảnh báo , nó chỉ ra IP_address bạn ssh tới .  

<img src="http://i.imgur.com/oPHmNY5.png" >  

<a name="4"></a>
# 4.Install SSH Client and SSH Server on the Ubuntu  14.04
## a.Install SSH Client
```
$sudo apt-get install openssh-client
```
## b.Install SSH Server 
\- Install :  
```
$sudo apt-get install openssh-server
#or
$sudo apt-get install ssh
```

<a name="5"></a>
# 5.File config in SSH client and SSH server
There are two different sets of configuration files: those for client programs (that is, ssh, scp, and sftp), and those for the server (the sshd daemon).

<a name="5.1"></a>
## 5.1.User-specific configuration files
\- User-specific SSH configuration information is stored in `~/.ssh/` within the user's home directory .  

<img src="http://i.imgur.com/Vqj8gPg.png" >  

>- Note : MoBaXTerm sử dụng openssh-client :
Các file được lưu trong thư mục `/MobaXterm/home/[user]/.ssh` 

<a name="5.1.1"></a>
### 5.1.1.~/.ssh/know_hosts file
\- file /MobaXterm/home/.ssh/known_hosts  :  chứa thông tin về các host đã đăng nhập , thuật toán mã hóa , host key .  
**VD** : Nội dung trong file `/home/.ssh/known_hosts`  :  
```
10.10.10.137 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqgwEdhKDwm6xzV6Mp1yiFFXvbS6DVOviV7h1/xV90/NwlbDIur/gh9TVCMza4d0HfXdsgocMclBd2xZ0oDHB2wOyqQRoFFdZnYxqgWK/DKue/P/M82Uf103fcMoRG8gnwDQNM3vvs3ZmsLLz4nLc+Dw2RvyoAy5lRsj3X9wroP8FUFE1SsKJvONgZ5fxQdd0A3mT8TFe0lDFDCNK+ptGTVmrGuDu3hG8j21xnzTBFKeUM/LCIX0qV4KPb7forh6NccGBlbW/qc82JaGdKsLlt5bpk5I0NK94T1yg9wdnWku+u0rgQf9wIUZAinxZHRhr1QSlfP6KNWqpJIQkPy6Sv
172.16.69.135 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqgwEdhKDwm6xzV6Mp1yiFFXvbS6DVOviV7h1/xV90/NwlbDIur/gh9TVCMza4d0HfXdsgocMclBd2xZ0oDHB2wOyqQRoFFdZnYxqgWK/DKue/P/M82Uf103fcMoRG8gnwDQNM3vvs3ZmsLLz4nLc+Dw2RvyoAy5lRsj3X9wroP8FUFE1SsKJvONgZ5fxQdd0A3mT8TFe0lDFDCNK+ptGTVmrGuDu3hG8j21xnzTBFKeUM/LCIX0qV4KPb7forh6NccGBlbW/qc82JaGdKsLlt5bpk5I0NK94T1yg9wdnWku+u0rgQf9wIUZAinxZHRhr1QSlfP6KNWqpJIQkPy6Sv
```
>NX : Nội dung private key là giống nhau nếu cùng thuật toán mã hóa .

<a name="5.1.2"></a>
### 5.1.2. ~/.ssh/config
\- File config ssh ( `~/.ssh/config` ) chứa nhiều thông tin cấu hình trước khi kết nối với remote host.  
#### a.Host
\- File config được tách thành nhiều phần bởi chỉ thị "Host". Mọi cấu hình sau dòng Host được áp dụng cho host đó.  
\- Chỉ thị "Host *" là chỉ thị đặc biệt, ký tự "*" đại diện cho mọi host.  
#### b.Hostname
\- Sử dụng chỉ thị "HostName " để chỉ định host với ip_address cụ thể. SSH sẽ kết nối tới host đó thay thì host chỉ định trên command line.  
#### c.User
\- Chỉ định người dùng khi kết nối tới host, tương ứng với "<user>@" khi thực hiện ssh trên command line. Ví dụ:  
**VD**: file `~/.ssh/config`  
``` 
Host *
Hostname 10.10.10.137
User winterwind
```
or
```
Host devstack
Hostname 10.10.10.137
User winterwind
```

<img src="http://i.imgur.com/ybkNoIi.png" >  

<img src="http://i.imgur.com/6swkUH1.png" >  

#### d. Compression
\- Thiết lập "`Compression yes`" nếu muốn nén dữ liệu khi truyền dữ liệu.  
#### e.Port
```
port <port_number>
```

#### f. Lots of others
\- Ngoài các tùy chọn trên còn nhiều tùy chọn khác có thể cấu hình trong file config. Đọc thêm SSH book hoặc tra man page để tìm hiểu thêm.  
https://www.ssh.com/manuals/ 

<a name="5.2"></a>
## 5.2.System-wide configuration files
\- System-wide SSH configuration information is stored in the `/etc/ssh` .  

<img src="http://i.imgur.com/ZqldjAf.png" >  

<a name="5.2.1"></a>
### 5.2.1.File /etc/ssh/sshd_config
#### a. PermitRootLogin
\- Cho phép tài khoản root đăng nhập SSH :  
Tại dòng `PermitRootLogin without-password` thay đổi thành `PermitRootLogin yes`
\- Không cho phép tài khoản root đăng nhập SSH :  
Tại dòng `PermitRootLogin without-password` thay đổi thành `PermitRootLogin no`
#### b. Password Authentication
\- Mặc định là có password authentication .  
\- Tìm đến dòng có từ `PasswordAuthentication` :  
- Nếu muốn disable password authentication , sửa thành `PasswordAuthentication no` .
- Nếu muốn enable password authentication, sửa thành `PasswordAuthentication yes` .
On Ubuntu/Debian:  
```
sudo service ssh restart
```
On CentOS/Fedora:  
```
sudo service sshd restart
```
### c. Changing the Port that the SSH Daemon Runs On
\- Tìm đến dòng có `Port` và thay đổi .
\- Ví dụ :
```
Port 4444
```

#### d. Limiting the Users Who can Connect Through SSH
\- Để hạn chế user accounts có thể đăng nhập thông qua SSH . Bạn có thể tìm kiếm `AllowUsers` .Nếu không tồn tại , bạn có thể tạo nó ra ở bất cứ đâu . Sau chỉ thị này là danh sách các user accounts được phép đăng nhập qua SSH :  
```
AllowUsers <user1> <user2>
```
\- Bạn cũng có thể cho phép user group  login thông qua SSH bằng cách tìm đến chỉ thị `AllowGroups` . Sau chỉ này là dánh sách các group được phép đăng nhập qua SSH :  
```
AllowGroups <sshmembers>
```
Còn nữa :  
https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys#client-side-configuration-options

<a name="6"></a>
# 6.Command

<a name="6.1"></a>
## 6.1.SSH client command
\- Tham khảo :  
```
man ssh
```
\- SYNTAX :  
```
ssh [-1246AaCfgKkMNnqsTtVvXxYy] [-b bind_address] [-c cipher_spec]
    [-D [bind_address:]port] [-E log_file] [-e escape_char]
    [-F configfile] [-I pkcs11] [-i identity_file]
    [-L [bind_address:]port:host:hostport] [-l login_name] [-m mac_spec]
    [-O ctl_cmd] [-o option] [-p port]
    [-Q cipher | cipher-auth | mac | kex | key]
    [-R [bind_address:]port:host:hostport] [-S ctl_path] [-W host:port]
    [-w local_tun[:remote_tun]] [user@]hostname [command]
```
\- VD1 :  
```
ssh 10.10.10.135
ssh winterwind@10.10.10.135
ssh –l winterwind 10.10.10.135 
ssh –p 22 –l winterwind@10.10.10.135
ssh –p 22 –l winterwind 10.10.10.135
```
<a name="6.2"></a>
## 6.2.scp 
scp là một chương trình sao chép file qua mạng dựa trên giao thức ssh. Nó mã hóa mọi thứ, cả password và dữ liệu.  
\- Tham khảo :
```
man scp
```
\- NAME  
scp - secure copy (remote file copy program)  
\- SYNOPSIS  
```
scp [-12346BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]   [-l limit] [-o ssh_option] [-P port] [-S program]
     [[user@]host1:]file1 ... [[user@]host2:]file2
```
\- VD :  
- Copy file `test.txt` từ local đến thư mục `/home/winterwind` của remote host :
```
scp test.txt winterwind@10.10.10.137:/home/winterwind
```

<img src="http://i.imgur.com/pjV3LLd.png" >  

- Copy the file "foobar.txt" from a remote host to the local host
```
scp your_username@remotehost.edu:foobar.txt /some/local/directory
```
- Copy the directory "foo" from the local host to a remote host's directory "bar"
```
scp -r foo your_username@remotehost.edu:/some/remote/directory/bar
```
- Copy the file "foobar.txt" from remote host "rh1.edu" to remote host "rh2.edu"
```
scp your_username@rh1.edu:/some/remote/directory/foobar.txt your_username@rh2.edu:/some/remote/directory/
```
- Copying the files "foo.txt" and "bar.txt" from the local host to your home directory on the remote host
```
scp foo.txt bar.txt your_username@remotehost.edu:
```

<a name="6.3"></a>
## 6.3.ssh-keygen command
\- THAM KHẢO  
```
man ssh-keygen
```
\- NAME  
ssh-keygen - authentication key generation, management and conversion
\- SYNOPSIS  
```
     ssh-keygen [-q] [-b bits] [-t dsa | ecdsa | ed25519 | rsa | rsa1]
                [-N new_passphrase] [-C comment] [-f output_keyfile]
     ssh-keygen -p [-P old_passphrase] [-N new_passphrase] [-f keyfile]
     ssh-keygen -i [-m key_format] [-f input_keyfile]
     ssh-keygen -e [-m key_format] [-f input_keyfile]
     ssh-keygen -y [-f input_keyfile]
     ssh-keygen -c [-P passphrase] [-C comment] [-f keyfile]
     ssh-keygen -l [-f input_keyfile]
     ssh-keygen -B [-f input_keyfile]
     ssh-keygen -D pkcs11
     ssh-keygen -F hostname [-f known_hosts_file] [-l]
     ssh-keygen -H [-f known_hosts_file]
     ssh-keygen -R hostname [-f known_hosts_file]
     ssh-keygen -r hostname [-f input_keyfile] [-g]
     ssh-keygen -G output_file [-v] [-b bits] [-M memory] [-S start_point]
     ssh-keygen -T output_file -f input_file [-v] [-a rounds] [-J num_lines]
                [-j start_line] [-K checkpt] [-W generator]
     ssh-keygen -s ca_key -I certificate_identity [-h] [-n principals]
                [-O option] [-V validity_interval] [-z serial_number] file ...
     ssh-keygen -L [-f input_keyfile]
     ssh-keygen -A
     ssh-keygen -k -f krl_file [-u] [-s ca_public] [-z version_number]
                file ...
     ssh-keygen -Q -f krl_file file ...
```
\- VD:  
```
ssh-keygen –t rsa
```

<a name="7"></a>
# 7.Intermediate SSH

<a name="7.1"></a>
## 7.1.Remote command
\- Ta không cần kết nối tới shell trên remote computer, chỉ cần nói với ssh để thực hiện một command từ xa và lấy kết quả trả về.  
\- Cú pháp :  
```
ssh <username@remote_host> <command_to_run>
```
\- Ví dụ :  
```
[XuanSon.XuanSon] ➤ ssh winterwind@10.10.10.131 'ls -l ; echo Hello World ; whoami '
total 60
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Desktop
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Documents
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Downloads
-rw-r--r-- 1 winterwind winterwind 8980 Jun 20 11:10 examples.desktop
drwxrwxr-x 2 winterwind winterwind 4096 Sep 30 18:50 images
drwxrwxr-x 2 winterwind winterwind 4096 Sep 30 18:36 iso
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Music
drwxr-xr-x 3 winterwind winterwind 4096 Aug 13 18:48 my-wordpress
drwxrwxr-x 2 winterwind winterwind 4096 Oct  1 00:36 OSFile
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Pictures
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Public
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Templates
drwxr-xr-x 2 winterwind winterwind 4096 Jun 20 11:21 Videos
Hello World
winterwind
```

<img src="http://i.imgur.com/88l0hfZ.png" >

\- Một số chương trình chạy trực tiếp trên terminal như 'vi' là những chương trình có tính tương tác. Tuy nhiên khi sử dụng ssh remote command, cần phải sử dụng tùy chọn -t để sử dụng terminal giả lập để chạy các phần mềm đó. Ví dụ:  
```
[XuanSon.XuanSon] ➤ ssh -t winterwind@10.10.10.131 'vi note'
Connection to 10.10.10.131 closed.
```

<img src="http://i.imgur.com/MAhgcSS.png" >  

<a name="7.2"></a>
## 7.2.X11 forwarding
\- Chương trình đồ họa sử dụng giao thức X Window để hiển thị lên màn hình của bạn. Với X, bạn có thể chạy một chương trình trên remote computer và hiển thị nó lên máy cục bộ. Thông thường X sẽ không mã hóa qua mạng. Với tùy chọn -X, bạn có thể sử dụng kết nối mã hóa với chương trình đồ họa. Ví dụ:  
```
[XuanSon.XuanSon] ➤ ssh -X winterwind@10.10.10.131 xclock
Warning: Missing charsets in String to FontSet conversion
```

<img srcc="http://i.imgur.com/WtOqHOC.png" >

<a name="8"></a>
# 8.SSH key

<a name="8.1"></a>
## 8.1.Giới thiệu SSH key và Cách làm việc của SSH key

<a name="8.1.1"></a>
### 8.1.1. Giới thiệu SSH key
\- SSH có thể sử dụng một số phương pháp để “chứng thực” như sử dụng password hoặc ssh key . Tuy nhiên ssh key là an toàn hơn .  
\- Một số thuật toán mã hóa có thể được sử dụng như RSA , DSA , ECDSA . Tuy nhiên , RSA thường được ưa thích và là loại key mặc định .  

<a name="8.1.2"></a>
### 8.1.2. Cách làm việc của SSH key
\- SSH key pairs gồm public key và private key .  
\- Private key được giữ bởi client và tuyệt đối bảo mật . Để phòng ngừa bổ sung , private có thể được encrypted với passphrase .  
\- Public key liên kết có thể được shared một cách tự do mà không có bất kỳ hậy quả tiêu cực nào . Public key có thể encrypt messages mà chỉ private key có thể decrypt .  
\- Public key được upload lên remote host mà bạn muốn đăng nhập với SSH . Key được added thêm vào file chỉ định trong user account bạn sẽ đăng nhập gọi là `~/.ssh/authorized_keys` .  
\- SSH key làm việc như sau :  
- The client begins by sending an ID for the key pair it would like to authenticate with to the server.
- The server check's the authorized_keys file of the account that the client is attempting to log into for the key ID.
- If a public key with matching ID is found in the file, the server generates a random number and uses the public key to encrypt the number.
- The server sends the client this encrypted message.
- If the client actually has the associated private key, it will be able to decrypt the message using that key, revealing the original number.
- The client combines the decrypted number with the shared session key that is being used to encrypt the communication, and calculates the MD5 hash of this value.
- The client then sends this MD5 hash back to the server as an answer to the encrypted number message.
- The server uses the same shared session key and the original number that it sent to the client to calculate the MD5 value on its own. It compares its own calculation to the one that the client sent back. If these two values match, it proves that the client was in possession of the private key and the client is authenticate

<a name="8.2"></a>
## 8.2.Tạo key
Sử dụng `ssh-keygen` command với tùy chọn '`-t rsa`' để tạo RSA key ( bạn có thể chỉ sử dụng `ssh-keygen` command vì thuật toán RSA là thuật toán mặc định được sử dụng )
```
ssh-keygen -t rsa 
#or
ssh-keygen
```
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/demo/.ssh/id_rsa):
```

Tùy chọn này cho phép bạn chọn vị trí lưu RSA private key , mặc định là thư mục `home/demo/.ssh/id_rsa` ( nhấn phim ENTER để chọn mặc định )  
```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```
Tùy chọn này cho phép bạn nhập passphrase cho private_key của bạn . Theo mặc định mỗi lần bạn sử dụng private key này , bạn phải nhập passphrase này để sử dụng . Hãy nhấn phím ENTER để bỏ trống mục này nếu bạn không muốn phải điền mật khẩu mỗi lần dùng private key .  
Thủ tục này tạo ra một cặp RSA SSH key pair thư lục `.ssh` của thư mục `home` của user .  
- `~/.ssh/id_rsa`: The private key. DO NOT SHARE THIS FILE!
- `~/.ssh/id_rsa.pub`: The associated public key. This can be shared freely without consequence.
Ví dụ :  
```
[XuanSon.XuanSon] ➤ ssh-keygen -t rsa

Generating public/private rsa key pair.
Enter file in which to save the key (/home/mobaxterm/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/mobaxterm/.ssh/id_rsa.
Your public key has been saved in /home/mobaxterm/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:5h1aeHVyYx7FAyOba772CJu5ysiUOX9a9eab0g3hOjw XuanSon@XuanSon
The key's randomart image is:
+---[RSA 2048]----+
|           . o...|
|            + .o.|
|           oo * .|
|         . ..B o |
|        S ++. o  |
|      oo =+..o   |
|     =  ooo.ooo  |
|    o = ..=E=... |
|     o =+=oo==.  |
+----[SHA256]-----+

```

<a name="8.3"></a>
## 8.3.Removing or Changing the Passphrase on a Private Key
Sử dụng câu lệnh :  
```
ssh-keygen -p
```

<a name="8.4"></a>
## 8.4.Displaying the SSH Key Fingerprint
Each SSH key pair share a single cryptographic "fingerprint" which can be used to uniquely identify the keys. This can be useful in a variety of situations.  
To find out the fingerprint of an SSH key, sử dụng command:
```
ssh-keygen -l
```
<a name="8.5"></a>
## 8.5. Copying your Public SSH Key to a Server
\- Nếu bạn tạo keypair trên client , thì bạn cần thêm nội dung trong file `~/.ssh/id_rsa.pub`  ( trên client ) vào file `~/.ssh/authorized_keys` ( trên server)  .  
\- Tự copy file `~/.ssh/id_rsa.pub` lên server và ghi nội dung file đó vào file `~/.ssh/authoruzed_keys` hoặc dùng command :  
```
ssh-copy-id  -i <file_name>  username@ip_address 
```

<img src="http://i.imgur.com/AzEYVN4.png" >  

Để đăng nhập thông qua key :  
```
ssh –i <file_private_key> <username>@<IP_host>
```

>Note :
>- Key pair phải tương ứng với mỗi user ( ở server ) , có nghĩa là ta phải dùng private key tương ứng với public key trong file ~/.ssh/authorized_keys ( ở server ) của user ta muốn truy cập .
>- Mặc dù cả private_key và public_key đều dùng để giải mã mật mã được mã hóa bởi key kia, nhưng trong môi trường ssh thì private_key sử dụng cho client , public_key sử dụng cho server.
>- Trên OS Linux, file private_key phải để quyền 500 hoặc 600 hoặc 700 thì mới dùng để ssh từ client vào server bằng key pair được.


<a name="9"></a>
# 9.SSH agent
Tham khảo :  
https://github.com/thaihust/Thuc-tap-thang-03-2016/blob/master/ThaiPH/ThaiPH_baocaotimhieussh.md#host  


<a name="thamkhao"></a>
# THAM KHẢO
- Introduction :  
  - Homepage : https://www.ssh.com/
    - Docs : https://www.ssh.com/manuals/  
  - Openssh : https://www.openssh.com/ 
    - Đây là 1 phần mềm ssh client and server phổ biến của ssh .
  - https://en.wikipedia.org/wiki/Secure_Shell  
  - https://en.wikipedia.org/wiki/Secure_copy  
- Chi tiết : 
  - https://github.com/thaihust/Thuc-tap-thang-03-2016/blob/master/ThaiPH/ThaiPH_baocaotimhieussh.md#concept  
  - http://sinhvienit.net/forum/chuyen-de-tim-hieu-ssh.10058.html  
  - SSH :  
https://www.digitalocean.com/community/tutorials/understanding-the-ssh-encryption-and-connection-process  
https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server  
https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys  
https://www.digitalocean.com/community/search?q=ssh+key&type=tutorials  

- File config :
  - Openssh-server and client in Red Hat : https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/s1-ssh-configuration.html  
  - Openssh-server and client in Ubuntu : 
https://help.ubuntu.com/lts/serverguide/openssh-server.html   
https://help.ubuntu.com/community/SSH/OpenSSH/Configuring  
- Command Syntax : 
  - Remote operations are done using :
 ssh : http://man.openbsd.org/OpenBSD-current/man1/ssh.1  
 scp : http://man.openbsd.org/OpenBSD-current/man1/scp.1  
  http://www.hypexr.org/linux_scp_help.php  
 sftp : http://man.openbsd.org/OpenBSD-current/man1/sftp.1  



