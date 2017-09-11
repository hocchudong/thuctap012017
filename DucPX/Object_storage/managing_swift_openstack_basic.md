# Một số thao tác quản trị Swift trên Openstack

## Mục lục
- [1. Một số thao tác cơ bản](#1)
- [2. Quản lý phân quyền trên container](#2)
- [3. Sử dụng lệnh cURL](#3)

<a name=1></a>
## 1. Một số thao tác cơ bản.
- Sử dụng lệnh `swift stat`

  ```sh
  ~# swift stat
                          Account: AUTH_b54646bf669746db8c62ec0410bd0528
                       Containers: 2
                          Objects: 3
                            Bytes: 7
  Containers in policy "policy-0": 2
     Objects in policy "policy-0": 3
       Bytes in policy "policy-0": 7
      X-Account-Project-Domain-Id: default
           X-Openstack-Request-Id: txcd2bc73d764c42edac195-00599f95bb
                      X-Timestamp: 1502474830.56432
                       X-Trans-Id: txcd2bc73d764c42edac195-00599f95bb
                     Content-Type: text/plain; charset=utf-8
                    Accept-Ranges: bytes
  ```
  
  - Hiện tại có 2 containers, 3 objects.
  
- Xác định tên các containers có trong swift

  ```sh
  ~# swift list
  container1
  container2
  ```
  
- Liệt kê các object trong một container cụ thể

  ```sh
  ~# swift list container1
  file1
  file2
  ```
  
- Upload 1 file lên container

  ```sh
  $ swift upload new_container file2
  ```
  
  - `new_container` là tên của container
  - `file2` là file cần upload, có thể thay thế bằng path của file cần up.
  
- Xem trạng thái của một object

  ```sh
  ~# swift stat container1 file1
                 Account: AUTH_b54646bf669746db8c62ec0410bd0528
               Container: container1
                  Object: file1
            Content Type: application/octet-stream
          Content Length: 0
           Last Modified: Fri, 11 Aug 2017 18:13:10 GMT
                    ETag: d41d8cd98f00b204e9800998ecf8427e
           Accept-Ranges: bytes
             X-Timestamp: 1502475189.17697
              X-Trans-Id: tx04f19caf5781452484ae1-00599f9829
  X-Openstack-Request-Id: tx04f19caf5781452484ae1-00599f9829
  ```
  
- download một object.

  ```sh
  ~# swift download container2 file1
  file1 [auth 5.006s, headers 5.860s, total 5.861s, 0.000 MB/s]
  ```
  
<a name=2></a>
## 2. Quản lý phân quyền trên container.
- Người dùng có thể thiết lập kiểm soát truy cập ở mức container và định nghĩa truy cập đọc ghi.
- Để có quyền ghi lên container, user phải có quyền đọc trên container đó.

<Sẽ cập nhật sau>

<a name=3></a>
## 3. Sử dụng lệnh cURL.
- Lệnh cURL phổ biến trong giao thức HTTP.
- Lấy thông tin xác thực và URL của storage, sử dụng lệnh `swift auth`

  ```sh
  ~# swift auth
  export OS_STORAGE_URL=http://controller:8080/v1/AUTH_b54646bf669746db8c62ec0410bd0528
  export OS_AUTH_TOKEN=gAAAAABZn573BDBO-u0adDsY-N-cImY6HhwbibF8OIG52RnTkkzM8yCYARUHF-r-8nHYUNX2t0Hm5jql9B0_hpvgOs3NXb87UKtbF1c-P2K0P-eR6038tToexRRifmE9gKE5QA2f8iM4Uqv7nbNGMLX0nRKlUdlLC1orebRmucAcIWwQVbW_yPY
  ```
  
### 3.1 Tạo một container mới.
- Sử dụng HTTP PUT.

  ```sh
  curl -X PUT -H 'X-Auth-Token: gAAAAABZn573BDBO-u0adDsY-N-cImY6HhwbibF8OIG52RnTkkzM8yCYARUHF-r-8nHYUNX2t0Hm5jql9B0_hpvgOs3NXb87UKtbF1c-P2K0P-eR6038tToexRRifmE9gKE5QA2f8iM4Uqv7nbNGMLX0nRKlUdlLC1orebRmucAcIWwQVbW_yPY' \
  http://controller:8080/v1/AUTH_b54646bf669746db8c62ec0410bd0528/new_container
  ```
  
  - giá trị sau `X-Auth-Token` được thay thế bằng giá trị sau `OS_AUTH_TOKEN` nhận được ở trên.
  - sau url nhận được ở trên, cần thêm tên của container muốn tạo.
  
- Sử dụng HTTP GET để liệt kê các container giống như lệnh swift stat.

  ```sh
  $ curl -X GET -H 'X-Auth-Token: gAAAAABZn573BDBO-u0adDsY-N-cImY6HhwbibF8OIG52RnTkkzM8yCYARUHF-r-8nHYUNX2t0Hm5jql9B0_hpvgOs3NXb87UKtbF1c-P2K0P-eR6038tToexRRifmE9gKE5QA2f8iM4Uqv7nbNGMLX0nRKlUdlLC1orebRmucAcIWwQVbW_yPY' \
  http://controller:8080/v1/AUTH_b54646bf669746db8c62ec0410bd0528/
  
  container1
  container2
  new_container
  ```

- Upload file lên container

  ```sh
  $ curl -X PUT -H 'X-Auth-Token: gAAAAABZn573BDBO-u0adDsY-N-cImY6HhwbibF8OIG52RnTkkzM8yCYARUHF-r-8nHYUNX2t0Hm5jql9B0_hpvgOs3NXb87UKtbF1c-P2K0P-eR6038tToexRRifmE9gKE5QA2f8iM4Uqv7nbNGMLX0nRKlUdlLC1orebRmucAcIWwQVbW_yPY' \
  http://controller:8080/v1/AUTH_b54646bf669746db8c62ec0410bd0528/new_container/ -T /etc/network/interfaces
  ```
  
- Lấy nội dung trong new_container

  ```sh
  $ curl -X GET -H 'X-Auth-Token: gAAAAABZn573BDBO-u0adDsY-N-cImY6HhwbibF8OIG52RnTkkzM8yCYARUHF-r-8nHYUNX2t0Hm5jql9B0_hpvgOs3NXb87UKtbF1c-P2K0P-eR6038tToexRRifmE9gKE5QA2f8iM4Uqv7nbNGMLX0nRKlUdlLC1orebRmucAcIWwQVbW_yPY' \
  http://controller:8080/v1/AUTH_b54646bf669746db8c62ec0410bd0528/new_container 
  
  interfaces
  ```
  
- Lấy nội dung của object

  ```sh
  $ curl -X GET -H 'X-Auth-Token: gAAAAABZn573BDBO-u0adDsY-N-cImY6HhwbibF8OIG52RnTkkzM8yCYARUHF-r-8nHYUNX2t0Hm5jql9B0_hpvgOs3NXb87UKtbF1c-P2K0P-eR6038tToexRRifmE9gKE5QA2f8iM4Uqv7nbNGMLX0nRKlUdlLC1orebRmucAcIWwQVbW_yPY' \
  http://controller:8080/v1/AUTH_b54646bf669746db8c62ec0410bd0528/new_container/interfaces
  
  # This file describes the network interfaces available on your system
  # and how to activate them. For more information, see interfaces(5).

  source /etc/network/interfaces.d/*

  # The loopback network interface
  auto lo
  iface lo inet loopback

  # The primary network interface
  auto ens3
  iface ens3 inet static
          address 10.10.10.190
          netmask 255.255.255.0


  auto ens4
  iface ens4 inet static
          address 172.16.69.190
          netmask 255.255.255.0
          gateway 172.16.69.1
          dns-nameservers 8.8.8.8

  auto ens5
  iface ens5 inet static
          address 10.10.20.190
          netmask 255.255.255.0
  ```
 