# Lab thực hiện thay đổi thời gian tồn tại của token

## Kiểm tra thời gian tồn tại mặc định của token
- Sử dụng lệnh curl để lấy về token
  ```sh
  root@controller:~# curl -i -X POST -H "Content-Type: application/json" -d '
  >   {
  >     "auth": {
  >       "identity": {
  >         "methods": [
  >           "password"
  >         ],
  >         "password": {
  >           "user": {
  >             "name": "admin",
  >             "password": "Welcome123",
  >             "domain": {
  >               "name": "Default"
  >             }
  >           }
  >         }
  >       },
  >       "scope": {
  >         "project": {
  >           "name": "admin",
  >           "domain": {
  >             "name": "Default"
  >           }
  >         }
  >       }
  >     }
  >   }' http://10.10.10.61:5000/v3/auth/tokens
  
  # Kết quả trả về
  
  HTTP/1.1 201 Created
  Date: Wed, 10 May 2017 03:51:57 GMT
  Server: Apache/2.4.18 (Ubuntu)
  X-Subject-Token: gAAAAABZEo5mkwNS_CQImixAg6oaw5SgZ_magz8NQn_PdICK0xKE0sqjpiCXFCOTwYd4R94CSQeHMIO6RrfC95MpyUD_QdGrXSBL6Pp2U9fG4Grl6DChReNm20V4CG2vQngVwLY3nJrnFxwpW2lpJTDQQVstf4P_oj2AnTVWfEJdA0zU4PCEGOQ
  Vary: X-Auth-Token
  X-Distribution: Ubuntu
  x-openstack-request-id: req-eae51a1e-5410-4e55-8ac1-635853b7a52c
  Content-Length: 3305
  Content-Type: application/json

  {
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
      "expires_at": "2017-05-10T04:52:06.000000Z",
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
              "region_id": "RegionOne",
              "url": "http://controller:9696",
              "region": "RegionOne",
              "interface": "internal",
              "id": "14685bad4aec40f08981c3f1740e3545"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9696",
              "region": "RegionOne",
              "interface": "admin",
              "id": "7064b62c47c346f18c5fa237eaf6226f"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9696",
              "region": "RegionOne",
              "interface": "public",
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
              "region_id": "RegionOne",
              "url": "http://controller:5000/v3/",
              "region": "RegionOne",
              "interface": "internal",
              "id": "b2838eb934c9497c8d56f8999276ec91"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:35357/v3/",
              "region": "RegionOne",
              "interface": "admin",
              "id": "f0fb030e514741dd93b7b8f486a2e0d2"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:5000/v3/",
              "region": "RegionOne",
              "interface": "public",
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
              "region_id": "RegionOne",
              "url": "http://controller/placement",
              "region": "RegionOne",
              "interface": "public",
              "id": "42227e78ceff4bebb78e5a2f8ba71598"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller/placement",
              "region": "RegionOne",
              "interface": "internal",
              "id": "9441739790b0476e9ca82f472dd71ded"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller/placement",
              "region": "RegionOne",
              "interface": "admin",
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
              "region_id": "RegionOne",
              "url": "http://controller:8774/v2.1",
              "region": "RegionOne",
              "interface": "public",
              "id": "340ccc966bbf4a92b772b050f339ff3b"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:8774/v2.1",
              "region": "RegionOne",
              "interface": "internal",
              "id": "486b3a9f5b904d9f998d106ab21165db"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:8774/v2.1",
              "region": "RegionOne",
              "interface": "admin",
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
              "region_id": "RegionOne",
              "url": "http://controller:9292",
              "region": "RegionOne",
              "interface": "public",
              "id": "256f8c335b2942bfaa48ff5b8f736194"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9292",
              "region": "RegionOne",
              "interface": "admin",
              "id": "71b72367765942fe9aeacce70601f2ee"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9292",
              "region": "RegionOne",
              "interface": "internal",
              "id": "99d90e0a37294678ab983e53af2e8c70"
            }
          ],
          "type": "image",
          "id": "feba9d8531944339b45bb5bfa55e9fd6",
          "name": "glance"
        }
      ],
      "user": {
        "password_expires_at": null,
        "domain": {
          "id": "default",
          "name": "Default"
        },
        "id": "3ce3ca843dc7458bb61c851d3a654b8b",
        "name": "admin"
      },
      "audit_ids": [
        "0R3ypDGuQtmS2yeIK0Dp4Q"
      ],
      "issued_at": "2017-05-10T03:52:06.000000Z"
    }
  }
  ```

- Chúng ta chú ý đến 2 thông tin trong token để kiểm tra thời gian:
  ```sh
  "issued_at": "2017-05-10T03:52:06.000000Z"
  "expires_at": "2017-05-10T04:52:06.000000Z",
  
  ``  
  
- Như vậy thời gian mặc định tồn tại mặc định của token là 1 tiếng. (từ 03:52:06.000000Z lên 04:52:06.000000Z)

- Bây giờ chúng ta cần thay đổi thời gian tồn tại của token.
- Để thay đổi, chúng ta thay đổi tham số `expiration` trong section `[token]` của file `/etc/keystone/keystone.conf`
  ```sh
  [token]
  #
  # chúng ta thiết lập thời gian tồn tại của token trong vòng 1 phút (60 giây)
  expiration = 60
  ```

- Kiểm lại thời gian của token:
  ```sh
  # Lấy về token
  root@controller:~# curl -i -X POST -H "Content-Type: application/json" -d '
  >   {
  >     "auth": {
  >       "identity": {
  >         "methods": [
  >           "password"
  >         ],
  >         "password": {
  >           "user": {
  >             "name": "admin",
  >             "password": "Welcome123",
  >             "domain": {
  >               "name": "Default"
  >             }
  >           }
  >         }
  >       },
  >       "scope": {
  >         "project": {
  >           "name": "admin",
  >           "domain": {
  >             "name": "Default"
  >           }
  >         }
  >       }
  >     }
  >   }' http://10.10.10.61:5000/v3/auth/tokens
  
  # Kết quả
  HTTP/1.1 201 Created
  Date: Wed, 10 May 2017 04:04:41 GMT
  Server: Apache/2.4.18 (Ubuntu)
  X-Subject-Token: gAAAAABZEpFgLyKUJ4TtdG3C-MnkGoYMY2DqhoqTfZFF1_ehrwqaOfQVp5SVk-hCzeMa-rNqfpRM_9tT2WPPDVDPYReIlUYFoWUgFyNDs77cYsI097I3LRJb7r81kIkKFoedoXHfh6oxEtTNawpJYiBH0E4U4y55LGXY_js60jMKygBHwNSTSwc
  Vary: X-Auth-Token
  X-Distribution: Ubuntu
  x-openstack-request-id: req-b0369ac7-7e01-4c86-98f7-6be38e3d3f5c
  Content-Length: 3305
  Content-Type: application/json

  {
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
      "expires_at": "2017-05-10T04:52:06.000000Z",
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
              "region_id": "RegionOne",
              "url": "http://controller:9696",
              "region": "RegionOne",
              "interface": "internal",
              "id": "14685bad4aec40f08981c3f1740e3545"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9696",
              "region": "RegionOne",
              "interface": "admin",
              "id": "7064b62c47c346f18c5fa237eaf6226f"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9696",
              "region": "RegionOne",
              "interface": "public",
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
              "region_id": "RegionOne",
              "url": "http://controller:5000/v3/",
              "region": "RegionOne",
              "interface": "internal",
              "id": "b2838eb934c9497c8d56f8999276ec91"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:35357/v3/",
              "region": "RegionOne",
              "interface": "admin",
              "id": "f0fb030e514741dd93b7b8f486a2e0d2"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:5000/v3/",
              "region": "RegionOne",
              "interface": "public",
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
              "region_id": "RegionOne",
              "url": "http://controller/placement",
              "region": "RegionOne",
              "interface": "public",
              "id": "42227e78ceff4bebb78e5a2f8ba71598"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller/placement",
              "region": "RegionOne",
              "interface": "internal",
              "id": "9441739790b0476e9ca82f472dd71ded"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller/placement",
              "region": "RegionOne",
              "interface": "admin",
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
              "region_id": "RegionOne",
              "url": "http://controller:8774/v2.1",
              "region": "RegionOne",
              "interface": "public",
              "id": "340ccc966bbf4a92b772b050f339ff3b"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:8774/v2.1",
              "region": "RegionOne",
              "interface": "internal",
              "id": "486b3a9f5b904d9f998d106ab21165db"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:8774/v2.1",
              "region": "RegionOne",
              "interface": "admin",
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
              "region_id": "RegionOne",
              "url": "http://controller:9292",
              "region": "RegionOne",
              "interface": "public",
              "id": "256f8c335b2942bfaa48ff5b8f736194"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9292",
              "region": "RegionOne",
              "interface": "admin",
              "id": "71b72367765942fe9aeacce70601f2ee"
            },
            {
              "region_id": "RegionOne",
              "url": "http://controller:9292",
              "region": "RegionOne",
              "interface": "internal",
              "id": "99d90e0a37294678ab983e53af2e8c70"
            }
          ],
          "type": "image",
          "id": "feba9d8531944339b45bb5bfa55e9fd6",
          "name": "glance"
        }
      ],
      "user": {
        "password_expires_at": null,
        "domain": {
          "id": "default",
          "name": "Default"
        },
        "id": "3ce3ca843dc7458bb61c851d3a654b8b",
        "name": "admin"
      },
      "audit_ids": [
        "0R3ypDGuQtmS2yeIK0Dp4Q"
      ],
      "issued_at": "2017-05-10T03:52:06.000000Z"
    }
  }
  ```

- Kiểm tra thời gian tồn tại của token:
  ```sh
  "issued_at": "2017-05-10T07:02:29.000000Z"
  "expires_at": "2017-05-10T07:03:29.000000Z"
  ```

Thời gian của token đã rút ngắn lại chỉ có 1 phút (từ 2017-05-10T07:02:29.000000Z đến 2017-05-10T07:03:29.000000Z)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

