# Lab sử dụng UUID thay thế cho fernet token 

## Một số vấn đề lưu ý khi sử dụng UUID token
- Thông thường, database keystone có khoảng 300,000 token với thời gian tồn tại 1 ngày
- Để có thể kiểm soát được kích thước database, chúng ta phải chạy lệnh token_flush mỗi giờ để giảm số lượng token trong database

## Thay đổi định dạng token
- Trên hệ thống đang sử dụng fernet-token, thì trong database của keystone không lưu token. Kiểm tra lại, ta nhận được kết quả như sau:
  ```sh
  MariaDB [(none)]> select * from keystone.token;
  Empty set (0.00 sec)
  ```
  
- Chỉnh sửa section [token] trong file `/etc/keystone/keystone.conf` như sau để sử dụng UUID token
  ```sh
  [token]
  # Khai báo sử dụng UUID token
  provider = uuid
  
  # Khi sử dụng UUID, phải chỉ rõ backend lưu trữ token
  driver = sql
  ```
  
- Kiểm tra kết quả
  ```sh
  root@controller:~# . admin-openrc
  root@controller:~# openstack token issue
  +------------+----------------------------------+
  | Field      | Value                            |
  +------------+----------------------------------+
  | expires    | 2017-05-07T04:25:09+0000         |
  | id         | **2d4469dad7f94ec785425d17acb4a706** |
  | project_id | 1667a274e14647ec8f2c0dd593e661de |
  | user_id    | 3ce3ca843dc7458bb61c851d3a654b8b |
  +------------+----------------------------------+

  
  root@controller:~# mysql
  
  MariaDB [(none)]> select * from keystone.token\G
  *************************** 1. row ***************************
      id: **2d4469dad7f94ec785425d17acb4a706**
  expires: 2017-05-07 04:25:09
   extra: 
    {
      "is_domain": null,
      "token_data": {
        "token": {
          "is_domain": false,
          "methods": [
            "password"
          ],
          "roles": [
            {
              "id": "9577b0c1837b430cabfd7d20e548e8fe",
              "name": "admin"
            }
          ],
          "expires_at": "2017-05-07T04:25:09.000000Z",
          "project": {
            "domain": {
              "id": "default",
              "name": "Default"
            },
            "id": "1667a274e14647ec8f2c0dd593e661de",
            "name": "admin"
          },
          "catalog": [
            {
              "endpoints": [
                {
                  "url": "http://controller:9696",
                  "interface": "internal",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "14685bad4aec40f08981c3f1740e3545"
                },
                {
                  "url": "http://controller:9696",
                  "interface": "admin",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "7064b62c47c346f18c5fa237eaf6226f"
                },
                {
                  "url": "http://controller:9696",
                  "interface": "public",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "a1c9071a4f1649f5a4f1c698cf2011c0"
                }
              ],
              "type": "network",
              "id": "372bb5b327cf4729929f17ca254a2347",
              "name": "neutron"
            },
            {
              "endpoints": [
                {
                  "url": "http://controller:5000/v3/",
                  "interface": "internal",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "b2838eb934c9497c8d56f8999276ec91"
                },
                {
                  "url": "http://controller:35357/v3/",
                  "interface": "admin",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "f0fb030e514741dd93b7b8f486a2e0d2"
                },
                {
                  "url": "http://controller:5000/v3/",
                  "interface": "public",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "f3dd04abc59542838494d08967aa0af0"
                }
              ],
              "type": "identity",
              "id": "46fb085ff2594d2bb3e1c928b8cdb05e",
              "name": "keystone"
            },
            {
              "endpoints": [
                {
                  "url": "http://controller/placement",
                  "interface": "public",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "42227e78ceff4bebb78e5a2f8ba71598"
                },
                {
                  "url": "http://controller/placement",
                  "interface": "internal",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "9441739790b0476e9ca82f472dd71ded"
                },
                {
                  "url": "http://controller/placement",
                  "interface": "admin",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "c95d2c05791b478192fcc139a3e57751"
                }
              ],
              "type": "placement",
              "id": "6b1281d26ba940439bda68155fafd903",
              "name": "placement"
            },
            {
              "endpoints": [
                {
                  "url": "http://controller:8774/v2.1",
                  "interface": "public",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "340ccc966bbf4a92b772b050f339ff3b"
                },
                {
                  "url": "http://controller:8774/v2.1",
                  "interface": "internal",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "486b3a9f5b904d9f998d106ab21165db"
                },
                {
                  "url": "http://controller:8774/v2.1",
                  "interface": "admin",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "ecfd4ecc85d54f4b836c0be89f991b01"
                }
              ],
              "type": "compute",
              "id": "bdf3c1364bcb4b569d75e98a4914644a",
              "name": "nova"
            },
            {
              "endpoints": [
                {
                  "url": "http://controller:9292",
                  "interface": "public",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "256f8c335b2942bfaa48ff5b8f736194"
                },
                {
                  "url": "http://controller:9292",
                  "interface": "admin",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "71b72367765942fe9aeacce70601f2ee"
                },
                {
                  "url": "http://controller:9292",
                  "interface": "internal",
                  "region": "RegionOne",
                  "region_id": "RegionOne",
                  "id": "99d90e0a37294678ab983e53af2e8c70"
                }
              ],
              "type": "image",
              "id": "feba9d8531944339b45bb5bfa55e9fd6",
              "name": "glance"
            }
          ],
          "user": {
            "id": "3ce3ca843dc7458bb61c851d3a654b8b",
            "domain": {
              "id": "default",
              "name": "Default"
            },
            "password_expires_at": null,
            "name": "admin"
          },
          "audit_ids": [
            "vUYZ3oQIQO-OIj8639g6Bg"
          ],
          "issued_at": "2017-05-07T03:25:09.000000Z"
        }
      },
      "user": {
        "id": "3ce3ca843dc7458bb61c851d3a654b8b",
        "domain": {
          "id": "default",
          "name": "Default"
        },
        "password_expires_at": null,
        "name": "admin"
      },
      "key": "2d4469dad7f94ec785425d17acb4a706",
      "token_version": "v3.0",
      "tenant": {
        "domain": {
          "id": "default",
          "name": "Default"
        },
        "id": "1667a274e14647ec8f2c0dd593e661de",
        "name": "admin"
      }
    }
   valid: 1
  trust_id: NULL
  user_id: 3ce3ca843dc7458bb61c851d3a654b8b
  1 row in set (0.00 sec)
  ```
  
- Như vậy chúng ta đã thực hiện thành công chuyển từ việc sử dụng fernet-token sang UUID token.