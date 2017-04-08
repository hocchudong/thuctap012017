# Lab tính năng Linux bridge




# MỤC LỤC
- [1.Topology](#1)
- [2.Cài đặt và cấu hình](#2)
	- [2.1.LAB 1](#2.1)
	- [2.2.LAB 2](#2.3)




<a name="1"></a>
# 1.Topology
<img src="http://i.imgur.com/symlOAC.png" />

\- Một host với 2 card ens33 và ens38 (có thể sử dụng virtual machine), cài Ubuntu Server 16.04 và software – linuxbridge, libvirt, KVM-QEMU.  
- LAB 1: Tạo một vswitch và gán interface ens33 vào vswitch đó. Tạo 2 VM trên host, xin cấp phát IP address và ping giữa 2 VM.
- LAB 2: Gắn cả 2 card ens33 và ens38 của host vào vswitch. Tạo 2 VM trên host, xin cấp phát IP address và ping giữa 2 VM với một trong 2 tường hợp sau :
  - TH1: Bật card ens33 và tắt card ens38. 
  - TH2 : Tắt card ens33 và bật card ens38.

<a name="2"></a>
# 2.Cài đặt và cấu hình

<a name="2.1"></a>
## 2.1.LAB 1
\- **Bước 1**: Khi tạo một vswitch mới br .Ta có thể sử dụng command hoặc cấu hình trong file `/etc/network/interfaces` để giữ cấu hình cho vswitch sau khi khởi động lại:  
- Sử dụng command ( khi restart lại máy sẽ mất ) :  
```
brctl addbr br # tạo mới
brctl addif br ens33 # Gán ens33 vào vswith br
brctl stp br on # enable tính năng STP nếu cần
brctl setfd br 2
ip a flush ens33 
#xin cấp phát ip cho br
dhclient br
#tự cấu hình
ifconfig br 172.16.69.10
```

- Cấu hình trong file  `/etc/network/interfaces` (restart lại máy không mất )  
```
#config ens33
auto ens33
iface ens33 inet manual 
#config br
auto br
iface br inet dhcp
bridge_ports ens33
bridge_stp on
bridge_fd 2
```

\- **Bước 2** : kiểm tra tra lại cấu hình bridge  
```
brctl show br 
```

Kết quả kiểm tra cấu hình sẽ tương tự như sau:

<img src="http://i.imgur.com/e9wrEDC.png" />

Kiểm tra xem có mạng không :  
<img src="http://i.imgur.com/9lWNP8c.png" />

\- **Bước 3** : Tạo 2 VM trên host, xin cấp phát IP address và ping giữa 2 VM.  
- **Tạo VM1 và config để connected đến bridge br.**  
```
virsh edit KVM1
```

Tìm đến section `interface` và sửa lại như sau :  
```
<interface type='bridge'>
  <source bridge='br'/>
</interface>
```

- **Tạo VM2 và config để connected đến bridge `br`.**  
Tương tự VM1.  
- **Ping giữa 2 VM : VM1 và VM2**  

<img src="http://i.imgur.com/24qMjvM.png" />

<a name="2.2"></a>
## 2.2.LAB 2
\- Gắn cả 2 card ens33 và ens38 của host vào vswitch. Tạo 2 VM trên host, xin cấp phát IP address và ping giữa 2 VM với một trong 2 tường hợp sau :  
- **TH1**: Bật card ens33 và tắt card ens38. 
- **TH2** : Tắt card ens33 và bật card ens38.

\- Làm tương tự như bài LAB 1 nhưng gắn thêm card ens38 vào vswitch “br”. Cấu hình trong file  `/etc/network/interfaces`   

```
#config ens33
auto ens33
iface ens33 inet manual 
#config br
auto br
iface br inet dhcp
bridge_ports ens33 ens38
bridge_stp on
bridge_fd 2
```

\- **TH1** : Bật card `ens33` và tắt card `ens38`.    
Kết quả tương tự bài LAB 1.  
\- **TH2** : Tắt card `ens33` và bật card `ens38`.  
Kết quả :  
- Vswitch br có IP_address là `10.10.10.145/24` .

<img src="http://i.imgur.com/1CJfDyi.png" />

- Ping giữa 2 VM : VM1 và VM2

<img src="http://i.imgur.com/uX1NQ53.png" />

















