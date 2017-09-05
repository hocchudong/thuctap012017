# Networking Option 1: Provider networks trên node Controller



# MỤC LỤC
- [1.Cài đặt các thành phần](#1)
- [2.Cấu hình các thành phần server](#2)
- [3.Cấu hình Modular Layer 2 (ML2) plug-in](#3)
- [4.Cấu hình Linux bridge agent](#4)
- [5. Cấu hình DHCP agent](#5)
- [6.Các thứ liên quan](#6)



<a name="1"></a>

# 1.Cài đặt các thành phần
\- Chạy câu lệnh sau:  
```
apt install neutron-server neutron-plugin-ml2 \
  neutron-linuxbridge-agent neutron-dhcp-agent \
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
\- ML2 plug-in sử dụng Linux bridge mechanism để xây dựng cơ sở hạng tầng mạng ảo layer-2 cho instances.  
\- Sửa file `/etc/neutron/plugins/ml2/ml2_conf.ini` và hoàn thành các hành động sau:  
- Trong section `[ml2]`, kích hoạt mạng flat và VLAN:  
```
[ml2]
# ...
type_drivers = flat,vlan
```

- Trong section `[ml2]`, disable self-service networks:  
```
[ml2]
# ...
tenant_network_types =
```

- Trong section `[ml2]`, enable Linux bridge:  
```
[ml2]
# ...
mechanism_drivers = linuxbridge
```   

- Trong section `[ml2]`, enable port security extension driver:  
```
[ml2]
# ...
extension_drivers = port_security
```

- Trong section `[ml2_type_flat]`, cấu hình provider virtual network như flat network:  
```
[ml2_type_flat]
# ...
flat_networks = provider
```

- Trong section `[ml2_type_vlan]`, cấu hình provider virtual network như vlan network:  
```
[ml2_type_vlan]
network_vlan_ranges = provider
```


>Chú ý:  
>- `tenant_network_types` option không chứa giá trụ bởi vì kiến trúc này không hỗ self-service network.  
>- Giá trị `provider` trong `network_vlan_ranges` option thiếu VLAN ID ranges để hỗ trợ sử dụng VLAN IDs tùy ý.

<a name="4"></a>

# 4.Cấu hình Linux bridge agent
\- Linux bridge agent xây dựng cơ sở hạ tầng mạng ảo layer-2 cho instances và xử lý security groups.  
\- Sửa file `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`, làm như sau:  
- Trong section [linux_bridge], map **provider virtual network** đến **provider physical network interface**:  
```
[linux_bridge]
physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME
```

Thay `PROVIDER_INTERFACE_NAME` bằng tên của **provider physical network interface**, trong bài lab này `ens3`.  
- Trong section [vxlan], disable VXLAN overlay networks:  
```
[vxlan]
enable_vxlan = false
```

- Trong section [securitygroup], enable security groups và cấu hình Linux bridge **iptables** firewall driver:  
```
[securitygroup]
# ...
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
```

<a name="5"></a>

# 5. Cấu hình DHCP agent
\- Sửa file `/etc/neutron/dhcp_agent.ini`, cấu hình DHCP agent:  
```
[DEFAULT]
# ...
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
```


Quay lại [**Cấu hình Neutron trên node Controller**](Install_OPS_with_Linuxbridge.md#config_neutron_controller)






