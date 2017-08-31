# Networking Option 2: Self-service networks




# Cấu hình Open vSwitch agent
\- Open vSwitch agent xấy dựng cơ sở hạ tầng mạng ảo layer-2 cho instances và xử lý security groups.  
\- Sửa file `/etc/neutron/plugins/ml2/openvswitch_agent.ini`, cấu hình OVS agent:  
```
[agent]
tunnel_types = vxlan
l2_population = True

[ovs]
bridge_mappings = provider:br-provider
local_ip = 10.10.10.72

[securitygroup]
firewall_driver = iptables_hybrid
```

\- Start service Open vSwitch.  
\- Tạo OVS provider bridge `br-provider`:  
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
ip a add 192.168.2.72/24 ens3
```

>Chú ý:  
Tuy tạo vswith và gán interface với Open vSwitch khi restart lại server sẽ không bị mất, nhưng gán địa chỉ IP cho vswitch sau khi restart lại server sẽ bị mất, muốn sau khi restart lại server không mất, thay vì tạo vswitch, gán interface, gán địa chỉ IP bằng câu lệnh, ta comment các dòng cấu hình interface `ens3` ghi vào file `/etc/network/interfaces` như sau, sau đó restart lại server:  
```
auto br-provider
allow-ovs br-provider
iface br-provider inet static
    address 192.168.2.72
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


Quay lại [**Cấu hình Neutron trên node Compute1**](Install_OPS_with_OVS.md#config_neutron_compute1)