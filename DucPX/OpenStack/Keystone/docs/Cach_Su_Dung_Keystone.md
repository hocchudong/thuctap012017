# Sử dụng keystone cơ bản để liệt kê ra users, projects, domains,... có trong openstack

## Mục lục
- [Lấy Token](#token)
- [I. Liệt kê ra các thông tin.](#I)
  - [1. Liệt kê các users](#1)
  - [2. Liệt kê Projects](#2)
  - [3. Liệt kê Groups](#3)
  - [4. Liệt kê Roles](#4)
  - [5. Liệt kê Domains](#5)
- [II. Tạo domain, project](#II)
  - [1. Tạo một domain mới](#a)
  - [2. Tạo một project bên trong domain đã tạo](#b)
  - [3. Tạo User trong domain](#c)
  - [4. Gán quyền cho user](#d)
- [III. Sử dụng horizon](#III)
---

## Để sử dụng các lệnh với keystone, khai báo các biến môi trường để thuận lợi trong việc xác thực

```sh
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

<a name=token></a>
## Sử dụng hai cách: *dùng lệnh mà openstack cung cấp* và *curl* để sử dụng keystone
### Lấy Token
- Sử dụng lệnh. Sau khi khai báo các biến môi trường, chúng ta chỉ cần dùng lệnh `openstack token issue` là có thể lấy token về.

  ```sh
  root@controller:~# openstack token issue
  +------------+-------------------------------------------------------------------------------------------------------------------------------------+
  | Field      | Value                                                                                                                               |
  +------------+-------------------------------------------------------------------------------------------------------------------------------------+
  | expires    | 2017-04-28T04:19:17+0000                                                                                                            |
  | id         | gAAAAABZArS1Qgi_MMYf6J4odgU-tU9eoBfD44Ob149egIzNrK_XpnovPkzh9xWp0wWiR4BDM-Vke76EFmk7dDoFtXIQtVksde-                                 |
  |            | 8uCJSgDJNIVAsgW_pLVR28qQ3DHIhSrcRXHGw8MLSdhMyPJjJrDYqKKhNh6iczBnLN4k9YoB3A52IZUrP9ug                                                |
  | project_id | 1667a274e14647ec8f2c0dd593e661de                                                                                                    |
  | user_id    | 3ce3ca843dc7458bb61c851d3a654b8b                                                                                                    |
  +------------+-------------------------------------------------------------------------------------------------------------------------------------+

  ```

- Sử dụng lệnh `curl` để lấy token, payload để xác thực yêu cầu phải có thông tin về user và project.

  ```sh
  root@controller:~# curl -i -X POST -H "Content-Type: application/json" -d '
  >  {
  >    "auth": {
  >      "identity": {
  >        "methods": [
  >          "password"
  >        ],
  >        "password": {
  >          "user": {
  >            "name": "admin",
  >            "password": "Welcome123",
  >            "domain": {
  >              "name": "Default"
  >            }
  >          }
  >        }
  >      },
  >      "scope": {
  >        "project": {
  >          "name": "admin",
  >          "domain": {
  >            "name": "Default"
  >          }
  >        }
  >      }
  >    }
  >  }' http://10.10.10.61:5000/v3/auth/tokens

  ```

	- kết quả thu được như sau (đây là phần header chứa token, phần body sẽ là một chuỗi json chứa các thông tin về token và một catalog servcie)

	```sh
	HTTP/1.1 201 Created
	Date: Fri, 28 Apr 2017 03:21:57 GMT
	Server: Apache/2.4.18 (Ubuntu)
	X-Subject-Token: gAAAAABZArVWYOIkZDLHoIGvaMMm10WUvuSg2POh6g-je1Pvc-xYiStKIsiDqDheAr-Vjzg2274fbBTvPzm8I_6e6A9f1X7VPgpFGke57CS5cfxLwwJSDE747jg0fkjByUhMol7j7bFVo_e6cIFe5n8naNpkcvf4oVcAqBWtUZf2ycI0XffanMQ
	Vary: X-Auth-Token
	X-Distribution: Ubuntu
	x-openstack-request-id: req-d6007e22-c33a-4f4e-a4b7-42caf475d0b6
	Content-Length: 3305
	Content-Type: application/json
	```

	- token là chuỗi nằm sau `X-Subject-Token`
	- `gAAAAABZArVWYOIkZDLHoIGvaMMm10WUvuSg2POh6g-je1Pvc-xYiStKIsiDqDheAr-Vjzg2274fbBTvPzm8I_6e6A9f1X7VPgpFGke57CS5cfxLwwJSDE747jg0fkjByUhMol7j7bFVo_e6cIFe5n8naNpkcvf4oVcAqBWtUZf2ycI0XffanMQ`

- Sau khi xác định được chuỗi token, khai báo biến môi trường `OS_TOKEN` để sử dụng cho các lệnh curl cần thiết sau này
  ```sh
  root@controller:~# OS_TOKEN=gAAAAABZArVWYOIkZDLHoIGvaMMm10WUvuSg2POh6g-je1Pvc-xYiStKIsiDqDheAr-Vjzg2274fbBTvPzm8I_6e6A9f1X7VPgpFGke57CS5cfxLwwJSDE747jg0fkjByUhMol7j7bFVo_e6cIFe5n8naNpkcvf4oVcAqBWtUZf2ycI0XffanMQ
  ```
  
- Sau OS_TOKEN là token mà chúng ta nhận được.

<a name=I></a>
## I. Liệt kê ra các thông tin.
<a name=1></a>
### 1. Liệt kê các users
Trong quá trình cài đặt openstack, chúng ta đã tạo một số user trùng tên với từng dịch vụ. Dùng lệnh `openstack user list` để liệt kê ra danh sách các user có trong openstack.
- Dùng lệnh
  ```sh
  root@controller:~# openstack user list
  +----------------------------------+-----------+
  | ID                               | Name      |
  +----------------------------------+-----------+
  | 0dbfa2b697d24b0cb3aaad815d72799a | nova      |
  | 116522ee479c4cc7a7dc9c81691d5a9b | demo      |
  | 3ce3ca843dc7458bb61c851d3a654b8b | admin     |
  | 9424c28abcbd494bb2cd241184dffec7 | placement |
  | f00f9e4d49d54cbca319d9075e502127 | neutron   |
  | fe1d690b18df406d9b2aa500ce808346 | glance    |
  +----------------------------------+-----------+
  ```

- Dùng curl. Khi dùng curl cần cung cấp đúng endpoint đến API mà openstack đã cung cấp. Để liệt kê ra các user, endpoint là `http://10.10.10.61:5000/v3/users`
  ```sh
  root@controller:~#  curl -s -H "X-Auth-Token: $OS_TOKEN"   http://10.10.10.61:5000/v3/users | python -mjson.tool
  {
      "links": {
          "next": null,
          "previous": null,
          "self": "http://localhost:5000/v3/users"
      },
      "users": [
          {
              "domain_id": "default",
              "enabled": true,
              "id": "0dbfa2b697d24b0cb3aaad815d72799a",
              "links": {
                  "self": "http://localhost:5000/v3/users/0dbfa2b697d24b0cb3aaad815d72799a"
              },
              "name": "nova",
              "options": {},
              "password_expires_at": null
          },
          {
              "domain_id": "default",
              "enabled": true,
              "id": "116522ee479c4cc7a7dc9c81691d5a9b",
              "links": {
                  "self": "http://localhost:5000/v3/users/116522ee479c4cc7a7dc9c81691d5a9b"
              },
              "name": "demo",
              "options": {},
              "password_expires_at": null
          },
          {
              "domain_id": "default",
              "enabled": true,
              "id": "3ce3ca843dc7458bb61c851d3a654b8b",
              "links": {
                  "self": "http://localhost:5000/v3/users/3ce3ca843dc7458bb61c851d3a654b8b"
              },
              "name": "admin",
              "options": {},
              "password_expires_at": null
          },
          {
              "domain_id": "default",
              "enabled": true,
              "id": "9424c28abcbd494bb2cd241184dffec7",
              "links": {
                  "self": "http://localhost:5000/v3/users/9424c28abcbd494bb2cd241184dffec7"
              },
              "name": "placement",
              "options": {},
              "password_expires_at": null
          },
          {
              "domain_id": "default",
              "enabled": true,
              "id": "f00f9e4d49d54cbca319d9075e502127",
              "links": {
                  "self": "http://localhost:5000/v3/users/f00f9e4d49d54cbca319d9075e502127"
              },
              "name": "neutron",
              "options": {},
              "password_expires_at": null
          },
          {
              "domain_id": "default",
              "enabled": true,
              "id": "fe1d690b18df406d9b2aa500ce808346",
              "links": {
                  "self": "http://localhost:5000/v3/users/fe1d690b18df406d9b2aa500ce808346"
              },
              "name": "glance",
              "options": {},
              "password_expires_at": null
          }
      ]
  }
  ```
<a name=2></a>
### 2. Liệt kê Projects

- Dùng lệnh. Để liệt kê ra các project, đơn giản chỉ cần dùng lệnh `openstack project list`.
  ```sh
  root@controller:~# openstack project list
  +----------------------------------+---------+
  | ID                               | Name    |
  +----------------------------------+---------+
  | 142a2e061eac4845beefc265b037ddea | service |
  | 1667a274e14647ec8f2c0dd593e661de | admin   |
  | f102c6f6308e4e7ba5378954363c7ad6 | demo    |
  +----------------------------------+---------+
  ```

- Dùng curl. endpoint gọi đến API để liệt kê ra project là `http://10.10.10.61:5000/v3/projects`.
  ```sh
  root@controller:~# curl -s -H "X-Auth-Token: $OS_TOKEN"   http://10.10.10.61:5000/v3/projects | python -mjson.tool
  {
      "links": {
          "next": null,
          "previous": null,
          "self": "http://10.10.10.61:5000/v3/projects"
      },
      "projects": [
          {
              "description": "Service Project",
              "domain_id": "default",
              "enabled": true,
              "id": "142a2e061eac4845beefc265b037ddea",
              "is_domain": false,
              "links": {
                  "self": "http://10.10.10.61:5000/v3/projects/142a2e061eac4845beefc265b037ddea"
              },
              "name": "service",
              "parent_id": "default"
          },
          {
              "description": "Bootstrap project for initializing the cloud.",
              "domain_id": "default",
              "enabled": true,
              "id": "1667a274e14647ec8f2c0dd593e661de",
              "is_domain": false,
              "links": {
                  "self": "http://10.10.10.61:5000/v3/projects/1667a274e14647ec8f2c0dd593e661de"
              },
              "name": "admin",
              "parent_id": "default"
          },
          {
              "description": "Demo Project",
              "domain_id": "default",
              "enabled": true,
              "id": "f102c6f6308e4e7ba5378954363c7ad6",
              "is_domain": false,
              "links": {
                  "self": "http://10.10.10.61:5000/v3/projects/f102c6f6308e4e7ba5378954363c7ad6"
              },
              "name": "demo",
              "parent_id": "default"
          }
      ]
  }
  ```

<a name=3></a>
### 3. Liệt kê Groups

- Dùng lệnh `openstack group list`

- Dùng curl
  ```sh
  root@controller:~# openstack group list

  root@controller:~# curl -s -H "X-Auth-Token: $OS_TOKEN"   http://10.10.10.61:5000/v3/groups | python -mjson.tool
  {
      "groups": [],
      "links": {
          "next": null,
          "previous": null,
          "self": "http://10.10.10.61:5000/v3/groups"
      }
  }
  ```

<a name=4></a>
### 4. Liệt kê Roles
- dùng lệnh
  ```sh
  root@controller:~# openstack role list
  +----------------------------------+----------+
  | ID                               | Name     |
  +----------------------------------+----------+
  | 846e4b17fde047e98c13ca941f9b0d3b | user     |
  | 9577b0c1837b430cabfd7d20e548e8fe | admin    |
  | 9fe2ff9ee4384b1894a90878d3e92bab | _member_ |
  +----------------------------------+----------+
  ```
- dùng curl
  ```sh
  root@controller:~# curl -s -H "X-Auth-Token: $OS_TOKEN"   http://10.10.10.61:5000/v3/roles | python -mjson.tool
  {
      "links": {
          "next": null,
          "previous": null,
          "self": "http://10.10.10.61:5000/v3/roles"
      },
      "roles": [
          {
              "domain_id": null,
              "id": "846e4b17fde047e98c13ca941f9b0d3b",
              "links": {
                  "self": "http://10.10.10.61:5000/v3/roles/846e4b17fde047e98c13ca941f9b0d3b"
              },
              "name": "user"
          },
          {
              "domain_id": null,
              "id": "9577b0c1837b430cabfd7d20e548e8fe",
              "links": {
                  "self": "http://10.10.10.61:5000/v3/roles/9577b0c1837b430cabfd7d20e548e8fe"
              },
              "name": "admin"
          },
          {
              "domain_id": null,
              "id": "9fe2ff9ee4384b1894a90878d3e92bab",
              "links": {
                  "self": "http://10.10.10.61:5000/v3/roles/9fe2ff9ee4384b1894a90878d3e92bab"
              },
              "name": "_member_"
          }
      ]
  }
  ```

<a name=5></a>
### 5. Liệt kê Domains
- dùng lệnh
  ```sh
  root@controller:~# openstack domain list
  +---------+---------+---------+--------------------+
  | ID      | Name    | Enabled | Description        |
  +---------+---------+---------+--------------------+
  | default | Default | True    | The default domain |
  +---------+---------+---------+--------------------+
  ```

- dùng curl
  ```sh
  root@controller:~# curl -s -H "X-Auth-Token: $OS_TOKEN"   http://10.10.10.61:5000/v3/domains | python -mjson.tool
  {
      "domains": [
          {
              "description": "The default domain",
              "enabled": true,
              "id": "default",
              "links": {
                  "self": "http://10.10.10.61:5000/v3/domains/default"
              },
              "name": "Default"
          }
      ],
      "links": {
          "next": null,
          "previous": null,
          "self": "http://10.10.10.61:5000/v3/domains"
      }
  }
  ```

<a name=II></a>
## II. Tạo domain, project
<a name=a></a>
### 1. Tạo một domain mới
- Dùng lệnh
  ```sh
  root@controller:~# openstack domain create new_domain
  +-------------+----------------------------------+
  | Field       | Value                            |
  +-------------+----------------------------------+
  | description |                                  |
  | enabled     | True                             |
  | id          | 9cbb9d6749f14776bb6c3e4a10e1469b |
  | name        | new_domain                       |
  +-------------+----------------------------------+
  ```
- Dùng curl. Tạo một POST request, payload chứa thông tin tối thiểu là tên của domain.
  ```sh
  root@controller:~# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json" -d '{ "domain": { "name": "new_domain2"}}' http://localhost:5000/v3/domains | python -mjson.tool
  {
      "domain": {
          "description": "",
          "enabled": true,
          "id": "1530d9e7adae43dd9cd680c18942d700",
          "links": {
              "self": "http://localhost:5000/v3/domains/1530d9e7adae43dd9cd680c18942d700"
          },
          "name": "new_domain2"
      }
  }
  ```

<a name=b></a>
### 2. Tạo một project bên trong domain đã tạo
- Dùng lệnh, tạo project trong domain `new_domain`
  ```sh
  root@controller:~# openstack project create --domain new_domain --description "New project in domain new_domain" new_project
  +-------------+----------------------------------+
  | Field       | Value                            |
  +-------------+----------------------------------+
  | description | New project in domain new_domain |
  | domain_id   | 9cbb9d6749f14776bb6c3e4a10e1469b |
  | enabled     | True                             |
  | id          | 67fb750b2923427fb7631c7267a42ebe |
  | is_domain   | False                            |
  | name        | new_project                      |
  | parent_id   | 9cbb9d6749f14776bb6c3e4a10e1469b |
  +-------------+----------------------------------+
  ```

- Dùng curl để tạo project trong domain `new_domain2`. Trong payload của POST request phải chỉ rõ domain ID, domain ID được tìm thấy ở các bước trước.
  ```sh
  root@controller:~# curl -s  -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json" -d '{ "project": { "name": "new_project2", "domain_id": "1530d9e7adae43dd9cd680c18942d700", "description": "New project2 in domain new_domain2"}}' http://localhost:5000/v3/projects | python -mjson.tool
  {
      "project": {
          "description": "New project2 in domain new_domain2",
          "domain_id": "1530d9e7adae43dd9cd680c18942d700",
          "enabled": true,
          "id": "36d0d4687f644d98803fb9ec1d15117e",
          "is_domain": false,
          "links": {
              "self": "http://localhost:5000/v3/projects/36d0d4687f644d98803fb9ec1d15117e"
          },
          "name": "new_project2",
          "parent_id": "1530d9e7adae43dd9cd680c18942d700"
      }
  }
  ```

<a name=c></a>
### 3. Tạo User trong domain
- Dùng lệnh để tạo
  ```sh
  root@controller:~# openstack user create --domain new_domain --password 123 demo
  +---------------------+----------------------------------+
  | Field               | Value                            |
  +---------------------+----------------------------------+
  | domain_id           | 9cbb9d6749f14776bb6c3e4a10e1469b |
  | enabled             | True                             |
  | id                  | fc9c94e9f7764bbe90b84d2745e7c00d |
  | name                | demo                             |
  | options             | {}                               |
  | password_expires_at | None                             |
  +---------------------+----------------------------------+
  ```

- Dùng curl
  ```sh
  root@controller:~# curl -s  -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  -d '{ "user": { "name": "new_user", "password": "123", "domain_id": "1530d9e7adae43dd9cd680c18942d700", "description": "new_user in domain new_domain2"}}' http://localhost:5000/v3/users | python -mjson.tool
  {
      "user": {
          "description": "new_user in domain new_domain2",
          "domain_id": "1530d9e7adae43dd9cd680c18942d700",
          "enabled": true,
          "id": "076778b30c2d4192ae3abbe755c72ae7",
          "links": {
              "self": "http://localhost:5000/v3/users/076778b30c2d4192ae3abbe755c72ae7"
          },
          "name": "new_user",
          "options": {},
          "password_expires_at": null
      }
  }
  ```

<a name=d></a>
### 4. Gán quyền cho user
- dùng lệnh 

  `openstack role add --project new_project --project-domain new_domain --user demo --user-domain new_domain user`

- dùng curl
  ```sh
  root@controller:~# curl -s -X PUT -H "X-Auth-Token: $OS_TOKEN" http://localhost:5000/v3/projects/1530d9e7adae43dd9cd680c18942d700/users/076778b30c2d4192ae3abbe755c72ae7/roles/846e4b17fde047e98c13ca941f9b0d3b
  ```

- khi dùng curl, cần chỉ rõ id của project, id của user và id của role.

### 5. Xác thực user `demo` trong domain `new_domain`
- Khai báo các biến môi trường
  ```sh
  export OS_PASSWORD=123 
  export OS_IDENTITY_API_VERSION=3 
  export OS_AUTH_URL=http://10.10.10.61:5000/v3 
  export OS_USERNAME=demo 
  export OS_PROJECT_NAME=new_project
  export OS_USER_DOMAIN_NAME=new_domain 
  export OS_PROJECT_DOMAIN_NAME=new_domain
  ```

- Lấy về token của user demo
  ```sh
  root@controller:~# openstack token issue
  +------------+-------------------------------------------------------------------------------------------------------------------------------------+
  | Field      | Value                                                                                                                               |
  +------------+-------------------------------------------------------------------------------------------------------------------------------------+
  | expires    | 2017-04-28T05:30:24+0000                                                                                                            |
  | id         | gAAAAABZAsVgooJZ1Dcpy52N-vN8Iwln3t-bGupwkLcqCCApv2Mo3LpSbHnJeLaRCfXycT9nDE7U6I6AuYn3c2cx9hp6OveTSWGKGM6_GoQ3kW6Bb5gfWX5C734FiMWvr55 |
  |            | HIFzPMADHTt_YZxL86ZERXPKgLyvTlsHeik0OCqck9lbqJyi7eys                                                                                |
  | project_id | 67fb750b2923427fb7631c7267a42ebe                                                                                                    |
  | user_id    | fc9c94e9f7764bbe90b84d2745e7c00d                                                                                                    |
  +------------+-------------------------------------------------------------------------------------------------------------------------------------+
  ```

- Dùng curl lấy về token giống như lấy token của `admin`

  ```sh
  root@controller:~# curl -i -X POST -H "Content-Type: application/json" -d '
  >  {
  >    "auth": {
  >      "identity": {
  >        "methods": [
  >          "password"
  >        ],
  >        "password": {
  >          "user": {
  >            "name": "demo",
  >            "password": "123",
  >            "domain": {
  >              "name": "new_domain"
  >            }
  >          }
  >        }
  >      },
  >      "scope": {
  >        "project": {
  >          "name": "new_project",
  >          "domain": {
  >            "name": "new_domain"
  >          }
  >        }
  >      }
  >    }
  >  }' http://10.10.10.61:5000/v3/auth/tokens
  ```

<a name=III></a>
## III. Sử dụng horizon
- Đăng nhập vào horizon với đường link `10.10.10.61/horizon

![Imgur](http://i.imgur.com/6134DHX.png)

- thông tin đăng nhập như hình trên.

- 2 project vừa mới tạo lúc trước

![Imgur](http://i.imgur.com/wSVT1Es.png)

- 2 user vừa tạo

![Imgur](http://i.imgur.com/VV44JEI.png)

- Để thực hiện các thao tác liệt kê, thiết lập các giá trị, xóa, tạo mới và xem đơn giản chỉ cần click trên giao diện rất trực quan cho người sử dụng.