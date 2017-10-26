# Networking Option 2: Self-service networks




# Cấu hình Linux bridge agent
\- Linux bridge agent xây dựng cơ sở hạ tầng mạng ảo layer-2 cho instances và xử lý security groups.  
\- Sửa file `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`, làm như sau:  
- Trong section [linux_bridge], map **provider virtual network** đến **provider physical network interface**:  
```
[linux_bridge]
physical_interface_mappings = provider:PROVIDER_INTERFACE_NAME
```

Thay `PROVIDER_INTERFACE_NAME` bằng tên của **provider physical network interface**, trong bài lab này `ens3`.  
- Trong section [vxlan], enable VXLAN overlay networks, cấu hình địa chỉ IP của **physical network interface** xử lý overlay networks, enable layer-2 population:  
```
[vxlan]
enable_vxlan = true
local_ip = OVERLAY_INTERFACE_IP_ADDRESS
l2_population = true
```  

Thay `OVERLAY_INTERFACE_IP_ADDRESS` bằng địa chỉ IP của **physical network interface** xử lý overlay network trên node compute.  Trong bài lab này là `10.10.10.72`.  

- Trong section [securitygroup], enable security groups và cấu hình Linux bridge **iptables** firewall driver:  
```
[securitygroup]
# ...
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
```


Quay lại [**Cấu hình Neutron trên node Compute**](Install_OPS_with_Linuxbridge.md#config_neutron_compute)