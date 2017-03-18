# **TÌM HIỂU CÔNG CỤ TCPDUMP**

## ***Mục lục***

[1. Giới thiệu tcpdump](#1)

[2. Một số tùy chọn cơ bản thao tác với câu lệnh `tcpdump`](#2)

- [2.1. Các tùy chọn lệnh.](#2.1)

- [2.2. Một số tùy chọn lọc gói](#2.2)

[3. Một số ví dụ](#3)

[4. Tài liệu tham khảo](#4)

---

<a name="1"></a>
# 1. Giới thiệu tcpdump


**tcpdump** là công cụ được phát triển nhằm mục đích phân tích các gói dữ liệu mạng theo dòng lệnh. Nó cho phép người dùng chặn và hiển thị các gói tin được truyền đi hoặc nhận được trên một mạng máy tính mà nó tham gia.

- **tcpdump** xuất ra màn hình nội dung gói tin (mà ***bắt*** được trên card mạng mà nó đang lắng nghe) phù hợp với biểu thức logic lọc mà người dùng nhập vào. 

- Với option **-w**, người dùng có thể xuất ra những mô tả về các gói tin dưới dạng file **.pcap** để có thể dùng phân tích về sau, và có thể đọc nội dung một file **.pcap** với tùy chọn **-r**. Các file **.pcap** này cũng có thể được đọc trong một số chương trình phân tích gói tin khác cố giao diện đồ họa như Wireshark, Enttercap...

- Khi **tcpdump** kết thúc việc bắt (capture) gói tin thì nó sẽ thống kê lại thông tin về số lượng các gói tin đã capture, số lượng gói tin nhận được từ bộ lọc (lọc theo nhu cầu người dùng nhập vào), và số lượng gói tin bị dropped do thiếu không gian vùng đệm, bởi cơ chế bắt gói tin của hệ điều hành.

- Được hỗ trợ sẵn trong hầu hết các hệ thống Linux/Unix.

- Các đặc điểm của **tcpdump**:

  - Nhìn thấy được bản tin dump trên terminal.

  - Bắt được (capture) các bản tin và có thể lưu vào file định dạng .pcap (có thể đọc được nhờ Wireshark).

  - Tạo được các bộ lọc filter để lọc các bản tin cần thiết: http, ssh, ftp, ...

  - Có thể nhìn được trực tiếp các bản tin điều khiển Linux.

  - Và nhiều hơn nữa mà sẽ tìm hiểu ở phần sau.


<a name="2"></a>
# 2. Một số tùy chọn cơ bản với câu lệnh `tcpdump`

Cấu trúc câu lệnh tcpdump như sau: 

```
tcpdump [ -AbdDefhHIJKlLnNOpqStuUvxX# ] [ -B buffer_size ] 

         [ -c count ] 

         [ -C file_size ] [ -G rotate_seconds ] [ -F file ] 

         [ -i interface ] [ -j tstamp_type ] [ -m module ] [ -M secret ] 

         [ --number ] [ -Q in|out|inout ] 
         [ -r file ] [ -V file ] [ -s snaplen ] [ -T type ] [ -w file ] 

         [ -W filecount ] 

         [ -E spi@ipaddr algo:secret,... ] 

         [ -y datalinktype ] [ -z postrotate-command ] [ -Z user ] 
         [ --time-stamp-precision=tstamp_precision ] 
         [ --immediate-mode ] [ --version ] 
         [ expression ] 
 ```

<a name="2.1"></a>
## 2.1. Các tùy chọn lệnh:
Trong đó, một số tùy chọn thông dụng như sau:

- **-A** : Hiển thị các gói tin bắt được dưới dạng ASCII.

- **-c** *count* : Capture đến khi đủ *count* gói tin sẽ dừng lại.

- **-C** *file_size* : Giới hạn kích thước file : ghi lại thông tin các gói tin capture được vào file với tùy chọn **-w** đến khi dung lượng file đủ *file_size* thì sẽ ghi sang file mới, file mới được đặt tên giống file cũ và thêm phần đánh thứ tự các file.

- **-D** hoặc **--list-interfaces**: List ra thông tin các card mà tcpdump có thể capture gói tin.

- **-e**: Hiển thị ra header lớp link-layer. Dùng để hiển thì ra địa chỉ MAC đích và MAC nguồn của gói tin bị capture.

- **--version** : in ra version của tcpdump.

- **-i** - **--intrface**=*interface* : lắng nghe trên ***interface*** chỉ định.

- **-n** : In ra thông tin địa chỉ IP của gói tin.

- **-r** *file-name*: Đọc gói tin từ 1 file đã được lưu thông tin các gói bắt được trước đó.

- **-w** *file_name*: ghi lại thông tin các gói tin bắt được vào file tên ***file-name***

- **-t**: Bỏ in thời gian capture gói tin ở mỗi dòng.

- **-ttt**: In thêm khoảng thời gian bắt gói tin hiện tại và thời gian bắt gói tin trước đó tại mỗi đầu dòng.

- **-tttt**: Hiển thị thông tin chi tiết về thời gian yyyy/mm/dd hh:mm:ss bắt gói tin tại mỗi đầu dòng.

*Tham khảo thêm các tùy chọn khác [tcpdump-manpage](http://www.tcpdump.org/tcpdump_man.html).*

<a name="2.2"></a>

## 2.1. Một số tùy chọn bộ lọc sử dụng với tcpdump:

Sử dụng trong tùy chọn [expression] trong câu lệnh tcpdump.

- **and, or, not** : sử dụng kết hợp các bộ lọc.

- **dst host** *host* : lọc các gói tin có địa chỉ IP hoặc tên host đích của gói tin là ***host***

- **src host** *host*: tương tự như trên với địa chỉ nguồn của gói tin.

- **host** *host_addr* : lọc nếu trong gói tin có địa chỉ nguồn hoặc đích bằng với ***host_addr***

- **ether dst host** *ehost* : lọc gói tin nếu MAC đích của gói tin ethernet có giá trị là ***ehost***

- **ether src host** *ehost*: tương tự với giá trị là MAC nguồn.

- **ether host** *ehost* :lọc gói tin nếu gói tin ethernet có MAC đích hoặc MAC nguồn là ***ehost***

- **dst port** *port* : lọc gói tin nếu gói tin bắt được có port đích bằng với ***port***

- **src port** *port* và **port** *port* cũng tương tự như trên.

- **dst portrange** *port1-port2* lọc gói tin nếu gói tin có địa chỉ port dích nằm trong khoảng từ ***port1*** tới ***port2**

- **src portrange** *port1-port2* và **portrange** *port1-port2* ý nghĩa tương tự.

- **less** *length* : lọc nếu gói tin có kích thước nhỏ hơn hoặc bằng ***length*** (tính bằng byte)

- **greater** *length*: lọc  nếu gói tin có kích thước lớn hơn hoặc bằng ***length***

- **ip proto** *protocol*: lọc các gói tin ipv4 có giao thức là ***protocol***. Ví dụ: tcp, udp, icmp, arp

- **ether broadcast**: lọc các gói tin gửi broadcast layer 2.

- **vlan** *vlan_id* lọc các gói tin thuộc vlan_id.

- Một số giao thức được hỗ trợ capture mà không cần phần lệnh lọc như: **tcp, udp, icmp, ip, ip6, arp, rarp, atalk, aarp, decnet, iso, stp, ipx, netbeui** 

*Tham khảo thêm tại [pcap-filer man page](http://www.tcpdump.org/manpages/pcap-filter.7.html).*

<a name="3"></a>
# 3. Một số ví dụ:

Khi đang chạy lệnh `tcpdump`, để dùng việc capture gói tin ta dùng tổ hợp `Ctrl + C` hoặc kill tiến trình tcpdump. Mặc định, tcpdump sẽ lắng nghe trên card đầu tiên. Ubuntu là eth0.

- Capture và lọc ra 10 gói tin giao thức icmp có địa chỉ IP đích là 8.8.8.8 (google-public-dns-a.google.com):

<img src="http://imgur.com/rTYqUac.jpg">

- Capture và lọc ra các gói tin ARP trong đó, hiển thị ra các địa chỉ MAC đích MAC nguồn của gói tin: 

<img src="http://imgur.com/BvrtMVH.jpg">

- Lưu thông tin các gói tin bắt được vào một file định dạng .pcap để dùng cho phân tích về sau :

(Lọc 10 gói tin tcp có kích thước nhỏ hơn 100 bytes, ghi rõ thông tin ngày tháng năm, thời gian bắt gói)

<img src="http://imgur.com/xw6Kgiz.jpg">

- Đọc thông tin các gói tin bắt được từ 1 file đã lưu trước đó với tùy chọn -r :
 
 <img src="http://imgur.com/iTUCtIR.jpg">

- Bắt tất cả các gói tin ngoại trừ gói tin tcp

<img src="http://imgur.com/tqpapWV.jpg">

- Bắt các gói tin ssh trên cổng 22:

<img src="http://imgur.com/ttepq0w.jpg">

Từ những tùy chọn lệnh và tùy chọn lọc gói tin, các bạn có thể tự lọc ra các gói tin tùy theo ý thích của mình. 

<a name="4"></a>
# 4. Tài liệu tham khảo

[1] http://www.tcpdump.org/tcpdump_man.html

[2] http://www.tcpdump.org/manpages/pcap-filter.7.html

[3] https://k3nshjnz.wordpress.com/2013/05/31/lenh-tcpdump-tren-linux/





