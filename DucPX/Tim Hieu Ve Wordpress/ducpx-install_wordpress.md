#Báo cáo về cài đặt Wordpress

#Mục lục
- 1. Giới thiệu Wordpress.
- 2. Cài đặt LAMP
- 3. Cài đặt Wordpress.
- 4. Tài liệu tham khảo

##1. Giới thiệu Wordpress
- Wordpress là gì?
	- Wordpress là một phần mềm mã nguồn mở.
	- Được viết bằng ngôn ngữ lập trình website PHP và sử dụng hệ quản trị cơ sở dữ liệu MySQL.
	- Hỗ trợ tạo các blog cá nhân.
	- Wordpress phát triển mạnh mẽ, được xem như là một hệ quản trị nội dung. Dễ dàng tạo ra các loại website khác nhau như web bán hàng, blog, tin tức,...

- Một số lý do tuyệt vời để chọn wordpress:
	- Dễ sử dụng: wordpress hướng tới cộng đồng phổ thông, không có nhiều kiến thức lập trình nâng cao. Wordpress cung cấp một giao diện để quản lý trực quan, thao tác dễ dàng.
	- Cộng đồng đông đảo.
	- Có nhiều gói giao diện có sẵn.
	- Có nhiều plugin hỗ trợ: thêm một số chức năng cho webstie
	- Dễ phát triển cho lập trình viên: nếu bạn là một lập trình viên am hiểu về HTML, CSS, PHP thì bạn dễ dàng mở rộng thêm các chức năng cho website của mình. Dễ dàng hiểu được nguyên tắc hoạt động và phát triển các tính năng.
	- Hỗ trợ nhiều ngôn ngữ, kể cả tiếng việt.
	- Có thể làm ra nhiều loại website: không chỉ có thể tạo blog cá nhân, wordpress có thể tạo ra nhiều loại website phức tạp như bán hàng, tin tức,...

##2. Cài đặt LAMP
Trước hết chúng ta chạy lệnh `apt-get update` để cập nhật các gói phần mềm

---
```sh
Cài đặt Wordpress trên môi trường ubuntu server 64 bit 14.04. 
Đại chỉ Ip được cài đặt tĩnh vơi địa chỉ 172.16.69.4/24
```

###2.1 Cài đặt Apache
- `apt-get install -y apache2`
- Khai báo `ServerName 172.16.69.4` ở trong file /etc/apache2/apache2.conf
- `service apache2 restart` khởi động lại apache

###2.2 Cài đặt MySQL
- `sudo apt-get install -y mysql-server`
- Trong quá trình cài đặt phải tạo mật khẩu **root** cho Mysql

###2.3 Cài đặt PHP
- `apt-get install -y php5 libapache2-mod-php php5-mcrypt php5-mysql`
- Mặc định apache ưu tiên load file index.html, chúng ta thay đổi để apache ưu tiên load index.php bằng cách thay đổi trong file **/etc/apache2/mods-enabled/dir.conf**. Thay đổi file sẽ được như thế này ![Imgur](http://i.imgur.com/242x40O.png)
- Có thể kiểm tra PHP cài đặt thành công hay chưa, chúng ta tạo một file `vi /var/www/html/info.php`
```sh
<?php
phpinfo();
?>
```
- sau đó vào trình duyệt web nhập địa chỉ `http://your_server_IP_address/info.php` ![Imgur](http://i.imgur.com/ZriyDmB.png)
- xóa file info.php `rm /var/www/html/info.php`

##3. Cài đặt Wordpress
###3.1 Tạo một database và một user để thao tác trên database này:
- `mysql -u root -p` nhập mật khẩu **root** của mysql để đăng nhập vào mysql
- `mysql> CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;` tạo một database có tên là **wordpress**
- `mysql> GRANT ALL ON wordpress.* TO 'wordpressadmin'@'localhost' IDENTIFIED BY '123456789';` cho phép user **wordpressadmin** có toàn quyền trên database **wordpress** có mật khẩu **123456789**
- `mysql> FLUSH PRIVILEGES;`
- `mysql> exit;`
- Thay đổi file cấu hình `vi /etc/apache2/apache2.conf` cho phép override 
```sh
<Directory /var/www/html/>
    AllowOverride All
</Directory>
```
###3.2 Download wordpress và cấu hình
	```sh
	cd /tmp
	wget https://wordpress.org/latest.tar.gz
	```

-  `tar xzvf latest.tar.gz` giải nén file vừa tải về

-  copy file cấu hình sang một file cấu hình file mà wordpress có thể đọc `cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php`

-  `cp -a /tmp/wordpress/. /var/www/html` copy toàn bộ thư mục wordpress vừa giả nén sang **/var/www/html**
-  Cấu hình để wordpress nhận database mà chúng ta đã tạo lúc trước ![Imgur](http://i.imgur.com/phfb5vE.png)
-  `chown -R pxduc:www-data /var/www/html`
-  `http://server_domain_or_IP` ta được ![Imgur](http://i.imgur.com/a9xIEaj.png)
- nhập các thông tin và click install wordpress.

=> như vậy là đã cài đặt thành công wordpress.

##4. Tài liệu tham khảo
https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lamp-on-ubuntu-16-04

https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04