#Giới thiệu và cách cài đặt WordPress

#Mục lục
- [1.Giới thiệu](#1)
- [2.Cài đặt WordPress](#2)
     [2.1.Cài đặt LAMP Stack](#2.1)
     [2.2.Cài đặt WordPress](#2.2)

<a name="1"></a>
##1.Giới thiệu
\-WordPress là 1 CMS được xây dựng từ ngôn ngữ lập trình PHP và sử dụng hệ quản trị CSDL MySQL để lưu trữ
\-Được phát triển bởi Michel Valdrighi và public hoàn toàn miễn phí.
\-Trước đây WP thường sử dụng cho cá nhân tạo blog hay các doanh nghiệp tạo website đơn giản để quảng bá thương hiệu.
Hiện nay, nó không còn là blogging Platform mà trở thành 1 công cụ tạo ra nhiều loại Website khác trong đó có các website mảng thương mại điện tử.
\-Có nhiều Website cung cấp Theme cho WordPress như MyThemeShop.com, ThemeForest.com nên dễ dàng chọn 1 giao diện cho riêng mình
\-Theo thống kê có khoảng 20% website nổi tiếng đang sử dụng WordPress
\-WordPress hỗ trợ đa ngôn ngữ

<a name="2"></a>
##2.Cài đặt WordPress
Muốn cài đặt WordPress trước hết chúng ta cần phải cài đặt LAMP Stack bao gồm: Apache, MySQL, PHP

<a name="2.1"></a>
###2.1 Cài đặt LAMP Stack
\-Bước 1: Cài đặt Apache
    ```
    sudo apt-get update
    sudo apt-get install apache2
    ```
\-Bước 2: Cài đặt MySQL
  Thực hiện như sau:
  ```
  sudo apt-get install mysql-server
  ```
  \- Cài đặt  `php5-mysql` để giao tiếp với `mysql-server` :
  ```
  sudo apt-get install php5-mysql
  ```
\-Bước 3: Cài đặt PHP
  Thực hiện như sau:
  ```
  sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql
  ```
  Kiểm tra xem có index.php trong /etc/apache2/mods-enabled/dir.conf. Nếu chưa có thì thêm vào.

  Restart lại apache server sudo systemctl restart apache2

  Kiểm tra PHP: Tạo file info.php trong /var/www/html và thay đổi file đó như sau
  ```
  <?php
  phpinfo();
  ?>
  ```
  Sau đó , dùng bowser truy cập đến
  ```
  http://your_server_IP_address/info.php
  ```

  <a name="2.2"></a>
  ###2.2.Cài đặt WordPress

  \-Bước 1: Tạo CSDL và user để quản lý
     Thực hiện như sau:
     -Đăng nhập vào MySQL
     ```
     mysql -u root -p
     ```
     Tạo database `myWP` :
     ```
     CREATE DATABASE myWP;
     ```
     Tạo `vulee` user sử dụng `myWP` database :
     ```
     CREATE USER vulee@localhost IDENTIFIED BY '123456';
     ```
     Cấp quyền cho `vulee` user trên `myWP` database :
     ```
     GRANT ALL PRIVILEGES ON myWP.* TO vulee@localhost;
     ```

\-Bước 2: Tải WordPress

   Thực hiện như sau:
   ```
   cd Downloads
   curl -0 https:/wordpress.org/latest.tar.gz
   ```
   -Giải nén file vừa download
   ```
   tar xzvf latest.tar.gz
   ```
\-Bước 3: Config WordPress
   Thực hiện như sau:
   ```
   touch wordpress/.htaccess
   chmod 660 wordpress/.htaccess
   sudo cp -a wordpress/. /var/www/html
   ```
   Tiếp tục
   ```
   cp wp-config-sample.php wp-config.php
   sudo chown -R vulee:www-data /var/www/html
   sudo chmod g+w wp-content/
   sudo chmod -R g+w wp-content/themes/
   sudo chmod -R g+w wp-content/plugins/
   ```
\-Bước 4: Cấu hình CSDL
   Thực hiện như sau:
    Mở file wp-config.php :
    ```
    vi wp-config.php
    ```
    Tìm đến thiết lập `DB_NAME` , `DB_USER` , `DB_PASSWORD` , `DB_HOST` để Wordpress kết nối một cách chính xác đến database chúng ta tạo ra . Điền các giá trị của parameters với thông tin database như sau :
    ```
    // ** MySQL settings - You can get this info from your web host ** //
    /** The name of the database for WordPress */
    define('DB_NAME', 'myWP');

    /** MySQL database username */
    define('DB_USER', 'vulee');

    /** MySQL database password */
    define('DB_PASSWORD', '123456');

    /** MySQL hostname */
    define('DB_HOST', 'localhost');
    ```
\-Bước 5: Khởi động lại apache server
   Thực hiện như sau:
   ```
   service apache2 restart
   ```
\-Bước 6: Truy cập vào WordPress thông qua web browser thông qua địa chỉ ip của web server
  Kiểm tra địa chỉ ip của web-server bằng câu lệnh: ifconfig
  
