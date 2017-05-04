# Ghi chép cấu hình Keystone

## Mục lục
Giải thích một số dòng cấu hình trong file cấu hình của keystone `/etc/keystone/keystone.conf`
- [Section database](#1)
- [Section fernet_tokens](#2)
- [Section token](#3)
- [Section cahe](#4)
<a name=1></a>
## Section [database]
  ```sh
  [database]
  connection =  mysql+pymysql://keystone:Welcome123@controller/keystone
  ```
  
  - Kết nối đến database
  
<a name=2></a>
## Section [fernet_tokens]
  ```sh
  [fernet_tokens]
  # Thư mục chứa các fernet keys. Đây là thư mục mặc định để lưu các fernet keys.
  # Thư mục này phải tồn tại trước khi chạy lệnh`keystone-manage fernet_setup` cho lần đầu tiên
  # Và có thể đọc được bởi server của keystone
  key_repository = /etc/keystone/fernet-keys/ 

  # Giới hạn số lượng fernet keys trong thư mục chứa của nó
  # Giá trị mặc định là 3
  max_active_keys = 3
  
  ```
<a name=3></a>
## Section [token]
  ```sh
  # Khai báo provider dùng để kiểm soát các công việc thực hiện tạo, xác nhận, thu hồi token trong keystone
  provider = fernet
  
  # Lượng thời gian của token còn có giá trị kể từ khi được sinh ra
  # Đơn vị tính bằng giây (s)
  expiration = 3600
  
  # Cho phép caching token, để thực hiện được caching token thì phải bật chức năng cache trong section [cache]
  caching = true

  # Thời gian cache của token
  cache_time = <None>
  ```
  
<a name=4></a>
## Section [cahe]
  ```sh
  [cahe]
  
  # Cho phép toàn bộ hệ thống có thể bật chức năng cache
  enabled = true
  ```
  
---
#### Trên đây là một số thông tin cấu hình cơ bản trong `keystone.conf`  