# Bài thực hành số 4. Cấu hình iptables cho các kết nối từ mạng bên ngoài truy cập hệ thống bằng việc sử dụng mạng cục bộ

____

# Mục lục


- [4.1 Đặt vấn đề](#issue)
- [4.2 Mô hình](#models-l4)
- [4.3 Cách cấu hình](#config)
- [4.4 Kiểm tra kết quả](#checking)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="issue">4.1 Đặt vấn đề</a>

    - Trong hệ thống cung cấp dịch vụ, đôi khi ta sẽ từ chối việc kết nối từ một địa chỉ IP nào đó tới hệ thống. Đơn giản là chỉ chấp nhận một vài địa chỉ IP được phép truy cập vào hệ thống. Còn lại cần phải truy cập qua địa chỉ cục bộ.

- ### <a name="models-l4">4.2 Mô hình</a>

    - Mô hình của bài cấu hình giống như sau:

        > ![models-l4](../images/models-l4.png)

    - Server sử dụng hệ điều hành CentOS 7 và iptables làm firewall
    - Cấu hình được thực hiện trên VMWare.

- ### <a name="config">4.3 Cách cấu hình</a>

    - Với mô hình như trên, ta sẽ thực hiện cấu hình trên máy chủ Server với các nội dung như sau:

        1. Mặc định từ chối các kết nối đến hệ thống.
        2. Mặc định chấp nhận các kết nối đi ra khỏi hệ thống.
        3. Mặc định từ chối các kết nối được chuyển hướng.
        4. Cho phép các kết nối được thiết lập
        5. Cho phép các kết nối từ loopback
        6. Chuyển kết nối đến interface `ens36` port `22` đến port `22` trên `backends01`.
        7. Chuyển kết nối đến interface `ens36` port `80` đến port `80` trên `backends02`.
        8. Cho phép các kết nối ping với giới hạn 5 lần 1 phút đối với các kết nối từ LAN (10.10.10.0/24)
        9. Cho phép kết nối SSH đến từ mạng LAN (10.10.10.0/24)
        10. Cho phép các gói tin đi qua Server đến từ mạng LAN (10.10.10.0/24) và thực hiện NAT.

    - Chi tiết các bước làm như sau:

        - Có thể thực hiện chạy câu lệnh này nếu bạn muốn xóa các rules đã có của iptables và tạo ra các rule cho các chains mới hoàn toàn:

                iptables -F
                iptables -X

            trong đó:

                - tham số `-F`: có tác dụng xóa tất cả các quy tắc (rules)
                - tham số `-X`: xóa các chain do người dùng khai báo

        - Kích hoạt chế độ chuyển gói tin ở mức kernel (loading module). Tính năng này cần được kích hoạt để iptables có thể chuyển gói tin sang máy khác:

                echo 1 > /proc/sys/net/ipv4/ip_forward

        1. Thực hiện xóa các rule trong bảng NAT:

                iptables -t nat -F

            trong đó:
                - tham số `-t nat`: Khai báo rằng các gói tin sẽ áp dụng rule với bảng NAT.
                - tham số `-F`: Xóa toàn bộ các rule.

        2. Mặc định từ chối các kết nối đến hệ thống:

                iptables -P INPUT DROP

        3. Mặc định chấp nhận các kết nối đi ra khỏi hệ thống:

                iptables -P OUTPUT ACCEPT

        4. Mặc định từ chối các kết nối được chuyển hướng:

                iptables -P FORWARD DROP

        5. Chấp nhận các kết nối chuyển hướng và cho phép được thiết lập kết nối:

                iptables -A FORWARD -i ens34 -o ens36 -s 10.10.10.0/24 -j ACCEPT
                iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

        6. Cho phép các kết nối từ loopback và cho phép thiết lập kết nối đến:

                iptable -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
                iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

        7. Cho phép các kết nối ping với giới hạn 5 lần 1 phút đối với các kết nối từ LAN (10.10.10.0/24):

                iptables -A INPUT -p icmp --icmp-type echo-request -s 10.10.10.0/24 \
                -d 10.10.10.72 -m limit --limit 1/m --limit-burst 5 -j ACCEPT

        8. Cho phép kết nối SSH đến từ mạng LAN (10.10.10.0/24):

                iptables -A INPUT -p tcp -m state --state NEW -m tcp -s 10.10.10.0/24 \
                -d 10.10.10.72 --dport 22 -j ACCEPT

        9. Chấp nhận kết nối chuyển hướng đến port `22` trên `backends01`:

                iptables -A FORWARD -p tcp -d 10.10.10.20 --dport 22 -j ACCEPT

        10. Chấp nhận kết nối chuyển hướng đến port `80` trên `backends02`:

                iptables -A FORWARD -p tcp -d 10.10.10.30 --dport 80 -j ACCEPT

        11. Thực hiện cấu hình IP nguồn của gói tin sẽ giống như IP nguồn của firewall (SNAT):

                iptables -t nat -A POSTROUTING -o ens36 -s 10.10.10.0/24 -j MASQUERADE

        1. Chuyển kết nối đến interface `ens36` port `22` đến port `22` trên `backends01`:

                iptables -t nat -A PREROUTING -p tcp -d 192.168.19.72 --dport 22 \
                -j DNAT --to-destination 10.10.10.20:22
                iptables -t nat -A POSTROUTING -p tcp -d 10.10.10.20 --dport 22 \
                -j SNAT --to-source 10.10.10.72

        15. Chuyển kết nối đến interface `ens36` port `80` đến port `80` trên `backends02`:

                iptables -t nat -A PREROUTING -p tcp -d 192.168.19.72 --dport 80 \
                -j DNAT --to-destination 10.10.10.30:80
                iptables -t nat -A POSTROUTING -p tcp -d 10.10.10.30 --dport 80 \
                -j SNAT --to-source 10.10.10.72

        16. Lưu lại cấu hình và khởi động lại iptables:

                iptables-save
                systemctl restart iptables

- ### <a name="checking">4.4 Kiểm tra kết quả</a>

    - Ta sẽ kiểm tra kết quả đối với SSH tới Server với địa chỉ `192.168.19.72` qua `ens36`. Theo cấu hình iptables bên trên. Ta sẽ được chuyển hướng SSH đến `Backends01` với địa chỉ IP là `10.10.10.20`. Sử dụng câu lệnh sau để kiểm tra kết quả:

            ssh root@10.10.10.20

        trong đó: root là tên người dùng trong máy Backends01. Kết quả ta nhận được như sau:

        > ![login-ssh](../images/login-ssh.png)

    - Kiểm tra địa chỉ IP của máy đang thực hiện SSH, ta nhận được:

        > ![ssh-done](../images/ssh-done.png)

    - Từ cửa sổ trình duyệt, ta truy cập đến địa chỉ:

            http://ip_address

        trong đó: ip_address là địa chỉ IP của máy cấu hình iptables nằm trên interface ens36. Ta nhận được kết quả như sau:

        > ![http-done.png](http-done.png)

____

# <a name="content-others">Các nội dung khác</a>
