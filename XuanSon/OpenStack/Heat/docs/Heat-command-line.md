# Heat command line

# MỤC LỤC
- [1.OpenStack command line](#1)
- [2.Heat command client](#2)
- [3.Heat api](#3)
- [4.Sử dụng dashboard](#4)

<a name="1"></a>
# 1.OpenStack command line
\- Tham khảo:  
https://docs.openstack.org/python-heatclient/latest/cli/index.html  

## 1.1.Stack
\- Tạo stack  
```
openstack stack create [--timeout <timeout>] [--enable-rollback] [--wait] [-e <environment>] -t <template> <stack-name>
```

- --timeout <timeout> :  Stack đang tạo timeout trong vài phút.
- --enable-rollback :  Enable rollback trên create/update lỗi.
- --wait : Chờ cho đến khi stack chuyển sang trạng thái CREATE_COMPLETE hoặc CREATE_FAILED




<img src="../images/heat-command-1.png" />

\- Xóa stack  
```
openstack stack delete [--wait] <stack> [<stack> ...]
```

- --wait : Chờ cho quá trình xóa stack hoàn thành
- stack : Tên hoặc id của stack bị xóa 

\- Liệt kê danh sách stack  
```
openstack stack list
```

<img src="../images/heat-command-2.png" />

\- Show chi tiết về stack  
```
openstack stack show <stack>
```

VD:  
```
root@controller:~/stack# openstack stack show VM1
+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| Field                 | Value                                                                                                              |
+-----------------------+--------------------------------------------------------------------------------------------------------------------+
| id                    | e9f1d080-9461-4dc7-bd2d-fa232cc01a01                                                                               |
| stack_name            | VM1                                                                                                                |
| description           | Create a instance                                                                                                  |
| creation_time         | 2018-03-26T14:58:14Z                                                                                               |
| updated_time          | None                                                                                                               |
| stack_status          | CREATE_COMPLETE                                                                                                    |
| stack_status_reason   | Stack CREATE completed successfully                                                                                |
| parameters            | OS::project_id: 960918fcb2d34071a87ea67f8d685aa4                                                                   |
|                       | OS::stack_id: e9f1d080-9461-4dc7-bd2d-fa232cc01a01                                                                 |
|                       | OS::stack_name: VM1                                                                                                |
|                       | cidr: 10.1.0.0/24                                                                                                  |
|                       | dns: 8.8.8.8,8.8.4.4                                                                                               |
|                       | flavor: medium                                                                                                     |
|                       | image: ubuntu16.04                                                                                                 |
|                       | public_network: provider                                                                                           |
|                       |                                                                                                                    |
| outputs               | - description: Floating Ip of instance                                                                             |
|                       |   output_key: instance_ip_floating                                                                                 |
|                       |   output_value: 192.168.101.3                                                                                      |
|                       | - description: Private key                                                                                         |
|                       |   output_key: private_key                                                                                          |
|                       |   output_value: '-----BEGIN RSA PRIVATE KEY-----                                                                   |
|                       |                                                                                                                    |
|                       |     MIIEpQIBAAKCAQEAx29vvJV/t9ezsvjVwWow51G0xEyRie9zvv+YkRMQ+wx+P2Cl                                               |
|                       |                                                                                                                    |
|                       |     nfqP4iFu2g3+xufdAFsFbawqMpqbCu4xXwvVjmDX8yjL1n5fstKMzUdCOx8wqx8P                                               |
|                       |                                                                                                                    |
|                       |     ad8O1dslTzFEJ5STjAKu9DKJOPsw+E4DsmhIUopqycmTM5Ol567i5ldc3tD+Cu8c                                               |
|                       |                                                                                                                    |
|                       |     gc7ijfIpO5uhovRIZ/UgquIvP5IDNlfAt9oMpWUSJb5V4XcpPhq5+zt3NH8MFhYh                                               |
|                       |                                                                                                                    |
|                       |     TU1rirX6gwBvchy0ZNknWavRBmIF3h7yk0HL/8YpWBRtEuRRUTTytoiJdRM1o6zi                                               |
|                       |                                                                                                                    |
|                       |     G+xHlgFb6VrkSEFY8ndjulg2wjlqUXz6IxVc5wIDAQABAoIBAQCV0t+sWttR71fu                                               |
|                       |                                                                                                                    |
|                       |     cgWTggUvIjCc77C+YQchS77/7cTp9N67Gg4RenSxOtCeO7lVEEb0x2xykc45qfAj                                               |
|                       |                                                                                                                    |
|                       |     7AFnF+rdRV+2KsXHY7TdEFP6uzfEVpAnXfQkYxAwFKwYrDg5S+L0YeexSG3SQtLt                                               |
|                       |                                                                                                                    |
|                       |     Fx6r3q/GYnoLEcXmD1upi7aluKfqMt88anIgWtB5KWTJFnDDlO4XUCJq57Eubxxq                                               |
|                       |                                                                                                                    |
|                       |     VShc53IxO3SuVXbE9Id+KEL4I9456kxJ6n5OVZYbBTZOz1KWEUwDT3aricx3Xcze                                               |
|                       |                                                                                                                    |
|                       |     3ui/n+9qn7ZSPBvT0u/dGruk2wOqGZsk0OL2EL5+F6R9K8MQMsdiD3wLeAVcO6ht                                               |
|                       |                                                                                                                    |
|                       |     8V8ZztlBAoGBAO8ZueVa0WHTK+oA4CQIT8vMEp4vKjmZvE3f61dffNdHHPPSfGEp                                               |
|                       |                                                                                                                    |
|                       |     F/QCUIKX9ryBfB7KXvF+mVnO6kx4ZYtugyAWDIri9kwvuedLJAcSbTYlZwHJRtHB                                               |
|                       |                                                                                                                    |
|                       |     gNC2DCWA+3qkGpRztinAyBLDXx9BaM8eFhXGe/AQuDxVUGQ9tKf5rGVxAoGBANWI                                               |
|                       |                                                                                                                    |
|                       |     ApFktzhPEcG3sdHumQnvM/Vj7KRdtslpQkUVGjCHcayxZuN52C5N1YEQmZX4UfXv                                               |
|                       |                                                                                                                    |
|                       |     vWzY3TTpS9LgLYDewXh/M0325iVl3UTkYxzYYPMvGXa6ZRU1a8LUJ6oHymPtzUoJ                                               |
|                       |                                                                                                                    |
|                       |     9D8LBCcaC47mZxLjMcjxuyxO1ABvVqEMy5IMjVvXAoGBAK8ghrppFKe0Rpv03DdI                                               |
|                       |                                                                                                                    |
|                       |     Jzo8VP6ryR+7bOMVOYkblZMQsTIdX6DCupqs/09IAx77MHBVBcmYUrYnChHMtYO1                                               |
|                       |                                                                                                                    |
|                       |     BDICNFmd94zCAEZbER5k7r0UFCiIxmhodPNqA+eMW6XugNFvF2PpoiGsHAYGoL/j                                               |
|                       |                                                                                                                    |
|                       |     Z4W3hZvGg0sdqe5iC+pkw1LhAoGARTan9m7aANOIYu1jIzQewRybD/CK1SBXTmPj                                               |
|                       |                                                                                                                    |
|                       |     Cjdz3MUacKq0OgnVq/SovwQddIIgNwK1uOF2ml8Ap+LofPw3ZBJ/E8dzBC5Hkbwh                                               |
|                       |                                                                                                                    |
|                       |     8Eim7EyZCWYTu9MsEePo03FhBhEf2N7vH7w3ZWFI29INGQ8xpPvN+ue2SknMn7lh                                               |
|                       |                                                                                                                    |
|                       |     Bv8wltMCgYEAtp+64mNpPZT0wg+X9Pl2voLmgIAVADmC64d8qA39DIV5ngYsct8p                                               |
|                       |                                                                                                                    |
|                       |     KJ2REf5vBIEhbPNM73zbK80CczFv3xN4Igs1PoP56YPeE+InzR6V2JN5PPguq04Y                                               |
|                       |                                                                                                                    |
|                       |     J10kOrqlUujJF8wj5W76o06xJSFPNCpDEmiMM5AYOis4FDLeqM6K6Bk=                                                       |
|                       |                                                                                                                    |
|                       |     -----END RSA PRIVATE KEY-----                                                                                  |
|                       |                                                                                                                    |
|                       |     '                                                                                                              |
|                       | - description: Ip private of instance                                                                              |
|                       |   output_key: instance_ip_private                                                                                  |
|                       |   output_value: 10.1.0.5                                                                                           |
|                       |                                                                                                                    |
| links                 | - href: http://controller:8004/v1/960918fcb2d34071a87ea67f8d685aa4/stacks/VM1/e9f1d080-9461-4dc7-bd2d-fa232cc01a01 |
|                       |   rel: self                                                                                                        |
|                       |                                                                                                                    |
| parent                | None                                                                                                               |
| disable_rollback      | True                                                                                                               |
| deletion_time         | None                                                                                                               |
| stack_user_project_id | 4ba639001ac4400b9f7d270aa7f8c882                                                                                   |
| capabilities          | []                                                                                                                 |
| notification_topics   | []                                                                                                                 |
| stack_owner           | None                                                                                                               |
| timeout_mins          | None                                                                                                               |
| tags                  | None                                                                                                               |
+-----------------------+--------------------------------------------------------------------------------------------------------------------+
```

\- Liệt kê ouput của stack  
```
openstack stack output list [-f {csv,json,table,value,yaml}] <stack>
```

<img src="../images/heat-command-3.png" />

\- Show output của stack  
```
openstack stack output show [--all] <stack> [<output>]
```

Chú ý: Phải sử dụng 1 trong 2 option --all hoặc <output>.  

<img src="../images/heat-command-4.png" />

\- Liệt kê resource của stack  
```
openstack stack resource list <stack>
```

<img src="../images/heat-command-5.png" />

\- Hiển thị resource của stack  
```
openstack stack resource show <stack> <resource>
```

\- Show template của stack  
```
openstack stack template show <stack>
```

\- Update stack:  
```
openstack stack update [-t <template>] [-e <environment>] [--parameter <key=value>] <stack>
```

<a name="2"></a>
# 2.Heat command client
- Tham khảo: https://docs.openstack.org/ocata/cli-reference/heat.html  
## 2.1.Stack
\- Tạo stack  
```
heat stack-create [-t <TIMEOUT>] [-r] [-e <FILE or URL>] [-f <FILE>] [-u <URL>] <STACK_NAME>
```

- -f <FILE>, --template-file <FILE> : đường dẫn cảu template
- -u <URL>, --template-url <URL> : URL của template
- -e <FILE or URL>, --environment-file <FILE or URL> : Đường dẫn đến file environment
- -t <TIMEOUT>, --timeout <TIMEOUT> : Stack đang tạo timeout trong vài phút
- -r, --enable-rollback : Enable rollback trên create/update lỗi


\- Xóa stack
```
heat stack-delete <NAME or ID> [<NAME or ID> ...]
```

\- Liệt kê danh sách stack  
```
heat stack-list
```

\- Show chi tiết về stack  
```
heat stack-show [--no-resolve-outputs] <NAME or ID>
```

- --no-resolve-outputs : Do not resolve outputs of the stack.

\- Liệt kê ouput của stack  
```
heat output-list <NAME or ID>
```

\- Show output của stack  
```
heat output-show [-F <FORMAT>] [-a] <NAME or ID> [<OUTPUT NAME>]
```

- -F <FORMAT>, --format <FORMAT> : giá trị output format là json hoặc raw.

\- Liệt kê resource của stack  
```
heat resource-list <NAME or ID>
```

\- Hiển thị resource của stack  
```
heat resource-show <NAME or ID> <RESOURCE>
```

\- Show template của stack  
```
heat template-show <NAME or ID>
```

\- Update stack:  
```
heat stack-update [-f <FILE>] [-e <FILE or URL>] [-u <URL>] [-P <KEY1=VALUE1;KEY2=VALUE2...>] <NAME or ID>
```

- -f <FILE>, --template-file <FILE> : đường dẫn cảu template
- -u <URL>, --template-url <URL> : URL của template
- -e <FILE or URL>, --environment-file <FILE or URL> : Đường dẫn đến file environment

<a name="3"></a>
# 3.Heat api
- Tham khảo: https://developer.openstack.org/api-ref/orchestration/v1/index.html

<a name="4"></a>
# 4.Sử dụng dashboard


