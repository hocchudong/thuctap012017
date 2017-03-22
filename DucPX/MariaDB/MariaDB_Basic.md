# Hệ quản trị cơ sở dữ liệu MySQL (MariaDB)

## Mục lục
- 1. Cài đặt MariaDB.
- 2. Cấu hình cho phép đăng nhập từ xa MariaDB.
- 3. Kiểm tra các user trong DB, các database đã được tạo.
- 4. Kiểm tra dung lượng của một DB đã tạo trong MySQL or MariaDB.
- 5. Backup các Database đã tạo (áp dụng với wordpress).
- 6. Restore database đã tạo (áp dụng với wordpress).


## 1. Cài đặt MariaDB.

- `sudo  apt-get install -y mariadb-server` để cài đặt MariaDB trên server
- trong quá trình cài đặt cần cung cấp mật khẩu cho tài khoản **root** của mysql ![Imgur](http://i.imgur.com/06q4Cxb.png)
- Sau khi cài đặt xong MariaDB, chúng ta nên activate nó bằng lệnh `sudo mysql_install_db`
- Kết thúc quá trình cài đặt bằng chạy lệnh `sudo /usr/bin/mysql_secure_installation`


## 2. Cấu hình cho phép đăng nhập từ xa MariaDB.

- copy file cấu hình cũ sang một file khác

```sh
sudo copy /etc/mysql/my.cnf /etc/mysql/my.cnf.original
```

- `sudo vi /etc/mysql/my.cnf`

- comment dòng

```sh
#bind-address           = 127.0.0.1
#skip-networking
``` 

- sau đó restart lại mysql `sudo service mysql restart`
- Sau khi cài đặt xong, mặc định trong mysql có username và password để đăng nhập tại local. Vì vậy cần cấp quyền cho phép tài khoản đăng nhập từ xa. Cho phép tài khoản root đăng nhập từ tất cả các máy khác.
	- `mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456789' WITH GRANT OPTION;`
	- Tại client cần được cài đặt mariadb-client. Đăng nhập vào mysql bằng lệnh `mysql -u root -p123456789 -h <ipserver>`
		
## 3. Kiểm tra các user trong DB, các database đã được tạo.
- Kiểm tra có user nào trong database: `select user from mysql.user;`
- show ra các database: `show databases;`

## 4. Kiểm tra dung lượng của một DB đã tạo trong MySQL or MariaDB.
`select table_schema "DB name", sum(data_length + index_length)/1024/1024 "database size in Mb" from information_schema.tables group by table_schema;`

![Imgur](http://i.imgur.com/Hbn3uTf.png) 

## 5. Backup các Database đã tạo (áp dụng với wordpress).
`mysqldump -u root -p123456789 -h 10.10.10.2 wordpress > wordpress.sql`

![Imgur](http://i.imgur.com/RvNxj6k.png)

## 6. Restore database đã tạo (áp dụng với wordpress).
`mysqldump -u root -p123456789 -h 10.10.10.2 wordpress < wordpress.sql`