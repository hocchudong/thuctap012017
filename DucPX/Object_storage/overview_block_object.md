# Tổng quan về dịch vụ lưu trữ Block và Object

## 1. Dịch vụ lưu trữ Block
- Cung cấp các thiết bị lưu trữ tương tự như hard disk thông qua mạng.
- Block storage cung cấp một block với kích thước bất kỳ và cắm block vào máy ảo để sử dụng.
- Ta sẽ xem block này như disk thông thường. Nó có thể được định dạng để ghi các file lên, phối hợp nhiều block để tạo RAID,...
- Block cũng có một số ưu điểm như hard disk:
  - Có thể snapshot các block này cho mục đích backup.
  - Có thể thay đổi kích thước để lưu trữ lượng data cần thiết (ví dụ khi data tăng lên hoặc giảm, không gây lãng phí, đáp ứng nhu cầu lưu trữ).
  - Dễ dàng tháo gỡ và chuyển qua các máy khác.

### Một số ưu điểm của lưu trữ Block
- Người dùng phổ thông dễ dàng hiểu và sử dụng.
- Các thiết bị block hỗ trợ tốt. Các ngôn ngữ lập trình dễ dàng đọc và ghi các files.
- Kiểm soát truy cập và phân quyền truy cập filesystem quen thuộc (như trên các thiết bị hard disk).
- Độ trễ thấp, phù hợp để sử dụng cho lưu trữ database.

### Một số nhược điểm.
- Kho lưu trữ phải gắn vào một server tại cùng một thời điểm.
- Blocks và filesystems giới hạn matadata (lưu matadata: thời gian tạo, chủ sở hữu, kích thước). Các thông tin cần lưu thêm thì phải lưu ở mức ứng dụng và database. Điều này gây ra sự phức tạp cho các nhà phát triển.
- Chỉ có thể truy cập đến block storage thông qua một server đang chạy.
- Cần nhiều thao tác cài đặt, thiết lập hơn so với lưu trữ bằng object (chọn filesystem, phân quyền, backup, etc).

=> Vì đặc điểm tốc độ IO nhanh nên nó phù hợp với các hệ thống lưu trữ database. Hơn nữa có nhiều phần mềm được kế thừa từ các phần mềm cũ có yêu cầu lưu trữ filesystem thông thường nên yêu cầu sử dụng thiết bị lưu trữ block.

## 2. Dịch vụ lưu trữ Object.
- Trong mô hình lưu trữ hiện đại của cloud computing, lưu trữ object là việc lưu trữ và thu hồi data và metadata thông qua HTTP API.
- Thay vì "băm" files thành các block và lưu trữ chúng xuống disk sử dụng filesystem, thì chúng ta sẽ lưu theo đối tượng thông qua mạng.
- Chúng là phi cấu trúc thì chúng không tuân theo giản đồ hay định dạng nào cả.
- Sử dụng các API theo chuẩn giao thức HTTP, các thư viện được phát triển cho nhiều ngôn ngữ lập trình. Lưu trữ data trở nên dễ dàng thông qua HTTP PUT resquest để lưu object.
- Tìm kiếm files đã lưu trữ thường thông qua GET request.
- Chỉ tính phí cho không gian lưu trữ mà người dùng sử dụng (một số thì có thể tính theo số lượng http request hoặc băng thông).

### Ưu điểm của Object storage
- Sử dụng HTTP API, phổ biến cho hầu hết các hệ điều hành và ngôn ngữ lập trình.
- Chỉ chi trả cho những gì bạn sử dụng.
- Tùy chọn phiên bản, có nghĩa là bạn có thể thu hồi version của object cũ và thay thế bằng object mới.
- Dễ dàng mở rộng phù hợp với nhu cầu.
- Không phải quản lý các thiết bị disk.
- Việc lưu trữ đoạn metadata của dữ liệu làm đơn giản hóa trong cấu trúc của ứng dụng.

### Nhược điểm của Object storage.
- Không thể sử dụng để lưu database vì độ trễ cao.
- Không thể thay đổi data, tất cả object đều phải được đồng bộ một lần. Nếu muốn thay đổi thì phải lấy lại object và thay đổi, rồi ghi cả object mới.
- OS không thể dễ dàng để mount 1 object như disk.

=> Với những đặc điểm này, phù hợp với các hosting, lưu trữ phim ảnh, file backup,...
