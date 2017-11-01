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
    - [1.2.3 Khái niệm về chain](#about-chain)
    - [1.2.4 Khái niệm về rule](#about-rule)
    - [1.2.5 Khái niệm về port](#about-port)
- [1.3 Các bảng và chức năng sử dụng trong iptables](#tables)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [](#)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="about">1.1 Giới thiệu về iptables</a>
    - ### <a name="role">1.1.1 Vai trò, chức năng</a>

        - `iptables` là một ứng dụng dùng để quản lý filtering gói tin và NAT rules hoạt động trên console của linux rất nhỏ và tiện dụng. Được cung cấp miễn phí nhằm nâng cao tính bảo mật trên hệ thống Linux.

        - `iptables` bao gồm 2 phần là `netfilter` nằm bên trong nhân Linux và `iptables` nằm ở vùng ngoài nhân. `iptables` chịu trách nhiệm giao tiếp với người dùng và sau đó đẩy rules của người dùng vào cho `netfilter` xử lý. `netfilter` thực hiện công việc lọc các gói tin ở mức IP. `netfilter` làm việc trực tiếp ở trong nhân của Linux nhanh và không làm giảm tốc độ của hệ thống.

        - `iptables` cung cấp các tính năng sau:

            - Có khả năng phân tích gói tin hiệu quả.
            - Filtering gói tin dựa vào MAC và một số cờ hiệu (flags) trong TCP Header.
            - Cung cấp kỹ thuật NAT, chi tiết cho các tùy chọn để ghi nhận sự kiện hệ thống.
            - Có khả năng ngăn chặn một số cơ chế tấn công theo kiểu DoS.
            - Xây dựng một hệ thống tường lửa (firewall).
            - Cung cấp, xây dựng và quản lý các rule để xử lý các gói tin.

        
    - ### <a name="install">1.1.2 Cách cài đặt iptales</a>

        - `iptables` được cài đặt mặc định trong các hệ điều hành Linux. Riêng trên hệ điều hành (CentOS) có cung cấp `firewalld` được sử dụng mặc định thay cho `iptables` và trên (Ubuntu) có cung cấp `ufw` dành riêng cho chức năng `netfilter firewall`. Về bản chất thì các phần mềm hoạt động với chức năng là như nhau nên trong khuôn khổ nội dung của bài viết này, ta chỉ sử dụng và đề cập đến `iptables` nhiều hơn tất cả.

        - Đối với Ubuntu, để sử dụng `iptables`, ta cần khởi động nó với 2 câu lệnh sau:

                service ufw start
                service ufw re-start

        - Đối với CentOS, để sử dụng `iptables`, ta cần phải cài đặt nó và dừng hoạt động `firewalld` với các câu lệnh sau:

                yum install -y iptables

                systemctl stop firewalld
                systemctl disable firewalld

                systemctl start iptables
                systemctl enable iptables

- ### <a name="concepts">1.2 Các khái niệm cần biết trước khi tìm hiểu về iptables</a>
    - ### <a name="about-NAT">1.2.1 Khái niệm về NAT</a>

        - Mỗi một kết nối trước khi được xử lý đều có địa chỉ nguồn (source ip address) và địa chỉ đích (destination ip address) được chứa trong thông tin của các gói tin. NAT trong `netfilter` đơn giản là việc thực hiện thay đổi địa chỉ đích và port theo một cách mong muốn.

        - Khi các gói tin được nhận, các kết nối cũng sẽ được thực so sánh lại một lần nữa với địa chỉ đích (bao gồm cả port). Việc không phân mảnh cũng là một yêu cầu quan trọng dành cho NAT. (Nếu cần thiết, các gói tin IPv4 cũng sẽ được sắp xếp lại theo ngăn xếp giống như bình thường.)


    - ### <a name="about-filtering">1.2.2 Khái niệm về filtering</a>

        - Là quá trình chặn bắt gói tin theo một số tiêu chí mà ta đề ra.

        - Giả sử: Khi một gói tin đi đến sẽ chứa các giá trị về địa chỉ IP nguồn (source address), địa chỉ IP đích (destination address) và các port tương ứng (port nguồn và port đích). Khi ta thực hiện `filtering` gói tin theo tiêu chí địa chỉ IP nguồn. Thì các gói tin có địa chỉ IP nguồn khớp với địa chỉ IP mà ta đề ra sẽ được giữ lại để chờ xử lý.


    - ### <a name="about-mangle">1.2.3 Khái niệm về mangle</a>

        - Là quá trình bóc tách gói tin và chịu trách nhiệm thay đổi bits của QoS (Quality of Services) trong IP Header bởi vì `mangle` làm việc với các gói tin IP.


    - ### <a name="about-chain">1.2.3 Khái niệm về chain</a>

        - `chain` là một quy tắc xử lý các gói tin bao gồm nhiều rules có liên quan tới nhau.

    - ### <a name="about-rule">1.2.4 Khái niệm về rule</a>

        - `rule` là là một luật, hành động cụ thể xử lý gói tin ứng với mỗi trường hợp, tiêu chí mà ta đề ra.

    - ### <a name="about-port">1.2.5 Khái niệm về port</a>

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

- ### <a name="tables">1.3 Các bảng và chức năng sử dụng trong iptables</a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>
- ### <a name=""></a>


____

# <a name="content-others">Các nội dung khác</a>
