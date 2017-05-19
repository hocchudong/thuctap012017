# Mô hình cài OpenStack
## Mô hình cài đặt OpenStack ocata
<img src="../images/1.png" />

<img src="../images/2.png" />


## Hướng dẫn cài theo shell scripts
\- Download các file shell scripts. Sau đó thực hiện các bước sau với quyền `root`.  
\- Set quyền 755 cho các files đó.  
```
chmod 755 *
```

\- Chỉnh sử tên network card theo server của bạn trong file `config.cnf`. 

\- Thực thi các file theo comand sau:  

```
source function.sh
source config.cnf
source ctl-0-ipaddr.sh
source ctl-1-environment.sh
source ctl-2-keystone.sh
```











