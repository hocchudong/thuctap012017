# Networking Option 1: Provider networks



# MỤC LỤC
- [1.Cài đặt các thành phần](#1)
- [2.Cấu hình các thành phần server](#2)
- [3.Cấu hình Modular Layer 2 (ML2) plug-in](#3)
- [4.Cấu hình Open vSwitch agent](#4)
- [5. Cấu hình DHCP agent](#5)
- [6.Các thứ liên quan](#6)



<a name="1"></a>

# 1.Cài đặt các thành phần
\- Chạy câu lệnh sau:  
```
apt install neutron-server neutron-plugin-ml2 \
  neutron-openvswitch-agent neutron-dhcp-agent \
  neutron-metadata-agent
```

<a name="2"></a>

# 2.Cấu hình các thành phần server
\- Sửa file `/etc/neutron/neutron.conf`:  
- Trong section `[database]`, cấu hình truy cập database:  
```
[database]
# ...
connection = mysql+pymysql://neutron:Welcome123@controller/neutron
```

- Trong section `[DEFAULT]`, kích hoạt Modular Layer 2 (ML2) plug-in và disable các plug-ins bổ sung:  
```
[DEFAULT]
# ...
core_plugin = ml2
service_plugins =
```

- Trong section `[DEFAULT]`, cấu hình `RabbitMQ` truy cập message queue:  
```
[DEFAULT]
# ...
transport_url = rabbit://openstack:Welcome123@controller
```

- Trong section `[DEFAULT]` và `[keystone_authtoken]`, cấu hình truy cập Identity service:  
```
[DEFAULT]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = Welcome123
```

- Trong section `[DEFAULT]` và `[nova]`, cấu hình Networking để thông báo cho Compute về việc thay đổi topology mạng:  
```
[DEFAULT]
# ...
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[nova]
# ...
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = Welcome123
```

<a name="3"></a>

# 3.Cấu hình Modular Layer 2 (ML2) plug-in
\- ML2 plug-in sử dụng Open vSwitch mechanism để xây dựng layer-2.  
\- Cấu hình drivers và loại network:  
```
[ml2]
type_drivers = flat,vlan
tenant_network_types =
mechanism_drivers = openvswitch
extension_drivers = port_security
```

- Cấu hình network mappings:  
```
[ml2_type_flat]
flat_networks = provider

[ml2_type_vlan]
network_vlan_ranges = provider
```

>Chú ý:  
>- `tenant_network_types` option không chứa giá trụ bởi vì kiến trúc này không hỗ self-service network.  
>- Giá trị `provider` trong `network_vlan_ranges` option thiếu VLAN ID ranges để hỗ trợ sử dụng VLAN IDs tùy ý.

<a name="4"></a>

# 4.Cấu hình Open vSwitch agent
\- Open vSwitch agent xấy dựng cơ sở hạ tầng mạng ảo layer-2 cho instances và xử lý security groups.  
\- Sửa file `/etc/neutron/plugins/ml2/openvswitch_agent.ini`, cấu hình OVS agent:  
```
[ovs]
bridge_mappings = provider:br-provider

[securitygroup]
firewall_driver = iptables_hybrid
```

<a name="5"></a>

# 5. Cấu hình DHCP agent
\- Sửa file `/etc/neutron/dhcp_agent.ini`, cấu hình DHCP agent:  
```
[DEFAULT]
interface_driver = openvswitch
enable_isolated_metadata = True
force_metadata = True
```

<a name="6"></a>

# 6.Các thứ liên quan
\- Start service Open vSwitch.  
\- Tạo OVS privider bridge `br-provider`:  
```
ovs-vsctl add-br br-provider
```

\- Thêm provider network interface như 1 port trên OVS provider bridge `br-provider`:  
```
ovs-vsctl add-port br-provider PROVIDER_INTERFACE
```

Thay `PROVIDER_INTERFACE` với tên của interface xử lý provider network, trong mô hình này là `ens3`.  

\- Chuyển địa chỉ IP của network interface `ens3` sang cho vswitch `br-provider`:  
```
ip a flush ens3
ip a add 192.168.2.71/24 ens3
```

>Chú ý:  
Tuy tạo vswith và gán interface với Open vSwitch khi restart lại server sẽ không bị mất, nhưng gán địa chỉ IP cho vswitch sau khi restart lại server sẽ bị mất, muốn sau khi restart lại server không mất, thay vì tạo vswitch, gán interface, gán địa chỉ IP bằng câu lệnh, ta comment các dòng cấu hình interface `ens3` ghi vào file `/etc/network/interfaces` như sau, sau đó restart lại server:  
```
auto br-provider
allow-ovs br-provider
iface br-provider inet static
    address 192.168.2.71
    netmask 255.255.255.0
    gateway 192.168.2.1
    dns-nameservers 8.8.8.8
    ovs_type OVSBridge
    ovs_ports ens3

allow-br-provider ens3
iface ens3 inet manual
    ovs_bridge br-provider
    ovs_type OVSPort
```















