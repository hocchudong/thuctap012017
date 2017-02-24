# THỰC HÀNH CÀI ĐẶT UBUNTU SERVER 14.04

***Mục đích***: Hiểu cơ bản về các bước cài đặt Ubuntu Server 14.04

---
---

# Mục lục

[1. Giới thiệu hệ điều hành Ubuntu Server ](#1)

[2. Thực hành cài đặt Ubuntu Server 14.04 trên VMware Work Station 12](#2)

  - [2.1. Chuẩn bị](##2.1)
  
  - [2.2. Các bước cài đặt](##2.2)

  ---
  ---

  <a name=#1></a>

  # 1. Giới thiệu hệ điều hành Ubuntu Server

  - ***Ubuntu*** là một hệ điều hành mã nguồn mở miễn phí được xây dựng dựa trên Debian GNU/Linux. Điều đó có nghĩa là mọi người đều được tự do sử dụng, thay đổi, cải tiến nó… Ubuntu được tài trợ bởi công ty Canonical Ltd (chủ sở hữu là một người Nam Phi Mark Shuttleworth).  Thay vì bán Ubuntu, Canonical tạo ra doanh thu bằng cách bán hỗ trợ kĩ thuật.

  - Các hệ thống máy chủ là các máy chuyên phục vụ cho các máy khách, các dịch vụ có thể rất chuyên dụng như: DNS, DHCP, hay rất thông dụng như Email, Firewall,… Nhưng việc xây dựng một hệ thống máy chủ có quy mô còn đòi hỏi những kiến thức rất chuyên dụng về các dịch vụ, hệ thống mạng, và cả về hệ điều hành.Các máy chủ thường chạy trên các hệ điều hành Window Server, hoặc các điều hành Linux( mã nguồn mở). Việc hệ điều hành Window khá thân thuộc( có lẽ sẽ giúp cho việc quản trị dễ dàng hơn) nhưng hệ điều hành Window Server thì bản quyền khá đắt. Trong khi đó các máy chủ Linux được đánh giá là bảo mật, lại hoàn toàn miễn phí( do xây dựng hoàn toàn trên hệ thống nguồn mở). 

  - Trong bài này, mình sẽ cài đặt *Ubuntu Sererver 14.04 - 64 bit* là phiên bản Ubuntu server  LTS phát hành tháng 4 năm 2014. Tuy ra đời đã được một thời gian nhưng do tính ổn định của phiên bản này nên mình vẫn chọn nó. (Với người mới bắt đầu như mình thì nên chọn một phiên bản ổn định hơn là phiên bản hoàn toàn mới như 16.04. Việc chọn phiên bản sẽ tùy thuộc vào sự hiểu biết và nhu cầu của bạn)

  - Cấu hình tối thiểu cho việc cài đặt phiên bản Ubuntu Server là máy có bộ vi xử lí 300 MHz x86, RAM 256 MB, và card màn hình VGA hỗ trợ độ phân giải 640x480 trở lên. (*Lưu ý điều này khi cấu hình phần cứng cho máy ảo VMware trước khi cài đặt*)

<a name=#2></a>
# 2. Thực hành cài đặt Ubuntu Server 14.04 trên VMware Work Station 12

<a name=##2.1></a>
## 2.1. Chuẩn bị
 - VMware Work Station 12. Có thể xem hướng dẫn sử dụng VMware cho những bạn chưa nắm vững [tại đây](https://github.com/hocchudong/vmware-workstation-network))
 
 - Iso Ubuntu Server 14.04: Download tại http://releases.ubuntu.com/14.04/ 

 <a name=##2.2></a>
 ## 2.2. Các bước cài đặt 

- Chọn 







