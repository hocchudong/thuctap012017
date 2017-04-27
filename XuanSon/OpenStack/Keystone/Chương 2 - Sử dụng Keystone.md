# Chương 2 - Sử dụng Keystone



# MỤC LỤC
- [1.Install OpenStack](#1)
- [2.Basic Keystone Operations Using OpenStackClient](#2)
	- [2.1 Getting a Token](#2.1)
	- [2.2.Listing Users](#2.2)
	- [2.3.Listing Project](#2.3)
	- [2.4.Listing Groups](#2.4)
	- [2.5.Listing Roles](#2.5)
	- [2.6.Listing Domains](#2.6)
	- [2.7.Creating Another Domain](#2.7)
	- [2.8.Create a Project within the Domain](#2.8)
	- [2.9.Create a User within the Domain](#2.9)
	- [2.10.Assigning a Role to a User for a Project](#2.10)
	- [2.11.Authenticating as the New User](#2.11)
- [3.Basic Keystone Operations Using Horizon](#3)
	- [3.1.What Keystone Operations Are Available through Horizon?](#3.1)
	- [3.2.Accessing the Identity Operations](#3.2)
	- [3.3.List, Set, Delete, Create, and View a Project](#3.3)
	- [3.4.List, Set, Delete, Create, and View a User](#3.4)




<a name="1"></a>
# 1.Install OpenStack

Cài Openstack Ocata sử dụng Ubuntu 16.04 theo docs:  
https://docs.openstack.org/ocata/install-guide-ubuntu/ 

<img src="http://imgur.com/k6hMeOY.png" />

<a name="2"></a>
# 2.Basic Keystone Operations Using OpenStackClient
Thực hiện lệnh tại controller node, trước tiên, phải thiết lập environment variable như sau: (chú ý thay 10.10.10.61 bằng địa chỉ IP của controller của bạn và PASSWORD bằng mật khẩu của bạn)  
```
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=1
export OS_AUTH_URL=http://10.10.10.61:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

Để kiểm tra environment variables được thiết lập, thực hiện câu lệnh:
```
env | grep OS_
```

<img src="http://imgur.com/BYtdaG9.png" />

<a name="2.1"></a>
## 2.1 Getting a Token
\- Using OpenStackClient  
Nếu đã thiết lập authentication và authorization dữ liệu như các biến môi trường, sử dụng lệnh sau để xin ra token:  
```
openstack token issue
```

<img src="http://imgur.com/GKDh2ft.png" />

\- Using cURL  
Khi sử dụng cURL để lây token, payload cho authentication request phải bao gồm information về user và project.  
```
curl -i -H "Content-Type: application/json" -d '
{ 
"auth": {
	"identity": {
		"methods": ["password"],
		"password": {
			"user": {
				"name": "admin",
				"domain": { "name": "Default" },
				"password": "1"
			}
		}
	},
	"scope": {
		"project": {
			"name": "admin",
			"domain": { "name": "Default" }
		}
	}	
}
}' http://localhost:35357/v3/auth/tokens
```

Kết quả:  
```
HTTP/1.1 201 Created
Date: Mon, 24 Apr 2017 02:55:50 GMT
Server: Apache/2.4.18 (Ubuntu)
X-Subject-Token: gAAAAABY_Wk4AU8gK1hZtXOQzNTDylGcUFQhWDeKrBGtUDMs39_XL5j4y3idux2hXAyWPGlpdk8koPX5RIXFG7MJqoLIyqaA8Yk5wL36xCEQZPsPoBDoknhdcfHfPLqClKqdcUA5v8X8D6L7_56SY7M_K2D_KonpHzlhrzI2v_BNZjnfkJj8c4
Vary: X-Auth-Token
X-Distribution: Ubuntu
x-openstack-request-id: req-45354880-059a-4a7f-b2a4-7f1ec99f1d66
Content-Length: 3290
Content-Type: application/json

{"token": {"is_domain": false, "methods": ["password"], "roles": [{"id": "7a42a5bd64464c7198539c11c68ad251", "name": "admin"}], "expires_at": "2017-04-24T03:55:52.000000Z", "project": {"domain": {"id": "default", "name": "Default"}, "id": "937cb5f0121244ada10b7dcfa1faded3", "name": "admin"}, "catalog": [{"endpoints": [{"region_id": "RegionOne", "url": "http://controller:5000/v3/", "region": "RegionOne", "interface": "internal", "id": "20d326e2a1d3449383bc528d0a5c7ba2"}, {"region_id": "RegionOne", "url": "http://controller:35357/v3/", "region": "RegionOne", "interface": "admin", "id": "47a7d6c1f34e47988d1e104628be7850"}, {"region_id": "RegionOne", "url": "http://controller:5000/v3/", "region": "RegionOne", "interface": "public", "id": "c096db2e39ea482f9083a8c6bb911053"}], "type": "identity", "id": "1045b29c81d5480a945e0ffffce3b7e7", "name": "keystone"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "internal", "id": "888ee3be94b34d70b0cf17b7a81ac594"}, {"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "public", "id": "e67ce49945f8459ca45128cb1c69a21b"}, {"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "admin", "id": "fe06aca0361547ed87c3ea74a41023e1"}], "type": "compute", "id": "38f4a515fd264b4aaf957d23aec90fe1", "name": "nova"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "public", "id": "4f62cace9d56440f832e7eb66a074be3"}, {"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "internal", "id": "6ea87df34e854e369a39fd8845882ec3"}, {"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "admin", "id": "6f05a93d323c4b11a493810f1a1eac2a"}], "type": "network", "id": "498bb0bb11174ba097ce506ba5d87552", "name": "neutron"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "internal", "id": "8de2c585ddee482fac8a6b6fa5c2854a"}, {"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "admin", "id": "d329393fa04144a6acbd5f206f6687bf"}, {"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "public", "id": "e070382ebc6640eb8bcbcb748e722c94"}], "type": "image", "id": "76e9c67a663a4594b9cd4d8a612b2364", "name": "glance"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:8778", "region": "RegionOne", "interface": "admin", "id": "750920ea265a43b4be39050d1e2c299f"}, {"region_id": "RegionOne", "url": "http://controller:8778", "region": "RegionOne", "interface": "internal", "id": "d21598f990504a9da96ec08b649addb8"}, {"region_id": "RegionOne", "url": "http://controller:8778", "region": "RegionOne", "interface": "public", "id": "db39c3023b8a4fd9b1721cbc50beeed6"}], "type": "placement", "id": "e2b580f6921946cd8d8545e002768d9f", "name": "placement"}], "user": {"password_expires_at": null, "domain": {"id": "default", "name": "Default"}, "id": "221ebbb4d16f444f8ea49fc8a79f80f1", "name": "admin"}, "audit_ids": ["aAJVymE4Qk-gm1Oz-JSPpw"], "issued_at": "2017-04-24T02:55:52.000000Z"}}
```

Note:  
Câu  trả lời bao gồm full catalog với all endpoints.   
Token vaule được đặt ở X-Subject-Token response header.Các ví dụ sau, để sử dụng cURL, thiết lập OS_TOKEN làm environment variable.  
```
export OS_TOKEN=gAAAAABY_Wk4AU8gK1hZtXOQzNTDylGcUFQhWDeKrBGtUDMs39_XL5j4y3idux2hXAyWPGlpdk8koPX5RIXFG7MJqoLIyqaA8Yk5wL36xCEQZPsPoBDoknhdcfHfPLqClKqdcUA5v8X8D6L7_56SY7M_K2D_KonpHzlhrzI2v_BNZjnfkJj8c4
```

<a name="2.2"></a>
## 2.2.Listing Users
\- Using OpenstackClient  
Sau khi cài đặt OpenStack ocata, nhiều users sẽ được tạo tự động. Có các service accounts cho các Openstack services khác như (Cinder, Glance, và Nova), 1 admin account (admin), và 1 non-admin account (demo).  
```
openstack user list
```

<img src="http://imgur.com/N50tg7u.png" />

\- Using cURL  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" http://localhost:35357/v3/users | python -mjson.tool
```

```
wind@controller:~$ curl -s -H "X-Auth-Token: $OS_TOKEN" http://localhost:35357/v3/users | python -mjson.tool                                                       {
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:35357/v3/users"
    },
    "users": [
        {
            "domain_id": "default",
            "enabled": true,
            "id": "221ebbb4d16f444f8ea49fc8a79f80f1",
            "links": {
                "self": "http://localhost:35357/v3/users/221ebbb4d16f444f8ea49fc8a79f80f1"
            },
            "name": "admin",
            "options": {},
            "password_expires_at": null
        },
        {
            "domain_id": "default",
            "enabled": true,
            "id": "3cca078537d04eefb159a2e000b91404",
            "links": {
                "self": "http://localhost:35357/v3/users/3cca078537d04eefb159a2e000b91404"
            },
            "name": "placement",
            "options": {},
            "password_expires_at": null
        },
        {
            "domain_id": "default",
            "enabled": true,
            "id": "46c73bec16f34b0a8b184854bde0b5f1",
            "links": {
                "self": "http://localhost:35357/v3/users/46c73bec16f34b0a8b184854bde0b5f1"
            },
            "name": "neutron",
            "options": {},
            "password_expires_at": null
        },
        {
            "domain_id": "default",
            "enabled": true,
            "id": "dd0124b2f29041979853fdf0b1cb1fe3",
            "links": {
                "self": "http://localhost:35357/v3/users/dd0124b2f29041979853fdf0b1cb1fe3"
            },
            "name": "glance",
            "options": {},
            "password_expires_at": null
        },
        {
            "domain_id": "default",
            "enabled": true,
            "id": "e8b23798d6fe4943b58ce63192796918",
            "links": {
                "self": "http://localhost:35357/v3/users/e8b23798d6fe4943b58ce63192796918"
            },
            "name": "nova",
            "options": {},
            "password_expires_at": null
        },
        {
            "domain_id": "default",
            "enabled": true,
            "id": "ff271fa2bd2c4796832bf447ef478c07",
            "links": {
                "self": "http://localhost:35357/v3/users/ff271fa2bd2c4796832bf447ef478c07"
            },
            "name": "demo",
            "options": {},
            "password_expires_at": null
        }
    ]
}
```

<a name="2.3"></a>
## 2.3.Listing Project
\- Using OpenStackClient  
Tương tự như users, Openstack tạo một vài projects mặc định. Show projects bằng cách sử dụng lệnh sau:  
```
openstack project list
```

\- Using cURL  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" http://localhost:35357/v3/projects | python -mjson.tool
```

```
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:35357/v3/projects"
    },
    "projects": [
        {
            "description": "Service Project",
            "domain_id": "default",
            "enabled": true,
            "id": "114e79d995444dbcab48806e16212c28",
            "is_domain": false,
            "links": {
                "self": "http://localhost:35357/v3/projects/114e79d995444dbcab48806e16212c28"
            },
            "name": "service",
            "parent_id": "default"
        },
        {
            "description": "Demo Project",
            "domain_id": "default",
            "enabled": true,
            "id": "93189a31c4e64aec9370737bf64e2232",
            "is_domain": false,
            "links": {
                "self": "http://localhost:35357/v3/projects/93189a31c4e64aec9370737bf64e2232"
            },
            "name": "demo",
            "parent_id": "default"
        },
        {
            "description": "Bootstrap project for initializing the cloud.",
            "domain_id": "default",
            "enabled": true,
            "id": "937cb5f0121244ada10b7dcfa1faded3",
            "is_domain": false,
            "links": {
                "self": "http://localhost:35357/v3/projects/937cb5f0121244ada10b7dcfa1faded3"
            },
            "name": "admin",
            "parent_id": "default"
        }
    ]
}
```

<a name="2.4"></a>
## 2.4.Listing Groups
\- Using OpenStackClient  
```
openstack group list
```

\- Using cURL  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" http://localhost:35357/v3/groups | python -mjson.tool
```

```
{
    "groups": [],
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:35357/v3/groups"
    }
}
```

<a name="2.5"></a>
## 2.5.Listing Roles
\- Using OpenstackClient  
```
openstack role list
```

<img src="http://imgur.com/nB7X2Jw.png" />

\- Using cURL  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" http://localhost:35357/v3/roles | python -mjson.tool
```

```
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:35357/v3/roles"
    },
    "roles": [
        {
            "domain_id": null,
            "id": "0c185ceca63749dd9529d3a5d1becc24",
            "links": {
                "self": "http://localhost:35357/v3/roles/0c185ceca63749dd9529d3a5d1becc24"
            },
            "name": "user"
        },
        {
            "domain_id": null,
            "id": "7a42a5bd64464c7198539c11c68ad251",
            "links": {
                "self": "http://localhost:35357/v3/roles/7a42a5bd64464c7198539c11c68ad251"
            },
            "name": "admin"
        },
        {
            "domain_id": null,
            "id": "9fe2ff9ee4384b1894a90878d3e92bab",
            "links": {
                "self": "http://localhost:35357/v3/roles/9fe2ff9ee4384b1894a90878d3e92bab"
            },
            "name": "_member_"
        }
    ]
}
```

<a name="2.6"></a>
## 2.6.Listing Domains
\- Using OpenStackClient  
Keystone tự động tạo ra một domain.  
```
openstack domain list
```

<img src="http://imgur.com/kDQ8Hvx.png" />

\- Using cURL  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" http://localhost:35357/v3/domains | python -mjson.tool
```

```
{
    "domains": [
        {
            "description": "The default domain",
            "enabled": true,
            "id": "default",
            "links": {
                "self": "http://localhost:35357/v3/domains/default"
            },
            "name": "Default"
        }
    ],
    "links": {
        "next": null,
        "previous": null,
        "self": "http://localhost:35357/v3/domains"
    }
}
```

<a name="2.7"></a>
## 2.7.Creating Another Domain
\- Using OpenStackClient  
Để thấy ý nghĩa hơn của việc dụng v3 of Identity API, ta sẽ tạo domain, project và user sở hữu bởi domain.  
```
openstack domain create acme
```

<img src="http://imgur.com/Byfah0V.png" />

\- Using cURL  
Chúng ta sử dụng POST request với information trong payload.  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" \
-H "Content-Type: application/json" -d '{ "domain": { "name": "acme"}}' http://localhost:35357/v3/domains | python -mjson.tool
```

```
{
    "domain": {
        "description": "",
        "enabled": true,
        "id": "bf81a62bf0b54c828dfd342ddcc0d244",
        "links": {
            "self": "http://localhost:35357/v3/domains/bf81a62bf0b54c828dfd342ddcc0d244"
        },
        "name": "acme"
    }
}
```

<a name="2.8"></a>
## 2.8.Create a Project within the Domain
\- Using OpenStackClient  
```
openstack project create tims_project --domain acme --description "time dev project"
```

<img src="http://imgur.com/BB3XKq8.png" />

\- Using cURL
Payload của POST request phải chỉ định domain ID. Description của project là option.  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" \
-H "Content-Type: application/json" \
-d '
{ 
"project": 
	{ 
	"name": "tims_project", 
	"domain_id": "bf81a62bf0b54c828dfd342ddcc0d244", 
	"description": "tims dev project"
	}
}' http://localhost:35357/v3/projects | python -mjson.tool
```

```
{
    "project": {
        "description": "tims dev project",
        "domain_id": "bf81a62bf0b54c828dfd342ddcc0d244",
        "enabled": true,
        "id": "4a342c8bd5dd459c857946767d740689",
        "is_domain": false,
        "links": {
            "self": "http://localhost:35357/v3/projects/4a342c8bd5dd459c857946767d740689"
        },
        "name": "tims_project",
        "parent_id": "bf81a62bf0b54c828dfd342ddcc0d244"
    }
}
```

<a name="2.9"></a>
## 2.9.Create a User within the Domain
\- Để tạo user trong domain, bạn cần chỉ định domain bạn đã tạo ở bước trước. Thiết lập passoword và email cho user là option.  
```
openstack user create son --domain acme --email do.xuanson1812195@gmail.com --description "sons openstack user account" --password son
```

<img src="http://imgur.com/5l7AGG5.png" />

\- Using cURL  
```
curl -s -H "X-Auth-Token: $OS_TOKEN" \
-H "Content-Type: application/json" \
-d '
{ 
"user": { 
	"name": "son", 
	"password": "son",
	"email": "do.xuanson1812195@gmail.com", 
	"domain_id": "bf81a62bf0b54c828dfd342ddcc0d244", 
	"description": "sons openstack user account"
	}
}' http://localhost:35357/v3/users \
| python -mjson.tool
```

```
{
    "user": {
        "description": "sons openstack user account",
        "domain_id": "bf81a62bf0b54c828dfd342ddcc0d244",
        "email": "do.xuanson1812195@gmail.com",
        "enabled": true,
        "id": "df9b146c5b5446c297fb25902095612e",
        "links": {
            "self": "http://localhost:35357/v3/users/df9b146c5b5446c297fb25902095612e"
        },
        "name": "son",
        "options": {},
        "password_expires_at": null
    }
}
```

<a name="2.10"></a>
## 2.10.Assigning a Role to a User for a Project
\- Using OpenstaclClient  
To assign a role to the new user on the new project, chúng ta có thể sử dụng CLI, nhưng cả 2 user và project phải đủ với domain đúng, hoặc OpenStackClient sẽ sử dụng default domain.  
```
openstack role add member --project tims_project --project-domain acme \
--user son --user-domain acme
```

\- Using cURL  
API cho assigning role  khác so với các command trước, nó sử PUT thay cho POST, và chỉ chấp nhận IDs cho user, project và role.  
```
curl -s -X PUT -H "X-Auth-Token: $OS_TOKEN" \
http://localhost:35357/v3/projects/4a342c8bd5dd459c857946767d740689/users/df9b146c5b5446c297fb25902095612e/roles/9fe2ff9ee4384b1894a90878d3e92bab
```

<a name="2.11"></a>
## 2.11.Authenticating as the New User
\- Using OpenStackClient  
Để authenticate như một new user, bạn nên bật new terminal seesion và tạp new environment variable. Trong trường hợp này, thông tin user name, passoword, project, và domain phải được thiết lập.  
```
export OS_PROJECT_DOMAIN_NAME=acme
export OS_USER_DOMAIN_NAME=acme
export OS_PROJECT_NAME=tims_project
export OS_USERNAME=son
export OS_PASSWORD=son
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

Xin cập token:  
```
openstack token issue
```

<img src="http://imgur.com/22v9d1R.png" />

\- Using cURL  
Tương tự như “2.2.1.Getting a Token”.  
```
curl -i -H "Content-Type: application/json" -d '
{ 
"auth": {
	"identity": {
		"methods": ["password"],
		"password": {
			"user": {
				"name": "son",
				"domain": { "name": "acme" },
				"password": "son"
			}
		}
	},
	"scope": {
		"project": {
			"name": "tims_project",
			"domain": { "name": "acme" }
		}
	}	
}
}' http://localhost:35357/v3/auth/tokens
```

```
HTTP/1.1 201 Created
Date: Mon, 24 Apr 2017 10:33:24 GMT
Server: Apache/2.4.18 (Ubuntu)
X-Subject-Token: gAAAAABY_dR0H8D-HetgnB3DJZyhev_fIKF2wnfC4efmAp6ViE7z9S8-puq61C6dRzMAvlqodobJIuJG25HM-rVYDWBmVTD_kPrvSvaX3IIkkoLDsMSHBZ3yLrofwn0JMuPcMQOQLffTXe1F1mp2gRIF6N11-8qk7alHVgNWG2RG6h0MUPtXr34
Vary: X-Auth-Token
X-Distribution: Ubuntu
x-openstack-request-id: req-44571f39-b7d5-4462-b4eb-8d0374ee5df3
Content-Length: 3342
Content-Type: application/json

{"token": {"is_domain": false, "methods": ["password"], "roles": [{"id": "9fe2ff9ee4384b1894a90878d3e92bab", "name": "_member_"}], "expires_at": "2017-04-24T11:33:24.000000Z", "project": {"domain": {"id": "bf81a62bf0b54c828dfd342ddcc0d244", "name": "acme"}, "id": "4a342c8bd5dd459c857946767d740689", "name": "tims_project"}, "catalog": [{"endpoints": [{"region_id": "RegionOne", "url": "http://controller:5000/v3/", "region": "RegionOne", "interface": "internal", "id": "20d326e2a1d3449383bc528d0a5c7ba2"}, {"region_id": "RegionOne", "url": "http://controller:35357/v3/", "region": "RegionOne", "interface": "admin", "id": "47a7d6c1f34e47988d1e104628be7850"}, {"region_id": "RegionOne", "url": "http://controller:5000/v3/", "region": "RegionOne", "interface": "public", "id": "c096db2e39ea482f9083a8c6bb911053"}], "type": "identity", "id": "1045b29c81d5480a945e0ffffce3b7e7", "name": "keystone"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "internal", "id": "888ee3be94b34d70b0cf17b7a81ac594"}, {"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "public", "id": "e67ce49945f8459ca45128cb1c69a21b"}, {"region_id": "RegionOne", "url": "http://controller:8774/v2.1", "region": "RegionOne", "interface": "admin", "id": "fe06aca0361547ed87c3ea74a41023e1"}], "type": "compute", "id": "38f4a515fd264b4aaf957d23aec90fe1", "name": "nova"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "public", "id": "4f62cace9d56440f832e7eb66a074be3"}, {"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "internal", "id": "6ea87df34e854e369a39fd8845882ec3"}, {"region_id": "RegionOne", "url": "http://controller:9696", "region": "RegionOne", "interface": "admin", "id": "6f05a93d323c4b11a493810f1a1eac2a"}], "type": "network", "id": "498bb0bb11174ba097ce506ba5d87552", "name": "neutron"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "internal", "id": "8de2c585ddee482fac8a6b6fa5c2854a"}, {"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "admin", "id": "d329393fa04144a6acbd5f206f6687bf"}, {"region_id": "RegionOne", "url": "http://controller:9292", "region": "RegionOne", "interface": "public", "id": "e070382ebc6640eb8bcbcb748e722c94"}], "type": "image", "id": "76e9c67a663a4594b9cd4d8a612b2364", "name": "glance"}, {"endpoints": [{"region_id": "RegionOne", "url": "http://controller:8778", "region": "RegionOne", "interface": "admin", "id": "750920ea265a43b4be39050d1e2c299f"}, {"region_id": "RegionOne", "url": "http://controller:8778", "region": "RegionOne", "interface": "internal", "id": "d21598f990504a9da96ec08b649addb8"}, {"region_id": "RegionOne", "url": "http://controller:8778", "region": "RegionOne", "interface": "public", "id": "db39c3023b8a4fd9b1721cbc50beeed6"}], "type": "placement", "id": "e2b580f6921946cd8d8545e002768d9f", "name": "placement"}], "user": {"password_expires_at": null, "domain": {"id": "bf81a62bf0b54c828dfd342ddcc0d244", "name": "acme"}, "id": "df9b146c5b5446c297fb25902095612e", "name": "son"}, "audit_ids": ["sTMU45xuRAuqdtVbVjIRrA"], "issued_at": "2017-04-24T10:33:24.000000Z"}}
```

<a name="3"></a>
# 3.Basic Keystone Operations Using Horizon

<a name="3.1"></a>
## 3.1.What Keystone Operations Are Available through Horizon?
Có nhiều Keystone operations khác nhau được hỗ trợ thông qua Horizon, OpenStack’s Dashboard. Tuy nhiên, phụ thuộc vào version enable trong file cấu hình Horizon, có nhiều thứ khác nhau.  
Nếu v2 của Identity API được enabled, chỉ duy nhất User và Project CRUD sẽ hỗ trợ sẵn, users sẽ chỉ có khả năng authenticate trong một domain.  
Nếu v3 của Identity API được enabled, User, Group, Project, Domain và Role CRUD sẽ hỗ trợ sẵn, users sẽ có khả năng authenticate trên multiple domains.  

<a name="3.2"></a>
## 3.2.Accessing the Identity Operations
The Identity operations will appear in their own menu on the left-hand accordion. (v3 API Identity)  

<img src="http://imgur.com/KzN0BJH.png" />

<a name="3.3"></a>
## 3.3.List, Set, Delete, Create, and View a Project
From Horizon, a user will be able to perform the same project-based command line operations.  

<img src="http://imgur.com/JVNxxTY.png" />

<a name="3.4"></a>
## 3.4.List, Set, Delete, Create, and View a User
From Horizon, a user will be able to perform the same user-based command line operations.  

<img src="http://imgur.com/Zop8M2y.png" />









































