# Thực hành triển khai mô hình lab NFS

## Mục lục
- [I. Giới thiệu NFS](#1)
- [II. Thực hiện lab](#2)

## I. Giới thiệu NFS
- NFS - Network File System là một giao thức phân phối file system, nó cho phép bạn mount các thư mục từ xa có trên server.
- NFS được phát triển bởi SUN Microsystem, bắt đầu từ năm 1984 với phiên bản đầu tiên.
- Cho đến nay đã có tất cả 6 phiên bản:
  - version 1: phát hành năm 1984 với mục đích thí nghiệm
  - version 2: phát hành năm 1989, được đưa ra thị trường
  - version 3: phát hành năm 1995 với nhiều cải tiến
  - version 4 năm 2000, version 4.1 năm 2010 và version 4.2 năm 2016
- Cho phép bạn quản lý không gian lưu trữ ở một nơi khác và ghi vào không gian lưu trữ này từ nhiều clients.
- NFS cung cấp một cách tương đối nhanh chóng và dễ dàng để truy cập vào các hệ thống từ xa qua mạng và hoạt động tốt trong các tình huống mà các tài nguyên chia sẻ sẽ được truy cập thường xuyên.
- Dung lượng file mà NFS cho phép client truy cập lớn hơn 2GB
- Truyền thông giữa client và server thực hiện qua mạng Ethernet
- Client và Server sử dụng RPC (Remote Procedure Call) để giao tiếp với nhau.
- NFS sử dụng cổng 2049
- NFS hoạt động theo mô hình client/server. Một server đóng vai trò storage system, cho phép nhiều client kết nối tới để sử dụng dịch vụ.

## II. Thực hiện lab
- Bài lab thực hiện Ubuntu Server 16.04 64-bit.
- Gồm hai con VM:
  - 1 vm đóng vai trò Host server, với IP: 172.16.1.10/24
  - 1 vm đóng vai trò client, với IP: 172.16.1.20/24
  
### 1. Tiến hành cài đặt trên node Host server
- 1. Cài đặt các thành phần

  ```sh
  apt-get update
  apt-get install nfs-kernel-server -y
  ```
  
- 2. Tạo `Share Directories`
  - Tạo thư mục
    
    ```sh
    mkdir /var/nfs/general -p
    ```
    
  - Thay đổi ownership thư mục trên
  
    ```sh
    chown nobody:nogroup /var/nfs/general
    ```

- 3. Cấu hình NFS Exports trên Host server. Thêm dòng sau vào file `/etc/exports`

  ```sh
  /var/nfs/general    172.16.1.0/24(rw,sync,no_subtree_check)
  /home               172.16.1.0/24(rw,sync,no_root_squash,no_subtree_check)
  ```
  
  - **/var/nfs/general** đây là thư mục mà chúng ta đã tạo ở trên.
  - **172.16.1.0/24** cho phép clients trong mạng 172.16.1.0 có thể truy cập vào
  - **rw** cho phép client truy cập vào có khả năng đọc và ghi.
  - **sync** option này buộc NFS ghi lại các thay đổi vào disk trước khi trả lời. Điều này dẫn đến một môi trường ổn định hơn và nhất quán vì phản hồi phản ánh tình trạng thực tế của remote volume. Tuy nhiên, nó cũng làm giảm tốc độ hoạt động của file.
  - **no_subtree_check** Tùy chọn này ngăn việc kiểm tra subtree, đó là một tiến trình mà host phải kiểm tra xem liệu tệp đó có thực sự vẫn còn trong cây export cho mọi yêu cầu hay không. Điều này có thể gây ra nhiều vấn đề khi một tập tin được đổi tên trong khi client đã mở nó. Trong hầu hết các trường hợp, tốt hơn là để vô hiệu hóa việc kiểm tra subtree.
  - **no_root_squash** Nếu từ client đăng nhập bằng tài khoản root, từ phía server sẽ chuyển vào non-privileged user trên server. Điều này vì lý do bảo mật.
- 4. Restart dịch vụ

  ```sh
  service nfs-kernel-server restart
  ```
  
### 2. Cài đặt trên client
- 1. Cài đặt các gói

  ```sh
  apt-get update
  apt-get install nfs-common -y
  ```
  
- 2. Tạo Mount point

  ```sh
  mkdir -p /nfs/general
  ```
  
- 3. Mount thư mục cho client

  ```sh
  mount 172.16.1.10:/var/nfs/general /nfs/general
  ```
  
- Kiểm tra kết quả mount

  ```sh
  ~# df -h
  Filesystem                    Size  Used Avail Use% Mounted on
  udev                          972M     0  972M   0% /dev
  tmpfs                         199M  6.0M  193M   3% /run
  /dev/mapper/ubuntu--vg-root    18G  1.4G   15G   9% /
  tmpfs                         992M     0  992M   0% /dev/shm
  tmpfs                         5.0M     0  5.0M   0% /run/lock
  tmpfs                         992M     0  992M   0% /sys/fs/cgroup
  /dev/sda1                     472M   57M  391M  13% /boot
  tmpfs                         199M     0  199M   0% /run/user/0
  172.16.1.10:/var/nfs/general   18G  1.4G   15G   9% /nfs/general
  ```
  
  - vì chúng ta đã mount cùng file system từ Host server nên sẽ hiện thị Size của cả disk host server. Dùng lệnh sau để xem thực sự dung lượng bao nhiêu đang được sử dụng
  
  ```sh
  ~# du -sh /nfs/general/
  4.0K    /nfs/general/
  ```
  
### 3. Kiểm tra lại truy cập NFS
- Tạo file mới vào thư mục `/nfs/general`

  ```sh
  touch /nfs/general/general.test
  ```

- Kiểm tra ownership của file vừa tạo

  ```sh
  ~# ls -l /nfs/general/general.test
  -rw-r--r-- 1 nobody nogroup 0 Jul 25 15:18 /nfs/general/general.test
  ```
  
- Kiểm tra thư mục `/var/nfs/general` trên Host server xem có những file gì

  ```sh
  /var/nfs/general# ls
  general.test
  ```
  
  - Ta thấy file `general.test` được tạo trên client và được lưu trên Host server.
  
### 4. Mounting the Remote NFS Directories khi khởi động.
- Khi client tắt và bật lại, thì mount point đến Host server sẽ bị mất đi. Nếu muốn sử dụng thì phải mount lại.
- Thay vì phải mount lại mỗi khi khởi động máy, chúng ta sẽ cấu hình hệ thống mount tự động.
- Chỉnh sửa file `/etc/fstab`. Thêm dòng cấu hình sau

  ```sh
  172.16.1.10:/var/nfs/general    /nfs/general   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
  ```
  
- Kiểm tra lại bằng cách restart client và dùng lệnh `df -h` để xem các mount point.

--- 
### Một số lưu ý:
- Trong quá trình vận hành có thể xảy ra một số trường hợp sau:
- 1. Có 2 client đồng thời mount cùng một thư mục trên server:
cả 2 đều có thể đồng thời chỉnh sửa cùng một file => hệ thống sẽ thông báo cho client sử dụng sau biết rằng có một client khác đang chỉnh sửa file. Nếu client này thực hiện sửa thì file sẽ lưu lại theo client nào thực hiện lưu cuối cùng.
- 2. Phía server bị fail hoặc restart dịch vụ. Client sẽ bị treo máy và chờ đến khi được kết nối trở lại. Việc kết nối được thực hiện ngầm, trong suốt với người dùng.  