# Ghi chép cấu hình Keystone

## Mục lục
Giải thích một số dòng cấu hình trong file cấu hình của keystone `/etc/keystone/keystone.conf`
- [Section database](#1)
- [Section fernet_tokens](#2)
- [Section token](#3)
- [Section cache](#4)

<a name=1></a>
## Section [database]
  ```sh
  [database]
  # Đường dẫn đến server database sẽ được sử dụng cho keystone
  connection =  mysql+pymysql://keystone:Welcome123@controller/keystone
  ```
  
  
<a name=2></a>
## Section [fernet_tokens]
  ```sh
  [fernet_tokens]
  # Thư mục chứa các fernet keys. Đây là thư mục mặc định để lưu các fernet keys.
  # Thư mục này phải tồn tại trước khi chạy lệnh`keystone-manage fernet_setup` cho lần đầu tiên
  # Và có thể đọc được bởi server của keystone
  # Các keys ở trong thư mục này sẽ thuộc 1 trong 3 loại keys:
  # - 1 staged key (chỉ số luôn là 0) được sử dụng để giải mã token
  # - 2 primary key (luôn có chỉ số cao nhất) được sử dụng để mã hóa và giải mã token
  # - các key còn lại là secondry key được sử dụng cho giải mã token
  key_repository = /etc/keystone/fernet-keys/ 

  # Giới hạn số lượng fernet keys trong thư mục chứa của nó
  # Giá trị mặc định là 3
  # Chúng ta có thể gán giá trị theo mong muốn của mình
  # Giả sử gán giá trị bằng 4, thì trong thư mục chứa key (/etc/keystone/fernet-keys/)
  # sẽ có 4 key và luôn có một key với chỉ số là 0 và còn lại 3 key có chỉ số theo thứ tự tăng dần (ví dụ: 0 4 5 6)
  max_active_keys = 4
  
  ```
<a name=3></a>
## Section [token]
  ```sh
  # Khai báo provider dùng để kiểm soát các công việc thực hiện tạo, xác nhận, thu hồi token trong keystone
  # Keystone có hai provider là "uuid" và "fernet"
  # UUID token sẽ được lưu lại trong backend, để sử dụng uuid, cần chỉ rõ backend (ở trong tùy chọn `[token] driver`)
  # fernet token thì sẽ không được lưu lại như uuid, nhưng yêu cầu chạy lệnh keystone-manage fernet_setup` (cũng như lệnh `keystone-manage fernet_rotate`) để quản lý key
  # Nếu sử dụng uuid thì gán giá trị như sau
  # provider = uuid
  # dòng dưới đây dùng để khai báo sử dụng fernet
  provider = fernet
  
  # Lượng thời gian tồn tại của token, kể từ lúc token được tạo
  # Đơn vị tính bằng giây (s)
  # Ví dụ: chúng ta muốn token tồn tại trong vòng 5 phút thì số giây tương đương là 5*60 = 300
  # Như vậy chỉ cần gán giá trị tham số expiration = 300
  expiration = 300
  
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