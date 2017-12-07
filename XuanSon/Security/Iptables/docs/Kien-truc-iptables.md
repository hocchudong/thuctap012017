# Kiến trúc Iptables 

# MỤC LỤC
- [1.Tables](#1)
	- [1.1.Filter tables](#1.1)
	- [1.2.NAT tables](#1.2)
	- [1.3.Mangle table](#1.3)
	- [1.4.Raw table](#1.4)
- [2.Chain](#2)
- [3.Rules](#3)


\- Iptables chứa nhiều tables.  
Tables chứa nhiều chains.Chains có thể được tích hợp sẵn hoặc do người dùng định nghĩa.  
Chains chứa nhiều rules. Rules được định nghĩa cho các gói tin.  
\- Cấu trúc:  
iptables -> Tables -> Chains -> Rules.  

<img src="images/2.png" />

<a name="1"></a>
# 1.Tables
\- Iptables có 4 tables được xây dựng sẵn.  
<img src="images/3.png" />

<a name="1.1"></a>
## 1.1.Filter tables
\- Filter là table mặc định cho iptables. Nếu bạn không xác định tables, bạn sẽ sử dụng filter tables.  
\- Bảng này được sử dụng để lọc gói tin.  
\- Filter tables của iptables có các chains sau.  
- INPUT chain – Incoming đến firewall. Cho các gói tin đến local server.
- OUTPUT chain – Outgoing từ firewall. Cho các gói tin sinh ra ở local và đi ra khỏi local server. 
- FORWARD chain – Gói tin cho NIC khác trên local server. Cho gói tin được định tuyến thông qua local server.

\- Các target có trong bảng này:  
- DROP
- ACCEPT
- LOG
- REJECT

<a name="1.2"></a>
## 1.2.NAT tables
\- Bảng này được sử dụng cho chức năng NAT trên các gói tin khác nhau.  
\- NAT tables của iptables có các chains sau.  
- PREROUTING chain: thay đổi gói tin trước khi định tuyến. VD. Translation gói tin ngay sau khi gói tin đi vào hệ thống ( trước khi định tuyến). Điều này giúp translate địa chỉ IP đích của gói tin đến 1 cái gì đó phù hợp với việc định truyến trên local server. Điều này được sử dụng cho DNAT (destination NAT).
- POSTROUTING chain: Thay đổi gói tin sau khi định tuyến. VD. Translation gói tin xảy ra khi gói tin rời khỏi hệ thống. Điều này giúp dịch chuyển địa chỉ IP nguồn đến 1 cái gì đó phù hợp với việc định tuyến trên destination server. Điều này được sử dụng cho SNAT (source NAT).
- OUTPUT chain: NAT cho gói tin được sinh ra cục bộ trên firewall.

\- Các target có trong bảng này:  
- DNAT
- SNAT
- MASQUERADE

<a name="1.3"></a>
## 1.3.Mangle table
\- Mangle tables của Iptables dành cho những thay đổi gói tin đặc biệt. Điều này thay đổi bit QoS của TCP header.  
\- Mangle table có các chains sau.  
- PREROUTING chain
- OUTPUT chain
- FORWARD chain
- INPUT chain
- POSTROUTING chain

\- Các Targets trong bảng  
- TOS: Dùng để thay đổi trường Type of Service trong gói tin ipdatagram.
- TTL: Dùng để thay đổi trường Time To Live trong gói tin ipdatagram.
- MARK: Dùng để đặt giá trị special mark cho gói tin. Sau đó, bạn có thể đặt một số rules riêng cho những gói tin được đánh dấu.

<a name="1.4"></a>
## 1.4.Raw table
\- Bảng raw chủ yếu chỉ được sử dụng cho một điều, và đó là để thiết lập một đánh dấu trên gói tin rằng họ không nên được xử lý bởi các hệ thống theo dõi kết nối. Điều này được thực hiện bằng target `NOTRACK`.  
Khi sử dụng target NOTRACK, bạn không thể sử dụng các module theo dõi kết nối như `state` và `conntrack`.  
\- Raw tables có các chains sau.  
- PREROUTING chain
- OUTPUT chain

<a name="2"></a>
# 2.Chain
|Chain|Ý nghĩa|
|---|---|
|INPUT|những gói tin đi vào hệ thống|
|OUTPUT|những gói tin đi ra từ hệ thống|
|FORWARD|những gói tin đi qua hệ thống (đi vào một hệ thống khác|
|PREROUTING|sửa địa chỉ đích của gói tin trước khi nó được routing bởi bảng routing của hệ thống (destination NAT hay DNAT).|
|POSTROUTING|ngược lại với Pre-routing, nó sửa địa chỉ nguồn của gói tin sau khi gói tin đã được routing bởi hệ thống (SNAT).|

<a name="3"></a>
# 3.Rules
Sau đây là những điển chính cần ghi nhớ cho cho các rules của iptables.  
- Rules chứa criteria và target.
- Nếu các criteria là phù hợp, nó sẽ thực hiên target của rules này. 
- Nếu các criteria là không phù hợp, nó sẽ chutyển sang rules tiếp theo.














