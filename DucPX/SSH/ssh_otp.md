## How To Set Up Multi-Factor Authentication for SSH on Ubuntu 16.04

## Giới thiệu
- Một yếu tố xác thực (Authentication factor) là một phần thông tin được sử dụng để chứng minh bạn có quyền thực hiện hành động, chẳng hạn như đăng nhập vào một hệ thống. Kênh xác thực (authentication channel) là cách thức một hệ thống xác thực cung cấp một yếu tố cho người dùng hoặc yêu cầu người dùng trả lời. Mật khẩu và thẻ an ninh (security token) là những ví dụ về các yếu tố xác thực; máy tính và điện thoại là những ví dụ về các kênh.
- Mặc định, SSH sử dụng mật khẩu để xác thực, và hầu hết các hướng dẫn về ssh khuyên nên sử dụng ssh key để thay thế. Tuy nhiên, đây vẫn đang chỉ là xác thực một nhân tố. Nếu có máy tính của bạn bị hacked thì kẻ xấu có thể sử dụng ssh key để đăng nhập vào servers.
- Trong hướng dẫn này sẽ thiết lập multi-fator authentication (xác thực đa nhân tố)
- Hướng dẫn thực hiện trên Ubuntu server 16.04
- Chuẩn bị: 
	- Một server cài OS là Ubuntu server 16.04 
	- Một smartphone hoặc tablet cài đặt Google Authenticator.
	
## Step 1 - cài đặt Google PAM (Pluggable Authentication Module)
- Cài đặt PAM

```sh
apt update
apt -y install libpam-google-authenticator
```

- Khi PAM đã được cài đặt, chúng tôi sẽ sử dụng một ứng dụng trợ giúp đi kèm với PAM để tạo ra một TOTP key cho người dùng mà bạn muốn thêm yếu tố thứ hai vào. Khóa này được tạo ra trên cơ sở người dùng, không phải là toàn hệ thống. Điều này có nghĩa là mọi người dùng muốn sử dụng ứng dụng xác thực TOTP sẽ cần phải đăng nhập và chạy ứng dụng trợ giúp để lấy chìa khóa của chính họ.

- Chạy app

```sh
google-authenticator
```

- Sau khi bạn chạy lệnh trên, bạn sẽ được hỏi một vài câu hỏi. Câu hỏi đầu tiên hỏi nếu thẻ chứng thực phải dựa trên thời gian.

```sh
Do you want authentication tokens to be time-based (y/n) y
https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/root@ubuntu%3Fsecret%3DDT3E3KRF4ITYZLN4
```

	![](../images/ssh_otp.png)
	
```sh
Your new secret key is: DT3E3KRF4ITYZLN4
Your verification code is 286002
Your emergency scratch codes are:
  58974852
  68978567
  75618828
  60764875
  94876458

Do you want me to update your "/root/.google_authenticator" file (y/n) y

Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, tokens are good for 30 seconds and in order to compensate for
possible time-skew between the client and the server, we allow an extra
token before and after the current time. If you experience problems with poor
time synchronization, you can increase the window from its default
size of 1:30min to about 4min. Do you want to do so (y/n) y

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting (y/n) y
```

- Sử dụng smartphone cài app Google authenticator để scan mã vạch được sinh ra ở trên.
## Step 2 - Cấu hình OpenSSH
- Sửa file cấu hình `/etc/pam.d/sshd` và thêm dòng sau vào cuối file:

```sh
auth required pam_google_authenticator.so nullok
```

- Sửa file cấu hình `/etc/ssh/sshd_config` để hỗ trợ loại xác thực này. Tìm `ChallengeResponseAuthentication` và chuyển `no` => `yes`

```sh
# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication yes
```

- Restart ssh

```sh
service ssh restart
```

## Step 3 - Đăng nhập lại vào hệ thống
- Thực hiện ssh vào hệ thống. Đầu tiên, hệ thống yêu cầu nhập mật khẩu cho user `root`. Sau khi nhập mật khẩu cho user root, chúng ta mở app Google authenticator trên điện thoại để lấy mã và nhập khi hệ thống yêu cầu `Verifaction code:`

```sh
ssh root@172.16.10.130
Password:
Using keyboard-interactive authentication.
Verification code:
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.4.0-112-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

5 packages can be updated.
2 updates are security updates.


Last login: Wed Jan 31 01:41:08 2018 from 172.16.10.2
root@ubuntu:~#
```

--- 
- Link tham khảo: https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04