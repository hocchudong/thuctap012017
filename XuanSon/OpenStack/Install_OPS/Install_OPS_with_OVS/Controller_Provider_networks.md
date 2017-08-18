# Networking Option 1: Provider networks

# MỤC LỤC


# 1.Cài đặt các thành phần
\- Chạy câu lệnh sau:  
```
apt install neutron-server neutron-plugin-ml2 \
  neutron-openvswitch-agent neutron-dhcp-agent \
  neutron-metadata-agent
```

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

# 4.Cấu hình Open vSwitch agent
\- Open vSwitch agent xấy dựng cơ sở hạ tầng mạng ảo layer-2 cho instances và xử lý security groups.  
\- Sửa file `/etc/neutron/plugins/ml2/openvswitch_agent.ini`, cấu hình OVS agent:  
```
[ovs]
bridge_mappings = provider:br-provider

[securitygroup]
firewall_driver = iptables_hybrid
```

# 5. Cấu hình DHCP agent
\- Sửa file `/etc/neutron/dhcp_agent.ini`, cấu hình DHCP agent:  
```
[DEFAULT]
interface_driver = openvswitch
enable_isolated_metadata = True
force_metadata = True
```

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














