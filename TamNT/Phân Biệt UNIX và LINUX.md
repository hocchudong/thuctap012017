# PHÂN BIỆT UNIX VÀ LINUX

# Mục lục

[1. Giới thiệu chung về UNIX và LINUX](#1)

- [1.1. UNIX](#1.1)

- [1.2. LINUX](#1.2)
  
[2. Phân biệt UNIX và LINUX](#2)

[3. Tài liệu tham khảo](#3)

---


<a name="1"></a>
# 1. Giới thiệu chung về UNIX và LINIX

<a name="1.1"></a>
## 1.1. UNIX

- Là một Hệ điều hành máy tính đa nhiệm, đa người dùng được phát triển vào năm 1969 bởi một nhóm nhân viên tại công ty AT&T tại phòng thí nghiệm Bell Labs.

- Hệ thống UNIX có đặc điểm là thiết kế theo module - tức là Hệ điều hành cung cấp một tập hợp các công cụ đơn giản, và mỗi công cụ chỉ thực hiện những chức năng giới hạn và được định nghĩa rõ ràng, với hệ thống file là phương tiện chính để
giao tiếp và phần lập trình vỏ và ngôn ngữ lệnh kết hợp các công cụ để thực hiện các chức năng phức tạp.

- UNIX là một trong những hệ điều hành 64 bit đầu tiên. Hiện nay UNIX được sử dụng bởi nhiều công ty tập đoàn lớn trên thế giới vì mức độ bảo mật của nó tương đối cao.

-  Qua nhiều năm, nó đã được phát triển thành nhiều phiên bản sử dụng trên nhiều môi trường phần cứng khác nhau. Hầu hết các phiên bản UNIX hiện này đều là những biến thể của UNIX gốc và được các nhà phát triển sửa đổi, viết lại hoặc thêm các tính năng, công nghệ riêng biệt. Các phiên bản UNIX hiện nay có thể kể đến: HP-UX (HP), AIX (IBM), Solaris (Sun/Oracle), Mac OS X (Apple).

<a name="1.2"></a>
## 1.2. LINUX

- LINUX là một mã nguồn mở, miễn phí sử dụng cho nhiều hệ điều hành sử dụng cho phần cứng máy tính và phần mềm, phát triển game, tablet PCS, mainframes ...

- LINUX được tạo ra với mục đích tạo ra một phần mềm miễn phí nhằm thay thế cho môi trường UNIX thương mại.

- Phiên bản Linux đầu tiên do Linus Torvalds viết vào năm 1991, lúc ông còn là một sinh viên của Đại học Helsinki tại Phần Lan. Ông làm việc một cách hăng say trong vòng 3 năm liên tục và cho ra đời phiên bản Linux 1.0 vào năm 1994. Bộ phận chủ yếu này được phát triển và tung ra trên thị trường dưới bản quyền GNU General Public License. Do đó mà bất cứ ai cũng có thể tải và xem mã nguồn của Linux.

- Thuật ngữ "Linux" được sử dụng để chỉ nhân Linux, nhưng tên này được sử dụng một cách rộng rãi để miêu tả tổng thể một hệ điều hành tương tự Unix (còn được biết đến dưới tên **GNU/Linux**) được tạo ra bởi việc ***"đóng gói"*** nhân Linux cùng với các thư viện và công cụ **GNU**, cũng như là các bản phân phối Linux. 

<a name="2.2"></a>
# 2. Phân biệt UNIX và LINUX


| Tiêu chí đánh giá | UNIX  | LINUX | 
|-------------------|-------|-------|
| **Phí - bản quyền**     |Mỗi phiên bản khác nhau của UNIX có mức phí bản quyền khác nhau tùy theo nhà cung cấp. | Có thể được phân phối miễn phí, download miễn phí. Có thể có một số bản phân phối tính phí nhưng phí đó thường rẻ hơn so với Window.|
|**Phát triển và phân phối** | UNIX được chia thành các bản flavor khác nhau, chủ yếu phát triển bởi AT&T cũng như các nhà nhà cung cấp thương mại và các tổ chức phi lợi nhuận | Được phát triển bởi sự phát triển của Open Source, thông qua việc hợp tác và chia sẻ code và các tính năng thông qua các forum và nó được cung cấp bởi nhiều nhà cung cấp khác nhau. | 
| **User**|Được phát triển chủ yếu cho các máy tính lớn, servers , máy trạm, trong các trường đại học, các công ty và doanh nghiệp lớn ngoài trừ MAC OS X là dùng cho tất cả mọi người. Môi trường UNIX và mô hình server - client là yếu tố thiết yếu trong sự phát triển của Internet. | Tất cả mọi người: từ người sử dụng không chuyên tới các nhà phát triển và những người đam mêm máy tính... |
| **Kiến trúc phần cứng** | Được lập trình để chạy trên một nhóm kiến trúc phần cứng nhất định. Việc giới hạn phần cứng giúp các công ty bán UNIX tối ưu hóa HĐH của mình để có thể chạy thật tốt trên một thiết bị phần cứng nào đó. | Có thể chạy trên rất nhiều kiến trúc phần cứng, và số lượng các thiết bị gán ngoài, thiết bị I/O hầu như không giới hạn. Do đó cũng dấn tới hệ quả là không thể hoàn toàn tối ưu hóa HĐH cho từng kiến trúc phần cứng. |
| **Hệ thống file** | Định dạng file jfs, gpfs, hfs, hfs+, ufs, xfs, zfs | Định dạng file Ext2, Ext3, Ext4, Jfs, ReiserFS, Xfs, Btrfs, FAT, FAT32, NTFS |
| **Nhân Hệ điều hành** | Thường được cung cấp dưới dạng nhị phân hay các gói "nguyên khối", và những người khác chỉ có thể nâng cấp, chỉnh sửa một phần nhỏ. Thường có tính đóng. | Nhân Linux và và các thành phần khác đều là phần mềm tự do và mã nguồn mở. Nên việc biên tập, vá lỗi kernel và driver dễ dàng hơn. Do đó, khi có bug lỗi xảy ra thì tự người dùng có thể fix hoặc được hỗ trợ fix nhanh chóng thông qua các forum Open source|
|**Phát hiện và xử lý lỗi**| Do tính chất độc quyền của UNIX nên khi phát hiện mỗi đe dọa hay lỗi thì người dùng phải chờ đợi một thời gian để được các nhà cung cấp hỗ trợ. Nhưng thường không hay xảy ra vấn đề này. | Việc phát hiện các mối đe dọa hay các lỗi thường được phát hiện và cũng hầu như cũng tìm được giải pháp giải quyết rất nhanh bởi cộng đồng người dùng Open Source. |

Trên đây là một số tiêu chí đánh giá cơ bản để phân biệt Hệ điều hành UNIX và LINUX. 

<a name="3"></a>
# 3. Tài liệu tham khảo

[1] Different Unix and Linux: https://www.ibm.com/developerworks/aix/library/au-unix-difflinux.html

[2] http://www.diffen.com/difference/Linux_vs_Unix

[3] Phân biệt Linux và Unix: https://tinhte.vn/threads/phan-biet-giua-unix-va-linux.816063/

[4] Unix - Wiki: https://vi.wikipedia.org/wiki/Unix

[5] Linux - Wiki: https://vi.wikipedia.org/wiki/Linux




