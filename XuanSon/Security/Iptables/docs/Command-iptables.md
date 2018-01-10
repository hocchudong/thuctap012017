# Command iptables


# MỤC LỤC
- [1.Cú pháp](#1)
- [2.Command](#2)
- [3.Matches](#3)
	- [3.1.Generic matches](#3.1)
	- [3.2.Implicit matches](#3.2)
		- [3.2.1.TCP matches](#3.2.1)
		- [3.2.2.UDP matches](#3.2.2)
		- [3.2.3.ICMP matches](#3.2.3)

<a name="1"></a>
# 1.Cú pháp
```
iptables [-t table] command [chain] [match] [target/jump]
```

\- Thứ tự các tham số có thể thay đổi nhưng cú pháp trên là dễ hiểu nhất.  
\- Nếu không chỉ định `table`, mặc định sẽ là table filter.  
\- `command` sẽ chỉ định chương trình phải làm gì.  
VD: Insert rule hoặc thêm rule đến cuối của chains.  
\- `chain` phải phù hợp với `table` được chỉ định.  
\- `match` là phần của rule mà chúng ta gửi cho kernel để biết chi tiết cụ thể của gói tin, điều gì làm cho nó khác với các gói tin khác.  
VD: địa chỉ IP, port, giao thức hoặc bất cứ điều gì.  
\- Cuối cùng là `target` của gói tin. Nếu phù hợp với match, chúng tôi sẽ vói với kernel phải làm những gì với gói tin này.  

<a name="2"></a>
# 2.Command
\- command nói cho iptables biết phải làm gì với phần còn lại của rule. Thông thường chúng ta muốn thêm hoặc xóa 1 cái gì đó trong bảng. Các command sau có sẵn trong iptables.  
\- **command**  

|Command|Ví dụ|Ý nghĩa|
|---|---|---|
|-A, --append|iptables -A INPUT|thêm rule vào cuối của chains.|
|-D, --delete|iptables -D INPUT --dport 80 -j DROP **hoặc** iptables -D INPUT 1|xóa rule của chain. Điều này có thể được thực hiện theo 2 cách; bằng cách nhập cả rule để khớp (như trong vd đầu tiên), hoặc bằng cách chỉ định số thứ tự của rule mà bạn muốn xóa. Các rules được đánh số từ đầu đến cuối đối với mỗ chain, bắt đầu với số thứ tự 1.|
|-R, --replace|iptables -R INPUT 1 -s 192.168.0.1 -j DROP|thay thế rule cũ tại dòng chỉ định. Nó sẽ làm việc tương tự như câu lệnh --delete, nhưng thay vì xóa, nó sẽ thay thế nó bằng mục nhập mới.|
|-I, --insert|iptables -I INPUT 1 --dport 80 -j ACCEPT|Insert rule vào chain. Rule được insert vào như rule đầu tiên. Nói cách khác, trong ví dụ trên, rule sẽ được chèn vào làm rule 1 trong chain INPUT.|
|-L, --list|iptables -L INPUT|Liệt kê tất cả các rules trong chain chỉ định. Nếu không chỉ định chain, nó sẽ liệt kê tất cả các chain trong table. Đầu ra phụ thuộc bởi các tùy chọn khác như tùy chọn -n và -v, …|
|-F, --flush|iptables -F INPUT|xóa tất cả các rule trong chain chỉ định trong bảng chỉ định.|
|-Z, --zero|iptables -Z INPUT|This command tells the program to zero all counters in a specific chain, or in all chains.|
|-N, --new-chain|iptables -N allowed|Câu lệnh nói với kernel tạo chain mới với tên được chỉ định trong table chỉ định. Trong ví dụ trên, chúng ta tạo chain được gọi là allowed. Tên của chain mới không được giống tên của chain và target đã tồn tại.|
|-X, --delete chain|iptables -X allowed|Xóa chain được chỉ định từ tables. Bạn phải xóa tất cả các rule của chain trước khi xóa chain. Nếu lệnh này sử dụng với không tùy chọn, tất cả các chains được xây dựng sẽ bị xóa.|
|-P, --policy|iptables -P INPUT DROP|Câu lệnh nói với kernel để thiết lập target mặc định, hoặc policy của chain. Tất cả các gói tin không phù hợp với bất kỳ rule nào sẽ bị buộc phải sử dụng policy của chain. Target thường là DROP hoặc ACCEPT.|
|-E, --rename-chain|iptables -E allowed disallowed|Câu lệnh nói với iptables rằng cần thay đổi tên của chain. VD trên, tên chain được thay đổi từ **allowed** đến **disallowed**. Chú ý: Điều này sẽ không ảnh hướng đến phương thức thực tế của tables sẽ làm việc.|

\- **Option**  

|Option|các command được sử dụng với|Ý nghĩa|
|---|---|---|
|-v, --verbose|--list, --append, --insert, --delete, --replace|- Lệnh thường được sử dụng với tùy chọn **--list**. Nếu được sử dụng với tùy chọn **--list**, output sẽ là các địa chỉ interface, tùy chọn của rule và TOS masks. Lệnh **--list** cũng bao gồm bộ đếm bytes và gói tin cho mỗi rule, nếu tùy chọn **--verbose** được thiết lập. Bộ đếm sử dụng hệ số nhân K (x1000), M(x1000.000) và G (x1000.000.000). Để nhận kết quả chính xác bạn có thể sử dụng tùy chọn **-x**.|
|-x, --exact|--list|Output từ lệnh **--list** sẽ không chứa hệ số nhân K, M hoặc G. Thay vào đó, chúng ta sẽ nhận được kết quả chính xác từ các gói tin và bytes.|
|-n, --numeric|--list|Tùy chọn nói với iptables rằng đầu ra các giá trị số. Địa chỉ IP và số port sẽ được in ra sử dụng giá trị số và không sử dụng hostname, tên network hoặc tên tên ứng dụng.|
|--line-numbers|--list|Được sử dụng để đầu ra bao gồm số thứ tự dòng.|
|-c, --set-counters|--insert, --append, --replace||
|--modprobe|All||

<a name="3"></a>
# 3.Matches

<a name="3.1"></a>
## 3.1.Generic matches
|Math|Ví dụ|Ý nghĩa|
|---|---|---|
|-p, --protocol|iptables -A INPUT -p tcp|math này được sử dụng để kiểm tra giao thức. VD của protocols là TCP, UDP và ICMP. Giao thức phải là 1 trong các chỉ định TCP, UDP và ICMP. Nó cũng có thể là các giá trị được chỉ định trong file `/etc/protocols`. VD: giao thức ICP là giá trị 1, TCP là 6 và UDP là 17. Nó cũng có thể lấy giá trị **ALL**, **ALL** có nghĩa là nó phù hợp TCP, UDP và ICMP. lệnh này cũng có thể lấy 1 danh sách các giao thức được phân cách bởi dấu phẩy, như **udp,tcp**. math có thể sử dụng kí tự !. VD: --protocol ! tcp có nghĩa là để phù hợp với UDP và ICMP.|
|-s, --src, --source|iptables -A INPUT -s 192.168.1.1|Đây là so sánh nguồn, dựa trên địa chỉ IP nguồn. Nó có thể được sử dụng để so sánh 1 địa chỉ IP hoặc 1 dải địa chỉ IP. VD về 1  địa chỉ IP : 192.168.1.1 . VD về 1 dải địa chỉ IP: 192.168.0.0/24 hoặc 192.168.0.0/255.255.255.0. VD về số sánh đảo ngược: --source ! 192.168.0.0/24 , sẽ so sánh tất cả các gói tin với địa chỉ IP nguồn không đến từ dải 192.168.0.x.|
|-d, --dst, --destination|iptables -A INPUT -d 192.168.1.1|Đây là so sánh đích, dựa trên địa chỉ IP đích. Nó có thể được sử dụng để so sánh 1 địa chỉ IP hoặc 1 dải địa chỉ IP. VD về 1  địa chỉ IP : 192.168.1.1 . VD về 1 dải địa chỉ IP: 192.168.0.0/24 hoặc 192.168.0.0/255.255.255.0. VD về số sánh đảo ngược: --destination ! 192.168.0.1 , sẽ so sánh tất cả các gói tin với địa chỉ IP đích không phải 192.168.0.1.|
|-i, --in-interface|iptables -A INPUT -i eth0|So sánh này được sử dụng cho interface gói tin đến. Tùy chọn này chỉ sử dụng cho các chain INPUT, FORWARD và PREROUTING. Nếu interface không được chỉ định, nó sử giả trị giá trị là dấu +. Dấu + được sử dụng để khớp với với 1 chuỗi chữ cái và số, điều này có nghĩa là chấp nhất tất cả các gói tin mà xem xét nó đến interface nào. Dấu + cũng có thể được nối vào interface, **eth0+** sẽ là tất các thiết bị Ethernet. Chúng ta có thể đảo ngược ý nghĩa của tùy chọn với dấu !. VD: -i ! eth0 sẽ phù hợp với tất cả gói tin đến từ các interface, ngoại trừ eth0.|
|-o, --out-interface|iptables -A FORWARD -o eth0|So sánh này được sử dụng cho interface gói tin rời đi. Tùy chọn này chỉ sử dụng cho các chain OUTPUT, FORWARD và POSTROUTING. Nếu interface không được chỉ định, nó sử giả trị giá trị là dấu +. Dấu + được sử dụng để khớp với với 1 chuỗi chữ cái và số, điều này có nghĩa là chấp nhất tất cả các gói tin mà xem xét nó rời đi từ interface nào. Dấu + cũng có thể được nối vào interface, **eth0+** sẽ là tất các thiết bị eth. Chúng ta có thể đảo ngược ý nghĩa của tùy chọn với dấu !. VD: -i ! eth0 sẽ phù hợp với tất cả gói tin rời đi từ các interface, ngoại trừ eth0.|
|-f, --fragment|iptables -A INPUT -f||

<a name="3.2"></a>
## 3.2.Implicit matches

<a name="3.2.1"></a>
### 3.2.1.TCP matches
|Match|Ví dụ|Ý nghĩa|
|---|---|---|
|--sport, --source-port|iptables -A INPUT -p tcp --sport 22|So sánh **--source-port** được sử dụng để só sánh sựa trên port nguồn. Math này có thể lấy tên dịch vụ hoặc số port. Nếu bạn chỉ định tên dịch vụ, tên dịch vụ phải trong file `/etc/services`, **iptables** sẽ sử dụng file này để tìm. Nếu chỉ định port bởi số, rule sẽ tải nhanh hơn, **iptables** không phải kiểm tra tên dịch vụ. Bạn có thể sử dụng **--source-port** để chị định 1 dải **ports**, **--source-port 22:80**. Nếu bạn không chỉ định port đầu, mặc định sẽ là port 0, **--source-port :80** sẽ là port từ 0 -> 80. Nếu không chỉ định port cuối, mặc định sẽ là port là 65535, **--source-port 22:**. Nếu bạn viết **--source-port 80:22**, nó tương đường với **--source-port 22:80**. Bạn có thể đảo ngược so sánh bằng cách thêm dấu !. VD: **--source-port ! 22** nghĩa là tất cả các ports nhưng không phải port 22. hoặc **--source-port ! 22:80**|
|--dport, --destination-port|iptables -A INPUT -p tcp --dport 22|math này được sử dụng cho gói tin TCP, theo port đích. Cú pháp tương tự **--source-port**|
|--tcp-flags|iptables -p tcp --tcp-flags SYN,FIN,ACK SYN||
|--tcp-option|iptables -p tcp --tcp-option 16||

<a name="3.2.2"></a>
### 3.2.2.UDP matches
|Math|Ví dụ|Ý nghĩa|
|---|---|---|
|--sport, --source-port|iptables -A INPUT -p udp --sport 53|tương tự như TCP|
|--dport, --destination-port|iptables -A INPUT -p udp --dport 53|tương tự như TCP|

<a name="3.2.3"></a>
### 3.2.3.ICMP matches
\- Xem ICMP types tại:  http://www.faqs.org/docs/iptables/icmptypes.html  
\-  

|Math|Ví dụ|Ý nghĩa|
|---|---|---|
|--icmp-type|iptables -A INPUT -p icmp --icmp-type 8|Math này được sử dụng để chỉ ICMP type phù hợp. ICMP type có thể được xác định bằng giá trị số hoặc tên của chúng. Giá trị số được chỉ định trong RFC 792. Để xem danh sách các gái trị tên ICMP, thực hiện lệnh **iptables --protocol icmp --help**. Match này có thể được đảo ngược với dấu **!**, **--icmp-type ! 8**. Lưu ý: 1 số ICMP type đã lỗi thời.|




