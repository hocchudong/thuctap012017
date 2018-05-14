# Template cơ bản

# MỤC LỤC
- [1.Quản lý network](#1)
  - [1.1. Tạo network và subnet](#1.1)
  - [1.2.Tạo router và kết nối subnet đến router](#1.2)
  - [1.3.Tạo router, tạo port trên subnet và kết nối port đến router](#1.3)
  - [1.4.Tạo network hoàn chỉnh](#1.4)
- [2.Quản lý instance](#2)
  - [2.1.Tạo instance và kết nối instance đến network](#2.1)
  - [2.2.Tạo instance, tạo port, kết nối instance đến port](#2.2)
  - [2.3.Tạo và kết nối floating IP đến instance](#2.3)
  - [2.4.Tạo keypair và tạo instance sử dụng keypair đó](#2.4)
  - [2.5.Tạo network, router, instance](#2.5)
- [3.Quản lý volume](#3)
  - [3.1.Tạo volume](#3.1)
  - [3.2.Gắn volume đến instance](#3.2)
  - [3.3.Boot instance từ volume](#3.3)


<a name="1"></a>
# 1.Quản lý network

<a name="1.1"></a>
## 1.1. Tạo network và subnet
```
heat_template_version: 2017-09-01

description: >
  Create a new network with subnet 
  subnet address is "10.1.0.0/24"

parameters:
  cidr:
    type: string
    label: Network CIDR
    description: The CIDR of the private network.
    default: "10.1.0.0/24"
  dns:
    type: comma_delimited_list
    label: DNS nameservers
    description: Comma separated list of DNS nameservers for the private network.
    default: "8.8.8.8,8.8.4.4"
  
resources:
  new_network:
    type: OS::Neutron::Net 
  new_subnet:
    type: OS::Neutron::Subnet 
    properties:
      network: {get_resource: new_network}
      cidr: {get_param: cidr}
      dns_nameservers: {get_param: dns}
      ip_version: 4

outputs:
  new_network_show:
    description: Info network
    value: {get_attr: [new_network , show]}
  new_subnet_show:
    description: Info subnet
    value: {get_attr: [new_subnet , show]}
```

<a name="1.2"></a>
## 1.2.Tạo router và kết nối subnet đến router
\- Tạo router:  
```
heat_template_version: 2017-09-01

description: >
  Create a new router 

parameters:
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"

resources:
  new_router:   
    type: OS::Neutron::Router
    properties:
      external_gateway_info: {"network": {get_param: public_network}}

outputs:
  new_router_show:
    description: Info router
    value: {get_attr: [new_router , show]}
```

\- Tạo router và kết nối subnet đến router:  
```
heat_template_version: 2017-09-01

description: >
  Create a new router with name : newrouter 
  add subnet to router

parameters:
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"
  subnet:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "subnet-private"

resources:
  new_router:   
    type: OS::Neutron::Router
    properties:
      external_gateway_info: {"network": {get_param: public_network}}

  subnet_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router: {get_resource: new_router}
      subnet: {get_param: subnet}

outputs:
  new_router_show:
    description: Info router
    value: {get_attr: [new_router , show]}
```

<a name="1.3"></a>
## 1.3.Tạo router, tạo port trên subnet và kết nối port đến router
```
heat_template_version: 2017-09-01

description: >
  Create a port

parameters:
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"
  private_network:
    type: string
    label: Network name
    description: Name of network
    default: "network-subnet-new_network-5lwg44ouk7la"
  subnet_private_network:
    type: string
    label: Subnet name
    description: Subnet of network
    default: "network-subnet-new_subnet-rnkhn6kzwjf2"
  
resources:
  new_router:   
    type: OS::Neutron::Router
    properties:
      external_gateway_info: {"network": {get_param: public_network}}
  new_port:
    type: OS::Neutron::Port
    properties:
      network: {get_param: private_network}
      fixed_ips:
        - "subnet_id": {get_param: subnet_private_network}
  router_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router_id: {get_resource: new_router}
      port: {get_resource: new_port}

outputs:
  new_port_show:
    description: Info port
    value: {get_attr: [new_port , show]}
```

<a name="1.4"></a>
## 1.4.Tạo network hoàn chỉnh
\- Network hoàn chỉnh bao gồm:
- 1 network và 1 subnet liên kết
- 1 router với external gateway
- 1 interface để subnet kết nối đến router

### a.Tempalte 1
```
heat_template_version: 2017-09-01

description: >
  Create a new network with subnet 
  subnet address is "10.1.0.0/24"

parameters:
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"
  cidr:
    type: string
    label: Network CIDR
    description: The CIDR of the private network.
    default: "10.1.0.0/24"
  dns:
    type: comma_delimited_list
    label: DNS nameservers
    description: Comma separated list of DNS nameservers for the private network.
    default: "8.8.8.8,8.8.4.4"
  
resources:
  new_network:
    type: OS::Neutron::Net 
  new_subnet:
    type: OS::Neutron::Subnet 
    properties:
      network: {get_resource: new_network}
      cidr: {get_param: cidr}
      dns_nameservers: {get_param: dns}
      ip_version: 4
  new_router:   
    type: OS::Neutron::Router
    properties:
      external_gateway_info: {"network": {get_param: public_network}}
  router_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router: {get_resource: new_router}
      subnet: {get_resource: new_subnet}

outputs:
  new_network_show:
    description: Info network
    value: {get_attr: [new_network , show]}
  new_subnet_show:
    description: Info subnet
    value: {get_attr: [new_subnet , show]}
  new_router_show:
    description: Info router
    value: {get_attr: [new_router , show]}
```

### b.Template 2
```
heat_template_version: 2017-09-01

description: >
  Create a new network with subnet 
  subnet address is "10.1.0.0/24"

parameters:
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"
  cidr:
    type: string
    label: Network CIDR
    description: The CIDR of the private network.
    default: "10.1.0.0/24"
  dns:
    type: comma_delimited_list
    label: DNS nameservers
    description: Comma separated list of DNS nameservers for the private network.
    default: "8.8.8.8,8.8.4.4"
  default_gateway:
    type: string
    label: Default gateway
    description: Default gateway
    default: 10.1.0.1
   
  
resources:
  new_network:
    type: OS::Neutron::Net 
  new_subnet:
    type: OS::Neutron::Subnet 
    properties:
      network: {get_resource: new_network}
      cidr: {get_param: cidr}
      dns_nameservers: {get_param: dns}
      ip_version: 4
  new_port:
    type: OS::Neutron::Port
    properties:
      network: {get_resource: new_network}
      fixed_ips:
        - "ip_address": {get_param: default_gateway}
  new_router:   
    type: OS::Neutron::Router
    properties:
      external_gateway_info: {"network": {get_param: public_network}}
  router_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router_id: {get_resource: new_router}
      port: {get_resource: new_port}


outputs:
  new_network_show:
    description: Info network
    value: {get_attr: [new_network , show]}
  new_subnet_show:
    description: Info subnet
    value: {get_attr: [new_subnet , show]}
  new_router_show:
    description: Info router
    value: {get_attr: [new_router , show]}
```

<a name="2"></a>
# 2.Quản lý instance

<a name="2.1"></a>
## 2.1.Tạo instance và kết nối instance đến network
```
heat_template_version: 2017-09-01

description: Create a instance

parameters:
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: "cirros"
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: "small"
  private_network:
    type: string
    label: Private network name or ID
    description: Network to attach instance to.
    default: "private"

resources:
  instance:
    type: OS::Nova::Server
    properties:
      flavor: {get_param: flavor}
      image: {get_param: image}
      networks: 
        - "network": {get_param: private_network}

outputs:
  instance_ip:
    description: Ip of instance
    value: {get_attr: [instance , networks, {get_param: private_network}, 0]}
```

\- Note:  
Khi VM có nhiều địa chỉ IP, bạn có thể lấy địa chỉ IP đầu tiên bằng cách sử dụng attribute `first_address` như sau:  
```
outputs:
  instance_ip:
    description: Ip of instance
    value: {get_attr: [instance, first_address]}
```

Bạn có thể lấy địa chỉ IP thứ 2 bằng cách sau:  
```
outputs:
  instance_ip:
    description: Ip of instance
    value: {get_attr: [instance , networks, {get_param: private_network}, 1]}
```

<a name="2.2"></a>
## 2.2.Tạo instance, tạo port, kết nối instance đến port
```
heat_template_version: 2017-09-01

description: Create a instance

parameters:
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: "cirros"
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: "small"
  private_network:
    type: string
    label: Private network name or ID
    description: Network to attach instance to.
    default: "network-new_network-rn3ehlcvqca4"
  subnet_private_network:
    type: string
    label: Subnet name
    description: Subnet of network
    default: "network-new_subnet-an2wn4ys5xgy"

resources:
  new_port:
    type: OS::Neutron::Port
    properties:
      network: {get_param: private_network}
      fixed_ips:
        - "subnet_id": {get_param: subnet_private_network}
  instance:
    type: OS::Nova::Server
    properties:
      flavor: {get_param: flavor}
      image: {get_param: image}
      networks: 	
        - "port": {get_resource: new_port}

outputs:
  instance_ip:
    description: Ip of instance
    value: {get_attr: [instance , networks, {get_param: private_network}, 0]}
```

<a name="2.3"></a>
## 2.3.Tạo và kết nối floating IP đến instance
```
heat_template_version: 2017-09-01

description: Create a instance

parameters:
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: "cirros"
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: "small"
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"
  private_network:
    type: string
    label: Private network name or ID
    description: Network to attach instance to.
    default: "network-new_network-rn3ehlcvqca4"


resources:
  instance:
    type: OS::Nova::Server
    properties:
      flavor: {get_param: flavor}
      image: {get_param: image}
      networks: 
        - "network": {get_param: private_network}
  floating_ip:
    type: OS::Neutron::FloatingIP
    properties:
      floating_network: {get_param: public_network}
  association:
    type: OS::Neutron::FloatingIPAssociation
    properties:
      floatingip_id: {get_resource: floating_ip}
      port_id: {get_attr: [instance, addresses, {get_param: private_network}, 0, port]}

outputs:
  instance_ip_floating:
    description: Floating Ip of instance
    value: {get_attr: [floating_ip , floating_ip_address]}
  instance_ip_private:
    description: Ip private of instance
    value: {get_attr: [instance , networks, {get_param: private_network}, 0]}
```

<a name="2.4"></a>
## 2.4.Tạo keypair và tạo instance sử dụng keypair đó
```
heat_template_version: 2017-09-01

description: Create a instance

parameters:
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: "cirros"
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: "small"
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"
  private_network:
    type: string
    label: Private network name or ID
    description: Network to attach instance to.
    default: "network-new_network-hahaxnut4etx"
  subnet:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "network-new_subnet-yn2uzpdy7gxb"

resources:
  instance:
    type: OS::Nova::Server
    properties:
      flavor: {get_param: flavor}
      image: {get_param: image}
      networks: 
        - "network": {get_param: private_network}
      key_name: {get_resource: my_key}
  new_router:   
    type: OS::Neutron::Router
    properties:
      external_gateway_info: {"network": {get_param: public_network}}
  subnet_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router: {get_resource: new_router}
      subnet: {get_param: subnet}
  floating_ip:
    type: OS::Neutron::FloatingIP
    properties:
      floating_network: {get_param: public_network}
  association:
    type: OS::Neutron::FloatingIPAssociation
    properties:
      floatingip_id: {get_resource: floating_ip}
      port_id: {get_attr: [instance, addresses, {get_param: private_network}, 0, port]}
  my_key:
    type: OS::Nova::KeyPair
    properties:
      save_private_key: true
      name: "my_key"


outputs:
  instance_ip_floating:
    description: Floating Ip of instance
    value: {get_attr: [floating_ip , floating_ip_address]}
  instance_ip_private:
    description: Ip private of instance
    value: {get_attr: [instance , networks, {get_param: private_network}, 0]}
  private_key:
    description: Private key
    value: {get_attr: [my_key, private_key]}
```

<a name="2.5"></a>
## 2.5.Tạo network, router, instance
```
heat_template_version: 2017-09-01

description: Create a instance

parameters:
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: "provider"
  cidr:
    type: string
    label: Network CIDR
    description: The CIDR of the private network.
    default: "10.1.0.0/24"
  dns:
    type: comma_delimited_list
    label: DNS nameservers
    description: Comma separated list of DNS nameservers for the private network.
    default: "8.8.8.8,8.8.4.4"
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: "cirros"
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: "small"


resources:
  instance:
    type: OS::Nova::Server
    properties:
      flavor: {get_param: flavor}
      image: {get_param: image}
      networks: 
        - "network": {get_resource: new_network}
      key_name: {get_resource: my_key}

  new_network:
    type: OS::Neutron::Net 
  new_subnet:
    type: OS::Neutron::Subnet 
    properties:
      network: {get_resource: new_network}
      cidr: {get_param: cidr}
      dns_nameservers: {get_param: dns}
      ip_version: 4
  new_router:   
    type: OS::Neutron::Router
    properties:
      external_gateway_info: {"network": {get_param: public_network}}
  subnet_router:
    type: OS::Neutron::RouterInterface
    properties:
      router: {get_resource: new_router}
      subnet: {get_resource: new_subnet}
  floating_ip:
    type: OS::Neutron::FloatingIP
    properties:
      floating_network: {get_param: public_network}
  association_floating_ip:
    type: OS::Neutron::FloatingIPAssociation
    properties:
      floatingip_id: {get_resource: floating_ip}
      port_id: {get_attr: [instance, addresses, {get_resource: new_network}, 0, port]}
  my_key:
    type: OS::Nova::KeyPair
    properties:
      save_private_key: true
      name: "my_key"


outputs:
  instance_ip_floating:
    description: Floating Ip of instance
    value: {get_attr: [floating_ip , floating_ip_address]}
  instance_ip_private:
    description: Ip private of instance
    value: {get_attr: [instance , networks, {get_resource: new_network}, 0]}
  private_key:
    description: Private key
    value: {get_attr: [my_key, private_key]}
```

<a name="3"></a>
# 3.Quản lý volume 

<a name="3.1"></a>
## 3.1.Tạo volume
\- Tạo volume:  
```
heat_template_version: 2017-09-01

description: >
  Create a volume

parameters:
  size:
    type: number
    label: Size of volume
    description: The size of volume
    default: 2

resources:
  my_new_volume:
    type: OS::Cinder::Volume
    properties:
      size: {get_param: size}
      description: "Volume"


outputs:
  volume_name:
    description: Name of volume
    value: {get_attr: [my_new_volume, display_name]}
```

\- Tạo bootable volume sử dụng image  
```
heat_template_version: 2017-09-01

description: >
  Create a volume

parameters:
  size:
    type: number
    label: Size of volume
    description: The size of volume
    default: 5

resources:
  my_new_volume:
    type: OS::Cinder::Volume
    properties:
      size: {get_param: size}
      description: "Volume"
      image: ubuntu16.04

outputs:
  volume_name:
    description: Name of volume
    value: {get_attr: [my_new_volume, display_name]}
```

\- Tạo volume từ volume sẵn có, chú ý là size của volume mới phải >= volume sẵn có  
```
heat_template_version: 2017-09-01

description: >
  Create a volume

parameters:
  size:
    type: number
    label: Size of volume
    description: The size of volume
    default: 5

resources:
  my_new_volume:
    type: OS::Cinder::Volume
    properties:
      size: {get_param: size}
      description: "Volume"
      source_volid: 33471582-142a-43ee-aee0-dfd8f70594b2


outputs:
  volume_name:
    description: Name of volume
    value: {get_attr: [my_new_volume, display_name]}
```

\- Tạo volume từ bản snapshot volume  
```
heat_template_version: 2017-09-01

description: >
  Create a volume

parameters:
  size:
    type: number
    label: Size of volume
    description: The size of volume
    default: 5

resources:
  my_new_volume:
    type: OS::Cinder::Volume
    properties:
      size: {get_param: size}
      description: "Volume"
      snapshot_id: 4794d5b9-1bfb-4dba-915b-454f9ededbb3


outputs:
  volume_name:
    description: Name of volume
    value: {get_attr: [my_new_volume, display_name]}
```

<a name="3.2"></a>
## 3.2.Gắn volume đến instance
```
heat_template_version: 2017-09-01

description: Create a instance

parameters:
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: "ubuntu16.04"
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: "medium"
  private_network:
    type: string
    label: Private network name or ID
    description: Network to attach instance to.
    default: "private"
  size:
    type: number
    label: Size of volume
    description: The size of volume
    default: 2


resources:
  instance:
    type: OS::Nova::Server
    properties:
      flavor: {get_param: flavor}
      image: {get_param: image}
      networks: 
        - "network": {get_param: private_network}
  volume:
    type: OS::Cinder::Volume
    properties:
      size: {get_param: size}
      description: "Volume"

  volume_attachment:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: volume }
      instance_uuid: {get_resource: instance}


outputs:
  instance_ip:
    description: Ip of instance
    value: {get_attr: [instance , networks, {get_param: private_network}, 0]}
  volume_name:
    description: Name of volume
    value: {get_attr: [volume, display_name]}
```

<a name="3.3"></a>
## 3.3.Boot instance từ volume
```
heat_template_version: 2017-09-01

description: Create a instance

parameters:
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: "cirros"
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: "small"
  private_network:
    type: string
    label: Private network name or ID
    description: Network to attach instance to.
    default: "private"
  size:
    type: number
    label: Size of volume
    description: The size of volume
    default: 2
  device_name:
    type: string
    label: Name device
    description: Name of device
    default: "vda" 


resources:
resources:
  bootable_volume:
    type: OS::Cinder::Volume
    properties:
      size: {get_param: size}
      image: {get_param: image}

  instance:
    type: OS::Nova::Server
    properties:
      flavor: {get_param: flavor}
      networks:
        - network: {get_param: private_network}
      block_device_mapping:
        - device_name: vda
          volume_id: {get_resource: bootable_volume}
          delete_on_termination: true


outputs:
  instance_ip:
    description: Ip of instance
    value: {get_attr: [instance , networks, {get_param: private_network}, 0]}
  volume_name:
    description: Name of volume
    value: {get_attr: [bootable_volume, display_name]}
```














