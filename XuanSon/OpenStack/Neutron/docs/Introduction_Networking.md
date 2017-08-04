# Giới thiệu Networking


# MỤC LỤC




<a name="0"></a>

# 0.Lời mở đầu
\- OpenStack Networking service cung cấp API cho phép users thiết lập và định nghĩa kết nối và địa chỉ trong cloud. Project chịu trách nhiện cho Networking services là **neutron**. OpenStack Networking xử lý tạo và quản lý cơ sở hạ tầng mạng ảo, bao gồm networks, switches, subnets, và router cho devices được quản lý bởi OpenStack Compute service (Nova). Các services nâng cao như firewalls hoặc virtual private networks (VPNs) có thể được sử dụng.  
\- OpenStack Networking gồm neutron-server, database cho lưu trữ persistent, và bất kỳ số plug-in agent, cung cấp 1 số serviceskhsc như giao tiếp với native Linux networking mechanisms, external devices và SDN controller.  
\- OpenStack Networking là hoàn toàn độc lập và có thể triển khai trên 1 server độc lập.  
\- OpenStack Networking tích với 1 số thành phần OpenStac khác:  
- OpenStack Identity service (keystone) được sử dụng cho việc xác thực và ủy quyề của API request.
- OpenStack Compute service (nova) được sử dụng cho việc cắm mõi virtual NIC trên VM đến 1 mạng cụ thể.
- OpenStack Dashboard (horizon) được sử dụng bởi admin và user để tạo và quản lý network service thông qua giao diện web.

<a name="1"></a>

# 1.Cơ bản Networking

<a name="1.1"></a>

## 1.1.Ethernet
\- Ethernet là giao thức mạng, được định nghĩa vởi tiêu chuẩnIEEE 802.3. Hầu hết các network interface cards (NICs) truyề thông bằng Ethernet.  
\- Trong mô hình OSI của giao thức mạng, Ethernet thuộc layer 2 (data link layer).  
\- Trong mạng Ethernet, các hosts kết nối với mạng truyề thông bằng cách trao đổi các frames. Mỗi host trên mạng Ethernet có 1 địa chỉ MAC duy nhất. Cụ thể, mỗi virtual machine (VM) trong môi trường OpenStack có 1 địa chỉ MAC duy nhất.  
\- Ngày trước, mạng Ethernet như một bus đơn mà mỗi hosts kết nối với nhau. Tuy nhiên, ngày nay, người ta đã thay thế bằng switch, trong đó các hosts kến nối trực tiếp đến switch.  
\- Trong mạng Ethernet, mỗi host trên mạng có thể gửi frame trực tiếp đến host khác. Mạng Ethernet cũng hỗ trợ broadcast để 1 host có thể gửi frame đến mỗi host khác bằng cách chỉ định địa chỉ MAC đích là ff:ff:ff:ff:ff:ff. ARP và DHCP là 2 giao thức được sử dụng trong Ethernet broadcast. Vì Ethernet network hỗ trợ broadcast nên người ta còn gọi mạng Ethernet là **brodcast domain**.  
\- Khi NIC nhận được Ethernet frame, mặc định NIC kiểm tra địa chỉ MAC định có khớp với địa chỉ của NIC (hoặc địa chỉ broadcast), và Ethernet frame bị hủy nếu không phù hợp.  
Đối với compute host, hành vi này là không phù hợp bởi vì farme có thể được dành cho 1 trong các trường hợp sau:  
- Các Nics có thể được cấu hình ở `promiscuous mode`, nơi chúng truyền tất cả Ethernet frames đến hệ điều hành, ngay cả khi địa chỉ MAC không khớp. Compute hosts sẽ luôn phải có các NIC thích hợp được cấu hình cho `promiscuous mode`.  

<a name="1.2"></a>

## 1.2.VLAN
\- VLAN là công nghệ mạng cho phép 1 switch hoạt động như thể nó là nhiều switch độc lập. Cụ thể, 2 hosts kết nối đến cùng 1 switch nhưng trên VLANs khác nhau sẽ không thể giao tiếp với nhau. OpenStack tạn dụng VLANs để cô lập lưu lượng giữa các projects khác nhau, kể cả các projects trên cùng 1 compute host. Mỗi VLAN có 1 ID, từ 1 đến 4095.  
\- 1 switchport được cấu hình để truyề frames từ tất cả các VLAN IDs được gọi là **trunk port**. IEEE 802.1Q là tiêu chuẩn mạng mô tả cách thức VLAN tags được mã hóa trong các khung Ethernet khi trunking được sử dụng.  
\- Chú ý: Nếu bạn sử dụng VLANs trên physical switches để cô lập project trong OpenStack cloud, bạn phải đảm bảo rằng tất cả các switchports của bạn được cấu hình như các cổng trunks.  

<a name="1.3"></a>

## 1.3.Subnets và ARP
\- Trong khi NICs sử dụng địa chỉ MAC để xác định địa chỉ mạng hosts, ứng dụng TCP/IP sử dụng địa chỉ IP. Address Resolution Protocol (ARP) là cầu nối giữa Ethernet và IP bằng cách dịch địa chỉ IP thành địa chỉ MAC.  
\- Địa chỉ IP được chia thành 2 phần: `network number` và `host identifier`. 2 hosts nằm trên cùng 1 **subnet** nếu chúng có cùng 1 `network number`. 2 host chỉ có thể truyền thông trực tiếp qua Ethernet nếu chúng ở trên cùng 1 local network. ARP giả định tất cả PC trong cùng 1 subnet đều nằm trong 1 local network. Người qunar trị mạng phải gắn địa chỉ IP và netmasks cho hosts để 2 hosts nằm trong cùng 1 subnet đều nằm trên cùng 1 local network, nếu không ARP không hoạt động đúng.  
\- Có 2 cú phép để thể hiện netmask:  
- dotted quad (VD: 255.255.255.0)
- classless inter-domain routing (CIDR) (VD: 192.168.1.5/24)

>Note:  
CIDR subnets bao gồm địa chỉ multicast hoặc địa chỉ loopback là không được sử dụng trong môi trường OpenStack.  
Ví dụ: không tạo được subnet 224.0.0.0/16 hoặc 127.0.1.0/24.  

<a name="1.4"></a>

## 1.4.DHCP
\- Hosts kết nối mạng sử dụng **Dynamic Host Configuration Protocol (DHCP)** để tự động nhận địa chỉ IP.  
\- DHCP clients xác định vị trí DHCP server bằng cách gửi UDP packet từ port 68 đến địa chỉ `255.255.255.255` trên port 67. Địa chỉ `255.255.255.255` là địa chỉ broadcast mạng, tất cả hosts trên local network nhìn UDP packet gửi đến địa chỉ này. Tuy nhiên, packets này sẽ không được forward đến mạng khác. Do đó, DHCP server phải trên cùng local network như client, hoặc server sẽ không nhận được broadcast.  
\- OpenStack sử dụng chương trình của bên thứ 3 là **dnsmasq** (http://www.thekelleys.org.uk/dnsmasq/doc.html) để làm DHCP server. Dnsmasq ghi vào syslog nên bạn có thể quan sát DHCP request và reply.  
```
Apr 23 15:53:46 c100-1 dhcpd: DHCPDISCOVER from 08:00:27:b9:88:74 via eth2
Apr 23 15:53:46 c100-1 dhcpd: DHCPOFFER on 10.10.0.112 to 08:00:27:b9:88:74 via eth2
Apr 23 15:53:48 c100-1 dhcpd: DHCPREQUEST for 10.10.0.112 (10.10.0.131) from 08:00:27:b9:88:74 via eth2
Apr 23 15:53:48 c100-1 dhcpd: DHCPACK on 10.10.0.112 to 08:00:27:b9:88:74 via eth2
```

<a name="1.5"></a>

## 1.5.IP
\- Internet Protocol (IP) xác định cách định tuyến giữa các hosts mà được kết nối với local networks khác nhau. IP dựa trên network host đặc biệt gọi là routers hoặc gateway. 1 router là 1 host mà được kết nối đến ít nhất 2 local network và có thể forward IP packets từ 1 local network này đến local network khác. 1 router có nhiều địa chỉ IP, 1 cho mỗi mạng nó được kết nối.  
\- Trong mô hình OSI của giao thức mạng, giao thức IP nằm ở layer 3 (network layer).  
\- 1 host gửi packet đến địa chỉ IP sẽ tham khảo **routing table** của nó để xác định máy tính nào trên local network sẽ được nhận packet này. **Routing table** duy trì danh sách các  subnets liên kết với mỗi local network mà host được kết nối trực tiếp, cũng như 1 danh sách của định tuyến nằm trên các local network.  
\- Trên hệ điều hành Linux, có 1 vài command để show bảng routing:  
```
ip route show
route -r
netstat -rn
```

VD:  
```
root@ubuntu:~# ip route show
default via 172.16.69.1 dev ens33 onlink
172.16.69.0/24 dev ens33  proto kernel  scope link  src 172.16.69.101
192.168.122.0/24 dev virbr0  proto kernel  scope link  src 192.168.122.1 linkdown
```

\- Dòng 1 chỉ định vị chí của default route, rule định tuyến này được sử dụng nếu không có rule nào phù hợp. Routẻ liên kết với default route (`172.16.69.1`) được gọi là **default gateway**. DHCP server truyền địa chỉ của **default gateway** đến DHCP client cùng với địa chỉ IP client và netmask.  
\- Dòng 2 chỉ định IPs trong subnet `172.16.69.0/24` trên local network liên kết với network interface ens33.
\- Dòng 2 chỉ định IPs trong subnet `192.168.122.0/24` trên local network liên kết với network interface virbr0.  

<a name="1.6"></a>

## 1.6.TCP/UDP/ICMP
\- **Transmission Control Protocol** (TCP) là giao thức lớp 4 được sử dụng phổ biến trong các ứng dụng mạng. TCP là giao thức connection-oriented: nó sử dụng mô hình client-server. Sự tương tác dựa trên TCP tiến hành như sau:  
- 1.Client kết nối đến server.
- 2.Client và server trao đổi dữ liệu.
- 3.Client hoặc server hủy kết nối.

\- Bởi vì host có nhiều ứng dụng chạy trên TCP, TCP sử dụng **ports** để xác định duy nhất các ứng dụng dựa trên TCP. 1 TCP port là 1 số trong khoảng 1-65535, chỉ 1 ứng dụng trên host có thể liên kết với 1 TCP port tại 1 thời điểm.  
\- TCP server lắng nghe trên port. Ví dụ: SSH server lắng nghe trên port 22. Client kết nối đến server sử dụng TCP, client phải biết địa chỉ IP của server và TCP port của server.  
\- Hệ điều hành của ứng dụng TCP client sẽ tự động gán 1 port number cho client. Client sẽ sở hữu port number này cho đến khi kết nối TCP được chấm dứt, sau đố hệ điều hành phục gồi port number đó. Loại ports này gọi là **ephemeral port**.  
\- IANA duy trì việc đăng kí port number cho nhiều dịch vụ dựa trên TCP. Việc đăng kí Tcp port number là không bắt buộc, nhưng đăng kí port number sẽ tránh được va chạm với các dịch vụ khác. TCP ports mặc định được sử dụng cho các dịch vụ khác nhau tham giao vào việc triển khai OpenStack.  
\- API phổ biến nhất để viết các ứng dụng dựa trên TCP là **Berkeley sockets**, được gọi là BSD sockets hoặc sockets. TCP là giao thức đáng tin cậy vì nó sẽ truyền lại packets bị mất hoặc bị lỗi trên đường truyền.  
\- UDO là giao thức lớp 5 khác. UDP là giao thức **connectionless**: 2 ứng dụng giao tiếp qua UDP không cần thiết lập kết nối trước khi trao đổi dữ liệu. UDP là giao thức không đáng tin cậy. Hệ điều hành không phát lại hoặc thậm chí không phát hiện UDP packets bị mất. Hệ điều hành cũng không đảm bảo rằng ứng dụng nhận các UDP packet theo đúng thứ tự mà chúng được gửi.  
\- UDP và TCP đều sử dụng ports để phần biệt các ứng dụng khác nhau đang chạy trên cùng hệ thống. Tuy nhiên, hệ điều hành xử lý UDP port tách biệt với TCp port. Ví dụ: 1 ứng dụng được liên kết với TCP port 16543 và 1 ứng dụng được liên kết với UDP port 16543. 
\- Tương tự TCP, sockets API là API phổ biến để viết các ứng dụng dựa trên UDP.  
\- DHCP, DNS, Network Time Protocol (NTP), và VXLAN là những giao thức dựa trên UDP trong môi trường OpenStack.  
\- ICMP là giao thức được sử dụng để gửi các thông điệp điều khiển qua mạng IP.  
VD: 1 router nhận được gói tin IP có thể gửi gói tin ICMP về nguồn nếu không có tuyến đường trong bảng routing của router tương ứng với địa chỉ đích hoặc gói tin quá lớn cho router xử lý.  


<a name="2"></a>

# 2.Các thành phần mạng
<a name="2.1"></a>

## 2.1.Switches
Switches là thiết bị Multi-Input Multi-Output (MIMO) cho phép truyền packet từ 1 node đến 1 node khác. Switches hoạt động ở lớp 2 trong mô hình mạng. Chúng chuyển tiếp lưu lượng dựa trên địa chỉ Ethernet đích trong packet header.  

<a name="2.2"></a>

## 2.2.Router
Router là thiết bị cho phép packet đi từ mạng lớp 3 này đến mạng lớp 3 khác. Router cho phéo giao tiếp giữa 2 node trên các mạng lớp 3 khác nhau không kết nối trực tiếp với nhau. Router hoạt động ở lớp 3 trong mô hình 3.Chúng định tuyến dựa trên địa chỉ IP đích trong packet header.

<a name="2.3"></a>

## 2.3.Firewalls
Firewalls được sử dụng để điều khiển lưu lượng truy cập đến và đi từ máy chủ hoặc mạng. Firewall có thể là thiết bị chuyên dụng hoặc software-based filtering mechanism implemented được hiện bởi hệ điều hành. Firewall được sử dụng để hạn chế lưu lượng truy cập đến máy chủ dựa trên các rules được định nghĩa trên máy chủ. Chúng lọc packet dựa trên địa chỉ IP nguồn, địa chỉ IP đích, port number, trạng thái kết nối, etc. Cacs hệ điều hành Linux thực hiện tường lửa thông qua iptables.

<a name="2.4"></a>

## 2.4. Load balancers
Load balancers có thể là phần mềm hoặc thiết bị phần cứng cho phép lưu lượng truy cập được phần phối đồng đều trên nhiều server. Bằng cách phần phối lưu lượng truy cập trên nhiều server, nó tránh quá tải cho 1 server.  

<a name="3"></a>

## 3.Overlay (tunnel) protocols
<a name="3.1"></a>

## 3.1.Generic routing encapsulation (GRE)
Generic routing encapsulation (GRE) là giao thức chạy trên IP và được sử dụng để tạo kết nối point-to-point bảo mật. 

<a name="3.2"></a>

## 3.2.Virtual extensible local area network (VXLAN)
VXLAN là giao thức overlay lớp 2 qua mạng lớp 3.

<a name="4"></a>

# 4.Network namspaces
<a name="4.1"></a>

## 4.1.Linux network namespaces
\- Network namespaces là 1 trong 7 loại đã nói ở phần trên. Network namespaces ảo hóa mạng. Trên mỗi network namespaces chứa duy nhất 1 loopback interface.  
\- Mỗi network interface (physical hoặc virtual) có duy nhất 1 namespaces và có thể di chuyển giữa các namespaces.  
\- Mỗi namespaces có 1 bộ địa chỉ IP, bảng routing, danh sách socket, firewall và các nguồn tài nguyên mạng riêng.  
\- Khi network namespaces bị hủy, nó sẽ hủy tất cả các virtual interfaces nào bên trong nó và di chuyển bất kỳ physical interfaces nào trở lại network namespaces root.  

<a name="4.2"></a>

## 4.2.Virtual routing and forwarding (VRF)
Trong networking, khái niệm tương tự network namespaces của Linux là VRF - Virtual Routing and Forwarding, là một tính năng cấu hình được trên các router như của Cisco hoặc Alcatel-Lucent, Juniper,...VRF là một công nghệ IP cho phép tồn tại cùng một lúc nhiều routing instance trong cùng 1 router ở cùng một thời điểm (multiple instances of a routing table). Do các routing instances này là độc lập nên nó cho phép sự chồng lấn về địa chỉ IP subnet trên các intefaces của router mà không gặp tình trạng xung đột. Có thể hiểu VRF giống như VMWare cho router vậy, còn các routing instances tương tự như các VMware guest instances, hoặc cũng có thể hiểu nó tương tự như VLANs tuy nhiên VRF hoạt động ở layer 3.

<a name="5"></a>

# 5.Network address translation
\- NAT là quá trình thay đổi địa chỉ nguồn hoặc địa chỉ đích trong header của gói tin IP. Nói chung, các ứng dụng của người gửi và người nhận không nhận biết được rằng gói tIP đnag được thao tác.  
\- NAT thường được thực hiện bởi router. Tuy nhiên, trong OpenStack thường là Linux server thực hiện chức năng NAT, không phải hardware router. Server sử dụng gói phần mềm iptables để thực hiện chức năng NAT.  

<a name="5.1"></a>

## 5.1.SNAT
\- **Source Network Translation** (SNAT) , NAT router sửa đổi địa chỉ IP của bên gửi trong gói tin IP. SNAT thường được sử dụng để cho phép các địa chỉ private kết nối với servers trên public Internet.  
\- RFC 1918 quy định 3 dỉa subnets sau là địa chỉ private:  
- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16

\- OpenStack sử dụng SNAT để cho phép các ứng dụng chạy bên trong instances có thể kết nối public Internet.  

<a name="5.2"></a>

## 5.2.DNAT
\- **Destination Network Address Translation** (DNAT), NAT router thay dổi địa chỉ IP đích trong header gói tin IP.  
\- OpenStack sử dụng DNAT để định tuyến gói tin từ instances đến OpenStack metadata service. 

## One-to-one NAT
Trong **one-to-one NAT**, NAT router duy trù mapping giữa địa chỉ IP private và địa chỉ IP public. OpenStack sử dụng **one-to-one NAT** để thực hiện **địa chỉ IP floating**.  

<a name="6"></a>

# 6.OpenStack Networking
\- OpenStack Networking cho phép bạn tạo và quản lý network objects, như networks, subnets, và ports.  
\- Networking service, tên là **neutron**, cung cấp API cho php bạn xác định kết nối mạng và địa chỉ trong cloud. Networking service cho phép các nhà vận hành vận dụng các công nghệ networking khác để cung cấp cho cloud networking của họ. Networking service cũng cung cấp API để cấu hình và quản lý nhiều dịch vụ mạng khác nhau, từ L3 forwarding và NAT đến load balancing, firewalls, và virtual private networks.  
\- Nó bao gồm các thành phần:  
- API server:  
OpenStack Networking API bao gồm hỗ trợ **Layer 2 networking** và **IP address management (IPAM)**, cũng như 1 phần mở rộng cho **Layer 3 router** cho phép routing giữa các **Layer 2 networking**. OpenStack Networking bao gồm 1 danh sách các plug-in cho phép tương tác với các công nghệ mạng mã nguồn mở khác nhau, bao gồm routers, virtual switches, và software-defined networking (SDN) controllers.
- OpenStack Networking plug-in và agents:  
Plugs và unplugs ports, tạo network hoặc subnets, và cung cấp địa chỉ IP. Plug-in và agents được chọn khác nhau tùy thuộc và nhà cung cấp và công nghệ được sử dụng trong cloud cụ thể. Điều quan trọng cần đề cập là chỉ có thể sử dụng 1 plug-in trong 1 thời điểm.  
- Messaging queue:  
Cấp nhận và định tuyến các yêu cầu RPC giữa các agents để hoàn thành các hoạt động API. Message queue là được sử dụng trong **Ml2 plug-in** cho RPC giữa neutron server và neutron agents chạy trên mỗi hypervisor, **ML2 mechanism drivers** cho **Open vSwitch** và **Linux bridge**.  

<a name="6.1"></a>

## 6.1.Khái niệm
Để cấp hình topology mạng phong phú, bạn có thể tạo và cấu hình networks và subnets và hướng dẫn các dịch vụ OpenStack khác như Compute để gắn các **virtual device** đến ports trên networks này. **OpenStack Compute** là đối tượng sử dụng **OpenStack Networking** để cung cấp kết nối cho instqance của nó. Đặc biệt, OpenStack Networking hỗ trợ mỗi project có nhiều private network và cho phép projects chọn địa chỉ IP của riêng họ, ngay cả khi những địa chỉ IP đó chống chéo với những projects khác sử dụng. Có 2 loại network, **project** và **provider** network. 

<a name="6.1.1"></a>

### 6.1.1.Provider networks
\- Provider network cung cấp khả năng kết nối layer-2 đến instance với sự hỗ trợ tùy chọn cho DHCP và metadata service. Mạng này kết nối, hoặc map, với các mạng layer-2 hiện có trong data center, thường sử dụng tính năng VLAN (802.1q) tagging để xác định và tách chúng.  
\- Provider network cung cấp nói chung cung cấp sự đơn giản, hiệu năng và độ tin cậy với chi phí linh hoạt. Bởi mặc định, chỉ có admin có thể tạo hoặc cập nhật các **provider network** bởi vì cấu hình yêu cầu của cở sở hạ tầng physical network. Có thể thay đổi user cho phép tạp hoặc cập nhật **provider network** với sự thay đổi parameters của `policy.json`:  
- create_network:provider:physical_network
- update_network:provider:physical_network

> Việc tạo và sửa đổi **provoder network** cho phép sử dụng các tài nguyên mạng vật lý như VLANs. CHo phéo những thay đổi này chỉ dành cho những tenants đáng tin cậy.  

\- Ngoại ra, **provider network** chỉ xử lý kết nối layer-2 cho các instances, do đó thiếu sự hỗ trợ như routers và địa chỉ floating IP.  
\- Nói chung, các thành phàn phần mềm OpenStack Networking xử lý các hoạt động layer-3 ảnh hướng đến hiệu năng và độ tin cậy. Để cải hiện hiệu năng và độ tin cậy, provider network di chuyển hoạt động layer-3 đến cơ sở hạ tầng mạng vật lý.  
\- Trong 1 trường hợp cụ thể, triển khai OpenStack tồn tại trong 1 môi trường hỗ hợp với virtualization và bare-metal hosts sử dụng 1 cơ sở hạ tầng mạng vật lý cỡ lớn. Ứng dụng chạy trong triển khai OpenStack có thể yêu cầu truy cập trực tiếp layer-2, thông thường sử dụng VLAN, cho các ứng dụng bên ngoài triển khai.  

<a name="6.1.2"></a>

### 6.1.2.Routed provider network
\- Định tuyến **provider network** cung cấp kết nối layer-3 đến instances. Network này map mạng layer-3 đã tồn tại trong data center. Chính xác hơn, network maps đến nhiều segments layer-2, mỗi trong số đó về cơ bản là **provider network**.  

<a name="6.1.3"></a>

### 6.1.3.Self-service networks
\- **Self-service networks** chủ yếu cho phép các projects chung (không có đặc quyền) để quản lý mạng mà không cần đến admin. Các mạng này hoàn toàn là virtual và yêu câu virtual routers tương tác với provider và các magnj bên ngaofi Internet. **Self-service networks** cũng thường cung cấp các DHCP và metadata services đến instances.  
\- Trong hầu hết các trường hợp, self-service networks sử dụng *overlay protocol* như VXLAN và GRE bởi vì chugn có thể hỗ trợ nhiều mạng hơn layer-2 segementation bwangf cách sử dụng VLAN tagging (802.1q). Hơn nữa, các VLAN thường yêu cầu cấu hình bổ sung của cơ sở hạ tầng mạng vật lý.  
\- IPv4 **self-service network** sử dụng dải địa chỉ private IP và tương tác với **provider network** thông qua *source NAT* trên **virtual routers**. **Địa chỉ Floating IP** cho phép truy cập đến instance từ provider networks thông *destionation NAT* trên **virtual router**.   
IPv6 **self-service network** luôn sử dụng dải địa chỉ IP public và tương tác với các **provider network** thông qua **virtual router** với các *static route*.  
\- **Networking serive** thực hện routers bằng cách sử dụng **layer-3 agent**, thường là ít nhất 1 **network node**. Trái ngược với **provider network** cung cấp kết nối instances đến mạng vật lý tại layer-2, **self-service networks** phải đi qua **later-3 agent**.  
\- Users tạo ra các project network cho kết nối trong projects. Bởi mặc định, chúng được cô lập hoàn toàn và không được chia sẻ các project khác. OpenStack Networking hỗ trợ csac loại công nghệ mậng cô lập và overlay.  
- **Flat**  
Tất cả instances tren cùng 1 mạng, cũng có thể chia sẻ với các hosts. Không có VLAN tagging hoặc phần chia mạng.  
- **VLAN**  
Mạng cho phéo user tạo nhiều provider hoặc project sử dụng VLANIDs (802.1Q) tương ứng với các VLAN có trong mạng vật lý.  
- **GRE và VXLAN**  
VXLAN và GRE là giao thức đóng gói tọa ra overkay network để kích hoạt và kiểm soát giữa compute instance. 1 networking router được yêu cầu để cho phép luông lưu lượng đu ra ngoài mạng GRE hoặc VXLAN. 1 router cũng được yêu cầu để kết nối trực tiếp *project network* với *external network*. Router cung cấp khả năng kết nối trực tiếp instance từ external network sử dụng **địa chỉ floating IP**.  

<img src="../images/1.png" />

<a name="6.1.4"></a>

### 6.1.4.Subnets
Một khối các địa chỉ IP và trạng thái cấu hình liên quan. Đây cũng được gọi là native IPAM (IP Address Management) cung cấp bởi dịch vụ mạng cho project và provider network. Subnets được sử dụng để phần bổ địa chỉ IP khi các ports mới được tạo trên mạng.  

<a name="6.1.5"></a>

### 6.1.5. Subnet pools
\- End users có thể tạo subnets với bất kỳ đại chỉ IP hợp lệ. Tuy nhiên, 1 trong số các trường hợp, nó là tốt đẹp cho các admin hoặc project được định nghĩa trước pool của địa chỉ từ đó để tạo subnets với tự động cấp phát địa chỉ IP.  
\- Sử dụng **subnet pools** sẽ hạn chế những địa chỉ nào có thể sử dụng bằng cách yêu cầu mọi subnet phải nằm trong pool được xác định. Nó cũng ngăn ngừa việc tài sử dụng địa chỉ hoặc 2 subnets từ cùng pool.  
\- Đọc thêm: https://docs.openstack.org/ocata/networking-guide/config-subnet-pools.html#config-subnet-pools  

<a name="6.1.6"></a>

### 6.1.6.Ports
Port là điểm để kết nối để gắn 1 thiết bị, chẳng hạn NIC của virtual server, đến virtual network. Port cũng mô tả cấu hình mạng liên quan, chả hạn như MAC và địa chỉ IP được sử dụng trên port đó.

<a name="6.1.7"></a>

### 6.1.7.Routers
Router cung cấp virtual layer-3 services như routing và NAT giữa **self-service network** và **provider network** hoặc giữa các **self-service networks** phụ thuộc vào project. Networking service sử dụng **layer-3 agent** để quản lý routers thông qua namespaces.  

<a name="6.1.8"></a>

### 6.1.8. Security group
\- **Security groups**  cung cấp vùng lưu trữ cho *virtual firewall rules* để kiểm soát lưu lượng truy cập ingress (inbound to instance) và egress (outbound from instance) mạng ở mức port. **Security groups** sử dụng default deny policy và chỉ chứa các rules đồng ý phép lưu lượng cụ thể. FIrewall driver chuyển các *group rule* đến cấu hình cho ciing chệ lọc gói bên dưới như `iptables`.  
\- Mỗi project có chứa 1 `default` security group mà cho phép tát cả lưu lượng egress và từ chối tất cả các lưu lượng ingress. Bạn có thể thay đổi rules trong `default` security group. Nó bạn launch instance mà không có security group chỉ định, `default` security group sẽ tự động được áp dụng cho instance đó. Tương tự, nếu bạn tạo 1 port mà không chỉ định security group, `default` security group tự động được áp cho port đó.  

> Note:  
Nếu bạn sử dụng metadata service, xóa default egress rules denies truy cập đến TCP port 80 trên 169.254.169.254, như thế ngăn ngừa instances truy xuất metadata.  

\- **Security group rules** là stateful. Do đó, cho phép ingress TCP port 22 cho SSH tự động tạo lưu lượng engress và thông điệp ICMP error liên quan đến kết nối TCP.  
\- Mặc định, tất cả các security groups chứa 1 loạt các rules cơ bản và chống lừa đảo thực hiện các hành động sau:  
**Tham khảo**:  https://docs.openstack.org/ocata/networking-guide/intro-os-networking.html  

<a name="6.1.9"></a>

### 6.1.9.Extensions
**Tham khảo**:  https://docs.openstack.org/ocata/networking-guide/intro-os-networking.html  

<a name="6.1.10"></a>

### 6.1.10.DHCP
Dịch vụ DHCP quản lý địa chỉ IP cho instance trên **provider network** và **self-service network**. Networking service thực thi DHCH service sử dụng agent và quản lý `qdhcp` namespaces và `dnsmasq` service.  

<a name="6.1.11"></a>

### 6.1.11.Metadata
**Metadata service** tùy chọn cung cấp API cho instance cho các instance để lấy metadata như SSH keys.

<a name="6.2"></a>

## 6.2.Service và component hierarchy
<a name="6.2.1"></a>

### 6.2.1.Server
Cung cấp API, quản lý database,etc.

<a name="6.2.2"></a>

### 6.2.2.Plug-ins
Quản lý agents

<a name="6.2.3"></a>

### 6.2.3.Agents
\- Cung cấp layer 2/3 đến các instance.  
\- Xử lý chuyển tiếp physical-virtual network.  
\- Xử lý metadata, etc.

#### 6.2.3.1.Layer 2 (Ethernet và Switching)
\- Linux Bridge.  
\- OVS.  

#### 6.2.3.2.Layer 3 (IP và Routing)
\- L3  
\- DHCP  

#### 6.2.3.3.Miscellaneous
\- Metadata  

<a name="6.2.4"></a>

### 6.2.4.Services

#### 6.2.4.1.Routing services

#### 6.2.4.2.VPNaaS
Virtual Private Network-as-a-Service (VPNaaS) là phần mở rộng của neutron giới thiệu tính năng VPN.


#### 6.2.4.3.LBaaS
Load-Balancer-as-a-Service (LBaaS) API cung cấp và cấu hình load balancers. Việc thực hiện tham chiếu dựa trên HAProxy software load balancer.


#### 6.2.4.4.FWaaS
Firewall-as-a-Service (FWaaS) API là  API thực nghiệm cho phép adopters và nhà cung cấp thử nghiệm triển khia mạng của họ.  
<a name="7"></a>

### 7.Firewall-as-a-Service (FWaaS)
\- Plug-in Firewall-as-a-Service (FWaaS) áp dụng firewall cho các đối tượng OpenStack như projects, routers, và router ports.  

>Note:  
Dự kiến điều này mở rộng đến VM ports trong OpenStack Ocata.  

\- Các khái niệm với **OpenStack firewall** là những khái niệm về **firewall policy** và **firewall rule**. Policy là tập hợp các rules. Rule xác định tập hợp các thuộc tính (như dải port, giao thức và địa chỉ IP) tạo thành cách tiêu chí phù hợp và hành để thực hiện (đồng ý hoặc từ chối) về lưu lượng phù hợp. Policy có thể được công khai, vì vậy nó có thẻ chia sẻ giữa các projects.  
\- Firewakk thực hiện theo nhiều cách, tùy htuoojc và driver được sử dụng. VD:  
- iptables thực hiện firewall sử dụng iptable rules.  
- OpenVSwitch driver thực hiện firewall rules sử dụng flow entries trong flow tables.
- Cisco firewall driver thao túng các thiết bị của Cisco.
- VMWare driver cấu hình NSX router.

<a name="7.1"></a>

## 7.1.FWaaS v1
\- FWaaS ban đầu là v1, cung cấp bảo vệ cho router. Khi firewall được áp dụng cho 1 router, tất cả internal port được bảo vệ.  
\- Diagram dưới đây mô tả FWaaS v1. Nó minh họa lưu lượng ingress và egress cho VM2 instance:  

<img src="../images/2.png" />

<a name="7.2"></a>

## 7.2.FWaaS v2
Triển khai FWaas mới hơn là v2, cung cấp nhiều dịch vụ chi tiêt hơn. Khái niệm về **firewall** đã thay thế **firewall group** để chỉ ra rằng 1 firewall bao gồm 2 policies: ingress policy và egress policy. **FIrewall group** được áp dụng không ở router level (tất cả các ports trên router) nhưng tại port level. Hiện nay, router port có thể được chỉ định.  
Đối với Ocata, VM ports có thể được chỉ định.  

<a name="7.3"></a>

## 7.3.So sánh FWaaS v1 và v2
\- Bản sau đối chiều đặc điểm của v1 và v2.  

|Feature|v1|v2|
|---|---|---|
|Supports L3 firewalling for routers|YES|NO*|
|Supports L3 firewalling for router ports|NO|YES|
|Supports L2 firewalling (VM ports)|NO|NO**|
|CLI support|YES|YES|
|Horizon support|YES|NO|

\* : `Firewall group`**` có thể được áp dụng cho tất cả các cổng trên router nhất định để có hiệu lực này.  

** : Tính năng này được lên kế hoạch cho Ocata.  
		
\- Tham khảo cấu hình trong:  
- FWaaS v1: https://docs.openstack.org/ocata/networking-guide/fwaas-v1-scenario.html
- FWaas v2: https://docs.openstack.org/ocata/networking-guide/fwaas-v2-scenario.html

<a name="tailieuthamkhao"></a>
# Tài liệu tham khảo
https://docs.openstack.org/ocata/networking-guide/











