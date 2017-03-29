# TÌM HIỂU VÀ DỰNG WORDPRESS

## ***Mục lục***

[1. Giới thiệu Wordpress](#1)

- [1.1. Wordpress là gì?](#1.1)

- [1.2. Các đặc điểm nổi bật của Wordpress](#1.2)

[2. Dựng Wordpress ](#2)

 - [2.1. Dựng Wordpress trên 1 node (all-in-one)](#2.1)

 - [2.2. Dựng Wordpress trên 2 node - Database và Web server](#2.2)

   - [2.2.1. Cấu hình trên node Database](#2.2.1)

   - [2.2.2. Cấu hình trên node Web server ](#2.2.2)

 [3. Tham khảo](#3)

 ---

<a name = "1"></a>
# 1. Giới thiệu Wordpress

<a name = "1.1"></a>
## 1.1.  Wordpress là gì?

- **WordPress** là một ***phần mềm nguồn mở (Open Source Software)*** được viết bằng ngôn ngữ lập trình website **PHP (Hypertext Preprocessor)** và sử dụng **hệ quản trị cơ sở dữ liệu MySQL**.

- WordPress xử lý bằng ngôn ngữ PHP để hỗ trợ tạo blog cá nhân, và nó được rất nhiều người sử dụng ủng hộ về tính dễ sử dụng, nhiều tính năng hữu ích. Qua thời gian, số lượng người sử dụng tăng lên, các cộng tác viên là những lập trình viên cũng tham gia đông đảo để phát triển mã nguồn WordPress có thêm những tính năng tuyệt vời.

- Hiện tại, Wordpress là CMS (Content management system) phổ biến nhất trên internet. Nó cho phép bạn dễ dàng cài đặt những blog phức tạp và các website trên nền tảng lưu trữ MySQL với quá trình xử lý sử dụng PHP. Wordpress đã cho thấy được áp dụng một cách đáng kinh ngạc và là một sự lựa chọn tuyệt với cho việc dựng các website và chạy một cách nhanh chóng.

<a name = "1.2"></a>
## 1.2. Các đặc điểm nổi bật của Wordpress

\- **Dễ sử dụng:** WordPress được phát triển nhằm phục vụ đối tượng người dùng phổ thông, không có nhiều kiến thức về lập trình website nâng cao. Các thao tác trong WordPress rất đơn giản, giao diện quản trị trực quan giúp bạn có thể nắm rõ cơ cấu quản lý một website WordPress trong thời gian ngắn.

\- **Cộng đồng hỗ trợ đông đảo:** Là một mã nguồn CMS mở phổ biến nhất thế giới, điều này cũng có nghĩa là bạn sẽ được cộng đồng người sử dụng WordPress hỗ trợ bạn các khó khăn gặp phải trong quá trình sử dụng.

\- **Nhiều gói giao diện (theme) có sẵn**:  Người dùng có thể chỉnh sửa, tùy biến giao diện một cách đơn giản, nhẹ nhàng.

\- **Nhiều plugin hỗ trợ:** hỗ trợ nhiều plugin có sẵn và cho phép cộng đồng người dùng viết các plugin cho WP.

\- **Hổ trợ Widget dạng kéo – thả:** Thay vì phải động vào code, bạn chỉ việc kéo – thả ở những vị trí thích hợp.

\- **Dễ phát triển cho lập trình viên:** WordPress là một mã nguồn mở nên bạn có thể dễ dàng hiểu được cách hoạt động của nó và phát triển thêm các tính năng.

\- **Hỗ trợ nhiều ngôn ngữ**.

\- **Có thể làm nhiều loại Website:** Dùng WordPress không có nghĩa là bạn chỉ có thể làm blog cá nhân, mà bạn có thể biến website mình thành một trang bán hàng, một website giới thiệu công ty, một tờ tạp chí online bằng việc sử dụng kết hợp các theme và plugin với nhau.

<a name = "2"></a>
# 2. Dựng Wordpress

Dựng Wordpress trên máy ảo VMware Work Station 12, Wordpress cài trên máy ảo Ubuntu server 14.04.

Wordpress gồm 2 thành phần chính là phần Web server để lưu trữ code và phần Database để lưu trữ dữ liệu.

Các bước tiến hành nên sử dụng người dùng có quyền sudo, không nhất thiết phải sử dụng root. 

Thêm đó, bạn cần cài đặt **LAMP** trước khi cài đặt Wordpress.

LAMP (**L**inux – **A**pache – **M**ySQL – **P**HP) là một nhóm các phần mềm nguồn mở mà thường được sử dụng cùng nhau trên server để cấu hình các website động hoặc các web apps. LAMP là tên viết tắt được sử dụng cho hệ điều hành Linux với webserver là Apache. Dữ liệu sẽ được lưu trữ trong MySQL database và nội dung được xử lý bởi PHP.

Tham khảo cách cài đặt LAMP [tại đây.](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-14-04)


<a name = "2.1"></a>
## 2.1. Dựng Wordpress trên 1 node (all-in-one)

### 2.1.1. Tạo Database 

Wordpress sử dụng một cơ sở dữ liệu quan hệ để quản lý và lưu trữ thông tin và thông tin người dùng.

MySQL đã được cài đặt để tạo database sử dụng cho Wordpress.

\- Để bắt đầu, login vào MySQL với tài khoản root sử dụng câu lệnh:

`mysql –u root –p`

Gõ password đặt cho user root để login.

\- Trước hết, tạo một database mà wordpress có thể sử dụng điều khiển. Bạn có thể đặt bất kì tên gì nhưng nên đặt tên là wordpress để sau dễ phân biệt và dễ nhớ:

`CREATE DATABASE wordpress;`

\- Tiếp theo chúng ta sẽ tạo người dùng trong MySQL để sử dụng và quản lý database wordpress. Bạn có thể đặt tên và mật khẩu tùy ý cho người dùng này. Ở đây sẽ tạo người dùng wordpressuser, thực hiện như sau:

`CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';`

 (Thay mật khẩu của bạn vào `'password'`)


\- Tới bước này, bạn đã có database và user sử dụng cho wordpress nhưng chưa thực hiện kết nối chúng với nhau. Người dùng chưa được kết nối và sẽ không sử dụng được database. Thực hiện gán tất cả các quyền cho người dùng **wordpressuser** trên database **wordpess**:

`GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;`

\- Bây giờ, người dùng wordpressuser vừa tạo đã có toàn quyền với database wordpress.

\- Một khi hoàn tất các quyền gán cho user, và bạn muốn thiết lập quyền mới cho tài khoản mới khác, hãy thực hiện lệnh sau để đảm bảo các quyền được thiết lập lại từ đầu cho user mới.

`FLUSH PRIVILEGES;`

Các thay đổi của bạn bây giờ sẽ có hiệu lực. 

Đến đây là hoàn thành bước tạo database và user quản lý của wordpress. 

### 2.1.2. Download Wordpress 

WordPress luôn liên kết các phiên bản ổn định mới nhất của phần mềm của họ đến cùng một URL, vì vậy bạn có thể nhận được phiên bản mới nhất được cập nhật lên của WordPress bằng cách tải về từ link như sau:

```
cd ~
wget http://wordpress.org/latest.tar.gz
```

Lệnh trên sẽ download file nén về thư mục hiện tại. Giải nén file bằng lệnh:

`tar xzvf latest.tar.gz`

File sẽ được giải nén và tạo ra một thư mục là **wordpress** trong thư mục hiện tại.

Để làm việc với image và cho phép bạn cài đặt thêm một số plguin và update website thông qua SSH, ta cài một số gói sau: 

`sudo apt-get install php5-gd libssh2-php`

### 2.1.3. Cấu hình Wordpress 

Hầu hết các bước cấu hình sau sẽ có thể được thực hiện thông qua một giao diện web. Tuy nhiên, chúng ta cần phải thực hiện thông qua giao diện dòng lệnh trước khi nó được khởi động và hoạt động.

\-	Di chuyển vào thư mục wordpress: 

`cd ~/wordpress`

\-	Một file cầu hình sẵn mà phù hợp với hầu hết cấu hình mà chúng ta cần được lưu trong file wp-config-sample.php. Tuy nhiên, chúng ta cần copy vào file local để wordpress có thể nhận ra nó. Thực hiện lệnh sau: 

`cp wp-config-sample.php wp-config.php`

\-	Sửa lại file wp-config.php cho phù hợp với các thông số của database mà ta tạo ra trước đó:

``` 
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', 'password');  #Thay mật khẩu của bạn vào phần password
```

\-	 Các tham số mặc định còn lại không cần thay đổi.


### 2.1.4. Copy các file trong Wordpress vào thư mục gốc của Web 

Chúng ra đã cài cấu hình xong web, bây giờ copy nó vào thư mục gốc của Apache, nơi mà nó được lưu các file và hiển thị trên website. 

Một trong những cách nhanh và tin cậy nhất là chuyển các file từ thư mục sang thưc mục sử dụng lệnh rsync. Lệnh này sẽ giữ lại các quyền truy cập của file và có tính năng toàn vẹn dữ liệu tốt.

Thư mục gốc của Apache trong Ubuntu 14.04 là /var/www/html/. Chúng ta có thể copy tất cả các file của wordpress vào thư gốc bằng cách gõ lệnh như sau:

`sudo rsync -avP ~/wordpress/ /var/www/html/`

\-	Di chuyển tới thư mục **/var/www/html/** .

\-	Bạn sẽ cần thay đổi quyền truy cập của thư mục để tăng cường an ninh.

\-	Nhóm người sử dụng trên trình xử lý web server là www-data. Nó sẽ cho phép Apache tương tác với các Web khi cần thiết.

\-	Cấp quyền cho user dùng để thường xuyên tương tác với website bằng với quyền của nhóm người sử dụng www-data (nhóm người dùng thông qua giao diện website). Đó là một user quyền sudo bất kỳ trên máy chủ server của bạn. Điều này sẽ cho phép tương tác với Apache khi cần thiết. 

`sudo chown -R demo:www-data *`

\-	Tạo thư mục **uploads** ngay trong thư mục **wp-content** để lưu trữ các hình ảnh và nội dung upload:

`mkdir /var/www/html/wp-content/uploads`

\-	Cấp quyền cho người dùng trên webserver vào thư lục uploads:

`sudo chown -R :www-data /var/www/html/wp-content/uploads`

Điều này cho phép web server tạo các file và thư mục dưới thư mục này và cũng đồng thời cho phép chúng ta upload lên web server .

### 2.1.5. Kiểm tra trên trình duyệt Web 

Mở trình duyệt và gõ địa chỉ IP của web server vào được kết quả như sau là thành công: 

<img src = "http://imgur.com/9nj4SER.jpg">



Tạo tài khoản admin và đăng nhập vào wordpress ta được kết quả như sau:


<img src = "http://imgur.com/RWAX2ZV.jpg">


Vậy là đã cài đặt thành công Wordpress trên 1 node (all-in-one).


<a name = "2.2"></a>
## 2.2. Dựng Wordpress trên 2 node - Web server và Database

Do càng ngày các ứng dụng cũng như website ngày càng phát triển, nên việc tách 2 chức năng máy chủ webserver và database của wordpress thành 2 phần riêng biệt là việc nên làm để nâng cao hiệu suất, cũng như đem lại một số lợi ích về mặt bảo mật. (Database thì không cần phải gắn một địa chỉ IP public nhằm tránh gây bị tấn công).

Mô hình: 

<img src ="http://imgur.com/ihGtmmK.jpg">


<a name = "2.2.1"></a>
### 2.2.1. Cấu hình trên node Database


Cài đặt MySQL trên Database instance.

```
sudo apt-get update
sudo apt-get install mysql-server
sudo mysql_install_db
sudo mysql_secure_installation
```

- **Bước 1:** ***Cấu hình MySQL cho phép Webserver được quyền truy cập***

  Sửa file cấu hình MySQL để cho phép các máy khác truy cập vào database: 

  Tìm sửa file `/etc/mysql/my.conf`. Tìm đến section `[mysqld]` sửa lại bind-address cho lắng nghe trên interface của card mạng private eth1 – Lắng nghe các truy vấn đến trên interface nào. *(chỉ cấu hình được 1 interface, nếu để 0.0.0.0 sẽ lắng nghe trên tất cả các interface)*

  Trong mô hình này dùng địa chỉ IP dải private của database: 10.10.10.20

<img src ="http://imgur.com/TwmPH6e.jpg">

  Khởi động lại dịch vụ mysql : `sudo service mysql restart`

- **Bước 2:** ***Tạo các user cho phép truy vấn vào database và gán quyền cho từng user***

  Chúng ta đã cấu hình xong cho database instance lắng nghe trên IP private. Giờ sẽ cần tạo database và thiết lập kết nối. Bây giờ ta có thể tạo 2 user có tên giống hệt nhau nhưng ở trên những host khác nhau và giao cho những quyền truy cập khác nhau vào database để cấu hình. Đây là một chính sách bảo mật tốt.

  \- Tạo user trên local host cho phép truy cập vào database:

  ```
  CREATE DATABASE wordpress;
  CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
  GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
  ```

  \- Tạo các user trên các máy client cho phép truy cập vào database và gán các quyền trên database:

  ```
  CREATE USER 'wordpressuser'@'web_server_IP' IDENTIFIED BY 'password';
  GRANT SELECT,DELETE,INSERT,UPDATE ON wordpress.* TO 'wordpressuser'@'web_server_ip';
  GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'web_server_ip';
  FLUSH PRIVILEGES;
  ```

  Thay `web_server_ip` bằng địa chỉ IP của Web server của bạn. Như trong mô hình này là 10.10.10.10

- **Bước 3**: Kiểm tra kết nối trên máy database instance và kiểm tra trên máy webserver xem đã có quyền truy cập vào database chưa.

Trên máy database machine: 

```mysql –u wordpressuser –p```

Nếu đăng nhập thành công là ok.

Trên máy web server: 

Cài đặt gói mysql-client để có thể truy cập vào database:

```sudo apt-get install mysql-client```

Đăng nhập vào database sử dụng câu lệnh sau:

```mysql -u wordpressuser -h database_server_IP -p```

Ví dụ: trên web server dùng lệnh: 

  ```mysql –u wordpressuser –h 10.10.10.20 –p```  để truy cập database wordpress.


<a name = "2.2.2"></a>
### 2.2.2. Cấu hình trên node Webserver 

Cài đặt Wordpress như ở hướng dẫn [2.1.](#2.1)

Sửa file cấu hình ```wp-config.php ``` như sau:

```
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', 'password');

/** MySQL hostname */
define('DB_HOST', 'database_server_ip'); #trong trường hợp này là 10.10.10.20
```
-	Thực hiện cấp quyền truy cập cho người dùng www-data (người dùng truy cập web server qua trình duyệt)

```
cd /var/www/html/
sudo chown -R www-data:www-data *
```

-	Kiểm tra trên trình duyệt được như ở phần 2.1 là thành công.

<a name = "3"></a>
# 3. Tham khảo

[1] https://thachpham.com/wordpress/wordpress-tutorials/wordpress-la-gi-va-gioi-thieu.html

[2] http://inet.edu.vn/tin-tuc/194/gioi-thieu-ve-wordpress.html

[3] Dựng Wordpress trên 1 node: https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-14-04

[4] Dựng Wordpress trên 2 node: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-remote-database-to-optimize-site-performance-with-mysql