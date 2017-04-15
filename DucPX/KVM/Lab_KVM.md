# Cài đặt và sử dụng KVM

# Mục lục 

## [Chuẩn bị môi trường Lab](#lab)

## [Tiến hành cài đặt KVM](#install)

## [Bắt đầu cài đặt máy ảo.](#start)

[1. Cài máy ảo từ file iso](#1)

[2. Tạo máy ảo trong KVM bằng lệnh từ file img có sẵn (giống kiểu GHOST)](#2)

[3. Tạo máy ảo trong KVM bằng lệnh và cài từ internet](#3)

[4. Thu mục chứa máy ảo](#4)

[5. File log của KVM](#5)

[6. Lệnh để xem thông tin của file img (file chứa disk của máy ảo)](#6)

[7. Tạo snapshot cho máy ảo](#7)

<a name=lab></a>
## Chuẩn bị môi trường Lab

- Chúng ta sẽ thực hiện bài lab trên máy ảo VMware workstations, dùng hệ điều hành Ubuntu server 14.04 64bit có hỗ trợ ảo hóa.
- Chọn chuột phải vào máy ảo, chọn **Setting**. Cửa sổ mới xuật hiện, click vào ô màu đỏ để cho phép ảo hóa.

![Imgur](http://i.imgur.com/y2Wqf24.png)

- Kiểm tra xem máy ảo có cho phép ảo hóa hay không? 

	`egrep -c '(svm|vmx)' /proc/cpuinfo`
	
	![Imgur](http://i.imgur.com/PtLKLlV.png) 

	Giá trị 0 chỉ thị rằng CPU không hỗ trợ ảo hóa phần cứng trong khi giá trị khác 0 chỉ thị có hỗ trợ. Ở đây giá trị của mình là 4.

<a name=install></a>
## Tiến hành cài đặt KVM

- Cài đặt các gói phần mềm cần thiết

	`sudo apt-get install -y qemu-kvm libvirt-bin bridge-utils virt-manager virt-viewer`

- Gói *virt-manager* và *virt-viewer* để hỗ trợ quản lý máy ảo bằng giao diện đồ họa. Nếu không cài hai gói này, chúng ta cũng có thể quản lý các máy ảo bằng dòng lệnh.
- Sau khi cài đặt xong, hệ thống sẽ tự động tạo ra một Group là **libvirtd** và chỉ có quản trị viên (root user) những người dùng thuộc libvirtd group có quyền sử dụng máy ảo KVM. Chạy lệnh sau để thêm tài khoản người dùng vào libvirtd group:
	- `sudo adduser Username libvirtd`


- Đến đây là cài đặt xong kvm. 

<a name=start></a>
## Bắt đầu cài đặt máy ảo.

<a name=1></a>
#### 1. Cài máy ảo từ file iso
- Chúng ta phải có một file iso dùng để cài đặt máy ảo. Có thể tải từ internet hoặc dùng winscp để đẩy file iso từ máy vật lý vào máy ảo (máy ảo là máy chạy kvm).
- file iso được đặt tại folder `/var/lib/libvirt/boot`
- Máy ảo có thể được tạo bằng **virt-manager** hoặc lệnh **virt-install**
- Chúng ta sẽ tạo bằng cả hai cách:
	
##### 1.1 Tạo bằng **virt-manager**:
- Đăng nhập vào server thông qua MobaXterm.
- Nhập lệnh **virt-manager** sẽ xuất hiện một cửa sổ như hình dưới.

![Imgur](http://i.imgur.com/IIWqvvF.png)

- Tạo máy mới bằng cách click vào **New**.

![Imgur](http://i.imgur.com/GhCfmUS.png)

- Đặt tên máy ảo **vm1** và chọn cách cài đặt, sau đó click **Forward**

![Imgur](http://i.imgur.com/BizYAbf.png)

- Chỉ đường dẫn tới file iso (1), chọn kiểu hệ điều hành (2). Click **Forwarrd** để chuyển sang bước tiếp theo.
 
![Imgur](http://i.imgur.com/juNjN5I.png)

- Chọn dung lượng bộ nhớ RAM và số lượng CPU. Click **Forward**

![Imgur](http://i.imgur.com/l1Dw8Oh.png)

- Chọn dung lượng ổ đĩa để cài hệ điều hành.

![Imgur](http://i.imgur.com/aJKV8Vj.png)

- Kiểm tra lại các thông tin. Chú ý đến đường dẫn lưu trữ file img của máy ảo. Chúng ta cũng có thể thay đổi card mạng cho máy ảo. Ở đây đang để mặc định. Click **Finish** để hoàn thành cài đặt.

![Imgur](http://i.imgur.com/Li6SD6v.png)

- Sau khi click **Finish** sẽ xuất hiện cửa sổ để cài đặt. Chúng ta tiến hành cài đặt bình thường.

![Imgur](http://i.imgur.com/vadoGHS.png)

##### 1.2 Tạo bằng **virt-install**:

```sh
sudo virt-install \
--name ubuntu \
--ram 1024 \
--disk path=/var/lib/libvirt/images/ubuntu.qcow2,size=5,bus=virtio,format=qcow2 \
--vcpus 1 \
--os-variant rhel7 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location /var/lib/libvirt/boot/ubuntu-14.04.5-server-amd64.iso \
--extra-args 'console=ttyS0,115200n8 serial'
```

- Sau khi nhập lệnh trên, ta được kết quả sau và bằng đầu cài đặt.

![Imgur](http://i.imgur.com/B7ZQ4PS.png)

<a name=2></a>
#### 2. Tạo máy ảo trong KVM bằng lệnh từ file img có sẵn (giống kiểu GHOST)
- Liệt kê xem tất cả có bao nhiêu máy ảo đang trong kvm?

`virsh list --all`

![Imgur](http://i.imgur.com/BYKfBQo.png)

- File img có thể download từ trên mạng hoặc copy từ một máy ảo khác.
- Chúng ta có một file vm69.img được dùng để tạo một máy ảo

![Imgur](http://i.imgur.com/U89gj3g.png)

- lệnh để tạo máy ảo từ một file img có trước như sau: 

```sh 
 virt-install \
--name vm69 \
--ram 2048 \
--disk path=/var/lib/libvirt/images/vm69.img,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant ubuntutrusty \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--import 
```
**disk path=/var/lib/libvirt/images/vm69.img** là đường dẫn tới file img.

![Imgur](http://i.imgur.com/RLnt1SJ.png)

- vào `virt-manager` ta có thể thấy máy ảo vm69 đang chạy

![Imgur](http://i.imgur.com/YvimqHp.png)

<a name=3></a>
#### 3. Tạo máy ảo trong KVM bằng lệnh và cài từ internet

```sh
virt-install \
--name centos7 \
--ram 4096 \
--disk path=/var/kvm/images/centos7.img,size=5 \
--vcpus 2 \
--os-type linux \
--os-variant rhel7 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://ftp.iij.ad.jp/pub/linux/centos/7/os/x86_64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

**location 'http://ftp.iij.ad.jp/pub/linux/centos/7/os/x86_64/** chỉ đường dẫn tới file trên internet sẽ được tải về và tiến hành cài đặt. 

Lưu ý: Card mạng virbr0 phải được kết nối internet.
<a name=4></a>
#### 4. Thư mục chứa máy ảo

- Các máy ảo trong KVM mặc định được lưu trong thư mục `/var/lib/libvirt/images/`
- Thông tin cấu hình của máy ảo nằm ở thư mục `/etc/libvirt/qemu/`. Trong thư mục này sẽ chứa tất cả các file cấu hình của từng máy ảo hiện có trong KVM. Chúng ta có thể chỉnh sửa thông tin của máy ảo trực tiếp từ file này hoặc bằng lệnh `virsh edit <tên máy ảo>`

<a name=5></a>
#### 5. File log của KVM
- Các file log của KVM nằm trong thư mục `/var/log/libvirt/`
- Log ghi lại hoạt động của từng máy ảo nằm trong thư mục `/var/log/libvirt/qemu/`. Khi một máy ảo được tạo thì sẽ tự động tạo một file log cho máy ảo đó và được lưu trong thư mục này.

<a name=6></a>
#### 6. Lệnh để xem thông tin của file img (file chứa disk của máy ảo)

`qemu-img info <đường dẫn tới file img>`

![Imgur](http://i.imgur.com/EAQTrGa.png)

<a name=7></a>
#### 7. Tạo snapshot cho máy ảo

`qemu-img snapshot -c <tên snapshot> <tên file img>`

- Tạo một snapshot và kiểm tra thông tin trong file img sẽ có thông tin về snapshot vừa tạo

![Imgur](http://i.imgur.com/cyRKEg2.png)