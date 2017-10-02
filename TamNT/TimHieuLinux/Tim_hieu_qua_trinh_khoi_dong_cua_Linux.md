# QUÁ TRÌNH KHỞI ĐỘNG CỦA LINUX

### ***Mục lục***

[1. Power-on ](#1)

[2. Master Boot Record (MBR)](#2)

[3. Boot loader ](#3)

[4. Linux kernel được nạp và khởi chạy](#4)

[5. Các script trong INITRD được thực thi](#5)

[6. Chương trình init được thực thi](#6)

[7. Các initscript được thực thi dựa trên runlevel được chọn](#7)

[8. Đăng nhập với giao diện đồ họa ](#8)

[9. Khi người dùng đăng nhập thành công vào hệ thống](#9)

[Tham khảo](#ref)

---


Ghi chép tìm hiểu về quá trình khởi động của một máy Linux. Từ lúc nhấn nút nguồn để bật máy tính lên cho tới khi bạn có thể sử dụng máy tính để thực hiện các công việc của mình. 
<a name = '1'></a>
# 1. Power-on

- BIOS (một phần mềm được nhúng (embedded) vào các chip PROM, EPROM hay các bộ nhớ flash nằm trên các bo mạch chủ) là chương trình được chạy đầu tiên khi bạn nhấn nút nguồn hoặc nút reset trên máy tính của mình. BIOS thực hiện một công việc gọi là POST (Power-on Self-test) nhằm kiểm tra các thông số và trạng thái của các phần cứng máy tính khác nhau như là bộ nhớ, CPU, thiết bị lưu trữ, card mạng, ... 
- Đồng thười, BIOS cũng cho phép bạn thay đổi các thiết lập, cấu hình của nó.
- Nếu quá trình POST thành công, thì sau đó BIOS sẽ cố gắng tìm kiếm và khởi chạy (boot) một hệ điều hành được chứa trong các thiết bị lưu trữ như ổ cứng, CD/DVD, USB, ... Thứ tự tìm kiếm có thể được thay đổi bởi người dùng.

<a name = '2'></a>
# 2. Master Boot Record (MBR)

- Sector đầu tiên (được đánh số 0) của một thiết bị lưu trữ dữ liệu được gọi là MBR, thường sector 0 này có kích thước là 512 byte. Sau khi BIOS xác định được thiết bị lưu trữ nào sẽ được ư tiên để tìm kiếm đầu tiên thì thực chất BIOS sẽ đọc trong MBR của thiết bị này để nạp vào bộ nhớ một chương trình rất nhỏ (dưới 512 byte). Chương trình nhỏ này sẽ định vị và khởi động boot loader - đây là chương trình chịu trách nhiệm cho việc tìm và nạp nhân (kernel) của hệ điều hành. 

<a name = '3'></a>
# 3. Boot loader
- Có 2 loại bootloader phổ biến trên linux là GRUB và LILO(tiền thân của Grub). Cả 2 chương trình này đều có chung mục đích: cho phép bạn lựa chọn một trong các hệ điều hành có trên máy tính để khởi động, sau đó chúng sẽ nạp kernel của hệ điều hành đó vao bộ nhớ và chuyển quyền điều khiển máy tính cho kernel này.   
- Grub hay LILO đều có thể khởi động cho cả Linux và Windows, nhưng ngược lại các bootloader trên Windows (như NTLDR, BOOTMGR) thì không hỗ trợ khởi động cho các hệ điều hành Linux. Trong thế giới Linux, các bôt loader cũng có thể nạp thêm các ramdisk hoặc các INITRD.

<a name = '4'></a>
# 4. Linux kernel được nạp và khởi chạy
Bootloader nạp một phiên bản dạng nén của Linux kernel, và ngay lập tức nó tự giải nén và tự cài đặt mình lên đỉnh bộ nhớ hệ thống - nơi mà nó sẽ nằm ở đó cho đến khi bạn tắt máy. 

<a name = '5'></a>
# 5. Các script trong INITRD được thực thi
- Một vấn đề mà những người viết script đa mục đích phải đối mặt là: không thể nào đoán trước được chính xác cấu trúc máy tính của người sẽ sử dụng bản Linux của họ... Máy tính của người dùng có những thành phần linh kiện nào.  
- Các INITRD cung cấp một giải pháp: một tập các chương trình nhỏ sẽ được thực thi khi kernel vừa mới được khởi chạy. Các chương trình nhỏ này sẽ dò quyets phần cứng của hệ thống và xác định xem kernel cần được hỗ trợ thêm những gì dể có thể quản lý được các phần cứng đó. Chương trình INITRD có thể nạp thêm vào kernel các module bổ trợ. Khi chương trình INITRD kết thúc thì quá trình khởi động Linux sẽ tiếp diễn. 

<a name = '6'></a>
# 6. Chương trình init được thực thi

- Khi kernel được khởi chạy xong, nó triệu gọi duy nhất một chương trình tên là init.   
- Tiến trình này có tên PID = 1, init là cha của tất cả các tiến trình khác mà có trên hệ thống linux này. Do tính chất cực kỳ quan trọng này mà init sẽ không bao giờ bị chết (khi sử dụng lệnh `kill`) và không được phép chết.  
- Sau đó, init sẽ xem trong file `/etc/inittab` để biết được nó cần làm gì tiếp theo như: dựa vào runlevel mặc định để thực thi các script khởi động (initscript) tương ứng trong thư mục `/etc/rc.d`  

<a name = '7'></a>
# 7. Các initscript được thực thi dựa trên runlevel được chọn

- Nếu kiểm tra trong file `/etc/inittab`, bạn sẽ thấy nó bao gồm hầu hết các đặc tả, chỉ dẫn để cạy các chương trình nào đó. Các script có tên bắt đầu bằng kí tự S sẽ được thực thi, bằng cách này, init sẽ khởi động tất cả các hệ thống con (subsystem) hoặc các dịch vụ (daemon) để tạo thành một hệ thống linux hoạt động hoàn chỉnh. 

- Tại thời điểm này, về cơ bản Linux đã khởi động xong, init cũng hoàn thành vai trò của mình: tạm thời, nó sẽ "ngủ" (ở trạng thái chờ đợi) cho tới khi có chương trình nào đó chị chết hoặc cần được khởi động lại. Tất cả các hoạt động của hệ thống bây giờ sẽ được thực hiện bởi các daemon khác nhau. 

<a name = '8'></a>
# 8. Đăng nhập với giao diện đồ họa 
- Subsystem cuối cùng được init khởi động lên là XWindow, đây là một hệ thống cung cấp giao diện đồ họa cho người dùng (GUI) của Linux. 

<a name = '9'></a>
# 9. Khi người dùng đăng nhập thành công vào hệ thống
- Một chương trình `shell` (`bash`, `sh`, `csh`, ...) sẽ được bắt đầu. 

- Tất cả các chương trình mà bạn chạy và mọi thao tác khác mà bạn thực hiện trong suốt phiên làm việc sẽ được thực hiện bởi shell đó hoặc bởi chương trình khác mà được shell khởi động.  
- Khi bạn đăng xuất, shell đó và tất cả các tiến trình con của nó sẽ kết thúc. Sau đó, init sẽ "thức tỉnh" và bắt đầu một lời nhắc nhở đăng nhập mới. 

- Toàn bộ quá trình khởi động của hệ thống Linux được minh họa như hình sau: 

	![img](https://imgur.com/OZp8MhS.jpg)

<a name = 'ref'></a>
## Tham khảo: 

[1] https://manthang.wordpress.com/2011/01/04/tim-hieu-qua-trinh-khoi-dong-cua-may-linux/

[2] https://medium.com/@ntvthu/qua-trinh-boot-may-tinh-111d17685aad
