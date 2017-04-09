# Tool use KVM


# MỤC LỤC
- [1.virsh](#1)
  - [1.1.Introduction and Install on Ubuntu Server 16.04](#1.1)
  - [1.2. Một số câu lệnh virsh](#1.2)
- [2.Virt-manager tool](#2)
  - [2.1.Giới thiệu](#2.1)
  - [2.2.Cài đặt on Ubuntu Desktop 16.04](#2.2)
  - [2.3.Bật](#2.3)
  - [2.4.Creating a virtual network](#2.4)
  - [2.5.Using a virtual network](#2.5)
  - [2.6.Create VM](#2.6)
- [3.Webvirtmgr tool](#3)
  - [3.1.Giới thiệu](#3.1)
  - [3.2.Cài đặt Webvirtmgr on the Ubuntu 16.04](#3.2)
    - [3.2.1.Mô hình lab](#3.2.1)
    - [3.2.2.Cài đặt Webvirtmgr (Web panel)](#3.2.2)
    - [3.2.3. Cài đặt trên host server 1 và host server 2](#3.2.3)
  - [3.3.Sử dụng Webvirt](#3.3)
- [4.virt-install](#4)
  - [4.1.Lý thuyết](#4.1)
  - [4.2.Tóm tắt](#4.2)
    - [4.2.1.Introduction](#4.2.1)
    - [4.2.2.SYNOPSIS](#4.2.2)
    - [4.2.3.Example](#4.2.3)


<a name="1"></a>
# 1.virsh

<a name="1.1"></a>
## 1.1.Introduction and Install on Ubuntu Server 16.04

### a.Introduction
\- virsh là program quản lý virtual network and virtual machine ,có giao diện command.  
\- virsh là một trong các tool của libvirt toolkit . 

### b.Install on Ubuntu Server 16.04
Run command line :  
```
sudo apt-get install libvirt-bin
```

<a name="1.2"></a>
## 1.2. Một số câu lệnh virsh

### a.VM
\- **Liệt kê VM** :  
```
virsh list [-all] [--inavtive]
```

Ví dụ :  
```
root@ubuntu:~# virsh list --all
 Id    Name                           State
----------------------------------------------------
 -     KVM                            shut off
 ```

\- **Delete VM** :  
```
virsh undefine <VMname> {--remove-all-storage [--delete-snapshots]}
```

Undefine a domain. If the domain is running, this converts it to a transient domain, without stopping it. If the domain is inactive, domain configuration is removed. 

\- **Edit VM Configuration File** :  
- Sửa file VM in folder (Ubuntu 16.04) : `/etc/libvirt/qemu`

<img src="http://i.imgur.com/Q86OajD.png" />  

- Hoặc sử dụng câu lệnh ( có nhiều thông tin hơn trong file )  :  
```
virsh edit <VMname>
```

\- **Connect to VM Console** :  
```
virsh console <VMname>
```

\- **VM Information** :  
```
virsh dominfo <VMname>
```

\- **Shutdown , Reboot, Start VM** :  
```
virsh shutdown <VMname>
virsh reboot <VMname>
virsh start <VMname>
```

### b.Pool
\- List Pool :  
```
virsh pool-list [--inactive] [--all] [--transient] [--persistent] [--autostart] [--no-autostart] [--type <string>] [--details]
```

Ví dụ :  
```
root@ubuntu:~# virsh pool-list --all --details
 Name     State    Autostart  Persistent   Capacity  Allocation  Available
---------------------------------------------------------------------------
 default  running  yes        yes         18.58 GiB    4.85 GiB  13.72 GiB
```

<a name="2"></a>
# 2.Virt-manager tool

<a name="2.1"></a>
## 2.1.Giới thiệu
\- The virt-manager application is a desktop user interface for managing virtual machines through libvirt. It primarily targets KVM VMs, but also manages Xen and LXC (linux containers).  

<a name="2.2"></a>
## 2.2.Cài đặt on Ubuntu Desktop 16.04
\- Use command line :  
```
sudo apt-get install virt-manager
```

\- Nếu muốn sử dụng **virt-manager** mà không cần quyền `root` thì có thể add user đó vào group `libvirtd` :  
```
sudo adduser <user_name> libvirtd
```

<a name="2.3"></a>
## 2.3.Bật 
\- Bật virt-manager , sử dụng command line :  
```
sudo virt-manager
```

Giao diện :  
<img src="http://i.imgur.com/MhWlKlE.png" />

<a name="2.4"></a>
## 2.4.Creating a virtual network
\- Creating virtual networks is easy when using the Virtual Machine Manager GUIT.  

### 2.4.1.Creating a NAT virtual network 
http://wiki.libvirt.org/page/TaskNATSetupVirtManager

### 2.4.2.Creating a Routed virtual network 
http://wiki.libvirt.org/page/TaskRoutedNetworkSetupVirtManager

### 2.4.3.Creating a Isolated virtual network 
http://wiki.libvirt.org/page/TaskIsolatedNetworkSetupVirtManager

## 2.4.4.Creating a bridge virtual netowrk
http://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/configure-bridged-networking-for-kvm-on-ubuntu-14-10.html

<a name="2.5"></a>
## 2.5.Using a virtual network 
### 2.5.1.Starting a virtual network 
In **virt-manager** by clicking Start Network, or in virsh net-start. This command takes one mandatory argument, the network name. When starting a virtual network, libvirt will automatically set iptables and dnsmasq. However, transient networks are created and started at once.  

### 2.5.2.Stopping a virtual network 
Stopping virtual network can be done by clicking the appropriate button in Virtual Manager or by `net-destroy`. If it is a transient network being stopped, it is also removed.  

### 2.5.1.Removing a virtual network 
Again, removing a virtual network is possible in Virtual Manager or in virsh by `net-undefine`. 

### 2.5.2.Changing a virtual network
Making changes is only available via the virsh console tool. The `net-edit` command allows the user to edit the XML configuration of a virtual network.

<a name="2.6"></a>
## 2.6.Create VM
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Host_Configuration_and_Guest_Installation_Guide/chap-Virtualization_Host_Configuration_and_Guest_Installation_Guide-Guest_Installation_Virt_Manager-Creating_guests_with_virt_manager.html 

<a name="3"></a>
# 3.Webvirtmgr tool

<a name="3.1"></a>
## 3.1.Giới thiệu
\- WebVirtMgr is a libvirt-based Web interface for managing virtual machines. It allows you to create and configure new domains, and adjust a domain's resource allocation.  
\- A VNC viewer over a SSH tunnel presents a full graphical console to the guest domain.  
\- KVM is currently the only hypervisor supported.  

<a name="3.2"></a>
## 3.2.Cài đặt Webvirtmgr on the Ubuntu 16.04

<a name="3.2.1"></a>
### 3.2.1.Mô hình lab

<img src="http://i.imgur.com/jNZnu27.png" />

Mô hình lab bao gồm 2 node(cài đặt dưới dạng máy ảo trên VMWare Workstation)
- **WebVirtMgr host**: Cài đặt WebVirtMgr
- **Host Server 1**: Server cài đặt KVM-QEMU để tạo các máy ảo
- **Host Server 2**: Server cài đặt KVM-QEMU để tạo các máy ảo

<a name="3.2.2"></a>
### 3.2.2.Cài đặt Webvirtmgr (Web panel)
\- **Step 1 : Installation**    
Run :  
```
$ sudo apt-get install git python-pip python-libvirt python-libxml2 novnc supervisor nginx
```

\- **Step 2 : Install python requirements and setup Django environment**  
Run :  
```
$ git clone git://github.com/retspen/webvirtmgr.git
$ cd webvirtmgr
$ sudo pip install -r requirements.txt # or python-pip (RedHat, Fedora, CentOS, OpenSuse)
$ ./manage.py syncdb
$ ./manage.py collectstatic
```

Enter the user information:  

```
You just installed Django's auth system, which means you don't have any superusers defined.
Would you like to create one now? (yes/no): yes (Put: yes)
Username (Leave blank to use 'admin'): admin (Put: your username or login)
E-mail address: username@domain.local (Put: your email)
Password: xxxxxx (Put: your password)
Password (again): xxxxxx (Put: confirm password)
Superuser created successfully.
```

Adding additional superusers :  
Run :  
```
$ ./manage.py createsuperuser
```

\- **Step 3 : Setup Nginx**  
If you really know what you are doing, feel free to ignore the warning and continue setting up the redirect with nginx:  
```
$ cd ..
$ sudo cp -r webvirtmgr /var/www/         ( CentOS, RedHat, Fedora, Ubuntu )      
```

Add file `webvirtmgr.conf` in `/etc/nginx/conf.d` :  
```
server {
    listen 80 default_server;

    server_name $hostname;
    #access_log /var/log/nginx/webvirtmgr_access_log; 

    location /static/ {
        root /var/www/webvirtmgr/webvirtmgr; # or /srv instead of /var
        expires max;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-for $proxy_add_x_forwarded_for;
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_send_timeout 600;
        client_max_body_size 1024M; # Set higher depending on your needs 
    }
}
```

Open nginx.conf out of `/etc/nginx/nginx.conf` (in Ubuntu 16.04 LTS the configuration is in `/etc/nginx/sites-enabled/default`):  
```
$ sudo vim /etc/nginx/nginx.conf
```

Comment the Server Section as it is shown in the example:  
```
#    server {
#        listen       80 default_server;
#        server_name  localhost;
#        root         /usr/share/nginx/html;
#
#        #charset koi8-r;
#
#        #access_log  /var/log/nginx/host.access.log  main;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        location / {
#        }
#
#        # redirect server error pages to the static page /40x.html
#        #
#        error_page  404              /404.html;
#        location = /40x.html {
#        }
#
#        # redirect server error pages to the static page /50x.html
#        #
#        error_page   500 502 503 504  /50x.html;
#        location = /50x.html {
#        }
#    }
```

Restart nginx service:  
```
$ sudo service nginx restart
```

Automatically start supervisord on Ubuntu Server 16.04:  
- Run :
```
sysv-rc-conf supervisor on
```

\- **Step 4 : Setup supervisor**  
Run: 

```
$ sudo service novnc stop
$ sudo insserv -r novnc
$ sudo vi /etc/insserv/overrides/novnc
#!/bin/sh
### BEGIN INIT INFO
# Provides:          nova-novncproxy
# Required-Start:    $network $local_fs $remote_fs $syslog
# Required-Stop:     $remote_fs
# Default-Start:     
# Default-Stop:      
# Short-Description: Nova NoVNC proxy
# Description:       Nova NoVNC proxy
### END INIT INFO
$ sudo chown -R www-data:www-data /var/www/webvirtmgr
```

Add file `webvirtmgr.conf` in `/etc/supervisor/conf.d`:  

```
[program:webvirtmgr]
command=/usr/bin/python /var/www/webvirtmgr/manage.py run_gunicorn -c /var/www/webvirtmgr/conf/gunicorn.conf.py
directory=/var/www/webvirtmgr
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/webvirtmgr.log
redirect_stderr=true
user=www-data

[program:webvirtmgr-console]
command=/usr/bin/python /var/www/webvirtmgr/console/webvirtmgr-console
directory=/var/www/webvirtmgr
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/webvirtmgr-console.log
redirect_stderr=true
user=www-data
```

Restart supervisor daemon :  
```
$ sudo service supervisor stop
$ sudo service supervisor start
```

\- **Step 5 : Update**

```
$ cd /var/www/webvirtmgr
$ sudo git pull
$ sudo ./manage.py collectstatic
$ sudo service supervisor restart
```

\- **Step 6 : Debug**

If you have error or not run panel (only for DEBUG or DEVELOP):  
```
$ ./manage.py runserver 0:8000
```

Enter in your browser:  
```
http://x.x.x.x:8000 (x.x.x.x - your server IP address )
```

<a name="3.2.3"></a>
### 3.2.3. Cài đặt trên host server 1 và host server 2

\- Thao tác này thực hiện trên server host. Trước khi cài đặt KVM lên node này, cần kiểm tra xem bộ xử lý của máy có hỗ trợ ảo hóa không (VT-x hoặc AMD-V). Nếu thực hiện lab trên máy thật cần khởi động lại máy này vào BIOS thiết lập chế độ hỗ trợ ảo hóa. Tuy nhiên bài lab này thực hiện trên VMWare nên trước khi cài đặt cần thiết lập cho máy ảo hỗ trợ ảo hóa như sau:  

<img src="http://i.imgur.com/BEqXSBo.png" />

\- Cài đặt KVM :  
```
sudo apt-get install qemu-kvm libvirt-bin bridge-utils
```

\- Thêm người dùng muốn access thông qua Webvirt vào group `libvirtd`:  
```
sudo adduser <user_name> libvirtd
```

\- Tiến hành cấu hình libvirt:  
- Mở file `vi /etc/libvirt/libvirtd.conf`. Uncomment và chỉnh sửa lại các dòng với giá trị như dưới đây:  
```
listen_tls = 0
listen_tcp = 1
listen_addr = "0.0.0.0"
tcp_port = "16509"
auth_tcp = "none"
```

- Mở file `vi /etc/default/libvirt-bin`. Chỉnh sửa lại như sau:  
```
libvirtd_opts="-l -d"
```

- Kiểm tra lại việc cài đặt :  
```
root@ubuntu:~# ps ax | grep libvirtd
  1638 ?        Sl     1:24 /usr/sbin/libvirtd -l –d
root@ubuntu:~~# service libvirt-bin restart
root@ubuntu:~# sudo netstat -pantu | grep libvirtd
tcp        0      0 0.0.0.0:16509           0.0.0.0:*               LISTEN                                                                                              1638/libvirtd
root@ubuntu:~# virsh -c qemu+tcp://127.0.0.1/system
Welcome to virsh, the virtualization interactive terminal.

Type:  'help' for help with commands
       'quit' to quit

virsh # exit
```

>Chú ý: virsh là một công cụ quản lý máy ảo tương tự như webvirt, virt-manager, etc. nhưng có giao diện dòng lệnh.

<a name="3.3"></a>
## 3.3.Sử dụng Webvirt
\- Note 1 : Nếu quên password , ta truy cập vào thư mục `/var/www/webvirtmgr`, dùng câu lệnh :  
```
./manage.py changepassword <user_name>
```

để thay đổi password .
\- Note 2 : Truy cập vào IP_address của Webvirt host và dùng .  

### a. Create new connection
<img src="http://i.imgur.com/uxBbQLt.png" />

### b. Tạo pool mới
\- Tạo thư mục chứa images
Mặc định thư mục chứa files images là `/var/lib/libvirt/images` .

<img src="http://i.imgur.com/6HsJP1I.png" />

<img src="http://i.imgur.com/cpt5rLz.png" />

\- Tạo thư mục chứa iso :  
Mặc định thư mục chứa files iso là `/var/www/webvirtmgr/images` , tất nhiên thư mục này không có trên Server nên chúng ta cần đổi đường dẫn đến thư mục bất kì do chúng ta tạo.  
Chúng ta phải tạo ra thư mục đó vì nó ko có sẵn.  

<img src="http://i.imgur.com/c339OzS.png" />

>Note 1 : 
Thực chất Pool chứa images ( DIR ) và pool chứa ISO là giống nhau , đều là Pool chứa images.  
Nhưng giao diện Webvirt không cho bản upload images ở Pool DIR mà buộc phải upload file images và iso ở Pool ISO.  
Bạn có thể upload images vào pool DIR bằng command trên server.  
Người ta thường tạo images rỗng trong Pool DIR và upload iso trong Pool ISO sao đó connect chúng với nhau.  

>Note 2 :
 Error when create storage pool chứa ISO  
 error đôi khi xuất hiện trên chrome , các web brower khác vẫn create bình thường .  

<img src="http://i.imgur.com/Sh5zSey.png" />

### c. Create network and vswitch
<img src="http://i.imgur.com/xovfMrp.png" />

> Note :  
\- Muốn tạo network ở chế độ bridge, trước hết ta cần tạo virtual switch và gắn card mạng trên host vào virtual switch.  
\- Nếu tạo vswitch và gắn card mạng trên host vào vswitch bằng command thì sau khi restart lại host , virtual switch sẽ mất và ta phải tạo lại. Chúng ta cũng có thể tạo virtual switch và gắn card mạng trên host vào vswitch bằng cách cấu hình file /etc/network/interfaces (đối với Ubuntu 16.04) thì vswitch sẽ vĩnh viễn.  
\- Tuy nhiên , theo bản thân mình nhận thấy việc tạo network với type BRIDGE này là vô nghĩa , chúng ta chỉ cần tạo vswitch sử dụng chế độ bridge là đủ.  

<img src="http://i.imgur.com/YUOa9oA.png" />

### d. Create VM
\- Chuyển  qua tab `Storage`:  
<img src="http://i.imgur.com/rHCWva9.png" />

Click vào nút "Add image", tạo image của hệ điều hành, thiết lập tên, định dạng và kích thước phù hợp:  

<img src="http://i.imgur.com/4DGb3gy.png" />

Tạo instance(máy ảo) mới:  
<img src="http://i.imgur.com/x9i98DZ.png" />

Tùy chỉnh các thông số của máy ảo:  
<img src="http://i.imgur.com/UYlv21R.png" />

<img src="http://i.imgur.com/xNl5bEU.png" />

\- Nếu image file là file chứa OS thì ta chỉ cần power on VM là xong. Nếu image file rỗng thì ta cần connec `.iso` với image file rỗng đó.  
Chọn file `.iso` để cài đặt hệ điều hành:  
<img src="http://i.imgur.com/OqZDPRq.png" />

Bật máy ảo :  
<img src="http://i.imgur.com/2zIWtZo.png" />

Bật VNC viewer:  
<img src="http://i.imgur.com/Q6F3Z2Y.png" />  

<a name="4"></a>
# 4.virt-install

<a name="4.1"></a>
## 4.1.Lý thuyết
Tham khảo :  
http://manpages.ubuntu.com/manpages/xenial/man1/virt-install.1.html 

<a name="4.2"></a>
## 4.2.Tóm tắt

<a name="4.2.1"></a>
### 4.2.1.Introduction
\- virt-install is a command line tool for creating new KVM, Xen, or Linux container guests using the "libvirt" hypervisor management library.  

<a name="4.2.2"></a>
### 4.2.2.SYNOPSIS
```
virt-install [OPTION]...
```

- Most options are not required. Minimum requirements are `--name`,  `--memory`, guest storage (`--disk` or `--filesystem`), and an install.  

#### a.CONNECTING TO LIBVIRT
```
       -c URI
       --connect URI
           Connect to a non-default hypervisor. If this isn't specified,
           libvirt will try and choose the most suitable default.

           Some valid options here are:

           qemu:///system
               For creating KVM and QEMU guests to be run by the system
               libvirtd instance.  This is the default mode that virt-manager
               uses, and what most KVM users want.

           qemu:///session
               For creating KVM and QEMU guests for libvirtd running as the
               regular user.

           xen:///
               For connecting to Xen.

           lxc:///
               For creating linux containers
```

#### b.Option :
\- `-n` <NAME> or   `--name` <NAME>  
Name of the new guest virtual machine instance. This must be unique amongst all guests known to the hypervisor on the connection, including those not currently active.  
\- `-r` <number_MB> or `--ram` <number_MB>  
Ram của VM tính bằng MB.  
Bạn có thể dùng `--memory` option thay `-r` option.  
\- `--vcpus` <vCPU_number>  
Number of virtual cpus to configure for the guest.     
\- `-l` <LOCATION> or `--location` <OPTIONS>  
Đường đẫn đến file install , đó có thể là .ISO hoặc URL từ remote host.  
\- `--disk` <OPTIONS>  
Specifies media to use as storage for the guest, with various. The general format of a disk string is  
```
--disk opt1=val1,opt2=val2,...
```

The simplest invocation to create a new 10G disk image and disk device:  
`--disk size=10`  
**virt-install** will generate a path name, and place it in the default location for the hypervisor. To specify media, the command either be:  

`--disk /some/storage/path[,opt1=val1]...`  
or explicitly specify one of the following arguments:  
- `size` : size (in GiB) to use if creating new storage

>Note :  
--disk là option chỉ đường dẫn đến image hoặc một disk device lưu trữ VM, và size option sẽ chỉ định dung lượng của image. image sẽ được tạo trong quá trình thực thi command virt-install.  
Nếu image không rỗng mà là image chứa OS, thì ta không chỉ định --locaiton option mà thêm –import option.  

\- `--import` : Skip the OS installation process, and build a guest around an existing disk image. The device used for booting is the first device specified via "--disk" or "--filesystem".  
\- `-w` <OPTIONS> or `--network` <OPTIONS>  
 Connect the guest to the host network. OPTION :  
- bridge=<BRIDGE>
- network=<NAME>

\- `--graphics` <TYPE>,opt1=arg1,opt2=arg2,...  
Specifies the graphical display configuration.  
- **TYPE**  
The display type. This is one of:  
  - **vnc** : Setup a virtual console in the guest and export it as a VNC server in the host. Unless the "port" parameter is also provided, the VNC server will run on the first free port number at 5900 or above.
  - **none** : No graphical console will be allocated for the guest.
- **port** : Request a permanent, statically assigned port number for the guest console. This is used by 'vnc' and 'spice'.  
- **listen** : Address to listen on for VNC/Spice connections. Default is typically 127.0.0.1 (localhost only), but some hypervisors changing this globally (for example, the qemu driver default can be changed in /etc/libvirt/qemu.conf).  Use 0.0.0.0 to allow access from other machines. This is use by 'vnc' and 'spice'.  
- **password** : Request a VNC password, required at connection time. Beware, this info may end up in virt-install log files, so don't use an important password. This is used by 'vnc' and 'spice'.  

#### c.Note
\- Các option và arguments phải viết liền với dấu "=" và không được có space.  

<a name="4.2.3"></a>
### 4.2.3.Example
\- Create VM from location image file :  
```
virt-install \
              --connect qemu:///system \
              --name demo \
              --memory 500 \
              --vcpus 1 \
              --disk /var/lib/libvirt/images/cirros.disk.img \
              --import \
              --network network=default \
              --graphics vnc,listen='0.0.0.0'        
```

\- Create VM from location `.iso` file :  
```
virt-install \
              --connect qemu:///system \
              --name demo \
              --memory 1024 \
              --vcpus 1 \
              --disk /var/lib/libvirt/images/test.img,size=10 \
               --location /var/lib/libvirt/images/ubuntu-14.04.4-server-amd64.iso \
              --network network=default \
              --graphics vnc,listen='0.0.0.0'      
```

\- Create VM from on Internet use `netboot image`:  
```
virt-install \
              --connect qemu:///system \
              --name demo \
              --ram 1024 \
              --vcpus 1 \
              --disk /var/lib/libvirt/images/test.img,size=10 \
               --location http://vn.archive.ubuntu.com/ubuntu/dists/xenial/main/installer-i386/ \
              --network network=default \
              --graphics vnc,listen='0.0.0.0'      
```











