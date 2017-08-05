# ML2 plug-in



# MỤC LỤC
- [1.Kiến trúc](#1)
	- [1.1.ML2 driver support matrix](#1.1)
- [2.Cấu hình](#2)
	- [2.1.Network type drivers](#2.1)
		- [2.1.1.Provider network types](#2.1.1)
		- [2.1.2.Project network types](#2.1.2)
	- [2.2.Mechanism drivers](#2.2)
	- [2.3.Agent](#2.3)
		- [2.3.1.L2 agent](#2.3.1)
		- [2.3.2.L3 agent](#2.3.2)
		- [2.3.3.DHCP agent](#2.3.3)
		- [2.3.4.Metadata agent](#2.3.4)
		- [2.3.5.L3 metering agent](#2.3.5)
	- [2.4.Security](#2.4)
- [3.Reference implementations](#3)
	- [3.1.Tổng quan](#3.1)
	- [3.2.Hướng dẫn sử dụng](#3.2)
- [Tài liệu tham khảo](#tailieuthamkhao)


<a name="1"></a>

# 1.Kiến trúc
\- **Modular Layer 2 (ML2) neutron plug-in** là framework cho phép **OpenStack Networking** đồng thời sử dụng nhiều công nghệ mạng. ML2 framework phân biệt giữa 2 loại **drivers** có thể được cấu hình:  
- **Type drivers**  
Định nghĩa cách mà OpenStack network thực hiện kỹ thuật. VD: VXLAN  
Mỗi loại mạng được quản lý bởi **ML2 type driver**. Type drivers duy trì bất kỳ trạng thái mạng cụ thể nào. Chúng xác nhận thông tin cụ thể cho **provider network** và có trách nhiện phân bổ segment miễn phí trong project networks.  
- **Mechanism drivers**  
Định nghĩa mechanism truy cập OpenStack network của loại nào đó. VD: Open vSwitch mechanism driver.  
**Mechanism driver**  chịu trách nhiệm về việc lấy thông tin thiết lập bởi **type driver** và đảm bảo nó được áp dụng đúng cách với mechanisms mạng cụ thể đã được kích hoạt.  
**Mechanism driver** có thể dụng L2 agents (thông qua RPC) và/hoặc trực tiếp tương tác với thiết bị bên ngoài hoặc controllers.  

\- Nhiều mechanism và type drivers có thể được sử dụng đồng thời để truy cập cập các ports khác nhau của cùng 1 virtual network.  

<a name="1.1"></a>

## 1.1.ML2 driver support matrix
**Mechanism drivers và L2 agents**  

|type driver / mech driver|Flat|VLAN|VXLAN|GRE|
|---|---|---|---|---|
|Open vSwitch|Có|Có|Có|Có|
|Linux bridge|Có|Có|Có|Không|
|SRIOV|Có|Có|Không|Không|
|MacVTap|Có|Có|Không|Không|
|L2 population|Không|Không|Có|Có|

>Note:  
**L2 population** là mechanism driver đặc biệt nhằm tối ưu lưu lượng BUM (Broadcast, unknow destination address, multicast) trong overlay networks VXLAN và GRE. Nó cần được sử dụng kết hợp với Linux bridge hoặc Open vSwitch mechanism driver và không thể được sử dụng làm mechanism driver độc lập.  

<a name="2"></a>

# 2.Cấu hình
<a name="2.1"></a>

## 2.1.Network type drivers
\- Để kích type drivers trong ML2 plug-in. Sửa file `/etc/neutron/plugins/ml2/ml2_conf.ini`:  
```
[ml2]
type_drivers = flat,vlan,vxlan,gre
```

Tham khảo tại: [Networking configuration options](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#modular-layer-2-ml2-plug-in-configuration-options)

\- Các **tyle driver** có sẵn:  
- Flat
- VLAN
- GRE
- VXLAN

<a name="2.1.1"></a>

### 2.1.1.Provider network types
Provider network cung cấp kết nối như project networks. Nhưng chỉ admin users mới có quyền quản lý những mạng này vì interface của chúng giao tiếp với cơ sở hạ tầng mạng vật lý.  
- Flat  
Admin cần cấu hình 1 danh sách các **physical network name** có thể được dụng cho provider network. Chi tiết tại: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#modular-layer-2-ml2-flat-type-configuration-options)

- VLAN  
Admin cần cấu hình 1 danh sách các **physical network name** có thể được dụng cho provider network. Chi tiết tại: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#modular-layer-2-ml2-vlan-type-configuration-options)

- GRE  
Không yêu cầu cấu hình.  
- VXLAN  
Admin có thể cấu hình VXLAN multicast group cần được sử dụng.  

>Note:  
Cấu hình VXLAN multicast group không áp dụng cho **Open vSwitch agent**.  
Hiện tại, nó không được sử dụng trong Linux bridge agent. Linux bridge agent có tùy chọn cấu hình cụ thể của nó.  

<a name="2.1.2"></a>

### 2.1.2.Project network types
\- **Project networks** cung cấp kết nối đến instance cho project cị thể. User thông thường có quản lý **project network** với sự chỉ định mà admin hoặc nhà điều hành định nghĩa cho chúng.  
\- Cấu hình **Project network** trong file cấu hình `/etc/neutron/plugins/ml2/ml2_conf.ini`  trên neutron server:  
- VLAN  
Admin cần cấu hình dải **VLAN IDs** mà có thể được sử dụng cho project network. Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#modular-layer-2-ml2-vlan-type-configuration-options)  
- GRE  
Admin cần cấu hình dải **tunnel IDs** mà có thể được sử dụng cho project network. Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#modular-layer-2-ml2-gre-type-configuration-options)  
- VXLAN    
Admin cần cấu hình dải **VXLAN IDs** mà có thể được sử dụng cho project network. Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#modular-layer-2-ml2-vxlan-type-configuration-options)  

>Note:  
Flat networks cho project không được hỗ trợ. Chúng chỉ tồn tại như provider network.

<a name="2.2"></a>

## 2.2.Mechanism drivers
\- Để kích hoạt mechanism driver trong ML2 plug-in, sửa file `/etc/neutron/plugins/ml2/ml2_conf.ini` trên neutron server:  
```
[ml2]
mechanism_drivers = ovs,l2pop
```

Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#modular-layer-2-ml2-plug-in-configuration-options)

- Linux bridge  
Không yêu cầu cấu hình bổ sung cho **mechanism driver**. Cấu hình agent bổ sung được yêu cầu. Chi tiết xem phần *L2 agent* bên dưới.  
- Open vSwitch  
Không yêu cầu cấu hình bổ sung cho **mechanism driver**. Cấu hình agent bổ sung được yêu cầu. Chi tiết xem phần *L2 agent* bên dưới.  
- SRIOV
- MacVTap
- L2 population
- Specialized

<a name="2.3"></a>

## 2.3.Agent
<a name="2.3.1"></a>

### 2.3.1.L2 agent
\- L2 agent 
L2 agent phục vụ kết nối mạng layer 2 (Ethernet) với các tài nguyên OpenStack. Nó chạy trên mỗi Network node và mỗi Compute node.  
- Open vSwitch agent  
Open vSwitch agent được cấu hình để Open vSwitch nhận ra các L2 network cho tài nguyên OpenStack.  
Cấu hình cho Open vSwitch agent trong file cấu hình `openvswitch_agent.ini`.  
Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#open-vswitch-agent-configuration-options)

- Linux bridge agent  
Linux bridge agent cấu hình Linux bridges để  Linux bridges nhận ra các L2 networks cho tài nguyên OpenStack.  
Cấu hình Linux bridge agent trong file cấu hình `linuxbridge_agent.ini`.  
Chi tiết:  [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#linux-bridge-agent-configuration-options)  

- SRIOV Nic Switch agent
- MacVTap agent

<a name="2.3.2"></a>

### 2.3.2.L3 agent
\- L3 agent cung cấp các dịch vụ layer 3 nâng cao, như virtual Router và Floating IPs. Nó yêu cầu L2 agent chạy song song.  
\- Cấu hình cho L3 agent trong file cấu hình `l3_agent.ini`.  
\- Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#l3-agent)  
<a name="2.3.3"></a>

### 2.3.3.DHCP agent
\- DHCP agent chịu trách nhiệm cho DHCP và RADVD (Router Avertisement Daemon) services. Nó yêu cầu L2 agent chạy trên cùng 1 node.  
\- Cấu hình cho DHCP agent trong file cấu hình `dhcp_agent.ini`.  
\- Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#dhcp-agent)  

<a name="2.3.4"></a>

### 2.3.4.Metadata agent
\- Metadata agent cho phép instances để truy cập cloud-int meta data và user data thông qua mạng. Nó yêu cầu chạy L2 agent trên cùng 1 node.  
\- Cấu hình cho **Metadata agent** trong file cấu hình `metadata_agent.init`.  
\- Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#metadata-agent)  

<a name="2.3.5"></a>

### 2.3.5.L3 metering agent
\- L3 metering agent cho phép đo lưu lượng layer 3. Nó yêu chạy L3 agent trên cùng 1 node.  
\- Cấu hình cho L3 metering agent trong file cấu hình `metering_agent.ini`.  
\- Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#metering-agent)  

<a name="2.4"></a>

## 2.4.Security
L2 agent hỗ trợ cấu hình bảo mật:  
- Security Groups  
Chi tiết: [Configuration Reference](https://docs.openstack.org/ocata/config-reference/networking/networking_options_reference.html#security-groups)  

- Arp Spoofing Prevention  
Được cấu hình trong cấu hình L2 agent.  

<a name="3"></a>

# 3.Reference implementations
<a name="3.1"></a>

## 3.1.Tổng quan
\- Trong section này, sự phối hợp của **mechanism driver** và **L2 agent** được gọi là `reference implementation`. Bảng sau liệt kê implementations này:  
**Mechanism drivers và L2 agents**  
|Mechanism Driver|L2 agent|
|---|---|
|Open vSwitch|Open vSwitch agent|
|Linux bridge|Linux bridge agent|
|SRIOV|SRIOV nic switch agent|
|MacVTap|MacVTap agent|
|L2 population|Open vSwitch agent, Linux bridge agent|

\- Bảng sau show **reference implementation** hỗ trợ non-L2 neutron agents:  
**Reference implementations và agent khác**  
|Reference ImplementationL3||DHCP agent|Metadata agent|L3 agent Metering agent|
|---|---|---|---|---|
|Open vSwitch & Open vSwitch agent|Có|Có|Có|Có|
|Linux bridge & Linux bridge agent|Có|Có|Có|Có|
|SRIOV & SRIOV nic switch agent|Không|Không|Không|Không|
|MacVTap & MacVTap agent|Không|Không|Không|Không|

>Note:  
L2 popilation không được liệt kê ở đây, vì nó không phải mechanism độc lập. Nếu các agent khsac hỗ trợ phụ thuộc và mechanism driver liên kết mà được sử dụng để liên kết port.  
Chi tiết: [OpenStack Manuals](http://docs.ocselected.org/openstack-manuals/kilo/networking-guide/content/ml2_l2pop_scenarios.html) 

<a name="3.2"></a>

## 3.2.Hướng dẫn sử dụng
Hướng dẫn này mô tả **L2 refernce implementations** đang tồn tại:  
- Open vSwitch mechanism và Open vSwitch agent  
Có thể được sử cho mạng đính kèm instance, ví dụ như các tập hợp mạng khác như routers, DHCP, etc.  
-  Linux bridge mechanism và Linux bridge agent  
Có thể được sử dụng cho 
Có thể được sử cho mạng đính kèm instance, ví dụ như các tập hợp mạng khác như routers, DHCP, etc.  
- SRIOV mechanism driver và SRIOV NIC switch agent
- MacVTap mechanism driver và MacVTap agent

<a name="tailieuthamkhao"></a>

# Tài liệu tham khảo
https://docs.openstack.org/ocata/networking-guide/config-ml2.html







