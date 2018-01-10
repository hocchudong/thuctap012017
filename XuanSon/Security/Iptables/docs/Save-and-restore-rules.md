# Save và restore bộ rules

# MỤC LỤC



\- iptables có 2 công cụ để lưu trữ và khôi phục bộ các rules, đó là **iptables-save** và **iptables-restore**.  
\- Các rules của iptables được lưu trong memory nên khi khởi động lợi máy, các rules sẽ bị xóa hoàn toàn. Vì vậy ta cần dùng đến 2 công cụ đó là **iptables-save** và **iptables-restore**. Chúng lưu trữ các rules trong định dạng file text.  
\- **iptables-save** sẽ lấy toàn bộ rules từ kernel và lưu nó vào 1 file. **iptables-restore** sẽ tải lên 1 bộ rules để phòng khi cần khôi phục bộ rules đó.  

# 1.iptables-save
\- Cú pháp  
```
iptables-save [-c] [-t tables]
```

- Tham số `-c`: Lưu lại các giá trị được chỉ định trong bộ đếm bytes và packet.
- `-t`: chỉ định lưu lại tables nào. Nếu không chỉ định, mặc định iptables-save sẽ lưu lại tất cả các tables.

\- VD:  
<img src="../images/save-and-restore-1.png>

<img src="../images/save-and-restore-2.png>

\- Nhìn ví dụ ta thấy:  
- Mỗi tables chứa 1 vài comments với dấu #. Mỗi tables bắt đầu với dấu *.
- Với mỗi tables, có các chain và rules. 
- Mỗi chain được chỉ định như: `:<chain-name> <chain-policy> [<packet-counter>:<byte-counter>]`

\- Lưu bộ rules ra 1 file:  
```
iptables-save -c > /etc/iptables-save
```

# 2.iptables-restore
\- **iptables-restore** được sử dụng để khôi phục bộ rule iptables được lưu bởi **iptables-save**.  
\- Cú pháp:  
```
iptables-restore [-c] [-n]
```

- Tham số `-c`: Khôi phục các giá trị bộ đếm bytes và packet.  
- `-n`: chỉ định không ghi đề nên các rules có sẵn trong tables. Mặc định, **iptables-restore** sẽ xóa hết các rules trước đó. Option `-n` có thể được thay thế với định option **--noflush**.  

\- VD:  
```
cat /etc/iptables-save | iptables-restore -c
# or 
iptables-restore -c < /etc/iptables-save
```

# 3.iptables-persistent tool
\- Ở một vài hệ điều hành khác, bạn có thể sử dụng systemd hoặc một vài tool khác để add rules vào boot. Ở ubuntu, nó có tên là `iptables-persistent`.  
```
$ sudo apt-get install -y iptables-persistent
```

\- Sau khi installing, bạn sẽ thấy các file mới trong thư mục `/etc/iptables`  
```
/etc/iptables/rules.v4 #ipv4
/etc/iptables/rules.v6 #ipv6
```

\- Bạn có thể lưu các file rule bằng lệnh như ở trên  
```
sudo iptables-save | sudo tee /etc/iptables/rules.v4
sudo ip6tables-save | sudo tee /etc/iptables/rules.v6
```







