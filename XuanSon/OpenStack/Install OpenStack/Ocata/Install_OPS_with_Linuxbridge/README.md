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

- Mô hình **Self-service network**:  
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