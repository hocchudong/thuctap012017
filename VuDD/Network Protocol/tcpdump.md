#Tìm hiểu về tcpdump

#Mục Lục
[1.Giới thiệu chung](#1)
[2.Định dạng chung của dòng giao thức tcpdump](#2)
[3.Một số câu lệnh cơ bản](#3)

<a name='1'></a>
##1.Giới thiệu chung
\-Tcpdump là công cụ phát triển nhằm mục đích phân tích các gói dự liệu mang theo dòng lệnh.
\-Cho phép khách hàng chặn và hiển thị các gói tin được truyền đi hoặc được nhận trên 1 mạng mà máy tính có thể tham gia
\-Có thể lưu ra file và đọc bằng công cụ đồ hoà Wireshark
\-Trong trường hợp không có tuỳ chọn thì lệnh tcpdump sẽ chạy cho đến khi nhận được tín hiệu ngắt từ khách hàng
\-Cài đặt tcpdump:
```
sudo apt-get install tcpdump -y
```
\-Bảng thông số thu được bao gồm packet capture, packet received by filter, packet dropped by kernel
    packet capture: số lượng gói tin bắt được và xử lý
    packet received by filter: số lượng gói tin nhận bởi bộ lọc
    packet dropped by kernel: số lượng packet đã bị dropped bởi cho chế bắt gói tin của HĐH
<a name='2'></a>
##2.Định dạng chung của dòng giao thức tcpdump
```
time-stamp src>dst: flags data-seqno ack windown urgent option
```
Ý nghĩa của các trường là:
\-Time-stamp: hiện thị thời gian gói tin được capture
\-src và dst: hiển thị địa chỉ IP của người gửi và người nhận
\-Cờ flags: + S(SYN): được sử dụng trong quá trình bắt tay bời giao thức TCP
            + .(ACK): được sử dụng để thông báo cho bên gửi biết là gói tin nhận được dữ liệu thành công
            + F(FIN): được sử dụng để đóng kết nối TCP
            + R(RST): được sử dụng để khi muốn thiết lập lại đường truyền
\-Data-seqno: số seq number của gói dữ liệu hiện tại.
\-ACK: mô tả số sequence number tiếp theo của gói tin do bên gửi truyền(số sequence mong muốn nhận được)
\-Window: Vùng nhớ đệm có sẵn theo hướng khác trên kết nối
\-Urgent: Cho biết có dữ liệu khẩn cấp trong gói tin

<a name='3'></a>
##3.Một số tuỳ chọn cơ bản
    -i sử dụng tùy chọn này khi người sử dụng cần chụp các gói tin trên interfaces chỉ định.
    -D khi sử dụng tùy chọn này tcpdump sẽ liệt kê ra tất cả các interface hiện hữu trên máy mà có thể capture được.
    -c N khi sử dụng tùy chọn này tcpdump sẽ ngừng hoạt động khi đã capture N gói tin.
    -n khi sử dụng tùy chọn này tcpdump sẽ không phân giải địa chỉ IP sang hostname.
    -nn khi sử dụng tùy chọn này tcpdump không phân giải địa chỉ sang host name và cũng không phân giải cả portname.
    -v tăng khối lượng thông tin mà bạn mà gói tin có thể nhận được , thậm chí có thể tăng thêm với tùy chọn -vv và -vvv
    -X hiển thị thông tin dưới dạng mã HEX hoặc ACSII.
    -A hiển thị các packet được capture dưới dạng ACSII.
    -S Khi tcpdump capture packet, thì nó sẽ chuyển các số sequence number, ACK thành các relative sequense number, relative ACK. Nếu sử dụng option –S này thì nó sẽ không chuyển mà sẽ để mặc định.
    -F filename Dùng để filter các packet với các luật đã được định trước trong tập tin filename.
    -e Khi sử dụng option này, thay thì hiển thị địa chỉ IP của người gửi và người nhận, tcpdump sẽ thay thế các địa chỉ này bằng địa chỉ MAC.
    -t Khi sử dụng option này, tcpdump sẽ bỏ qua thời gian bắt được gói tin khi hiển thị cho khách hàng.
    -N Khi sử dụng option này tcpdump sẽ không in các quality domain name ra màn hình.
    -B size Sử dụng option này để cài đặt buffer_size .
    -L Hiển thị danh sách các datalink type mà interface hỗ trợ.
    -y Lựa chọn datalinktype khi bắt các gói tin.
