# Cài đặt và cấu hình iptables


# 1.Cài đặt
\- Chạy lệnh:  
```
sudo apt install iptables
```

# 2.Cấu hình
\- Kích hoạt iptables fordward packet sang máy khác, ta cần sửa file `/etc/sysctl.conf`:  
```
net.ipv4.ip_forward = 1
```

Chạy lệnh `sysctl -p /etc/sysctl.conf` để kiểm tra cài đặt.

\- Sau đó:  
- Trên Debian/Ubuntu:  
```
/etc/init.d/procps.sh restart
```

VD trên Ubuntu Server 16.04:  
```
/etc/init.d/procps restart
```

- Trên RetHat:  
```
service network restart
```







