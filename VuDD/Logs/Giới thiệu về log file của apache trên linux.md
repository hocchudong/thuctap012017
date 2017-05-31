## Giới thiệu về log file của apache trên linux

- File log của apache server nằm ở thư mục /var/log/apache2 (đối với ubuntu) và ở /var/log/httpd (đối với centOs)

- Bao gồm 2 file chính đó là access log và error log

## Mục lục

[1. Access log](#1)

[2. Error log](#2)

<a name ="1"></a>
## 1.Access log

- Có chức năng ghi lại những lần sử dụng, truy cập, yên cầu đến apache server

<image src="http://i.imgur.com/5PmheXl.png">

<image src="http://i.imgur.com/4s2E6Zw.png">

- File log được lưu trữ tại /var/log/httpd/access_log (hoặc /var/log/apache2/access.log)

- Định dạng log (LogFormat) cơ bản như sau là :   %h %l %u %t %r %>s %b Refer User_agent
- Trong đó:
    - %h: địa chỉ của máy client    - %l: nhận dạng người dùng được xác định bởi identd (thường không SD vì không tin cậy)    - %u: tên người dung được xác định bằng xác thức HTTP    - %t: thời gian yêu cầu được nhận    - %r: là yêu cầu từ người sử dụng (client)     - %>s: mã trạng thái được gửi từ máy chủ đến máy khách    - %b: kích cỡ phản hồi đối với client    - Refer: tiêu đề Refeer của yêu cầu HTTP (chứa URL của trang mà yêu cầu này được khởi tạo)    - User_agent: chuỗi xác định trình duyệt

- Ở trên là 1 ví dụ về LogFormat của access log. Ngoài những trường trên còn có thêm 1 số trường khác như trong bảng định dạnh của file log như sau:

<image src="http://i.imgur.com/XenDLhC.png">

- Ví dụ như: 

<image src="http://i.imgur.com/06FRgLc.png">

    - 172:16.79.202: là địa chỉ IP của máy client truy cập tới apache server    - 2 trường %l %u không có giá trị sẽ hiển thị “-“    - 18/May/2017…. Là thời gian nhận được yêu cầu từ client    - GET/HTTP/1.1: là yêu cầu từ client    - 404: mã trạng thái gửi từ server đến client    - 209: kich thước phản hồi lại client    - “http:/172.16.79.213”: url mà client yêu cầu tới server    - Moliza …. Chrome, Safari: là chuỗi định danh trình duyệt

- Ngoài ra bạn còn có thể thay đổi Format của file log này trong file cấu hình của apache server đặt tại thư mục /etc/apache2/apache2.conf

<image src="http://i.imgur.com/0YhXaoF.png">

<image src="http://i.imgur.com/AM1Hmss.png">

- Bạn cũng thể thay đổi vị trí lưu file log của mình bằng cách chỉnh sửa file cấu hình ở đường dẫn sau: /etc/apache2/sites-available/000-default.conf (đối với ubuntu)

<image src ="http://i.imgur.com/X5zE8iq.png">

- Bạn cũng có thể thay đổi thư mục lưu file log tại trường APACHE_LOG_DIR trong file cấu hình /etc/apache2/envvars (file này như là 1 file thư viện định danh các biến hằng sử dụng trong các file cấu hình khác của apache)

<a name ="2"></a>
## 2. Error log

- Chứa thông tin về lỗi mà máy chủ web gặp phải khi xử lý các yêu cầu, chẳng hạn như khi tệp bị thiếu.

- Là nơi đầu tiên để xem xét khi xảy ra sự cố khi khởi động máy chủ hoặc với hoạt động của máy chủ vì nó thường chứa thông tin chi tiết về những gì xảy ra và cách khắc phục 

- Nơi lưu trữ file log là /var/log/httpd/error_log (đối với centOs) và /var/log/apache2/error.log (đối với ubuntu)

- Định danh của error log tương đối tự do về mặt hình thức nhưng 1 số thông tin quan trọng có trong hầu hết các mục log như sau:

     - Trường thứ nhất: Trường thời gian - lưu thời gian nhận được message từ apache server
     - Trường thứ 2: liệt kê mức độ nghiêm trọng của lỗi được báo cáo
     - Trường thứ 3: Địa chỉ IP của client tạo ra lỗi
- Ví dụ: 

<image src="http://i.imgur.com/EqHSliR.png">

- Bạn cũng có thể thay đổi thư mục lưu trữ error log như đối với access log

- Ngoài ra bạn còn có thể đổi tên file error.log thành tên bạn mong muốn bằng cách sửa file config trong file cấu hình của apache /etc/apache2/apache2.conf:

<image src="http://i.imgur.com/njFiqMn.png">




