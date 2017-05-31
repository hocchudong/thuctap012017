# KVM tool

## Mục lục

[1. Giới thiệu và cài đặt KVM](#1)

[2. Công cụ quản lý với giao diện dòng lệnh - Virsh](#2)

[3. Công cụ quản lý với giao diện đồ họa - Virt manager](#3)

[4. Tham khảo](#4)


<a name="1"></a>

## 1. Giới thiệu và cài đặt KVM

-Bạn có thể sử dụng KVM trực tiếp hoặc cùng với những công cụ dòng lệnh khác, nhưng ứng dụng quản lý máy ảo (Virt-Manager) giao diện đồ họa sẽ giúp dễ dàng hơn cho những người đã từng sử dụng chương trình máy ảo khác.

-Trước hết chúng ta sẽ cài đặt KVM trên Ubuntu 16.04 theo các bước sau:

### Bước 1: 
KVM chỉ làm việc nếu CPU hỗ trợ ảo hóa phần cứng, Intel VT-x hoặc AMD-V. Để xác định CPU có những tính năng này không, thực hiện lệnh sau

```
egrep -c '(svm|vmx)' /proc/cpuinfo
```

-Giá trị 0 chỉ thị rằng CPU không hỗ trợ ảo hóa phần cứng trong khi giá trị khác 0 chỉ thị có hỗ trợ. Người dùng có thể vẫn phải kích hoạt chức năng hỗ trợ ảo hóa phần cứng trong BIOS của máy kể cả khi câu lệnh này trả về giá trị khác 0.

[Hình 1](http://i.imgur.com/BBrqNce.png)

### Bước 2:
-Sử dụng lệnh sau để cài KVM và các gói phụ trợ đi kèm

```
sudo apt-get install qemu-kvm libvirt-bin bridge-utils 
```

[Hình 2](http://i.imgur.com/BBrqNce.png)

### Bước 3: 
-Chỉ quản trị viên (root user) và những người dùng thuộc libvirtd group có quyền sử dụng máy ảo KVM. Chạy lệnh sau để thêm tài khoản người dùng vào libvirtd group:

```
sudo adduser name_user libvirtd
```

### Bước 4:
-Sau khi chạy lệnh này, đăng xuất rồi đăng nhập trở lại. Nhập câu lệnh sau sau khi đăng nhập:

```
sudo virsh list
```

[Hình 3](http://i.imgur.com/YKCAIDW.png)

<a name="2"></a>

## 2. Công cụ quản lý với giao diện dòng lệnh - Virsh

-Địa chỉ cấu hình mặc định của KVM

     -Default directory: /var/lib/libvirt/

     -ISO images for installation: /var/lib/libvirt/boot/

     -VM installation directory: /var/lib/libvirt/images/

     -Libvirt configuration directory for LVM/LXC/qemu: /etc/libvirt/

### 2.1 Tạo máy ảo bằng file iso có sẵn

-Đầu tiên ta cần tải file iso của OS mà chúng ta muốn cài máy ảo về máy (ví dụ ubuntu):

```
cd /var/lib/libvirt/images

sudo wget http://releases.ubuntu.com/xenial/ubuntu-16.04.2-desktop-amd64.iso

sudo ls
```

-Sau đó cài đặt VM bằng câu lệnh virt-install với các tham số đầu vào về CPU. memory như bạn mong muốn:

```
virt-install \
--name ubuntu1604 \
--ram 1024 \
--disk path=./ubuntu1604.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network network=default \
--graphics none \
--console pty,target_type=serial \
--location '/var/lib/libvirt/boot/ubuntu-16.04.2-desktop-amd64.iso' \
--extra-args 'console=ttyS0,115200n8 serial'
```

-Sau đó đợi quá trình cài đặt xong và sử dụng. Sau khi cài đặt xong bạn có thể sử dụng câu lệnh sau để kiểm tra VM đã được cài và chạy chưa

```
sudo virsh start ubuntu1604 (tên của VM bạn vừa cài đặt)

sudo virsh list 
```

### 2.2 Tạo VM từ internet

-Bạn chỉ cần thay tham số truyền vào của trường location thành 

```
location 'http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd' \
```

-Một số ví dụ về các hệ điều hành khác như sau:

Debian8

```
virt-install \
--name debian8 \
--ram 1024 \
--disk path=./debian8.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://ftp.nl.debian.org/debian/dists/jessie/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

CentOS7

```
virt-install \
--name centos7 \
--ram 1024 \
--disk path=./centos7.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant centos7 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://mirror.i3d.net/pub/centos/7/os/x86_64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

OpenSUSE 13

```
virt-install \
--name opensuse13 \
--ram 1024 \
--disk path=./opensuse13.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://download.opensuse.org/distribution/13.2/repo/oss/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

-Bạn có thể tham khảo các tham số của lệnh virt-install tại: https://linux.die.net/man/1/virt-install

<a name="3"></a>

## 3. Công cụ quản lý bằng giao diện đồ họa - Virt Manager

-Bạn cần cài cộng cụ virt manager bằng câu lệnh sau:

```
sudo apt-get install virt-manager
```

-Bật virt-manager bằng câu lệnh:

```
sudo virt-manager
```

[Hình 4](http://i.imgur.com/RVNM9xM.png)

-Vì đây là giao diện đồ họa nên bạn sẽ rất dễ dàng trong việc sử dụng, tạo và quản lý các máy ảo của bạn:

[Hình 5](http://i.imgur.com/qRaLj0p.png)

[Hình 6](http://i.imgur.com/BerTHbk.png)

[Hình 7](http://i.imgur.com/0IU8Uxz.png)

[Hình 8](http://i.imgur.com/0IU8Uxz.png)

-Ngoài Virt Manager bằng công cụ đồ họa bạn còn có thể quản lý các VMs bằng giao diện web. Bài viết sau sẽ viết về Webvirtmgr


<a name="4"></a>

## 4. Tham khảo

-https://raymii.org/s/articles/virt-install_introduction_and_copy_paste_distro_install_commands.html#Ubuntu_14.04

-https://www.cyberciti.biz/faq/how-to-install-kvm-on-ubuntu-linux-14-04/


