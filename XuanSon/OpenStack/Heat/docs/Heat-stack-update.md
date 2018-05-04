# Heat stack update
\- Heat stack update là việc cập nhật stack đã tồn tại như việc cập nhật địa chỉ mạng, image, flavor,…  
\-  1 số tài resource được cập nhật, trong khi 1 số resource khác được thay thế bởi resource mới.  
\- VD:  
```
$ openstack stack update -t private-network.yaml --parameter "cidr=10.2.0.0/24" private_network
+---------------------+-------------------------------------------------------------------+
| Field               | Value                                                             |
+---------------------+-------------------------------------------------------------------+
| id                  | b8701b94-f55e-492e-9b55-4157e7281a52                              |
| stack_name          | test                                                              |
| description         | Create a new network with subnet  subnet address is "10.1.0.0/24" |
|                     |                                                                   |
| creation_time       | 2018-04-03T17:19:35Z                                              |
| updated_time        | 2018-04-03T17:24:05Z                                              |
| stack_status        | UPDATE_IN_PROGRESS                                                |
| stack_status_reason | Stack UPDATE started                                              |
+---------------------+-------------------------------------------------------------------+
```

