# 1. Giới thiệu về iptables trong linux

____

# Mục lục


- [1.1 Giới thiệu về iptables](#about)
    - [1.1.1 Vai trò, chức năng](#role)
    - [1.1.2 Cách cài đặt iptales](#install)
- [1.2 Các khái niệm cần biết trước khi tìm hiểu về iptables](#concepts)
    - [1.2.1 Khái niệm về NAT](#about-NAT)
    - [1.2.2 Khái niệm về filtering](#about-filtering)
    - [1.2.3 Khái niệm về mangle](#about-mangle)
    - [1.2.4 Khái niệm về chain](#about-chain)
    - [1.2.5 Khái niệm về rule](#about-rule)
    - [1.2.6 Khái niệm về port](#about-port)
    - [1.2.7 Khái niệm về target](#about-target)
- [1.3 Các bảng và chức năng sử dụng trong iptables](#tables)
    - [1.3.1 NAT Table](#table-nat)
    - [1.3.2 FILTER Table](#table-filter)
    - [1.3.3 MANGLE Table](#table-mangle)
    - [1.3.4 RAW Table](#table-raw)
    - [1.3.5 Security Table](#table-security)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="about">1.1 Giới thiệu về iptables</a>
    - #### <a name="role">1.1.1 Vai trò, chức năng</a>

        - `iptables` là một ứng dụng dùng để quản lý filtering gói tin và NAT rules hoạt động trên console của linux rất nhỏ và tiện dụng. Được cung cấp miễn phí nhằm nâng cao tính bảo mật trên hệ thống Linux.

        - `iptables` bao gồm 2 phần là `netfilter` nằm bên trong nhân Linux và `iptables` nằm ở vùng ngoài nhân. `iptables` chịu trách nhiệm giao tiếp với người dùng và sau đó đẩy rules của người dùng vào cho `netfilter` xử lý. `netfilter` thực hiện công việc lọc các gói tin ở mức IP. `netfilter` làm việc trực tiếp ở trong nhân của Linux nhanh và không làm giảm tốc độ của hệ thống.

        - `iptables` cung cấp các tính năng sau:

            - Có khả năng phân tích gói tin hiệu quả.
            - Filtering gói tin dựa vào MAC và một số cờ hiệu (flags) trong TCP Header.
            - Cung cấp kỹ thuật NAT, chi tiết cho các tùy chọn để ghi nhận sự kiện hệ thống.
            - Có khả năng ngăn chặn một số cơ chế tấn công theo kiểu DoS.
            - Xây dựng một hệ thống tường lửa (firewall).
            - Cung cấp, xây dựng và quản lý các rule để xử lý các gói tin.

        
    - #### <a name="install">1.1.2 Cách cài đặt iptales</a>

        - `iptables` được cài đặt mặc định trong các hệ điều hành Linux. Riêng trên hệ điều hành (CentOS) có cung cấp `firewalld` được sử dụng mặc định thay cho `iptables` và trên (Ubuntu) có cung cấp `ufw` dành riêng cho chức năng `netfilter firewall`. Về bản chất thì các phần mềm hoạt động với chức năng là như nhau nên trong khuôn khổ nội dung của bài viết này, ta chỉ sử dụng và đề cập đến `iptables` nhiều hơn tất cả.

        - Đối với Ubuntu, để sử dụng `iptables`, ta cần khởi động nó với 2 câu lệnh sau:

                service ufw start
                service ufw re-start

        - Đối với CentOS, để sử dụng `iptables`, ta cần phải cài đặt nó và dừng hoạt động `firewalld` với các câu lệnh sau:

                yum install -y iptables iptables-services

                systemctl stop firewalld
                systemctl disable firewalld

                systemctl start iptables
                systemctl enable iptables

- ### <a name="concepts">1.2 Các khái niệm cần biết trước khi tìm hiểu về iptables</a>
    - #### <a name="about-NAT">1.2.1 Khái niệm về NAT</a>

        - Mỗi một kết nối trước khi được xử lý đều có địa chỉ nguồn (source ip address) và địa chỉ đích (destination ip address) được chứa trong thông tin của các gói tin. NAT trong `netfilter` đơn giản là việc thực hiện thay đổi địa chỉ đích và port theo một cách mong muốn.

        - Khi các gói tin được nhận, các kết nối cũng sẽ được thực so sánh lại một lần nữa với địa chỉ đích (bao gồm cả port). Việc không phân mảnh cũng là một yêu cầu quan trọng dành cho NAT. (Nếu cần thiết, các gói tin IPv4 cũng sẽ được sắp xếp lại theo ngăn xếp giống như bình thường.)


    - #### <a name="about-filtering">1.2.2 Khái niệm về filtering</a>

        - Là quá trình chặn bắt gói tin theo một số tiêu chí mà ta đề ra.

        - Giả sử: Khi một gói tin đi đến sẽ chứa các giá trị về địa chỉ IP nguồn (source address), địa chỉ IP đích (destination address) và các port tương ứng (port nguồn và port đích). Khi ta thực hiện `filtering` gói tin theo tiêu chí địa chỉ IP nguồn. Thì các gói tin có địa chỉ IP nguồn khớp với địa chỉ IP mà ta đề ra sẽ được giữ lại để chờ xử lý.


    - #### <a name="about-mangle">1.2.3 Khái niệm về mangle</a>

        - Là quá trình bóc tách gói tin và chịu trách nhiệm thay đổi bits của QoS (Quality of Services) trong IP Header bởi vì `mangle` làm việc với các gói tin IP.


    - #### <a name="about-chain">1.2.4 Khái niệm về chain</a>

        - `chain` là một quy tắc xử lý các gói tin bao gồm nhiều rules có liên quan tới nhau.

        - Mỗi `table` sẽ được tạo với một hoặc nhiều `chain`. `chain` cho phép lọc gói tin tại các điểm khác nhau. `iptable` có thể được thiết lập đối với các loại `chain` như sau:

            + chain `PREROUTING`: Các rule thuộc `chain` này sẽ được áp dụng ngay sau khi gói tin vừa đi vào đến dải mạng (Network Interface). `chain` này chỉ có thể có ở table NAT, RAW và MANGLE.

            + chain `INPUT`: Các rule thuộc `chain` này sẽ áp dụng cho các gói tin ngay trước khi gói tin đi vào hệ thống. `chain` này có trong table MANGLE và FILTER.

            + chain `OUTPUT`: Các rule thuộc `chain` này áp dụng ngay cho các gói tin đi ra từ hệ thống. `chain` có trong table MANGLE, RAW và FILTER.

            + chain `FORWARD`: Các rule thuộc `chain` này áp dụng các gói tin được chuyển tiếp qua hệ thống. `chain` có trong table MANGLE.

            + chain `POSTROUTING`: Các rule thuộc `chain` này áp dụng cho các gói tin tới dải mạng (Network Interface). `chain` này có trong table MANGLE và NAT.
            
            + Hãy quan sát hình ảnh dưới đây để hiểu về thứ tự xử lý các table và chain trong khi xử lý gói tin:

                > ![table-flow](../images/table-flow.png)


    - #### <a name="about-rule">1.2.5 Khái niệm về rule</a>

        - `rule` là là một luật, hành động cụ thể xử lý gói tin ứng với mỗi trường hợp, tiêu chí mà ta đề ra.

    - #### <a name="about-port">1.2.6 Khái niệm về port</a>

        - `port` là một vị trí nào đó mà gói tin TCP/UDP vào và ra trong thiết bị. Một địa chỉ IP có rất nhiều `port`.
        - Tất cả các `port` đều được định danh bởi các con số - `port number`
        - Một vài dịch vụ và port tương ứng:

            | Services | Port number |
            | ---------| ------------|
            | DNS      |      53     |
            | HTTP     |      80     |
            | FTP      |     20/21   |
            | SSH      |      22     |
            | Telnet   |      23     |
            | ICMP     |      5813   |
            | POP3     |      110    |
            | SMTP     |      25     |

    - #### <a name="about-target">1.2.7 Khái niệm về target</a>

        - Mỗi một `chain` là một danh sách các luật có thể được thiết lập cho các gói tin. Mỗi một luật sẽ cần phải khai báo những gì cần phải làm với gói tin được gọi là `target`.

        - Nói một cách đơn giản thì các hành động áp dụng cho các gói tin được gọi là `target` . Đối với những gói tin đúng theo rule mà chúng ta đặt ra thì các hành động (`target`) có thể thực hiện được đó là:

            - `ACCEPT`: chấp nhận gói tin, cho phép gói tin đi qua hay đi vào hệ thống.

            - `DROP`: loại bỏ gói tin, không phản hồi lại gói tin giống như việc gói tin đó được gửi đến một hệ thống không tồn tại.

            - `RETURN`: Dừng thực thi xử áp dụng `rules` tiếp theo trong `chain` hiện tại đối với gói tin. Việc kiểm soát sẽ được trả về đối với `chain` đang gọi.

            - `REJECT`: Thực hiện loại bỏ gói tin và gửi lại gói tin phản hồi thông báo lỗi. Ví dụ: 1 bản tin “connection reset” đối với gói TCP hoặc bản tin “destination host unreachable” đối với gói UDP và ICMP.

            - `LOG`: Chấp nhận gói tin và có ghi lại log.


- ### <a name="tables">1.3 Các bảng và chức năng sử dụng trong iptables</a>
    - Trong kiến trúc của iptable có sử dụng các bảng để quy định các `chain` cùng thực hiện các chức năng trong một không gian nhất định với công việc nhất định. Hiện tại, `iptable` cung cấp cho chúng ta 5 loại table (để có thể sử dụng được các table, trong kernel ta cần phải có module của nó). Một số module:

        + `iptables_nat module` cần cho một số loại NAT.

        + `ip_conntrack_ftp module` cần cho việc thêm vào giao thức FTP.

        + `ip_conntrack module` giữ trạng thái liên kết với giao thức TCP.

        + `ip_nat_ftp module` cần được tải cho những máy chủ FTP sau một firewall NAT

        > CHÚ Ý: file /etc/sysconfig/iptables không cập nhật những môdun tải về, vì vậy chúng ta phải thêm những trạng thái đó vào file /etc/rc.local và chạy nó tại cuối mỗi lần boot lại.

    - Những mẫu trong phần này bao gồm những trạng thái được lưu trong file `/etc/rc.local`:

        ```sh
        #File:/etc/rc.local

        #Module to track the state of connections modprobe ip_conntrack

        #Load the iptables active FTP module, requires ip_conntrack modprobe

        #ip_conntrack_ftp

        #Load iptables NAT module when required modprobe iptable_nat

        #Module required for active an FTP server using NAT modprobe ip_nat_ftp
        ```

    - ### <a name="table-nat">1.3.1 NAT Table</a>

        - Cho phép route các gói tin đến các host khác nhau trong mạng bằng cách thay đổi IP nguồn và IP đích của gói tin. Table này quy định và cho phép các kết nối có thể truy cập tới các dịch vụ không được truy cập trực tiếp. Bao gồm 3 thành phần:

            + `PREROUTING chain` – Thay đổi gói tin trước khi định tuyến, điều này có nghĩa là việc dịch gói tin sẽ xảy ra ngay lập tức sau khi gói tin đến hệ thống. Điều này thực hiện thay đổi địa chỉ IP đích thành một địa chỉ nào đó sao cho phù hợp với việc định tuyến trên máy chủ cục bộ - DNAT.

            + `POSTROUTING chain` – Thay đổi gói tin sau khi định tuyến, điều này có nghĩa là dịch gói tin khi gói tin ra khỏi hệ thống. Điều này thực hiện thay đổi địa chỉ IP nguồn của gói tin thành một địa chỉ nào đó phù hợp với việc định tuyến trên máy chủ đích - SNAT.

            + `OUTPUT chain` – thực hiện NAT cho các gói tin được thực hiện cục bộ trên firewall.

    - ### <a name="table-filter">1.3.2 FILTER Table</a>

        - Đây là table được sử dụng mặc định bởi `iptables` khi bạn tạo các `chain mà không khai báo cho `chain` đó thuộc vào table nào. Table hoạt động với việc quy định việc quyết định có cho phép gói tin được chuyển đến địa chỉ đích hay không. Bao gồm 3 thành phần:

            + `INPUT chain`: Các gói tin đến firewall. Áp dụng đối với các gói tin đến máy chủ cục bộ.

            + `OUTPUT chain`: Các gói tin đi ra khỏi firewall. Áp dụng với các gói tin được tạo ra cục bộ và đi ra khỏi máy chủ.

            + `FORWARD chain`: Áp dụng đối với các gói tin được định tuyến đi qua máy chủ.


    - ### <a name="table-mangle">1.3.3 MANGLE Table</a>

        - Table này liên quan đến việc sửa header của gói tin, ví dụ chỉnh sửa giá trị các trường TTL, MTU, Type of Service.

        - Bao gồm các thành phần sau:


            + PREROUTING chain

            + OUTPUT chain

            + FORWARD chain

            + INPUT chain

            + POSTROUTING chain


    - ### <a name="table-raw">1.3.4 RAW Table</a>

        - Bảng này được sử dụng chủ yếu dành cho việc cấu hình sử dụng `chain` có sẵn. Bao gồm:

            + PREROUTING chain

            + OUTPUT chain


    - ### <a name="table-security">1.3.5 Security Table</a>

        - Đây là bảng được sử dụng cho `Mandatory Access Control (MAC)` - kiểm soát truy cập bắt buộc đối với các rule về network.

        - MAC được triển khai bởi `Linux Security Modules` được biết đến như là SELinux. Gói tin được chuyển đến table này sau khi đi qua `FILTER table` và cho phép một vài `Discretionary Access Control (DAC)` - kiểm soát truy cập tùy ý trong `FILTER table` gây ảnh hưởng trước các MAC rule. Table này cung cấp các chain có sẵn là:

            + INPUT chain.

            + OUTPUT chain.

            + FORWARD chain.

____

# <a name="content-others">Các nội dung khác</a>
