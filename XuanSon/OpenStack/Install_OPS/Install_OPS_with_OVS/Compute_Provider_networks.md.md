# Networking Option 1: Provider networks




# Cấu hình Open vSwitch agent
\- Open vSwitch agent xấy dựng cơ sở hạ tầng mạng ảo layer-2 cho instances và xử lý security groups.  
\- Sửa file `/etc/neutron/plugins/ml2/openvswitch_agent.ini`, cấu hình OVS agent:  
```
[ovs]
bridge_mappings = provider:br-provider

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