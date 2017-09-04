# Networking Option 1: Provider networks




# Cấu hình Linux bridge agent
\- Linux bridge agent xấy dựng cơ sở hạ tầng mạng ảo layer-2 cho instances và xử lý security groups.  
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

Quay lại [**Cấu hình Neutron trên node Compute1**](Install_OPS_with_Linuxbridge.md#config_neutron_compute1)