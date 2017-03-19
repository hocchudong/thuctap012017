# Lab thực hành về lệnh SCP

## Mô hình bài Lab
![Imgur](http://i.imgur.com/0iwMTap.png)

- Bài Lab như sau:
	- client có địa chỉ IP: 172.16.69.128
	- hai server lần lượt có địa chỉ ip là `172.16.69.129` và `172.16.69.130`
	- tất cả các host đều sử dụng OS là ubuntu
	- chúng ta sẽ đứng tại client để thực hiện các kỹ thuật về **scp**
	- trên server `172.16.69.129` có cấu trúc thư mục lưu các file để lab như sau ![Imgur](http://i.imgur.com/T6MCLFO.png)
	- trên server `172.16.69.130` có cấu trúc thư mục lưu các file để lab như sau ![Imgur](http://i.imgur.com/BvmQpjK.png)
	
- Trên máy client có thư mục /home/pxduc/container để chứa các file copy từ server về và thư mục /home/pxduc/push chứa các file để đẩy đi

## 1.Đứng từ cilent copy file từ máy chủ về và đặt vào thư mục mong muốn.
Copy file `s1.txt` từ `172.16.69.129` về `172.16.69.128`:

```sh
scp root@172.16.69.129:/home/pxduc/directory/s1.txt /home/pxduc/container/
```

## 2. Đẩy file từ client lên máy chủ.
Copy file `s1.txt` từ `172.16.69.128` về `172.16.69.129`:
```sh
scp /home/pxduc/push/pu1.txt root@172.16.69.129:/home/pxduc/directory
```

## 3. Thực hiện SCP với cả thư mục (gồm nhiều file và thư mục rỗng ở trong)
- Trên client có thư mục rỗng là /home/pxduc/push/empty
- Để đẩy tất cả các file trong thư mục `push` và cả thư mục rỗng `/empty`, chỉ cần thêm tham số `-r`
```sh
scp -r /home/pxduc/push/ root@172.16.69.129:/home/pxduc/directory
```

## 4. copy nhiều file cùng một lúc (copy 2 file pu1.txt và pu2.txt lên server 172.16.69.130)
```sh
scp /home/pxduc/push/pu1.txt /home/pxduc/push/pu2.txt root@172.16.69.130:/home/pxduc/folder
```

Các file chỉ cần cách nhau bởi dấu cách.

## 5. Copy nhiều files từ server về local
Copy 2 file ser1.txt và ser2.txt về

```sh
scp root@172.16.69.130:/home/pxduc/folder/{ser1.txt,ser2.txt} .
``` 
