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