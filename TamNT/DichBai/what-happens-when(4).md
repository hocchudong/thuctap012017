# What-happens-when 

Ghi chép này trả lời cho câu hỏi: "Điều gì xảy ra khi bạn gõ google.com vào thanh địa chỉ của trình duyệt web và ấn enter? "

Ngoại trừ thay vì một câu chuyện bình thường, chúng tôi cố gắng thử trả lời câu hỏi này một cách chi tiết nhất có thể. Không bỏ quả bất cứ thứ gì. 

Bài viết được hình thành bằng cách hợp tác nhiều người, do đó hãy đào sâu và cố gắng giúp đỡ! Còn rất nhiều chi tiết bị thiếu, chỉ chờ bạn thêm chúng! Vì vậy làm ơn gửi pull request cho chúng tôi!

Tất cả đều được cấp phép theo điều khoản giấy phép [Creative Common Zero](https://creativecommons.org/publicdomain/zero/1.0/).

Đọc trong  [简体中文](https://github.com/skyline75489/what-happens-when-zh_CN) (tiếng Trung giản thể).

>> LƯU Ý: Điều này không được xem xét bởi alex/what-happens-when.

### ***Mục lục***

[The "g" key is pressed](#1)

[The "enter" key bottoms out](#2)

[Interrupt fires [NOT for USB keyboards](#3)

[(On Windows) A WM_KEYDOWN message is sent to the app](#4)

[(On OS X) A KeyDown NSEvent is sent to the app](#5)

[(On GNU/Linux) the Xorg server listens for keycodes](#6)

[Parse URL](#7)

[Is it a URL or a search term?](#8)

[Convert non-ASCII Unicode characters in hostname](#9)

[Check HSTS list](#10)

[DNS lookup](#11)

[ARP process](#12)

[Opening of a socket](#13)

[TLS handshake](#14)

[HTTP protocol](#15)

[HTTP Server Request Handle](#16)

[Behind the scenes of the Browser](#17)

[Browser](#18)

[HTML parsing](#19)

[CSS interpretation](#20)

[Page Rendering](#21)

[GPU Rendering](#22)

[Window Server](#23)

[Post-rendering and user-induced execution](#24)

[Link bài gốc](#25)

---

<a name = "1"></a>
## The "g" key is pressed

Phần sau giải thích tất cả về bàn phím vật lý và ngắt của hệ điều hành. Nhưng, tất cả những gì xảy ra sau đó không được giải thích. Khi bạn vừa ấn phím "g", trình duyệt nhận được sự kiện và hoàn toàn hoàn thành tự động toàn bộ bộ máy. Phục thuộc vào thuật toán trình duyệt của bạn và nếu bạn đang trong chế độ private/incognito (ẩn danh) hoặc không có nhiều sự gợi ý được đưa ra trong thanh bên dưới thanh URL bar. Hầu hết các thuật toán ưu tiên các kết quả dựa trên lịch sử tìm kiếm và bookmark. Bạn thử gõ "google.com" và không có vấn đề gì xảy ra, nhưng nhiều code sẽ chạy trước khi bạn tới đó và các gượi ý sẽ được tiết chế dần đi sau mỗi lần nhấn thêm một phím. Nó có thể đề xuất "google.com" trước cả khi bạn gõ nó. 

<a name = "2"></a>
## The "enter" key bottoms out

Để đến một điểm zẻo, hãy chọn phím Enter trên bàn phím và ấn ở cuối dải ô của nó. Tại điểm này, một chuyển mạch điện tử cụ thể tới phím enter được đóng (hoặc trực tiếp hoặc capacitively). Điều này cho phép một lượng nhỏ dòng điện chảy vào mạch logic của bàn phím, cái mà quét mọi trạng thái chuyển mạch của phím, xem xét các nhiễu điện của tín hiệu kết thúc chuyển mạch, và chuyển đỗi tín hiệu đó sang mã bàn phím nguyên, trong trường hợp 13. Bộ điều khiển bàn phím mã hóa keycode để truyền tới máy tính. Việc này bây giờ phổ biến trên các kết nối USB (Universal Serial Bus) hoặc kết nối Bluetooth, nhưng lịch sử đã thông qua kết nối PS/2 hoặc ADB.

*Trong trường bàn phím USB* 

- Mạch USB của bàn phím được tiếp điện bưởi nguồn cấp 5V thông qua pin 1 từ bộ điều khiển USB của máy tính. 

- Keycode sinh ra được lưu bởi bộ nhớ bàn phím bên trong trong một thanh ghi gọi là "endpoint".

- Bộ điều khiển USB dò "endpoint" đó mỗi 10ms (giá trị tối thiểu với bàn phím), nên nó lấy được keycode lưu trong đó. 

- Giá trị này tới USB SIE (Serial Interface Engine) được chuyển đổi trong một hoặc nhiều gói tin USB mà theo giao thức mức thấp USB.

- Những gói tin này được gửi bưởi các tín hiệu điện khác nhau qua các pin D+ và D- (giữa 2) tại giá trị tối đa của 1.5 Mb/s, như một thiết bị HID (Human Interface Device - Thiết bị giao diện người dùng) luôn thông báo là một "thiết bị tốc độ thấp" (tuân thủ USB 2.0)

- Tín hiệu này được giả mã ở bộ điều khiển USB của máy tính, và được diễn giải bởi dirver thiết bị bàn phím HID của máy tính. Giá trị của key sau đó được chuyển vào lớp abstraction phần cứng của hệ điều hành. 

*Trường hợp bàn phím ảo (như là gõ từ thiết bị màn hình)*:

- Khi người dùng chạm bàn tay vào màn hình cảm ứng, một lượng nhỏ dòng điện được truyền tới từ ngón tay. Điều này làm thông mạch qua các trường điện tĩnh của lớp dẫn điện và tạo ra một điện thế tại thời điểm đó trên màn hình. `screen controller` thực hiện ngắt báo cáo việc kết hợp các phím vừa nhấn. 

- Rồi hệ điều hành di động thông báo hiện tại tập trung ứng dụng của sự kiện nhấn trong một yếu tố của GUI (mà bây giờ là các nút ứng dụng của bản phím ảo)

- Bàn phím ảo bây giờ có thể gây ra ngắt cho việc gửi bản tin "key pressed" (phím đã nhấn) tới hệ điều hành.

- Việc ngắt thông báo cho ứng dụng hiện tại tập trung vào sự kiện "key pressed".

<a name = '3'></a>
## 3. Interrupt fires [NOT for USB keyboards]

Bàn phím gửi các tín hiệu trên interrupt request line (IRQ) của nó, thực hiện ánh xạ một `interrupt vector` (vector ngắt - số nguyên) bằng bộ điều khiển ngắt. CPU sử dụng Bảng mô tả ngắt `Interrupt Descriptor Table` (IDT) để ánh xạ các vector ngắt tới các hàm (`interrupt handler`) được cung cấp bởi kernel. Khi ngắt tới, CPU đánh chỉ só IDT với vector ngắt và chạy xử lý thích hợp. Do đó, kernel được nhập vào. 

<a name = '4'></a>
## (On Windows) A `WM_KEYDOWN` message is sent to the app (bản tin `WM_KEYDOWN` được gửi tới ứng dụng)

HID gửi thông qua key thông qua sự kiện nhấn phím xuống trình điểu khiển `KBDHID.sys`  để thực hiện chuyển đổi việc sử dụng HID thành scancode. Trong trường hợp này, scancode là `VK_RETURN` (0x0D). Giao diện trình điểu khiển `KBDHID.sys` với `KBDCLASS.sys` (trình điểu khiển lớp bàn phím). Trình điều khiển này chịu trách nhiệm xử lý tất cả keyboard và keypad đầu vào một cách bảo mật. Rồi nó gọi vào `Win32K.sys` (sau khi có khả năng truyền bản tin thông qua bộ lọc keyboard bên thứ 3 đã được cài đặt). Tất cả xảy ra ở trong kernel mode.

`Win32K.sys` mô tả cửa sổ nào là cửa sổ đang hoạt động thông qua API `GetForegroundWindow()`. API này cung cấp xử lý cửa sổ của thanh địa chỉ trình duyệt. Windows chính "bơm bản tin" (message pump) rồi gọi `SendMessage(hWnd, WM_KEYDOWN, VK_RETURN, lParam)`. `lPraram` là một bitmask để suy ra các thông tin về sự ấn phím: lặp lại bộ đếm (0 trong trường hợp này), và quét mã hiện tại (có thể phục thuộc OEM, nhưng thường không là `VK_RETURN`), cho dù các phím mở rộng (như Alt, Shift, Ctrl) cũng được nhấn (hoặc không), và một số trạng thái khác. 

API `SendMessage` của Window là một hàm đơn giản để thêm bản tin vào một hàng đợi cho cửa sổ cụ thể xử lý (`hWnd`). Sau đó, hàm chính xử lý bản tin (gọi là `WindowProc`) gán với `hWnd` được gọi vào để xử lý bản tin trong hàng đợi. 

Cửa sổ (`hWnd`) mà hoạt động thường điều chỉnh điểu khiển và `WindowProc` trong trường hợp này có một bộ xử lý bản tin cho các bản tin `WM_KEYDOWN`. Mã này nhìn như trong thông số thứ 3 mà được gửi tới `SendMessage` (`wParam`) và, vì nó là `VK_RETURN` biết người dùng đã ấn ENTER.

<a name="5"></a>
## (On OS X) A `KeyDown` NSEvent is sent to the app

Tín hiệu ngắt tạo ra sự kiện ngắt trong Kit I/O bàn phím. Trình điểu khiển sẽ dịch tín hiệu thành key code để đưa tới xử lý `WindowServer` của OS X. Kết quả, `WindownServer` gửi một sự kiện tới bất kì ứng dụng nào thích hợp (active hoặc listening) thông qua Mach port của chúng nơi được đặt vào trong hàng đợi sự kiện. Các sự kiện có thể được đọc tự hàng đợi này bởi các thread đặc quyền gọi là hàm `mach_ipc_dispatch`. Việc này hầu hết xả ra thông qua, và được xử lý bởi một vòng lặp sự kiện chính `NSApplication`, thông qua `NSEvent` của `NSEventType` `KeyDown`.

<a name ='6'></a>
## (On GNU/Linux) the Xorg server listens for keycodes

Khi `x server` đồ họa được sử dụng, `x` sẽ sử dụng trình điều khiển sự kiện chung `evdev` để yêu cầu keypress. Một ánh xạ lại của keycode tới scancode được thực hiện với các keymap và quy tắc cụ thể của `x server`. Khi scancode ánh xạ một phím nhấn được hoàn thành, `x server` gửi ký ự tới `window manager` (DWM, metacity, i3, ...), nên `window manager` gửi về kí tự tới cửa sổ tập trung. API đồ họa của cửa sổ nhận được kí tự in ra font kí tự tưng ứng. 

<a name ='7'></a>
## Parse URL 

- Trình duyệt bây giờ có các thông tin sau chứa trong Url (Uniform Resource Locator):

    >    - *`Protocol`* **"http"**
    >
    >        *Sử dụng 'Hyper Text Transfer Protocol'*

    >    - *`Resource`* **"/"**
    >
    >       *Truy xuất trang chính (index)*

<a name = '8'></a>
## Is it a URL or a search term?

Khi không có giao thức hoặc tên miền có hợp lệ, trình duyệt tiếp tục cung cấp văn bản được đưa ra ở thanh địa chỉ tới engine tìm kiếm mặc định của nó. Trong nhiều trường hợp, URL có một đoạn văn bản đặc biệt được nối vào để báo cho công cụ tìm kieemss rằng nó đến từ thanh URL của trình duyệt cụ thể nào đó.

<a name = '9'></a>
## Conver non-ASCII Unicode characters in hostname

- Trình duyệt kiểm tra hostname cho các kí tự không nằm trong `a-z` , `A-Z` , `0-9` , `-` , hoặc `.` .

- Bởi hostname là `google.com` không có các kí tự khác đó, nhưng nếu có trình duyệt sẽ ps dụng mã hóa [Punycode](https://en.wikipedia.org/wiki/Punycode) vào phần hostname của URL.

<a name = '10'></a>
## Check HSTS list

- Trình duyệt kiểm tra danh sách "HTST ((HTTP Strict Transport Security) đã load lại " của nó. Đây là danh sách các website yêu cầu request thông qua HTTPS.

- Nếu website có trong danh sách này, trình duyệt sẽ gửi request của nó thông qua HTTPS thay vì HTTP. Nếu không, request khởi tạo ban đầu được gửi thông qua HTTP. (Lư ý là một website có thể vẫn sử dụng chính sách HTST mà không cần trong danh sách HTST. Request HTTP đầu tiên tới website bởi ngươi dùng sẽ nhận được một phản hồi yêu cầu người dùng chỉ được gửi request HTTPS. Tuy nhiên, request HTTP này có thể có khả năng khiến người dùng dễ bị tấn công [downgrade](https://en.wikipedia.org/wiki/Moxie_Marlinspike#Notable_research), đó là ls do mà danh sách HSTS bao gồm trong các trình duyệt web ngày nay.)

<a name = '11'></a>
## DNSlookup

- Trình duyệt web kiểm tra xem domain có trong cache của nó không (để xem DNS cache của Chrome, gõ chrome://net-internals/#dns)

- Nếu không tìm thấy, trình duyệt gọi tới thư viện chức năng `gethostbyname` để thực hiện việc tìm kiếm này.

- `gethostbyname` kiểm tra hostname có thể được phân giải bằng cách tham chiếu tới file `hosts` cụ bộ ([vị trí file](https://en.wikipedia.org/wiki/Hosts_%28file%29#Location_in_the_file_system) tùy thuộc từng hệ điều hành)

- Nếu `gethostbyname` không tìm thấy trong cache hoặc không tìm thấy trong file `hosts` thì nó sẽ thực hiện request tới DNS server đã được cấu hình trong phần mạng của máy. Thường là router cục bộ hoặc DNS server caching của nhà cung cấp mạng.

- Nếu DNS server trong cùng subnet thì cho phép xử lý tiến trinh `ARP` để tìm DNS server. 

- Nếu DNS server trên một subnet khác, thư viện mạng sẽ thực hiện ARP tìm default gateway IP.

<a name = '12'></a>
## ARP process

Để gửi một bản tin broadcast ARP (Address Resolution Protocol) trong mạng để tìm kiếm địa chỉ IP cần tra cứu. Cần biết địa chỉ MAC của interface mà nó sẽ sử dụng để gửi bản tin quảng bá bản tin ARP. 

ARP cache được sử dụng đầu tiên để kiểm tra. Nếu IP cần tìm có trong cache, thư viện chức năng sẽ trả về kết quả: Target IP = MAC (Target IP là IP cần tra cứu).

Nếu không tìm thấy trong cache:

- Bảng định tuyến được sử dụng, để xem xem Target IP cần tìm có trong bất kì subnet nào của bảng định tuyến local hay không. Nếu có, nó sẽ sử dụng interface gán với subnet đó. Nếu không, thư viện sẽ sử dụng interface mà có default gateway.

- Địa chỉ MAC của interface được chọn để thực hiện tra cứu.

- Thực hiện gửi ARP request lớp 2 (lớp data link trong [mô hình OSI](https://en.wikipedia.org/wiki/OSI_model)):

`ARP request`

```
Sender MAC: interface:mac:address:here
Sender IP: interface.ip.goes.here
Target MAC: FF:FF:FF:FF:FF:FF (Broadcast)
Target IP: target.ip.goes.here
```

Phụ  thuộc vào phần cứng giữa các máy tính và router: 

Chuyển hướng trực tiếp:

- Nếu một máy tính được kết nối trực tieps tói router thì router sẽ trả lời lại với một `ARP reply` (xem bên dưới)

Hub:

- Nếu máy tính được kết nối tới một hub, hub sẽ quảng bá bản tin ARP request tới tất cả các port khác của nó. Nếu router được kết nối chung `'dây', nó sẽ trả lời lại với một `ARP repley` (xem bên dưới).

Switch: 

- Nếu máy tính được nối tới một switch, switch sẽ kiểm tra bảng CAM/MAC của nó để tìm xem port nào có địa chỉ MAC đang cần tìm kiếm không, nếu không nó sẽ lại quản bá bản tin ARP request tới tất cả các cổng còn lại.

- Nếu switch có tìm thấy trong bảng CAM/MAC của nó, nó sẽ gửi ARP request tới port mà có địa chỉ MAC đang cần tìm kiếm.

- Nếu router đang cùng "dây", nó sẽ phản hồi lại với bản tin `ARP reply` (xem dưới)

`ARP reply`

```
Sender MAC: target:mac:address:here
Sender IP: target.ip.goes.here
Target MAC: interface:mac:address:here
Target IP: interface.ip.goes.here
```

Bây giờ, đã có địa chỉ IP của DNS server hoặc của default gateway, có thể thực hiện tiến trình xử lý DNS:

- Port 53 được mở để gửi một UDP request tới DNS server (nếu có phản hồi với kích thước quá lớn, TCP sẽ được sử dụng thay thế).

- Nếu DNS server cục bộ hoặc của ISP không có, một tìm kiếm đệ quy sẽ được request và chuyển tới danh sách các DNS server cho đến khi SOA được tìm tháy, và nó sẽ tìm được câu trả lời gửi về.

<a name = '13'></a>
## Opening of a socket

Một khi trình duyệt nhận được địa chỉ IP của server đích, nó thực hiện lấy số cổng đã có từ URL (giao thức HTTP mặc định trên cổng 80, và HTTPs là cổng 443), và thực hiện gọi tới các chức năng thư viện tên là `socket` và yêu cầu một TCP socket stream - `AF_INET/AF` và `SOCK_STREAM`

- Request này đầu tiên được này đầu tiên được chuyển đến Transport Layer nơi một TCP segment được tạo ra. Cổng đích được thêm vào header, và cổng nguồn được chọn từ dải cổng động của kernel (ip_local_port_range trong Linux).

- Segment này được gửi tới Network Layer, bao gồm một tiêu đề IP bổ sung. Địa chỉ IP của máy chủ đích cũng như của máy hiện tại được chèn vào để tạo thành một gói tin.

- Gói kế tiếp ở lớp Data Link Layer. Một tiêu đề khung (header frame) được thêm vào bao gồm địa chỉ MAC của NIC máy cũng như địa chỉ MAC của gateway (local router). Nếu kernel không biết địa chỉ MAC của gateway, nó phải phát một truy vấn ARP request để tìm nó.

Tại thời điểm này, gói tin đã sẵn sàng được truyền đi thông qua:

- [Ethernet](http://en.wikipedia.org/wiki/IEEE_802.3)

- [WiFi](https://en.wikipedia.org/wiki/IEEE_802.11)

- [Cellular data network](https://en.wikipedia.org/wiki/Cellular_data_communication_protocol)

Đối với hầu hết các kết nối Internet gia đình hoặc doanh nghiệp nhỏ, gói tin sẽ truyền từ máy tính của bạn, có thể thông qua một mạng cục bộ, và sau đó tới một modem (MOdulator/DEModulator) chuyển đổi tín hiệu số từ bit 1 và 0 thành tín hiệu tương tự thích hợp để truyền qua điện thoại, cable, hoặc kết nối điện thoại không dây. Ở đầu kia của kết nối là một modem khác chuyển đổi tín hiệu analog sang dữ liệu số sẽ được xử lý bởi [network node](https://en.wikipedia.org/wiki/Computer_network#Network_nodes) tiếp theo nơi mà địa chỉ nguồn và địa chỉ đích sẽ được phân tích thêm.

Hầu hết các doanh nghiệp lớn hơn và một số kết nối dân cư mới hơn sẽ có kết nối cáp quang hoặc kết nối Ethernet trực tiếp, trong trường hợp dữ liệu vẫn là dạng dữ liệu số và được chuyển trực tiếp tới [nút mạng](https://en.wikipedia.org/wiki/Computer_network#Network_nodes) tiếp theo để xử lý.

Cuối cùng, gói tin sẽ truy cập router quản lý mạng con cục bộ. Từ đó, nó sẽ tiếp tục đi đến các router khác của hệ thống tự trị (AS - autonomous system), các AS khác, và cuối cùng đến máy chủ đích. Mỗi router trên đường đi sẽ lấy địa chỉ đích từ tiêu đề IP và định tuyến nó tới hops tới thích hợp. Trường Time to live (TTL) trong tiêu đề IP header được giảm bởi một khi đi qua mỗi router. Gói tin này sẽ bị loại bỏ nếu trường TTL bằng 0 hoặc nếu router hiện tại không có không gian trong hàng đợi của nó (có thể là do tắc nghẽn mạng).

Việc gửi và nhận này xảy ra nhiều lần theo luồng kết nối TCP:

- Client chọn một số thứ tự sequence number ban đầu (ISN - initial sequence number) và gửi gói tin tới máy chủ với bit SYN được đặt để cho biết nó đang thiết lập ISN

- ***Máy chủ nhận SYN và nếu nó trong một trạng thái thích hợp:***

	- Máy chủ lựa chọn số sequence number ban đầu của nó.

	- Máy chủ đặt SYN để cho biết nó đang chọn ISN của nó

	- Máy chủ sao chép (client ISN +1) vào trường ACK của nó và thêm cờ ACK để cho biết nó đang xác nhận nhận gói tin đầu tiên

- ***Client chấp nhận kết nối bằng cách gửi một gói tin:***

	- Tăng số thứ tự sequence number của nó.

	- Tăng số xác nhận (acknowledgment number) người nhận

	- Thiết lập trường ACK

- ***Dữ liệu được chuyển như sau:***

	- Khi một bên gửi N byte dữ liệu, nó sẽ tăng SEQ theo số đó

	- Khi phía bên kia đã nhận được gói tin đó (hoặc một chuỗi các gói tin), nó sẽ gửi một gói ACK với giá trị ACK bằng với chuỗi nhận được cuối cùng từ đầu kia

- ***Đóng kết nối:***

	- Gửi một gói FIN

	- Các bên khác ACKs gói FIN và gửi FIN của riêng mình

	- Chấp nhận đóng kết nối bằng cách gửi lại ACK cho các bên gửi FIN.


<a name="14"></a>
## TLS handshake

- Máy tính client gửi bản tin `ClientHello` tới máy chủ với phiên bản TLS (Transport Layer Security), liệt kê các thuật toán mật mã và phương pháp nén có sẵn.

- Máy chủ trả lời với bản tin `ServerHello` cho client với phiên bản TLS, phương pháp mật mã đã chọn, các phương pháp nén đã chọn và chứng chỉ công cộng của máy chủ ký bởi CA (Tổ chức phát hành chứng chỉ). Chứng chỉ chứa một khóa công khai sẽ được sử dụng bởi máy client để mã hóa phần còn lại của quá trình bắt tay cho đến khi một khoá đối xứng có thể được thỏa thuận.

- Client xác minh chứng chỉ số máy chủ đối với danh sách các CA đáng tin cậy. Nếu tin tưởng có thể được thiết lập dựa trên CA, client tạo ra một chuỗi các byte giả ngẫu nhiên và mã hóa điều này bằng khóa công khai của máy chủ. Các byte ngẫu nhiên này có thể được sử dụng để làm khóa đối xứng.

- Máy chủ giải mã các byte ngẫu nhiên sử dụng khóa riêng (private key) của nó và sử dụng các byte này để tạo bản sao khóa chính đối xứng.

- Client gửi một bản tin `Finished` đến máy chủ, mã hóa băm với khóa đối xứng.

- Máy chủ tạo ra hash của riêng nó, và sau đó giải mã các hash client gửi để xác minh rằng nó phù hợp. Nếu có, nó sẽ gửi thông điệp đã `Finished` của nó cho client, cả hai phía đều được mã hóa bằng khóa đối xứng.

- Cuối cùng, phiên TLS truyền dữ liệu ứng dụng (HTTP) được mã hóa bằng khóa đối xứng đã được đồng ý trước đó.

<a name="15"></a>
## HTTP protocol

- Nếu trình duyệt web sử dụng được viết bởi Google, thay vì gửi yêu cầu HTTP để truy xuất trang, nó sẽ gửi yêu cầu thử và thương lượng với máy chủ "nâng cấp" từ HTTP tới giao thức SPDY.


Nếu client đang sử dụng giao thức HTTP và không hỗ trợ SPDY, nó sẽ gửi yêu cầu tới máy chủ với form:

```
GET / HTTP/1.1
Host: google.com
Connection: close
[other headers]
```

Trong đó `[other headers]` đề cập đến một loạt các cặp khóa được định dạng theo đặc tả HTTP và được phân tách bằng các dòng mới. (Điều này giả định trình duyệt web đang được sử dụng không có bất kỳ vi phạm lỗi HTTP spec. Điều này cũng giả định rằng các trình duyệt web đang sử dụng HTTP/1.1, nếu không nó có thể không bao gồm các tiêu đề Host trong yêu cầu và phiên bản quy định tại GET yêu cầu sẽ là HTTP/1.0 hoặc HTTP/0.9.)

HTTP/ 1.1 xác định tùy chọn kết nối "đóng" để người gửi báo hiệu rằng kết nối sẽ bị đóng sau khi hoàn thành phản hồi. Ví dụ:

> Connection: close


Các ứng dụng HTTP/1.1 không hỗ trợ kết nối liên tục. Phải bao gồm tùy chọn kết nối "đóng" trong mỗi bản tin.

Sau khi gửi yêu cầu và tiêu đề, trình duyệt web gửi một dòng mới trống đến máy chủ cho biết rằng nội dung của yêu cầu được thực hiện.

Máy chủ trả lời bằng một mã phản hồi biểu thị trạng thái của yêu cầu và trả lời bằng câu trả lời của khuôn mẫu:

```
200 OK
[response headers]
```

Tiếp theo là một dòng mới, và sau đó gửi payload với nội dung HTML của `www.google.com` . Máy chủ sau đó có thể đóng kết nối, hoặc nếu tiêu đề được gửi bởi client yêu cầu nó, giữ cho kết nối mở để được sử dụng lại cho các yêu cầu tiếp theo.

Nếu các tiêu đề HTTP được gửi bởi trình duyệt web bao gồm đầy đủ thông tin cho máy chủ web để xác định xem phiên bản của file cache trong trình duyệt web đã được sửa đổi chưa kể từ lần truy hồi cuối cùng (ví dụ: nếu trình duyệt web bao gồm một tiêu đề `ETag` ) thay vào đó có thể đáp ứng với một yêu cầu của form: 

```
304 Not Modified
[response headers]
```

và không có payload, trình duyệt web sẽ lấy HTML từ bộ nhớ cache của nó.

Sau khi phân tích HTML, trình duyệt web (và máy chủ) lặp lại quá trình này cho mọi tài nguyên (hình ảnh, CSS, favicon.ico, vv) được tham chiếu bởi trang HTML, ngoại trừ `GET/HTTP/1.1`, request sẽ là `GET /$(URL relative to www.google.com) HTTP/1.1`.

Nếu HTML tham chiếu một tài nguyên trên một miền khác so với `www.google.com` , trình duyệt web sẽ quay trở lại các bước liên quan đến giải quyết miền khác và làm theo tất cả các bước như trên cho tên miền đó. Tiêu đề `Host` trong yêu cầu sẽ được đặt thành tên máy chủ thích hợp thay vì `google.com`. 

<a name="16"></a>
## HTTP server Request Handle

Máy chủ HTTPD (HTTP Daemon) là một máy chủ xử lý yêu cầu/ phản hồi ở phía máy chủ. Các máy chủ HTTPD phổ biến nhất là Apache hoặc nginx dành cho Linux và IIS cho Windows.

- HTTPD (HTTP Daemon) nhận được request.

- Máy chủ chia nhỏ yêu cầu theo các tham số sau:

	- Phương thức Yêu cầu HTTP ( `GET` , `HEAD` , `POST` , `PUT` , `DELETE` , `CONNECT` , `OPTIONS` , hoặc `TRACE` ). Trong trường hợp một URL được nhập trực tiếp vào thanh địa chỉ, nó sẽ là GET .
            
	- Tên miền, trong trường hợp này - google.com.

	- Đường dẫn /page, trong trường hợp này là / (vì không có đường dẫn /page cụ thể nào được yêu cầu, / là đường dẫn mặc định). 

- Máy chủ xác minh rằng có một Máy chủ Ảo được cấu hình trên máy chủ tương ứng với google.com.

- Máy chủ xác minh rằng google.com có ​​thể chấp nhận yêu cầu GET.

- Máy chủ xác minh rằng client được phép sử dụng phương pháp này (bằng IP, xác thực, v.v.).

- Nếu máy chủ đã cài đặt một mô-đun ghi đè (như mod_rewrite cho Apache hoặc URL Rewrite for IIS), nó sẽ cố gắng khớp yêu cầu với một trong các quy tắc được định cấu hình. Nếu tìm thấy một quy tắc phù hợp, máy chủ sẽ sử dụng quy tắc đó để viết lại yêu cầu.

- Các máy chủ sẽ thực hiện lấy nội dung tương ứng với yêu cầu, trong trường hợp của chúng tôi nó sẽ quay trở lại tập tin chỉ mục, vì "/" là tập tin chính (một số trường hợp có thể ghi đè lên điều này, nhưng đây là phương pháp phổ biến nhất).

- Máy chủ phân tích tệp theo trình xử lý. Nếu Google đang chạy trên PHP, máy chủ sử dụng PHP để giải thích tệp chỉ mục và phản hồi lại dữ liệu cho khách hàng. 

<a name="17"></a>
## Behind the scenes of the Browser

Khi máy chủ cung cấp các tài nguyên (HTML, CSS, JS, hình ảnh, v.v.) vào trình duyệt, nó sẽ trải qua quá trình dưới đây:

- Phân tích cú pháp HTML, CSS, JS

- Rendering - Xây dựng DOM Tree → Render Tree → Sắp đặt Render tree → Hiển thị Render tree

<a name="18"></a>
## Browser

Chức năng của trình duyệt là hiển thị tài nguyên web bạn chọn, bằng cách yêu cầu nó từ máy chủ và hiển thị nó trong cửa sổ trình duyệt. Tài nguyên thường là một tài liệu HTML, nhưng cũng có thể là dạng PDF, hình ảnh hoặc một số loại nội dung khác. Vị trí của tài nguyên được xác định bởi người dùng bằng cách sử dụng một URI (Uniform Resource Identifier).

Cách trình duyệt phân tích và hiển thị các tệp HTML được chỉ định trong các thông số HTML và CSS. Các đặc tả này được duy trì bởi tổ chức W3C (World Wide Web Consortium), là tổ chức tiêu chuẩn cho web.

Giao diện người dùng của trình duyệt có nhiều điểm tương đồng với nhau. Các yếu tố giao diện người dùng phổ biến là:


- Thanh địa chỉ để chèn một URI

- Nút quay lại và chuyển tiếp

- Tùy chọn bookmark

- Các nút Làm mới và Dừng để làm mới hoặc dừng tải tài liệu hiện tại

- Nút Trang chủ dẫn bạn tới trang chủ của bạn 

**Trình duyệt Cấu trúc cấp cao**

Các thành phần của các trình duyệt là:

- **Giao diện người dùng**: Giao diện người dùng bao gồm thanh địa chỉ, nút back/forward, bookmarking menu, ...

- **Công cụ trình duyệt**: Công cụ trình duyệt sắp xếp hành động giữa giao diện người dùng và công cụ rendering.

- **Rendering engine**: có trách nhiệm hiển thị nội dung yêu cầu. Ví dụ: nếu nội dung được yêu cầu là HTML, redenring engine phân tích HTML và CSS và hiển thị nội dung được phân tích trên màn hình.
- **Mạng**: Mạng xử lý các giao tiếp mạng như yêu cầu HTTP, sử dụng các triển khai khác nhau cho các nền tảng khác nhau đằng sau giao diện độc lập với nền tảng.

- **UI backend**: UI backend được sử dụng để hiển thị các widgets  cơ bản như combo boxes và windows. Phần phụ trợ này cho thấy một giao diện chung chung không phải là nền tảng cụ thể. Nó sử dụng phương pháp giao diện người dùng hệ điều hành.

- **JavaScript Engine**: Công cụ JavaScript được sử dụng để phân tích cú pháp và thực thi code  JavaScript.

- **Lưu trữ dữ liệu**: Việc lưu trữ dữ liệu là một lớp kiên cố. Trình duyệt có thể cần lưu tất cả các loại dữ liệu cục bộ, chẳng hạn như cookie. Các trình duyệt cũng hỗ trợ các cơ chế lưu trữ như localStorage, IndexedDB, WebSQL và FileSystem. 

<a name="19"></a>
## HTML Parsing 

Rendering engine bắt đầu lấy nội dung của tài liệu được yêu cầu từ lớp mạng. Điều này thường sẽ được thực hiện trong khối 8kB.

Công việc chính của trình phân tích cú pháp HTML là để phân tích HTML markup vào một cây phân tích cú pháp.

Cây ra ("cây phân tích") là một cây của các phần tử DOM và thuộc tính. DOM là viết tắt của Document Object Model. Đây là sự trình bày đối tượng của tài liệu HTML và giao diện của các phần tử HTML với JavaScript. Gốc của cây là đối tượng "Tài liệu". Trước bất kỳ thao tác nào qua scripting, DOM có mối quan hệ gần như một-một đối với markup.

**Thuật toán phân tích cú pháp**

Không thể phân tích cú pháp HTML bằng cách sử dụng trình phân tích cú pháp từ trên xuống dưới hoặc từ dưới lên.

Lý do là:

- Bản chất tự nhiên của ngôn ngữ.

- Sự thật là các trình duyệt có khả năng chịu lỗi để hỗ trợ các trường hợp HTML không hợp lệ.

- Quá trình phân tích cú pháp là tập trung lại. Đối với các ngôn ngữ khác, tài nguyên không thay đổi trong quá trình phân tích cú pháp, nhưng trong HTML, mã động (dynamic code) (như các phần tử script có chứa các lời gọi document.write ()) có thể thêm các thẻ phụ, do đó quá trình phân tích cú pháp thực sự sửa đổi đầu vào. 

Không thể sử dụng các kỹ thuật phân tích cú pháp thường xuyên, trình duyệt sử dụng một trình phân tích cú pháp tùy chỉnh để phân tích cú pháp HTML. Thuật toán phân tích cú pháp được mô tả chi tiết theo đặc tả của HTML5.

Thuật toán bao gồm hai giai đoạn: tokenization và xây dựng cây.

**Tác vụ khi phân tích cú pháp kết thúc**

Trình duyệt bắt đầu tìm nạp tài nguyên bên ngoài liên kết với trang (CSS, hình ảnh, tệp JavaScript, v.v ...).

Ở giai đoạn này, trình duyệt đánh dấu tài liệu là tương tác và bắt đầu phân tích cú pháp các kịch bản đang ở chế độ "deferred": những gì cần được thực hiện sau khi tài liệu được phân tích cú pháp. Trạng thái tài liệu được đặt thành "complete" và sự kiện "load" được kích hoạt.

Lưu ý không bao giờ có lỗi "Invalid Syntax" trên một trang HTML. Trình duyệt sẽ khắc phục bất kỳ nội dung không hợp lệ nào và tiếp tục.

<a name="20"></a>
## CSS Interpretation

- Phân tích các tệp CSS, nội dung thẻ `<style>` và các thuộc tính `style` bằng cách sử dụng ["CSS lexical and syntax grammar"](http://www.w3.org/TR/CSS2/grammar.html)

- Mỗi tệp CSS được phân tách thành một `StyleSheet object`, trong đó mỗi đối tượng chứa các quy tắc CSS với bộ chọn và các đối tượng tương ứng với ngữ pháp CSS.

- Một trình phân tích cú pháp CSS có thể là từ trên xuống dưới hoặc từ dưới lên khi sử dụng một trình tạo phân tích cú pháp cụ thể. 

<a name="21"></a>
## Page Rendering

- Tạo 'Frame Tree' hoặc 'Render Tree' bằng cách đi qua các nút DOM, và tính các giá trị kiểu CSS cho mỗi nút.

- Tính chiều rộng ưa thích của mỗi nút trong 'Frame Tree' từ dưới lên bằng cách tổng hợp chiều rộng ưa thích của các nút con và các lề nằm ngang, border và padding của nút.

- Tính toán chiều rộng thực tế của mỗi nút từ trên xuống bằng cách cấp phát chiều rộng cho mỗi nút của con.

- Tính toán chiều cao của mỗi nút từ dưới lên bằng cách áp dụng gói văn bản và tổng hợp các chiều cao nút con và các lề, biên và lề của nút.

- Tính tọa độ của mỗi nút bằng cách sử dụng thông tin được tính toán ở trên.

- Các bước phức tạp hơn được thực hiện khi các phần tử được floated , được định vị absolutely hoặc relatively , hoặc các tính năng phức tạp khác được sử dụng. Xem http://dev.w3.org/csswg/css2/ và http://www.w3.org/Style/CSS/current-work để biết thêm chi tiết.

- Tạo lớp để mô tả phần nào của trang có thể được hiển thị như một nhóm mà không bị làm lại. Mỗi đối tượng frame/ render được gán cho một layer.

- Textures  được cấp phát cho mỗi lớp của trang.

- Các đối tượng frame/render cho mỗi lớp được biến đổi ngược và các lệnh được thực hiện cho lớp tương ứng của chúng. Điều này có thể được rasterized bởi CPU hoặc vẽ trên GPU trực tiếp bằng cách sử dụng D2D/ SkiaGL.

- Tất cả các bước trên có thể sử dụng lại các giá trị được tính từ lần cuối cùng trang web được hiển thị, do đó các thay đổi gia tăng đòi hỏi ít công việc hơn.

- Các lớp trang được gửi đến quá trình kết hợp chúng được kết hợp với các lớp cho các nội dung có thể nhìn thấy khác như trình duyệt Chrome, iframe  và bảng addon.

- Các vị trí lớp cuối cùng được tính toán và các lệnh ghép được phát hành qua Direct3D/ OpenGL. Bộ đệm lệnh GPU được đổ vào GPU để hiển thị không đồng bộ và khung được gửi tới máy chủ cửa sổ. 

<a name="22"></a>
## GPU Rendering

- Trong quá trình dựng hình, các lớp tính toán đồ hoạ có thể sử dụng CPU hoặc GPU xử lý đồ họa.

- Khi sử dụng GPU để tính toán kết xuất đồ hoạ, các lớp phần mềm đồ họa chia công việc thành nhiều phần, vì vậy nó có thể tận dụng ưu thế song song lớn của GPU để tính toán điểm nổi yêu cầu cho quá trình dựng hình.

<a name="23"></a>
## Windows-Server

<a name="24"></a>
## Post-rendering and user-induced execution
Sau khi rendering hoàn thành, trình duyệt sẽ thực hiện mã JavaScript do kết quả của một số cơ chế thời gian (chẳng hạn như hình ảnh động của Google Doodle) hoặc sự tương tác của người dùng (nhập một truy vấn vào hộp tìm kiếm và nhận các đề xuất). Các plugin như Flash hay Java cũng có thể được thực hiện, mặc dù không phải vào thời điểm này trên trang chủ của Google. Các tập lệnh có thể làm cho các yêu cầu mạng bổ sung được thực hiện, cũng như sửa đổi trang hoặc bố cục của nó, gây ra việc rendering và vẽ trang khác.

<a name ='25'></a>
***Link bài gốc***: https://github.com/alex/what-happens-when