# Chuyện gì xảy ra

____

# Mục lục

Nội dung của bài viết nhắm trả lời câu hỏi "Điều gì xảy ra khi bạn nhập google.com vào thanh địa chỉ của trình duyệt và nhấn enter?"

Ngoại trừ các câu hỏi bình thường, chúng tôi sẽ cố gắng trả lời các câu hỏi này càng chi tiết càng tốt. Không bỏ qua bất cứ điều gì.

Bài viết được hình thành qua một quá trình hợp tác, vì vậy hãy tìm hiểu kỹ và cố gắng giúp đỡ! Có rất nhiều chi tiết bị thiếu, chỉ cần chờ bạn thêm chúng! Vì vậy, gửi cho chúng tôi một yêu cầu pull!

Tất cả được cấp phép theo các điều khoản của giấy phép [Creative Commons Zero](https://creativecommons.org/publicdomain/zero/1.0/).


- [Phím "g" được nhấn?](#1)
- [Những gì thực hiện khi nhấn Enter?](#2)
- [Ngắt intertupts (Không phù hợp với các remote keyboard)](#3)
- [(Trong Windows) một thông báo KeyDown được gửi tới ứng dụng?](#4)
- [(Trong OS X) Một KeyDown NSEvent đucợ gửi tới ứng dụng?](#5)
- [(Trong GNU/ Linux) máy chủ Xorg theo dõi keycodes?](#6)
- [Xử lý URL](#7)
- [Đó có phải là một URL?](#8)
- [Chuyển đổi ký tự UNICODE không phải ASCII trông máy chủ](#9)
- [Kiểm tra danh sách HSTS](#10)
- [Tra cứu DNS](#11)
- [Xử lý ARP](#12)
- [Tạo một socket](#13)
- [Quá trình bắt tay TLS](#14)
- [Giao thức HTTP](#15)
- [Xử lý request HTTP](#16)
- [Browser hoạt động như thế nào?](#17)
- [Browser](#18)
- [Biên dịch HTML](#19)
- [Biên dịch CSS](#20)
- [Page Rendering](#21)
- [GPU Rendering](#22)
- [Windows-Server](#23)
- [Thực thi post-rendering và user-included](#24)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="1">Phím "g" được nhấn?</a>

    - Các phần sau giải thích tất cả về bàn phím vật lý và ngắt trong hệ điều hành. Tuy nhiên, một số lượng lớn xảy ra sau đó mà không được giải thích. Khi bạn chỉ cần bấm "g" trình duyệt nhận được sự kiện và toàn bộ các auto-complete. Tùy thuộc vào thuật toán của trình duyệt của bạn và nếu bạn đang ở chế độ riêng tư (ẩn danh) hoặc không có các đề xuất khác nhau sẽ được hiển thị cho bạn ở phía dưới thanh URL. Hầu hết các thuật toán này ưu tiên các kết quả dựa trên lịch sử tìm kiếm và bookmark. Bạn sẽ nhập "google.com" vì vậy không có vấn đề gì xảy ra, nhưng rất nhiều code sẽ chạy trước khi bạn tới được google và các đề xuất sẽ được lựa chọn với mỗi lần nhấn phím. Nó thậm chí có thể đề xuất "google.com" trước khi bạn gõ.

- ### <a name="2">Những gì thực hiện khi nhấn Enter?</a>

    - Để chọn một vị trí trống, hãy chọn phím Enter trên bàn phím nhấn phía dưới phạm vi của nó. Tại thời điểm này, một mạch điện cụ thể cho phím được đóng lại (trực tiếp hoặc capacitively). Điều này cho phép một lượng nhỏ dòng điện chảy vào mạch logic của bàn phím, quét trạng thái của mỗi key chuyển đổi, và chuyển nó thành số nguyên mã phím, trong trường hợp này 13. Bộ điều khiển bàn phím sau đó mã hóa mã phím để chuyển đến máy tính. Điều này hiện nay hầu như phổ biến trên kết nối USB hoặc Bluetooth, nhưng về lịch sử đã qua kết nối PS / 2 hoặc ADB.

- *Trong trường hợp sử dụng bàn phím USB:*

    - Các mạch USB của bàn phím được cung cấp bởi nguồn cung cấp 5V cung cấp qua pin 1 từ bộ điều khiển máy chủ lưu trữ USB của máy tính.
    - Mã phím sinh ra được lưu trữ bởi bộ nhớ mạch trong bàn phím trong một thanh ghi được gọi là "điểm cuối" (endpoint).
    - Bộ điều khiển USB lưu trữ sẽ liên tục kiểm tra "điểm cuối" mỗi 10ms (giá trị nhỏ nhất được khai báo bởi bàn phím), do đó, nó sẽ nhận được giá trị mã phím được lưu trữ trên đó.
    - Giá trị này chuyển tới USB SIE (Serial Interface Engine) được chuyển đổi thành một hoặc nhiều gói dữ liệu USB theo giao thức USB cấp thấp.
    - Các gói dữ liệu này được gửi bởi một tín hiệu điện phân trên D+ và D- ở tốc độ tối đa 1.5 Mb / s, vì thiết bị HID (Human Interface Device) luôn được tuyên bố là "thiết bị tốc độ thấp" (Tuân thủ USB 2.0).
    - Tín hiệu nối tiếp này được giải mã tại bộ điều khiển USB máy chủ của máy tính, và được giải thích bởi trình điều khiển thiết bị bàn phím kết nối thiết bị con HID (Human Interface Device) của máy tính. Giá trị của phím sau đó được chuyển vào lớp trừu tượng phần cứng của hệ điều hành. 

- *Trong trường hợp sử dụng Bàn phím ảo (thường có trong các thiết bị màn hình cảm ứng):*

    - Khi người dùng đặt ngón tay lên màn hình cảm ứng điện dung hiện đại, một lượng nhỏ dòng điện được chuyển sang ngón tay. Điều này tạo thành một mạch hoàn chỉnh thông qua các trường tĩnh điện của lớp dẫn điện và tạo ra một điện áp giảm dần tại thời điểm đó trên màn hình. Bộ screen controller sau đó gây ra một gián đoạn báo cáo các phối hợp của báo chí chính.
    - Sau đó, hệ điều hành di động thông báo cho ứng dụng hiện tại đang chú ý đến của sự kiện "press" lên một phần tử của GUI (là các phím trong bàn phím ảo).

    - Bàn phím ảo bây giờ có thể gọi tới một phần mềm ngắt(interrupt) để gửi tin nhắn 'key pressed' trở lại hệ điều hành.
    Ngắt này thông báo cho ứng dụng về sự kiện 'press'.

- ### <a name="3">Ngắt intertupts (Không phù hợp với các remote keyboard)</a>

    - Bàn phím gửi các tín hiệu trên đường dây yêu cầu gián đoạn (IRQ - Interrupt Request Line), nó được ánh xạ tới một interrupt vector (số nguyên) bởi bộ điều khiển gián đoạn. CPU sử dụng bảng mô tả gián đoạn (Interrupt Descriptor Table - IDT) để lập bản đồ các vector gián đoạn tới các hàm ( interrupt handlers ) do kernel cung cấp. Khi một ngắt xuất hiện, CPU ánh xạ tới số IDT cùng với vector gián đoạn và chạy trình xử lý thích hợp. Do đó kernel được dưa vào.

- ### <a name="4">(Trong Windows) một thông báo KeyDown được gửi tới ứng dụng?</a>

    - HID truyền tải thông qua sự kiện nhấn phím (key down) xuống trình điều khiển `KBDHID.sys` để thực hiện chuyển đổi việc sử dụng HID thành scancode. Trong trường hợp này, mã quét là `VK_RETURN` ( 0x0D ). Giao diện trình điều khiển `KBDHID.sys` giao tiếp với trình điều khiển `KBDCLASS.sys`. Trình điều khiển này có trách nhiệm xử lý tất cả các bàn phím và đầu vào bàn phím một cách an toàn. Sau đó nó sẽ gọi đến `Win32K.sys` (sau khi có thể truyền thông điệp qua các bộ lọc bàn phím của bên thứ 3 đã được cài đặt). Tất cả điều này xảy ra trong chế độ nhân (kernel mode).

    - `Win32K.sys` xác định cửa sổ nào là cửa sổ đang hoạt động thông qua API `GetForegroundWindow()` . API này cung cấp trình điều khiển cửa sổ của thanh địa chỉ của trình duyệt. Windows chính "bơm thông báo" sau đó gọi `SendMessage(hWnd, WM_KEYDOWN, VK_RETURN, lParam)`. *lParam* là một bitmask cho biết thêm thông tin về keypress: count lặp lại (0 trong trường hợp này), mã quét thực tế (có thể phụ thuộc OEM, nhưng nói chung không phải là VK_RETURN ), cho dù các phím mở rộng (alt, shift, ctrl) cũng được nhấn (hoặc không), ...

    - Windows SendMessage API là một chức năng đơn giản dùng để thêm thông điệp vào một hàng đợi cho các cửa sổ cụ thể xử lý ( hWnd ). Sau đó, chức năng xử lý tin nhắn chính (gọi là WindowProc ) được gán cho hWnd với mục đích để xử lý từng thư trong hàng đợi.

    - Cửa sổ ( hWnd ) đang hoạt động thực tế là một chỉnh sửa về control và WindowProc trong trường hợp này có xử lý tin nhắn cho các tin nhắn WM_KEYDOWN . Mã này nhìn thấy được ở bên trong tham số thứ ba mà được truyền đến SendMessage ( wParam ) và bởi vì nó là VK_RETURN biết người dùng đã nhấn phím ENTER. 

- ### <a name="5">(Trong OS X) Một KeyDown NSEvent đucợ gửi tới ứng dụng?</a>

    - Tín hiệu ngắt gây ra sự gián đoạn trong trình điều khiển bàn phím I/ O Kit Kext. Trình điều khiển chuyển tín hiệu thành một mã khoá và chuyển nó tới quá trình `WindowServer` của OS X. Kết quả là `WindowServer` gửi một sự kiện đến bất kỳ ứng dụng thích hợp nào (ví dụ như active hoặc listening) thông qua cổng Mach, nơi nó được đặt vào một hàng đợi sự kiện. Các sự kiện sau đó có thể được đọc từ hàng đợi này bởi các thread (luồng đọc) có đủ đặc quyền gọi hàm `mach_ipc_dispatch`. Điều này thường xảy ra thông qua, và được xử lý bởi, một vòng lặp sự kiện `NSApplication`, thông qua một `NSEvent` của `NSEventType KeyDown` .

- ### <a name="6">(Trong GNU/ Linux) máy chủ Xorg theo dõi keycodes?</a>

    -Khi một `X server` đồ họa được sử dụng, X sẽ sử dụng trình điều khiển sự kiện chung `evdev` để có được keypress. Một ánh xạ lại các mã  tới scancode được thực hiện với các keymap và các quy tắc cụ thể của `X server`. Khi bản đồ scancode của phím được hoàn tất, `X server` sẽ gửi ký tự cho trình `window manager` (DWM, metacity, i3, vv), do đó `window manager` sẽ gửi ký tự tới cửa sổ đang sử dụng. API đồ hoạ của cửa sổ nhận được ký tự sẽ in biểu tượng font thích hợp lên màn hình.

- ### <a name="7">Xử lý URL</a>

    - Bây giờ trình duyệt có các thông tin sau trong URL (Uniform Resource Locator):

    >    - *Protocol* **"http"**
    >
    >        *Sử dụng 'Hyper Text Transfer Protocol'*

    >    - *Resource* **"/"**
    >
    >       *Truy xuất trang chính (index)*


- ### <a name="8">Đó có phải là một URL?</a>

    - Khi không có giao thức hoặc tên miền hợp lệ nào được cho phép, trình duyệt tiếp tục cung cấp cho văn bản được đưa ra trong thanh địa chỉ tới công cụ tìm kiếm mặc định của trình duyệt. Trong nhiều trường hợp, URL có một đoạn văn bản đặc biệt được nối vào nó để báo cho công cụ tìm kiếm rằng nó đến từ thanh URL của trình duyệt cụ thể.

- ### <a name="9">Chuyển đổi ký tự UNICODE không phải ASCII trông máy chủ</a>

    - Trình duyệt kiểm tra tên máy chủ cho các ký tự có trong `a-z` , `A-Z` , `0-9` , `-` , hoặc `.` .

    - Vì tên máy chủ là `google.com` và không có các ký tự khác, nhưng nếu có trình duyệt sẽ áp dụng mã hoá Punycode vào phần tên máy chủ của URL.

- ### <a name="10">Kiểm tra danh sách HSTS</a>

    - Trình duyệt kiểm tra danh sách "HSTS (HTTP Strict Transport Security) đã được tải trước". Đây là danh sách các trang web yêu cầu liên hệ qua HTTPS.

    - Nếu trang web nằm trong danh sách, trình duyệt sẽ gửi yêu cầu của mình qua HTTPS thay vì HTTP. Nếu không, yêu cầu ban đầu được gửi qua HTTP. (Lưu ý rằng một trang web vẫn có thể sử dụng chính sách HSTS mà không có trong danh sách HSTS. Yêu cầu HTTP đầu tiên cho trang web bởi người dùng sẽ nhận được phản hồi yêu cầu người dùng chỉ gửi yêu cầu HTTPS. Tuy nhiên, yêu cầu HTTP đơn này có thể để lại người dùng dễ bị [tấn công hạ cấp](http://en.wikipedia.org/wiki/SSL_stripping) , đó là lý do tại sao danh sách HSTS được bao gồm trong các trình duyệt web hiện đại.)

- ### <a name="11">Tra cứu DNS</a>

    - Trình duyệt sẽ kiểm tra xem tên miền có trong bộ nhớ cache của nó hay không. (để xem Bộ nhớ cache DNS trong Chrome, hãy truy cập tới địa chỉ chrome://net-internals/#dns).

    - Nếu không tìm thấy, trình duyệt sẽ gọi chức năng thư viện `gethostbyname` (thay đổi theo hệ điều hành) để thực hiện tìm kiếm.

    - `gethostbyname` kiểm tra xem tên máy chủ có thể được giải quyết bằng tham chiếu trong tệp hosts cục bộ (có vị trí [khác nhau theo hệ điều hành](https://en.wikipedia.org/wiki/Hosts_%28file%29#Location_in_the_file_system) ) trước khi cố gắng giải quyết tên máy chủ thông qua DNS.

    - Nếu `gethostbyname` không tìm thấy lưu trữ và không thể tìm thấy nó trong tệp hosts thì nó sẽ yêu cầu máy chủ DNS được cấu hình trong ngăn xếp mạng. Đây thường là bộ định tuyến cục bộ hoặc máy chủ DNS lưu trữ của ISP.

    - Nếu máy chủ DNS nằm trên cùng một mạng con, thư viện mạng sẽ được xử lý sử dụng ARP cho máy chủ DNS.

    - Nếu máy chủ DNS nằm trên một mạng con khác, thư viện mạng sẽ được xử lý sử dụng ARP cho IP gateway mặc định.

- ### <a name="12">Xử lý ARP</a>

    - Để gửi một ARP (Address Resolution Protocol) quảng bá, thư viện ngăn xếp mạng cần địa chỉ IP mục tiêu để tra cứu. Nó cũng cần biết địa chỉ MAC của giao diện mà nó sẽ sử dụng để gửi ARP broadcast.

    - ARP cache lần đầu tiên sẽ được kiểm tra cho một ARP entry đối với IP đích của chúng ta. Nếu nó có trong bộ nhớ cache, chức năng thư viện trả về kết quả: Target IP = MAC.

    - Nếu mục nhập không có trong bộ nhớ cache ARP:

        - Bảng định tuyến được tra cứu, để xem địa chỉ IP đích có nằm trên bất kỳ mạng con nào trên bảng định tuyến nội bộ hay không. Nếu có, thư viện sử dụng giao diện liên kết với mạng con đó. Nếu không, thư viện sử dụng giao diện có subnet của cổng mặc định của chúng ta.

        - Địa chỉ MAC của giao diện mạng đã chọn được tra cứu.

        - Thư viện mạng gửi một layer 2 ([lớp liên kết dữ liệu của mô hình OSI](https://en.wikipedia.org/wiki/OSI_model) ) yêu cầu ARP:

            `ARP Request:`

                Sender MAC: interface:mac:address:here
                Sender IP: interface.ip.goes.here
                Target MAC: FF:FF:FF:FF:FF:FF (Broadcast)
                Target IP: target.ip.goes.here

            Tùy thuộc vào loại phần cứng nào giữa máy tính và router:

            Kết nối trực tiếp:

            - Nếu máy tính được kết nối trực tiếp với bộ định tuyến router đáp ứng với một `ARP Reply`

            Hub:

            - Nếu máy tính được kết nối với một hub, hub sẽ thực hiện gửi quảng bá ARP yêu cầu ra tất cả các cổng khác. Nếu router được kết nối trên cùng một "dây", nó sẽ trả lời với một `ARP Reply`

            Switch:

            - Nếu máy tính được kết nối với một switch, switch sẽ kiểm tra bảng CAM/ MAC (Content Addressable Memory/ Media Access Control)cục bộ của nó để xem port nào có địa chỉ MAC mà chúng ta đang tìm kiếm. Nếu switch không có mục nhập cho địa chỉ MAC, nó sẽ phát lại lại yêu cầu ARP tới tất cả các cổng khác.

            - Nếu switch có mục nhập trong bảng MAC / CAM nó sẽ gửi yêu cầu ARP tới cổng có địa chỉ MAC mà chúng ta đang tìm kiếm.

            - Nếu router trên cùng một "dây", nó sẽ trả lời với một `ARP Reply`:

                `ARP Reply:`

                    Sender MAC: target:mac:address:here
                    Sender IP: target.ip.goes.here
                    Target MAC: interface:mac:address:here
                    Target IP: interface.ip.goes.here

            Bây giờ thư viện mạng có địa chỉ IP của máy chủ DNS của chúng ta hoặc cổng mặc định nó có thể tiếp tục quá trình DNS của nó:

            - Cổng 53 được mở ra để gửi yêu cầu UDP tới máy chủ DNS (nếu kích thước phản hồi quá lớn, TCP sẽ được sử dụng thay thế).

            - Nếu máy chủ DNS cục bộ / ISP không có nó, thì một yêu cầu tìm kiếm đệ quy được yêu cầu và sẽ xuất hiện danh sách các máy chủ DNS cho đến khi đạt đến SOA (Service-Oriented Architecture), và nếu tìm được câu trả lời.

- ### <a name="13">Tạo một socket</a>

    Một khi trình duyệt nhận được địa chỉ IP của máy chủ đích, nó sẽ thực hiện lấy số cổng đã cho từ URL (giao thức HTTP mặc định đến cổng 80 và HTTPS đến cổng 443) và thực hiện gọi tới hàm thư viện hệ thống có tên là `socket` và yêu cầu một luồng socket TCP - `AF_INET/AF_INET6` và `SOCK_STREAM`.
    
        - Yêu cầu này lần đầu tiên được chuyển đến `Transport Layer` nơi một `TCP segment` được tạo ra. Cổng đích được thêm vào header, và cổng nguồn được chọn từ phạm vi cổng động của kernel (ip_local_port_range trong Linux).

        - Segment này được gửi tới Network Layer, bao gồm một tiêu đề IP bổ sung. Địa chỉ IP của máy chủ đích cũng như của máy hiện tại được chèn vào để tạo thành một gói tin.

        - Gói kế tiếp đến Data Link Layer. Một tiêu đề khung được thêm vào bao gồm địa chỉ MAC của NIC máy cũng như địa chỉ MAC của gateway (local router). Nếu kernel không biết địa chỉ MAC của gateway, nó phải phát một truy vấn ARP để tìm nó.

    Tại thời điểm này, gói tin đã sẵn sàng để truyền qua:

        - [Ethernet](http://en.wikipedia.org/wiki/IEEE_802.3)
        - [WiFi](https://en.wikipedia.org/wiki/IEEE_802.11)
        - [Cellular data network](https://en.wikipedia.org/wiki/Cellular_data_communication_protocol)

    Đối với hầu hết các kết nối Internet gia đình hoặc doanh nghiệp nhỏ, gói tin sẽ truyền từ máy tính của bạn, có thể thông qua một mạng cục bộ, và sau đó thông qua một modem (MOdulator / DEModulator) chuyển đổi bit 1 và 0 thành tín hiệu tương tự thích hợp để truyền qua điện thoại, hoặc kết nối điện thoại không dây. Ở đầu kia của kết nối là một modem khác chuyển đổi tín hiệu analog sang dữ liệu số sẽ được xử lý bởi [nút mạng](https://en.wikipedia.org/wiki/Computer_network#Network_nodes) tiếp theo nơi mà địa chỉ nguồn và địa chỉ đích sẽ được phân tích thêm.

    Hầu hết các doanh nghiệp lớn hơn và một số kết nối dân cư mới hơn sẽ có kết nối cáp quang hoặc Ethernet trực tiếp, trong trường hợp dữ liệu vẫn là số và được chuyển trực tiếp tới [nút mạng](https://en.wikipedia.org/wiki/Computer_network#Network_nodes) tiếp theo để xử lý.

    Cuối cùng, gói tin sẽ truy cập router quản lý mạng cục bộ. Từ đó, nó sẽ tiếp tục đi đến các router khác của hệ thống tự trị (AS - autonomous system), các AS khác, và cuối cùng đến máy chủ đích. Mỗi router trên đường đi sẽ lấy địa chỉ đích từ tiêu đề IP và định tuyến nó tới hops tới thích hợp. Thời gian sống (TTL) trong tiêu đề IP được giảm bởi một cho mỗi router đi qua. Gói tin này sẽ bị loại bỏ nếu trường TTL đạt đến số không hoặc nếu router hiện tại không có không gian trong hàng đợi của nó (có thể là do tắc nghẽn mạng).

    Việc gửi và nhận này xảy ra nhiều lần theo TCP connection flow:

        - Client chọn một số thứ tự ban đầu (ISN - initial sequence number) và gửi gói tin tới máy chủ với bit SYN được đặt để cho biết nó đang thiết lập ISN

        - **Máy chủ nhận SYN và nếu nó trong một trạng thái thích hợp:**

            - Máy chủ lựa chọn số thứ tự ban đầu
            - Máy chủ đặt SYN để cho biết nó đang chọn ISN của nó
            - Máy chủ sao chép (client ISN +1) vào trường ACK của nó và thêm cờ ACK để cho biết nó đang xác nhận nhận gói tin đầu tiên

        - **Client thừa nhận kết nối bằng cách gửi một gói tin:**
            - Tăng số thứ tự của nó
            - Tăng số xác nhận (acknowledgment number) người nhận
            - Thiết lập trường ACK

        - **Dữ liệu được chuyển như sau:**

            - Khi một bên gửi N byte dữ liệu, nó sẽ tăng SEQ theo số đó
            - Khi phía bên kia thừa nhận nhận được gói tin đó (hoặc một chuỗi các gói tin), nó sẽ gửi một gói ACK với giá trị ACK bằng với chuỗi nhận được cuối cùng từ đầu kia

        - **Đóng kết nối:**

            - Gửi một gói FIN
            - Các bên khác ACKs gói FIN và gửi FIN của riêng mình
            - ACKs gói FIN của các bên khác.


- ### <a name="14">Quá trình bắt tay TLS</a>

    - Máy tính client gửi tin nhắn `ClientHello` tới máy chủ với phiên bản TLS (Transport Layer Security), liệt kê các thuật toán mật mã và phương pháp nén có sẵn.

    - Máy chủ trả lời với một tin `ServerHello` cho client với phiên bản TLS, mật mã đã chọn, các phương pháp nén đã chọn và chứng chỉ công cộng của máy chủ ký bởi CA (Tổ chức phát hành chứng chỉ). Chứng chỉ chứa một khóa công khai sẽ được sử dụng bởi máy client để mã hóa phần còn lại của bắt tay cho đến khi một chìa khoá đối xứng có thể được thỏa thuận.

    - Client xác minh chứng chỉ số máy chủ đối với danh sách các CA đáng tin cậy. Nếu tin tưởng có thể được thiết lập dựa trên CA, client tạo ra một chuỗi các byte giả ngẫu nhiên và mã hóa điều này bằng khóa công khai của máy chủ. Các byte ngẫu nhiên này có thể được sử dụng để xác định khóa đối xứng.

    - Máy chủ giải mã các byte ngẫu nhiên sử dụng khóa riêng của nó và sử dụng các byte này để tạo bản sao khóa chính đối xứng.

    - Client gửi một tin nhắn đã `Finished` đến máy chủ, mã hóa một hash của việc truyền tải đến thời điểm này với khóa đối xứng.

    - Máy chủ tạo ra hash của riêng nó, và sau đó giải mã các hash client gửi để xác minh rằng nó phù hợp. Nếu có, nó sẽ gửi thông điệp đã `Finished` của nó cho client, cả hai phía đều được mã hóa bằng khóa đối xứng.

    - Cuối cùng, phiên TLS truyền dữ liệu ứng dụng (HTTP) được mã hóa bằng khóa đối xứng được đồng ý.

- ### <a name="15">Giao thức HTTP</a>

    - Nếu trình duyệt web sử dụng được Google viết, thay vì gửi yêu cầu HTTP để truy xuất trang, nó sẽ gửi yêu cầu thử và thương lượng với máy chủ "nâng cấp" từ HTTP tới giao thức SPDY.

    - Nếu khách hàng đang sử dụng giao thức HTTP và không hỗ trợ SPDY, nó sẽ gửi yêu cầu tới máy chủ vời form:

            GET / HTTP/1.1
            Host: google.com
            Connection: close
            [other headers]

        trong đó `[other headers]` đề cập đến một loạt các cặp khóa-giá trị được định dạng theo đặc tả HTTP và được phân tách bằng các dòng mới. (Điều này giả định trình duyệt web đang được sử dụng không có bất kỳ vi phạm lỗi HTTP spec. Điều này cũng giả định rằng các trình duyệt web đang sử dụng HTTP/1.1, nếu không nó có thể không bao gồm các tiêu đề Host trong yêu cầu và phiên bản quy định tại GET yêu cầu sẽ là HTTP/1.0 hoặc HTTP/0.9.)

        HTTP/ 1.1 xác định tùy chọn kết nối "đóng" để người gửi báo hiệu rằng kết nối sẽ bị đóng sau khi hoàn thành phản hồi. Ví dụ:

            Connection: close

        Các ứng dụng HTTP/1.1 không hỗ trợ kết nối liên tục. VÌ vậy cần phải bao gồm tùy chọn kết nối "đóng" trong mỗi tin nhắn.

        Sau khi gửi yêu cầu và tiêu đề, trình duyệt web gửi một dòng mới trống đến máy chủ cho biết rằng nội dung của yêu cầu được thực hiện.

        Máy chủ trả lời bằng một mã phản hồi biểu thị trạng thái của yêu cầu và trả lời bằng câu trả lời của khuôn mẫu:

            200 OK
            [response headers]

        Tiếp theo là một dòng mới, và sau đó gửi payload với nội dung HTML của www.google.com . Máy chủ sau đó có thể đóng kết nối, hoặc nếu tiêu đề được gửi bởi khách hàng yêu cầu nó, giữ cho kết nối mở để được sử dụng lại cho các yêu cầu tiếp theo.

        Nếu các tiêu đề HTTP được gửi bởi trình duyệt web bao gồm đầy đủ thông tin cho máy chủ web để xác định xem phiên bản của tệp lưu trữ trong trình duyệt web đã được sửa đổi chưa kể từ lần truy hồi cuối cùng (ví dụ: nếu trình duyệt web bao gồm một tiêu đề ETag ) thay vào đó có thể đáp ứng với một yêu cầu của form: 

            304 Not Modified
            [response headers]

        và không có payload, trình duyệt web sẽ lấy HTML từ bộ nhớ cache của nó.

        Sau khi phân tích HTML, trình duyệt web (và máy chủ) lặp lại quá trình này cho mọi tài nguyên (hình ảnh, CSS, favicon.ico, vv) được tham chiếu bởi trang HTML, ngoại trừ `GET/HTTP/1.1` yêu cầu sẽ là `GET /$(URL relative to www.google.com) HTTP/1.1`.

        Nếu HTML tham chiếu một tài nguyên trên một miền khác với `www.google.com` , trình duyệt web sẽ quay trở lại các bước liên quan đến giải quyết miền khác và làm theo tất cả các bước như trên cho tên miền đó. Tiêu đề `Host` trong yêu cầu sẽ được đặt thành tên máy chủ thích hợp thay vì `google.com`. 

- ### <a name="16">Xử lý request HTTP</a>

    Máy chủ HTTPD (HTTP Daemon) là một máy chủ xử lý yêu cầu/ phản hồi ở phía máy chủ. Các máy chủ HTTPD phổ biến nhất là Apache hoặc nginx dành cho Linux và IIS cho Windows.

        - HTTPD (HTTP Daemon) nhận được yêu cầu.

        - Máy chủ chia nhỏ yêu cầu tới các tham số sau:
            - Phương thức Yêu cầu HTTP ( GET , HEAD , POST , PUT , DELETE , CONNECT , OPTIONS , hoặc TRACE ). Trong trường hợp một URL được nhập trực tiếp vào thanh địa chỉ, nó sẽ là GET .
            - Tên miền, trong trường hợp này - google.com.
            - Đường dẫn /page, trong trường hợp này là / (vì không có đường dẫn /page cụ thể nào được yêu cầu, / là đường dẫn mặc định). 

        - Máy chủ xác minh rằng có một Máy chủ Ảo được cấu hình trên máy chủ tương ứng với google.com.
        - Máy chủ xác minh rằng google.com có ​​thể chấp nhận yêu cầu GET.
        - Máy chủ xác minh rằng client được phép sử dụng phương pháp này (bằng IP, xác thực, v.v.).
        - Nếu máy chủ đã cài đặt một mô-đun ghi đè (như mod_rewrite cho Apache hoặc URL Rewrite for IIS), nó sẽ cố gắng khớp yêu cầu với một trong các quy tắc được định cấu hình. Nếu tìm thấy một quy tắc phù hợp, máy chủ sẽ sử dụng quy tắc đó để viết lại yêu cầu.
        - Các máy chủ sẽ thực hiện lấy nội dung tương ứng với yêu cầu, trong trường hợp của chúng tôi nó sẽ quay trở lại tập tin chỉ mục, vì "/" là tập tin chính (một số trường hợp có thể ghi đè lên điều này, nhưng đây là phương pháp phổ biến nhất).
        - Máy chủ phân tích tệp theo trình xử lý. Nếu Google đang chạy trên PHP, máy chủ sử dụng PHP để giải thích tệp chỉ mục và phản hồi lại dữ liệu cho khách hàng. 

- ### <a name="17">Browser hoạt động như thế nào?</a>

    - Khi máy chủ cung cấp các tài nguyên (HTML, CSS, JS, hình ảnh, v.v.) vào trình duyệt, nó sẽ trải qua quá trình dưới đây:

        - Phân tích cú pháp HTML, CSS, JS
        - Rendering - Xây dựng DOM Tree → Render Tree → Sắp đặt Render tree → Hiển thị Render tree

- ### <a name="18">Browser</a>

    - Chức năng của trình duyệt là hiển thị tài nguyên web bạn chọn, bằng cách yêu cầu nó từ máy chủ và hiển thị nó trong cửa sổ trình duyệt. Tài nguyên thường là một tài liệu HTML, nhưng cũng có thể là dạng PDF, hình ảnh hoặc một số loại nội dung khác. Vị trí của tài nguyên được xác định bởi người dùng bằng cách sử dụng một URI (Uniform Resource Identifier).

    - Cách trình duyệt phân tích và hiển thị các tệp HTML được chỉ định trong các thông số HTML và CSS. Các đặc tả này được duy trì bởi tổ chức W3C (World Wide Web Consortium), là tổ chức tiêu chuẩn cho web.

    - Giao diện người dùng của trình duyệt có nhiều điểm tương đồng với nhau. Các yếu tố giao diện người dùng phổ biến là:

        - Thanh địa chỉ để chèn một URI
        - Nút quay lại và chuyển tiếp
        - Tùy chọn bookmark
        - Các nút Làm mới và Dừng để làm mới hoặc dừng tải tài liệu hiện tại
        - Nút Trang chủ dẫn bạn tới trang chủ của bạn 

    **Trình duyệt Cấu trúc cấp cao**

    Các thành phần của các trình duyệt là:

        - **Giao diện người dùng**: Giao diện người dùng bao gồm thanh địa chỉ, nút back/ forward, bookmarking menu, ...
        - **Công cụ trình duyệt**: Công cụ trình duyệt sắp xếp hành động giữa giao diện người dùng và công cụ rendering.
        - **Công cụ hiển thị**: Công cụ hiển thị có trách nhiệm hiển thị nội dung yêu cầu. Ví dụ: nếu nội dung được yêu cầu là HTML, công cụ kết xuất phân tích HTML và CSS và hiển thị nội dung được phân tích trên màn hình.
        - **Mạng**: Mạng xử lý các giao tiếp mạng như yêu cầu HTTP, sử dụng các triển khai khác nhau cho các nền tảng khác nhau đằng sau giao diện độc lập với nền tảng.
        - **UI phụ trợ**: UI phụ trợ được sử dụng để hiển thị các widgets  cơ bản như combo boxes và windows. Phần phụ trợ này cho thấy một giao diện chung chung không phải là nền tảng cụ thể. Nó sử dụng phương pháp giao diện người dùng hệ điều hành.
        - **JavaScript Engine**: Công cụ JavaScript được sử dụng để phân tích cú pháp và thực thi mã JavaScript.
        - **Lưu trữ dữ liệu**: Việc lưu trữ dữ liệu là một lớp kiên cố. Trình duyệt có thể cần lưu tất cả các loại dữ liệu cục bộ, chẳng hạn như cookie. Các trình duyệt cũng hỗ trợ các cơ chế lưu trữ như localStorage, IndexedDB, WebSQL và FileSystem. 

- ### <a name="19">Biên dịch HTML</a>

    - Công cụ hiển thị bắt đầu nhận nội dung của tài liệu được yêu cầu từ lớp mạng. Điều này thường sẽ được thực hiện trong khối 8kB.

    - Công việc chính của trình phân tích cú pháp HTML là để phân tích HTML markup vào một cây phân tích cú pháp.

    - Cây ra ("cây phân tích") là một cây của các phần tử DOM và thuộc tính. DOM là viết tắt của Document Object Model. Đây là sự trình bày đối tượng của tài liệu HTML và giao diện, các phần tử HTML với JavaScript. Gốc của cây là đối tượng "Tài liệu". Trước bất kỳ thao tác nào qua scripting, DOM có mối quan hệ gần như một-một đối với markup.

    **Thuật toán phân tích cú pháp**

    Không thể phân tích cú pháp HTML bằng cách sử dụng trình phân tích cú pháp từ trên xuống dưới hoặc từ dưới lên.

    Lý do là:

        - Bản chất tự nhiên của ngôn ngữ.
        - Sự thật là các trình duyệt có khả năng chịu lỗi để hỗ trợ các trường hợp HTML không hợp lệ.
        - Quá trình phân tích cú pháp là tập trung lại. Đối với các ngôn ngữ khác, tài nguyên không thay đổi trong quá trình phân tích cú pháp, nhưng trong HTML, mã động (dynamic code) (như các phần tử script có chứa các lời gọi document.write ()) có thể thêm các thẻ phụ, do đó quá trình phân tích cú pháp thực sự sửa đổi đầu vào. 

    - Không thể sử dụng các kỹ thuật phân tích cú pháp thường xuyên, trình duyệt sử dụng một trình phân tích cú pháp tùy chỉnh để phân tích cú pháp HTML. Thuật toán phân tích cú pháp được mô tả chi tiết theo đặc tả của HTML5.

    - Thuật toán bao gồm hai giai đoạn: tokenization và xây dựng cây.

    **Tác vụ khi phân tích cú pháp kết thúc**

    - Trình duyệt bắt đầu tìm nạp tài nguyên bên ngoài liên kết với trang (CSS, hình ảnh, tệp JavaScript, v.v ...).

    - Ở giai đoạn này, trình duyệt đánh dấu tài liệu là tương tác và bắt đầu phân tích cú pháp các kịch bản đang ở chế độ "deferred": những gì cần được thực hiện sau khi tài liệu được phân tích cú pháp. Trạng thái tài liệu được đặt thành "complete" và sự kiện "load" được kích hoạt.

    - Lưu ý không bao giờ có lỗi "Invalid Syntax" trên một trang HTML. Trình duyệt sẽ khắc phục bất kỳ nội dung không hợp lệ nào và tiếp tục.

- ### <a name="20">Biên dịch CSS</a>

    - Phân tích các tệp CSS, nội dung thẻ `<style>` và các thuộc tính `style` bằng cách sử dụng "syntax CSS"
    - Mỗi tệp CSS được phân tách thành một `StyleSheet object`, trong đó mỗi đối tượng chứa các quy tắc CSS với bộ chọn và các đối tượng tương ứng với ngữ pháp CSS.
    - Một trình phân tích cú pháp CSS có thể là từ trên xuống dưới hoặc từ dưới lên khi sử dụng một trình tạo phân tích cú pháp cụ thể. 

- ### <a name="21">Page Rendering</a>

    - Tạo 'Frame Tree' hoặc 'Render Tree' bằng cách đi qua các nút DOM, và tính các giá trị kiểu CSS cho mỗi nút.

    - Tính chiều rộng ưa thích của mỗi nút trong 'Frame Tree' từ dưới lên bằng cách tổng hợp chiều rộng ưa thích của các nút con và các lề nằm ngang, border và padding của nút.

    - Tính toán chiều rộng thực tế của mỗi nút từ trên xuống bằng cách cấp phát chiều rộng cho mỗi nút của con.
    - Tính toán chiều cao của mỗi nút từ dưới lên bằng cách áp dụng gói văn bản và tổng hợp các chiều cao nút con và các lề, biên và lề của nút.
    - Tính tọa độ của mỗi nút bằng cách sử dụng thông tin được tính toán ở trên.
    - Các bước phức tạp hơn được thực hiện khi các phần tử được floated , được định vị absolutely hoặc relatively , hoặc các tính năng phức tạp khác được sử dụng. Xem http://dev.w3.org/csswg/css2/ và http://www.w3.org/Style/CSS/current-work để biết thêm chi tiết.
    - Tạo lớp để mô tả phần nào của trang có thể được hiển thị như một nhóm mà không bị làm lại. Mỗi đối tượng frame/ render được gán cho một layer.
    - Kết cấu được cấp phát cho mỗi lớp của trang.
    - Các đối tượng frame/ render cho mỗi lớp được traversed và các lệnh được thực hiện cho lớp tương ứng của chúng. Điều này có thể được rasterized bởi CPU hoặc vẽ trên GPU trực tiếp bằng cách sử dụng D2D/ SkiaGL.
    - Tất cả các bước trên có thể sử dụng lại các giá trị được tính từ lần cuối cùng trang web được hiển thị, do đó các thay đổi gia tăng đòi hỏi ít công việc hơn.
    - Các lớp trang được gửi đến quá trình kết hợp chúng được kết hợp với các lớp cho các nội dung có thể nhìn thấy khác như trình duyệt Chrome, khung nội tuyến và bảng addon.
    - Các vị trí lớp cuối cùng được tính toán và các lệnh ghép được phát hành qua Direct3D/ OpenGL. Bộ đệm lệnh GPU được đổ vào GPU để hiển thị không đồng bộ và khung được gửi tới máy chủ cửa sổ. 

- ### <a name="22">GPU Rendering</a>

    - Trong quá trình dựng hình, các lớp tính toán đồ hoạ có thể sử dụng CPU hoặc GPU xử lý đồ họa.
    - Khi sử dụng GPU để tính toán kết xuất đồ hoạ, các lớp phần mềm đồ họa chia công việc thành nhiều phần, vì vậy nó có thể tận dụng ưu thế song song lớn của GPU để tính toán điểm nổi yêu cầu cho quá trình dựng hình.

- ### <a name="23">Windows-Server</a>

- ### <a name="24">Thực thi post-rendering và user-included</a>

    - Sau khi kết xuất hoàn tất, trình duyệt sẽ thực hiện mã JavaScript do kết quả của một số cơ chế thời gian (chẳng hạn như hình ảnh động của Google Doodle) hoặc tương tác người dùng (nhập một truy vấn vào hộp tìm kiếm và nhận các đề xuất). Các plugin như Flash hay Java cũng có thể được thực hiện, mặc dù không phải vào thời điểm này trên trang chủ của Google. Các tập lệnh có thể làm cho các yêu cầu mạng bổ sung được thực hiện, cũng như sửa đổi trang hoặc bố cục của nó, gây ra việc rendering và vẽ trang khác.


____

# <a name="content-others">Các nội dung khác</a>
