# What happens when

Kho này là nỗ lực để trả lời câu hỏi đã cũ "Điều gì sẽ xảy ra khi bạn nhập google.com vào hộp địa chỉ của trình duyệt và nhấn enter?"  
Thay vì câu chuyện bình thường, chúng tôi sẽ cố gắng trả lời câu hội này càng chi tiết càng tốt. Không bỏ qua bất cứ điều gì.  
Đây là một quá trình cộng tác, vì vậy hãy tìm hiểu chi tiết và cố gắng giúp đỡ! Có hàng tấn chi tiết bị thiếu, chỉ cần chờ bạn thêm chúng! Xin vui lòng kéo xuống!  
Tất cả đã được cập phép theo điều khoản của giấy phép [Creative Commons Zero](https://creativecommons.org/publicdomain/zero/1.0/).  
Đọc nội dùng trong [简体中文](https://github.com/skyline75489/what-happens-when-zh_CN) (tiếng Trung giản thể) . Chú ý: Điều này chưa được xem xét bởi alex.  

# MỤC LỤC

## Phím "g" được nhấn
Các phần sau giải thích tất cả về bàn phím vật lý và ngắt trong hệ điều hành. Tuy nhiên, một số lượng lớn xảy ra sau đó mà không được giải thích. Khi bạn chỉ cần bấm 'g' trình duyệt nhận được sự kiện và toàn bộ máy tự động hoàn thành đá vào bánh răng cao. Tùy thuộc vào thuật toán của trình duyệt của bạn và nếu bạn đang ở chế độ riêng tư / ẩn danh hoặc không có các đề xuất khác nhau sẽ được trình bày cho bạn trong hộp chứa dưới thanh URL. Hầu hết các thuật toán này ưu tiên các kết quả dựa trên lịch sử tìm kiếm và bookmarks. Bạn sẽ nhập 'google.com' vì vậy không có vấn đề gì xảy ra, nhưng rất nhiều mã sẽ chạy trước khi bạn gõ xong và các đề xuất sẽ được tinh chế với mỗi lần nhấn phím. Nó thậm chí có thể đề xuất 'google.com' trước khi bạn gõ.  

## Các phim "enter" bên dưới
Để chọn một điểm zero, hãy chọn phím Enter trên bàn phím nhấn phía dưới phạm vi của nó. Tại thời điểm này, một mạch điện cụ thể cho khóa enter được đóng lại (trực tiếp hoặc điện dung). Điều này cho phép một lượng nhỏ dòng điện chảy vào mạch logic của bàn phím, quét trạng thái của mỗi khoá chuyển đổi, giảm tiếng ồn điện của sự đóng cửa liên tục của switch và chuyển nó thành keycode số nguyên, trong trường hợp này 13. Bộ điều khiển bàn phím sau đó mã hóa keycode để chuyển đến máy tính. Điều này hầu như phổ biến trên kết nối Universal Serial Bus (USB) hoặc kết nối Bluetooth, nhưng ịch sử đã kết nối qua PS/2 hoặc ADB.  

Trong trường hợp bàn phím USB:  
- Các mạch USB của bàn phím được cung cấp bởi nguồn cung cấp 5V cung cấp qua pin 1 từ bộ điều khiển máy chủ lưu trữ USB của máy tính.  
- Keycode được tạo ra được lưu trữ bởi bộ nhớ mạch điên bàn phím trong một thanh ghi được gọi là 'endpoint'.  
- Các bộ điều khiển USB máy chủ lưu trữ rằng 'điểm cuối' mỗi ~ 10ms (giá trị tối thiểu kê khai bởi bàn phím), do đó, nó được mã số giá trị được lưu trữ trên đó.  
- Giá trị này chuyển sang USB SIE (Serial Interface Engine) được chuyển đổi trong một hoặc nhiều gói dữ liệu USB đi theo giao thức USB cấp thấp.  
- Các gói tin đó được gửi bởi một tín hiệu điện phân trên D và D-pins (giữa 2) ở tốc độ tối đa 1.5 Mb / s, như một thiết bị HID (Human Interface Device) luôn được tuyên bố là một 'thiết bị tốc độ thấp '(Tuân thủ USB 2.0).  
- Tín hiệu nối tiếp này được giải mã tại bộ điều khiển USB máy chủ của máy tính và được giải thích bởi trình điều khiển thiết bị bàn phím kết nối thiết bị con người (HID) của máy tính. Giá trị của khóa sau đó được chuyển vào lớp trừu tượng phần cứng của hệ điều hành.  

Trong trường hợp Bàn phím Ảo (như trong các thiết bị màn hình cảm ứng):  
- Khi người dùng đặt ngón tay lên màn hình cảm ứng điện dung hiện đại, một lượng nhỏ dòng điện được chuyển sang ngón tay. Điều này hoàn thành mạch thông qua các trường tĩnh điện của lớp dẫn điện và tạo ra một điện áp thấp tại thời điểm đó trên màn hình. Bộ điều khiển màn hình sau đó gây ra ngắt báo cáo tọa độ của phím được nhấn.
- Sau đó, hệ điều hành di động thông báo cho ứng dụng hiện tại tập trung của một sự kiện nhấn trong một trong các yếu tố GUI của nó (mà bây giờ là các nút ứng dụng bàn phím ảo).
- Các bàn phím ảo bây giờ có thể chấm dứt phần mềm gián đoạn để gửi một tin nhắn 'nhấn phím' trở lại hệ điều hành.
- Ngắt này thông báo cho ứng dụng tập trung hiện tại của sự kiện 'nhấn phím'.  

## Interrupt fires [không dành cho bàn phím USB]
Bàn phím gửi tín hiệu trên đường dây yêu cầu gián đoạn (IRQ), nó được ánh xạ tới `interrupt vector` (số nguyên) bởi bộ điều khiển interrupt. CPU sử dụng `Interrupt Descriptor Table` (IDT) để ánh xạ interrupt vector đến hàm (`interrupt handlers`) do kernel cung cấp. Khi interrupt xuất hiện, CPU chỉ số IDT với interrupt vector và chạy chương trình xử lý thích hợp. Do đó, kernel được nhập vào.  

## (Trên Windows) Thông báo `WM_KEYDOWN` được gửi đến ứng dụng
Việc HID truyền sự kiện then chốt xuống trình điều khiển `KBDHID.sys` chuyển đổi việc sử dụng HID thành scancode. Trong trường hợp này, mã quét là `VK_RETURN (0x0D)`. Giao diện trình điều khiển `KBDHID.sys` giao tiếp với `KBDCLASS.sys` (trình điều khiển lớp bàn phím). Trình điều khiển này có trách nhiệm xử lý tất cả các bàn phím và đầu vào bàn phím một cách an toàn. Sau đó nó sẽ gọi đến `Win32K.sys` (sau khi có thể truyền thông điệp qua các bộ lọc bàn phím của bên thứ 3 đã được cài đặt). Tất cả điều này xảy ra trong chế độ kernel.  





## (On GNU/Linux) the Xorg server listens for keycodes

Khi một giao diện `X server` được sử dụng, `x` sẽ sử dụng các trình điều khiển sự kiện chung `evdev` để yêu cầu nhấn phím. Một re-mapping lại keycode của scancode được thực hiện với các keymap và các quy tắc cụ thể. Khi việc ánh xạ scancode của việc nhấn phim được hoàn thành, `X server` gửi kí tự tới `window manager` (DWM, metacity, i3, ...), do 











