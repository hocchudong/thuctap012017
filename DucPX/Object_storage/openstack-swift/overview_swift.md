# Chương 1: Công nghệ lưu trữ điện toán đám mây - Cloud Storage

## Mục lục
- [1. Ưu điểm và nhược điểm của lưu trữ điện toán đám mây.](#1)
- [2. Object Storage](#2)
- [3. Openstack Swift](#3)

---
- Swift đã phát triển vượt ra khỏi giới hạn của openstack, trở thành một công nghệ lưu trữ điện toán đám mây độc lập
- Khi xây dựng một hệ thống công nghệ thông tin, các kỹ sư sẽ không tái tạo lại những gì mà học đã có. Thay vào đó họ học hỏi những công nghệ đang được áp dụng tốt trong thực tiễn bởi các công ty lớn như Google,...
- Ngày nay có một kỹ thuật lưu trữ mang tính cách mạng, lưu trữ điện toán đám mây. Nó phù hợp cho các doanh nghiệp quản lý khối lượng lưu trữ lớn, cắt giảm chi phí có thể hơn 10 lần so với quản lý lưu trữ theo kiểu truyền thống lưu trữ filesystem và lưu trữ block.

<a name=1></a>
# 1. Ưu điểm và nhược điểm của lưu trữ điện toán đám mây.
### Ưu điểm:
- Cắt giảm tổng chi phí cho doanh nghiệp (TCO – total cost of ownership).
- Không giới hạn khả năng mở rộng.
- Đạt được tính đàn hồi bằng cách ảo hóa.
- Chi trả dựa trên nhu cầu sử dụng.
- Không giới hạn truy cập.
- Đa truy cập, đa người dùng.
- Lưu trữ dữ liệu lâu dài và đảm bảo tính khả dụng của dữ liệu.

### Nhược điểm:
- Hiệu năng.
- APIs mới.

<a name=2></a>
# 2. Object Storage.
- Lưu trữ dữ liệu trong dạng object (bản chất là filesystem) trong namespace sử dụng REST HTTP APIs.
- Ảo hóa hoàn toàn tài nguyên vật lý.
- Khả năng mở rộng lưu trữ dễ dàng.
- Không yêu cầu các loại phần cứng chuyên dụng, đắt tiền. Hỗ trợ nhiều loại phần cứng phổ biến hiện nay.
- Tự động hóa trong việc sắp xếp dữ liệu, quản lý đảm báo tính bền vững và độ khả dụng của dữ liệu.
- Người dùng truy cập đến đối tượng thông qua giao thức HTTP

<a name=3></a>
# 3. Openstack Swift.
- Openstack Swift là một mã nguồn mở lưu trữ đối tượng. Được Rackspace đã tạo ra Swift vào năm 2010, và các công ty lớn đóng góp vào sự phát triển Swift bao gồm SwiftStack, Rackspace, Red Hat, HP, Intel, IBM, 

### Một số đặc điểm của Openstack Swift.
- Open Source: Swift là phần mềm mã nguồn mở, người dùng không phải trả bất cứ chi phí nào.
- Open Standards: sử dụng HTTP REST APIs cùng với SSL cho tùy chọn mã hóa. Sự phối hợp open source và open standards đã loại bỏ hết các nhà cung cấp khóa (lock-in).
- Cấu trúc Account, Container, Object: Swift quản lý lưu trữ dựa vào cấu trúc phân chia cấp bậc, mức cao nhất Account, đến Container và cuối cùng là Object.
- Tính toàn cục trong cụm: Cho phép sao chép và phân phối dữ liệu lên toàn hệ thống. Tính năng này giúp khôi phục dữ liệu do các thảm họa, phân phối dữ liệu và một số lợi ích khác nữa.
- Các chính sách lưu trữ: Linh hoạt trong việc chọn phần cứng lưu trữ. Ví dụ, các tài nguyên quan trọng có giá trị có thể được lưu trữ ở nơi có phần cứng chất lượng, có độ an toàn. Trong khi đó, các dữ liệu ít quan trọng có thể lưu trữ ở nơi kém an toàn hơn, không yêu cầu phần cứng đặc biệt. Các dữ liệu yêu cầu độ truy xuất nhanh được lưu trong trong các ổ cứng SSDs.
- Thu hồi một phần của đối tượng: Ví dụ một phần của đối tượng phim hoặc file TAR.
- Kiến trúc Middleware: Cho phép người dùng thêm các tính năng. Ví dụ tích hợp với hệ thống xác thực.
- Hỗ trợ đối tượng có kích thước lớn: Swift có thể lưu trữ một đối tượng có kích bất kỳ.
- Các tính năng thêm: Swift còn có một số tính năng thêm như phiên bản của đối tượng, nguyên nhân đối tượng bị xóa, tốc độ giới hạn, …
