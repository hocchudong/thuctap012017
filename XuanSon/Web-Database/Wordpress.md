# Introduction and Install Wordpress


# MỤC LỤC
- [1.Introduction](#1)
- [2.Install Wordpress on Ubuntu Server 14.04](#2)
  - [2.1.Install LAMP on Ubuntu Server 14.04](#2.1)
  - [2.2.Install Wordpress](#2.2)
- [THAM KHẢO](#thamkhao)


<a name="1"></a>
# 1.Introduction

\- Wordpress là open source Content Management System (CMS) ,được viết bằng PHP , sử dụng database management system MySQL , cho phép user xây dựng dynamic web và blog .   
\- Content Management System (CMS) là phần mềm lưu trữ data như text , photos,music,document,etc và được làm có sẵn trên website .   
\- Wordpress được phát hành năm 2003 và được công bố như open source năm 2009 .  
\- Đặc điểm :  
- User Management
- Media Management
- Theme System 
- Extend with Plugins
- Search Engine Optimization
- Multilingual
- Importers 

<a name="2"></a>
# 2.Install Wordpress on Ubuntu Server 14.04

\- Muốn cài Wordpress , trước tiên chúng ta cần cài LAMP .  

<a name="2.1"></a>
## 2.1.Install LAMP on Ubuntu Server 14.04

## a.Install Apache
\- Thực thiện command :  
```
sudo apt-get install apache2
```

## b.Install mysql
\- Insttall `mysql-server` :    
```
sudo apt-get install mysql-server
```
\- Install `php5-mysql` để giao tiếp với `mysql-server` :  
```
sudo apt-get install php5-mysql
```

## c.Install PHP
\- PHP là thành phần để xử lý code , display dynamic content . Nó run scripts , connec đến MySQL databases để lấy information và giao content xử lý đến web server để display .  
\- Để cài đặt , thực hiện command :  
```
sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt
```
\- Bạn có thể cài thêm PHP Modules bổ sung , để xem các options for PHP modules có sẵn , bạn gõ command :  
``` 
apt-cache search php5-
```
\- Test PHP Processing on your Web Server :  
Tạo file `info.php` trong thư mục `/var/www/html` với nội dung nhưu sau :  
```
<?php
phpinfo();
?>
```  

Sau đó , dùng bowser truy cập đến  
``` 
http://your_server_IP_address/info.php
```

Nội dung hiện ra như sau :  
<img src="http://imgur.com/ZkLuPRD.png" >  

<a name="2.2"></a>
## 2.2.Install Wordpress

### Bước 1 : Create a MySQL Database and User for WordPress
\- Đầu tiên đăng nhập vào MySQL :  
```
mysql –u root -p
```
\- Tạo database `wordpress` :  
```
CREATE DATABASE wordpress;
```
\- Tạo `wordpressuser` user sử dụng `wordpress` database :  
```
CREATE USER wordpressuser@localhost IDENTIFIED BY '123456';
```
\- Cấp quyền cho `wordpressuser` user trên `wordpress` database :  
```
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;
```

### Bước 2 : Download WordPress
\- Thực hiện command :  
```
wget http://wordpress.org/latest.tar.gz
```
\- Giải nén file download :  
``` 
tar xzvf latest.tar.gz
```
\- Chúng ta có download và install thêm một số packeages để làm việc với images và cho phép bạn install plugins và update các phần của website thông qua SSH login .  
```
sudo apt-get install php5-gd libssh2-php
```

### Bước 3 : Configure WordPress
\- Di chuyển đến thư mục `wordpress` :  
```
cd ~/wordpress
```
\- A sample configuration file có name là `wp-config-sample.php` , chúng cần copy nó đến default configuration file ( `wp-config.php` ) để Wordpress nhận ra file đó .  
```
cp wp-config-sample.php wp-config.php
```
\- Mở file wp-config.php :  
```
vi wp-config.php
```
\- Tìm đến thiết lập `DB_NAME` , `DB_USER` , `DB_PASSWORD` , `DB_HOST` để Wordpress kết nối một cách chính xác đến database chúng ta tạo ra . Điền các giá trị của parameters với thông tin database như sau :  
```
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', '123456');

/** MySQL hostname */
define('DB_HOST', 'localhost');
```

### Bước 4 : Copy Files to the Document Root
\- Copy all files và directory trong `wordpress` directory to `/var/www/html` :  
```
sudo cp –r ~/wordpress/* /var/www/html
#or
sudo rsync -avP ~/wordpress/ /var/www/html/
```
\- Chúng ta cần thay đổi ownership của files để tăng cường security .   
Chúng tôi muốn cung cấp ownership cho user thường cuyên , non-root user ( with sudo privileges ) mà bạn có thể tương tác với website của bạn .  
Trong hướng dẫn này , chúng tôi sẽ sử dụng `wordpress` user mà chúng tôi tạo ra .  
Group ownership , chúng tôi sẽ cung cấp cho our web server process , đó là `www-data`. Điều này cho phép `Apache` tương tác với content khi cần thiết .  
```
sudo chown -R wordpress:www-data *
```
\- Để upload images và content to website , tạo thư mục uplocads trong thư mục `wp-content` .  
```
mkdir /var/www/html/wp-content/uploads
```
Chúng ta có thư mục để uploads file , tuy nhiên permissions bị hạn chế . Chúng ta cần phải cho phép web server viết vào thư mục này . Chúng ta có thể làm điều này bằng cách gán group ownershop của thư mục to web server , như sau :  
```
sudo chown -R :www-data /var/www/html/wp-content/uploads
```
Điều này cho phép web server tạo files và directory trong directory này , đồng thời cho phép chúng ta upload content to server .  

### Bước 5 : Complete Installation through the Web Interface
\- Truy cập vào wordpress thông qua IP web server , ở đây IP của webser server là 172.16.69.10 .  
```
http://172.16.69.10
```

<img src="http://imgur.com/LUuW0Sa.png" >  

\- Ban sẽ thấy trang cấu hình WordPress , nơi mà bạn tạo administrator account :  
<img src="http://imgur.com/W4FB3e7.png" >  

\- Điền information cho web và administrator account mà bạn muốn . Khi hoàn tất , nhấp install button ở phái dưới .  
Bạn sẽ trông thấy Wordpress interface như sau :  
<img src="http://imgur.com/WF1ydZ4.png" >  


<a name="thamkhao"></a>
# THAM KHẢO
- LAMP : https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu  
- Wordpress : https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-14-04  



