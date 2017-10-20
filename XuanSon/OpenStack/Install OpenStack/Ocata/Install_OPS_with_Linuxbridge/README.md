# Cài OpenStack Ocata với Linux bridge

# Mô hình
Mô hình cài đặt OpenStack Ocata gồm 2 node: Controller và Compute.

<img src="images/mo_hinh.png" />

# IP Planning
Yêu cầu phần cứng và địa chỉ IP cho các nodes.

<img src="images/ip_planning.png" />


# Cài thủ công theo hướng dẫn
[Cài OpenStack Ocata với Linux bridge](docs/Install_OPS_with_Linuxbridge.md)


# Sử dụng scripts theo hướng dẫn
Sử dụng scripts có 2 cách:  
## Cách 1
\- Download các file shell scripts. Sau đó thực hiện các bước sau với quyền root.  
[Links](scripts)

\- Set quyền 755 cho các files đó.  
```
chmod 755 *
```

\- Chỉnh sửa tên network card theo server của bạn trong file `config.cnf`.  
\- Bạn có thể cài theo mô hình **Provider netowrk** hoặc **Self-service network**:  
- Mô hình **Provider netowrk**:  
Thực thi các file bằng command như sau:  
  - Trên node **Controller**:  
  ```
  source ctl-0-ipaddr.sh
  source ctl-1-environment.sh
  source ctl-2-keystone.sh
  source ctl-3-glance.sh
  source ctl-4-nova.sh
  source ctl-5-neutron-provider.sh
  source ctl-6-horizon.sh
  ```

  - Trên node **Compute1**:  
  ```
  source com1-0-ipaddr.sh
  source com1-1-environment.sh
  source com1-2-nova.sh
  source com1-3-neutron-provider.sh
  ```

  - Sau khi cài xong trên node **Controller** và **Compute1**, thực hiện command sau để tìm kiếm các node **Compute**:  
  ```
  source ctl-4-nova_discoveryhost.sh
  ```

- Mô hình **Self-service network**:  
Thực thi các file bằng command như sau:  
  - Trên node **Controller**:  
  ```
  source ctl-0-ipaddr.sh
  source ctl-1-environment.sh
  source ctl-2-keystone.sh
  source ctl-3-glance.sh
  source ctl-4-nova.sh
  source ctl-5-neutron-selfservice.sh
  source ctl-6-horizon.sh
  ```

  - Trên node **Compute1**:  
  ```
  source com1-0-ipaddr.sh
  source com1-1-environment.sh
  source com1-2-nova.sh
  source com1-3-neutron-selfservice.sh
  ```

  - Sau khi cài xong trên node **Controller** và **Compute1**, thực hiện command sau để tìm kiếm các node **Compute**:  
  ```
  source ctl-4-nova_discoveryhost.sh
  ```

## Cách 2
\- Ý tưởng: Thực hiện cài Cài đặt các project trên node Controller, sau đó từ Controller, ta sử dụng scripts để cài các project trên node Compute.   
\- Trên node Controller  
  - download các file shell scripts theo link bên dưới. Sau đó thực hiện các bước sau với quyền root.  
[Links](scripts_ssh)

  - Set quyền 755 cho các files đó.  
```
chmod 755 CTL/*
chmod 755 COM/*
```

  - Chỉnh sửa tên network card theo server của bạn trong file `config.sh`.  

\- Trên code Compute
  - download file setup địa chỉ IP theo link bên dưới.  
[Links](scripts_ssh/COM/ip_setup.sh)

  - Thực hiện script theo cú pháp:  
  ```
  source ip_setup.sh <node_name> <NIC_name> <IP_address> <netmask> <gateway>
  ```

  Ví dụ trong trường hợp này:  
  ```
  source ip_setup.sh compute1 ens3 192.168.2.72 255.255.255.0 192.168.2.1
  ```
  
  - Yêu cầu cấu hình cho phép SSH qua root.  

\- Bạn có thể cài theo mô hình **Provider netowrk** hoặc **Self-service network**:  
  - Mô hình **Provider netowrk**, thực thi trên node Controller  
    Cài đặt các project trên node Controller:  
    ```
    cd CTL
    source ctl-provider-all.sh
    ```
    
    Cài đặt các project trên node Compute:
    ```
    cd COM
    source sshkey_setup.sh 192.168.2.72 #điền mật khẩu của user root trên node Compute
    source com-provider-all_ssh.sh 192.168.2.72
    ```

  - Mô hình **Self-service netowrk**, thực thi trên node Controller  
    Cài đặt các project trên node Controller:  
    ```
    cd CTL
    source ctl-selfservice-all.sh
    ```
    
    Cài đặt các project trên node Compute:
    ```
    cd COM
    source sshkey_setup.sh 192.168.2.72 #điền mật khẩu của user root trên node Compute
    source com-selfservice-all_ssh.sh 192.168.2.72
    ```


















