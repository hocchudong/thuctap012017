# THỰC HÀNH CÀI ĐẶT UBUNTU SERVER 14.04

***Mục đích***: Hiểu cơ bản về các bước cài đặt Ubuntu Server 14.04

---
---

# Mục lục

[1. Giới thiệu hệ điều hành Ubuntu Server ](#1)

[2. Thực hành cài đặt Ubuntu Server 14.04 trên VMware Work Station 12](#2)

  - [2.1. Chuẩn bị](#2.1)
  
  - [2.2. Các bước cài đặt](#2.2)


---
---

  <a name=1></a>
# 1. Giới thiệu hệ điều hành Ubuntu Server

   - ***Ubuntu*** là một hệ điều hành mã nguồn mở miễn phí được xây dựng dựa trên Debian GNU/Linux. Điều đó có nghĩa là mọi người đều được tự do sử dụng, thay đổi, cải tiến nó… Ubuntu được tài trợ bởi công ty Canonical Ltd (chủ sở hữu là một người Nam Phi Mark Shuttleworth).  Thay vì bán Ubuntu, Canonical tạo ra doanh thu bằng cách bán hỗ trợ kĩ thuật.

   -  Các hệ thống máy chủ là các máy chuyên phục vụ cho các máy khách, các dịch vụ có thể rất chuyên dụng như: DNS, DHCP, hay rất thông dụng như Email, Firewall,… Nhưng việc xây dựng một hệ thống máy chủ có quy mô còn đòi hỏi những kiến thức rất chuyên dụng về các dịch vụ, hệ thống mạng, và cả về hệ điều hành.Các máy chủ thường chạy trên các hệ điều hành Window Server, hoặc các điều hành Linux( mã nguồn mở). Việc hệ điều hành Window khá thân thuộc( có lẽ sẽ giúp cho việc quản trị dễ dàng hơn) nhưng hệ điều hành Window Server thì bản quyền khá đắt. Trong khi đó các máy chủ Linux được đánh giá là bảo mật, lại hoàn toàn miễn phí( do xây dựng hoàn toàn trên hệ thống nguồn mở). 

   -  Trong bài này, mình sẽ cài đặt **Ubuntu Sererver 14.04 - 64 bit** là phiên bản Ubuntu server  LTS phát hành tháng 4 năm 2014. Tuy ra đời đã được một thời gian nhưng do tính ổn định của phiên bản này nên mình vẫn chọn nó. (Với người mới bắt đầu như mình thì nên chọn một phiên bản ổn định hơn là phiên bản hoàn toàn mới như 16.04. Việc chọn phiên bản sẽ tùy thuộc vào sự hiểu biết và nhu cầu của bạn)

   -  Cấu hình tối thiểu cho việc cài đặt phiên bản Ubuntu Server là máy có bộ vi xử lí 300 MHz x86, RAM 256 MB, và card màn hình VGA hỗ trợ độ phân giải 640x480 trở lên. (*Lưu ý điều này khi cấu hình phần cứng cho máy ảo VMware trước khi cài đặt*)

<a name=2></a>
# 2. Thực hành cài đặt Ubuntu Server 14.04 trên VMware Work Station 12

<a name=2.1></a>
## 2.1. Chuẩn bị
 - VMware Work Station 12: Có thể xem hướng dẫn sử dụng VMware cho những bạn chưa nắm vững [tại đây](https://github.com/hocchudong/vmware-workstation-network).
 
 - Iso Ubuntu Server 14.04: Download tại http://releases.ubuntu.com/14.04/ 

 <a name=2.2></a>
 ## 2.2. Các bước cài đặt 

- Chọn ngôn ngữ cài đặt boot:

 <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/1.png">

- Chọn cài boot file iso cài đặt Ubuntu Server: 

 <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/2.png">

- Chọn ngôn ngữ cài đặt: 

 <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/3.png">

  => Chọn English.

- Tiếp theo là chọn vị trí của bạn: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/4.png">
    
    => chọn `other` -> `Asia` -> `Viet Nam`

 <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/5.png">
     
 <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/6.png">
  
  Do ngôn ngữ chọn để cài đặt trước đó là English nhưng lại chọn vị trí location là Viet Nam nên hệ thống báo rằng phải chọn location tham chiếu tới từ list location đưa ra: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/7.png">

   => Chọn `United States`

- Chọn layout keyboard:

  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/8.png">

  => Chọn `No`
- Chọn keyboard layout: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/9.png">

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/10.png">

   => Chọn `English` cho quen sử dụng.

- Cấu hình Network:

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/11.png">

   => Hệ thống chọn một interface để cài đặt. Chọn interface ra được ngoài mạng Internet. Như ở đây chọn `eth0`

- Cấu hình Hostname và superuser: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/12.png">

   => Gõ tên hostname mà bạn muốn. 

- Tạo tài khoản Superuser và set password (được dùng mượn quyền root):

  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/13.png">
  
  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/14.png">

  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/15.png">

  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/16.png">

  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/17.png">

=> Tải khoản mà bạn tạo ở bước này là tài khoản Superuser - nên bạn cần nhớ được user name và password để dùng sau này. 

- Cấu hình chọn Encrypt home directory: 

 <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/18.png">

 => Đây là bước cấu hình mã hóa thư mục home của người dùng nêu máy tính của bạn có bị mất cắp. Bước này mình chưa sử dụng bao giờ nên chọn `No`

- Cấu hình time zone cho hệ thống: 

  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/19.png">

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/20.png">

   => Chon `Ho Chi Minh`.

- Cấu hình phân vùng ổ cứng: 

  <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/21.png">

  => Nếu bạn có nhiều hơn 1 ổ cứng cho hệ thống của bạn thì chọn cấu hình set up với LVM (Logic Volumn Manager) - để quản lý các hard disk và gom gộp thành Logic Volumn để hoạt động hiệu quả hơn. 

     Còn nếu chỉ một ổ cứng thì bạn chỉ cần chọn cấu hình thứ nhất như mình. 
   
   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/22.png">

*Lưu ý*: Khi bạn chọn ổ cứng để phân vùng thì mọi dữ liệu trước đó trên ổ cứng sẽ bị xóa.

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/23.png">
 
 => cấu hình mặc định là Partition 1 là phân vùng primary - định dạng ext4 
   
   Partition 5 là phân vùng swap 

   => chọn `yes`

- Cấu hình proxy: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/24.png">

   Điền vào địa chỉ proxy nếu bạn dùng. Nếu không dùng, chọn `<Continue>`

- Cấu hình update hệ thống: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/25.png">

   => Bước này chọn `No automatic updates`. Khi nào cần update, chúng ta sẽ tự update thủ công. 

- Cài đặt các gói phần mềm cần thiết: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/31.png">

 => Ở đây chọn OpenSSH. Mình chọn gói phần mềm này vì để phục vụ quá trình sử dụng sau này. Nếu không chọn ở bước này, thì các phần mềm này đều có thể cài đặt manual sau khi sử dụng hệ thống. 
 
- Cài đặt Bootloader: 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/26.png">

   => Chọn `yes`

- Chờ sau khi hệ thống cài đặt xong là hoàn thành. 

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/27.png">

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/28.png">

- Dùng tài khoản superuser mới tạo lúc trước để đăng nhập hệ thống:

   <img src="https://github.com/ThanhTamPotter/thuctap012017/blob/master/TamNT/CaiDatUbuntuServer14.04/Pictures/29.png">

---

Sau khi cài đặt xong mình thường hay chạy lệnh sau để update hệ thống: 

`$apt-get update && apt-get disupgrade`
 
 *(Lệnh sử dụng với tài khoản superuser)*





























