# Libvirt



# MỤC LỤC
- [1.Introduction and Install libvirt toolkit](#1)
	- [1.1.Introduction toolkit](#1.1)
	- [1.2.Install on Ubuntu Server 16.04](#1.2)
- [2.Virtual Netowrking trong libvirt](#2)
- [3.Edit file XML for the VM](#3)
	- [3.1. Config VM connected virtual network](#3.1)
	- [3.2. Thêm Network Card cho VM](#3.2)
	- [3.3. Config VM connected virtual switch](#3.3)
- [4.Một số thông tin quan trọng](#4)
	- [4.0.Tóm lại network](#4.0)
	- [4.1.Libvirt directory on Ubuntu Server 16.04](#4.1)
	- [4.2.Quyền cho phép sử dụng API – libvirt](#4.2)
	- [4.3.Config libvirt daemon](#4.3)
	- [4.4.Service libvirt](#4.4)
- [THAM KHẢO](#thamkhao)




<a name="1"></a>
# 1.Introduction and Install libvirt toolkit

<a name="1.1"></a>
## 1.1.Introduction toolkit
Libvirt toolkit là :  
- is a toolkit to manage virtualization hosts (libvirt is  hypervisor management library.)
- is accessible from C, Python, Perl, Java and more
- is licensed under open source licenses
- supports KVM, QEMU, Xen, Virtuozzo, VMWare ESX, LXC, BHyve and more
- targets Linux, FreeBSD, Windows and OS-X
- is used by many applications như virsh , virsh-install ,virt-manager,Webvirt.

<img src="http://i.imgur.com/M0V8Jmd.png" />

<a name="1.2"></a>
## 1.2.Install on Ubuntu Server 16.04
Run command :  
```
sudo apt-get install libvirt-bin
```

<a name="2"></a>
# 2.Virtual Netowrking trong libvirt

Đọc trong :  
http://wiki.libvirt.org/page/VirtualNetworking  
http://libvirt.org/formatnetwork.html  

<a name="3"></a>
# 3.Edit file XML for the VM

<a name="3.1"></a>
## 3.1. Config VM connected virtual network 
Open the XML configuration for the VM in a text editor.  
```
virsh edit <name-of-vm>
```

Tìm đến section `<interface>`  
``` 
<interface type="network">
   <source network="default"/>
   <mac address="52:54:00:4f:47:f2"/>
</interface>
```

và sử defualt thành virtual network bạn muốn VM connected.  
```
<interface type="network">
  <source netowrk="virtual_network_name"/>
  <mac address="52:54:00:4f:47:f2"/>
</interface>
```

>Note : Nếu không ghi section `<mac … />` thì libvirt sẽ sinh ra 1 ramdom mac for the new interface này .  

<a name="3.2"></a>
## 3.2. Thêm Network Card cho VM
\- Thêm 1 section network tương tự :  
```
<interface type="network">
   <source network="default"/>
   <mac address="52:54:00:4f:47:f2"/>
</interface>
<interface type="network">
   <source network="default"/>
</interface>
```

<a name="3.3"></a>
## 3.3. Config VM connected virtual switch 
Open the XML configuration for the VM in a text editor.  
```
virsh edit <name-of-vm>
```

Tìm đến section `<interface>`  
``` 
<interface type="network">
   <source network="default"/>
   <mac address="52:54:00:4f:47:f2"/>
</interface>
```
để nguyên :  
```
<interface type="bridge">
  <source bridge="br"/>
  <mac address="52:54:00:4f:47:f2"/>
</interface>
```

> Note : Nếu không ghi section <mac … /> thì libvirt sẽ sinh ra 1 ramdom mac for the new interface này .

<a name="4"></a>
# 4.Một số thông tin quan trọng 

<a name="4.0"></a>
## 4.0.Tóm lại network
\- Tóm lại có 4 network mode :  
- NAT
- Routed
- Isolated
- Bridge

\- Bạn có thể tạo network mode như NAT, Routed, Isolated bằng sử dụng XML format . Còn đối với bridge mode, bạn phải config trong file `/etc/network/interfaces` đối với Ubuntu Server 16.04 và trong các file about interfaces đối với các OS khác .  

<a name="4.1"></a>
## 4.1.Libvirt directory on Ubuntu Server 16.04
\- Configuration directory : `/etc/libvirt` .  
\- Các file sinh ra từ /etc/libvirt được lưu trong : `/var/lib/libvirt` .  

<a name="4.2"></a>
## 4.2.Quyền cho phép sử dụng API – libvirt
\- Muốn user nào có quyền sử dụng API-libvirt thì add user đó vào libvirtd group . Sử dụng command :  
```
sudo adduser <username> libvirtd
```

\- Sau đó restart lại libvirt server hoặc restart lại máy .  
>Note :  
Mình đã thử restart lại libvirt service nhưng không được . Vì vậy mình khuyên các bạn nên restart lại máy .  

<a name="4.3"></a>
## 4.3.Config libvirt daemon
### a.Bước 1
\- ContOS, Fedora, RedHat  
Uncomment the line in the file `/etc/sysconfig/libvirtd`  
```
LIBVIRTD_ARGS="--listen"
```

\- Ubuntu, Debian  
Add the option -l in the file `/etc/default/libvirt-bin`  
```
libvirtd_opts="-d -l"
```

### b.Bước 2
\- Lý thuyết  
Libvirtd (the remote daemon) is configured from a file called `/etc/libvirt/libvirtd.conf`, or specified on the command line using `-f filename` or `--config filename`.  
This file should contain lines of the form below. Blank lines and comments beginning with `#` are ignored.
```
setting = value
```

The following settings, values and default are:

<img src="http://i.imgur.com/UmeZb6j.png" />  

<img src="http://i.imgur.com/02t7kms.png" />  

\- Example :  
```
listen_tls = 0
listen_tcp = 1
listen_addr = "0.0.0.0"
tcp_port = "16509"
auth_tcp = "none"
```

<a name="4.4"></a>
## 4.4.Service libvirt
\- Ubuntu, Debian :  
Restart the daemon libvirtd, because after installation it runs automatically.  
```
$ sudo service libvirt-bin restart
```

\- CentOS, Fedora, RedHat :  
Start the daemon libvirtd :  
```
# service libvirtd start
```

<a name="thamkhao"></a>
# THAM KHẢO  
- Mainpage :  http://libvirt.org/
  - Concept :
	http://libvirt.org/
	http://libvirt.org/apps.html
- Chi tiết :  
  - Introduction: http://wiki.libvirt.org/page/VirtualNetworking  
  - XML Format : http://libvirt.org/format.html
    - Netowrk XML format : http://libvirt.org/formatnetwork.html 
  - http://wiki.libvirt.org/page/Networking#Debian.2FUbuntu_Bridging  
  - libvirtd configuration file : https://libvirt.org/remote.html#Remote_libvirtd_configuration
- https://jamielinux.com/docs/libvirt-networking-handbook/bridged-network.html  
- File log : https://libvirt.org/logging.html
- 1 số vấn đề với bridged mode :
  - Linuxbridge : Config file /etc/network/interface with bridged network - Ubuntu Server 16.04 :  
http://manpages.ubuntu.com/manpages/xenial/man5/bridge-utils-interfaces.5.html  
  - Openvswitch : Config file /etc/network/interface with bridged network - Debian:  
https://github.com/openvswitch/ovs/blob/master/debian/openvswitch-switch.README.Debian  





















