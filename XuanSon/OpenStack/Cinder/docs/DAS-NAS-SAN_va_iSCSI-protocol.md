# DAS - NAS - SAN và iSCSI protocol


# MỤC LỤC

<img src="../images/16.png" />

<img src="../images/17.png" />

<a name="1"></a>
# 1.DAS
\- Direct-attached storage (DAS) là kỹ thuật lưu trữ được attach trực tiếp với computer truy cập vào nó.   
\- Hệ thống DAS điển hình được làm bằng thiết bị lưu trữ dữ liệu ( ví dụ: một things chứa các hard disk drives) kết nối trực tiếp đến computer thông qua host bus adapter (HBA). Giữa 2 điểm này không tồn tại network device (như hub, switch hoặc router).  
\- Ví dụ: DAS bao gồm: hard drives, solid-state drives, optical disc drives, and storage on external drives.  
\- Giao thức chính được dụng cho DAS để kết nối là ATA, SATA, SCSI, USB, USB 3.0, Fibre Channel.  

<a name="2"></a>
# 2.NAS
\- NAS (Network-attached storage) là kỹ thuật lưu trữ dữ liệu dạng file-level thông qua kết nối mạng.  
\- Một đơn vị NAS là 1 computer được kết nối network cung cấp dịch vụ lưu trữ dữ liệu dựa trên file đến 1 thiết bị khác trên network.  
\- Hệ thống NAS chứa 1 hoặc nhiều hard disk drives, thường được sawxp xếp hợp lý thành các kho lưu trữ dự phòng hoặc RAID.  
\- NAS sử dụng giao thức dựa trên file như NFD (phổ biến trên hệ thống UNIX), SMB/CIFS (Server Message Block/Common Internet File System) ( được sử dụng trên hệ thống MS Windows), AFP ( được sử dụng trên Apple Macintosh computers), hoặc NCP ( được sử dụng với OES và Novell NetWare)  

<a name="3"></a>
# 3.SAN
<a name="3.1"></a>
## 3.1.Tổng quan
\- SAN (Storage area network) là kỹ thuật lưu trữ dữ liệu dạng block-level thông qua kết nối mạng.  
\- SAN được sử dụng để tăng khả năng lưu trữ của thiết bị, như disk arrays, tape libraries, etc.  
\- SAN thường có mạng lưới lưu trữ riêng mà không thông qua mạng LAN với các thiết bị khác.  
\- SAN sử dụng các giao thức sau: Fibre Channel, iSCSI, ATA over Ethernet (AoE) and HyperSCSI.  

<a name="3.2"></a>
## 3.2.iSCSI protocol
\- iSCSI (Internet Small Computer  Systems Interface) là là giao thức Internet thuộc tầng application để lưu trữ thông qua Internet. Nó cung cấp truy cập block-level để truy cập thiết bị lưu trữ.  
\- iSCSI được sử dụng để truyền data qua LAN, WAN hoặc Internet.  
\- Một số khái niệm:  
- Initiator: là 1 iSCSI client.
- Target: là nơi chứa thiết bị lưu trữ data gọi – iSCSI server.

\- iSCSI sử dụng giao thức TCP (tiêu biểu là port 860 và 3260)  

<a name="3.3"></a>
## 3.3.LAB iSCSI protocol

<a name="3.3.1"></a>
### 3.3.1.Tổng quan
\- Mô hình:  

<img src="../images/18.png" />

\- Trong đó:  
- iSCSI Initiator: là Client sử dụng giao thức iSCSI để giao tiếp và sử dụng thiết bị lưu trữ bên Target.
- iSCSI Target: là Server chứa thiết bị lưu trữ và được truy cập bởi client.
- 2 máy đều cài hệ điều hành Ubuntu Server 16.04

\- Cài đặt:  
- iSCSI Initiator : Dùng gói “open-iscsi”.  
  - File cấu hình trong thư mục /etc/iscsi gồm:  
    - iscsid.conf: File cấu hình cho iscsi daemon. Nó đọc để startup.
    - initiatorname.iscsi: Tên của initator, daemon reds at the startup.
    - nodes directory: Thư mục chứa nodes và targets của họ.
    - send_targets directory: Thư mục chứa các targets được discovered.

open-iscsi được điều khiển bởi câu lệnh iscsiadm. Câu lệnh có thể discover các target, login/logout các target, display thông tin các session.

- iSCSI target: Dùng gói “iscsitarget”
  - File cấu hình bao gồm:  
    - Các file trong thư mục /etc/iet
    - File /etc/default/iscsitarget


<a name="3.3.2"></a>

### 3.3.2.Thực hành
<a name="a"></a>
#### a.Trên iSCSI Target
*) Cài package `iscisitarget`:  
```
apt-get install iscsitarget
```

*) Mở file `/etc/default/iscsitarget`:  
```
vi /etc/default/iscsitarget
```

và thiết lập:  
```
ISCSITARGET_ENABLE=true
```

*) Tiếp theo, ta cần tạo thiết bị lưu trữ, ta có thể sử dụng logical volume, image files, hard drive (/dev/sdb), hard drive partition (/dev/sdb1) hoặc RAID device (/dev/md0).  
Trong bài lab này, mình sử dụng image file:  
```
mkdir /storage
dd if=/dev/zero of=/storage/lun1.img bs=1024k count=1000
```

<img src="../images/19.png" />


( Nếu bạn muốn dụng logical volume, bạn có thể tạo logical volume storage_lun1trong volume group vg0 như sau:  
```
lvcreate -L 1G -n storage_lun1 vg0
```

)

*) Tiếp theo chúng ta sửa trong file `/etc/iet/ietd.conf`:  
Comment tất cả các dòng trong file và thêm vào những dòng sau:  
```
Target iqn.2017-07.com.example:storage.lun1
        IncomingUser client 123
        OutgoingUser
        Lun 0 Path=/storage/lun1.img,Type=fileio
        Alias LUN1
        #MaxConnections  6
```

\- Trong đó tên của target (iSCSI naming) phải là unique và được định nghĩa như sau:  
RFC document có quy định về iSCSI names.iSCSI name gồm 2 phần: type string và unique name string.  
type string có 2 loại như sau:  
- iqn. : iscsi qualifiled name
- eui. : eui-64 bit identifier

Hầu hết đều sử dụng iqn format. Ví dụ về tên initiator của mình: iqn.2017-07.com.example:storage.lun1  
- iqn : sử dụng iSCSI qualified name adress.
- 2017-07: the year of the month on which the naming authority acquired the domain name which is used in the iSCSI name. 
- com.example: reversed dns name which defines the organizational naming authority.
- storage.lun1: String này ta đặt sao cho dễ nhớ với file image (hoặc logical volume) tương ứng

\- Dòng IncomingUser chứa username và password cung cấp cho initiators (client) để chỉ những username và password này có thể log in và sử dụng thiết bị lưu trữ, nếu bạn không cần authentication thì không cần chỉ định username và password trong dòng IncomingUser.  
\- Trong dòng Lun, ta phải chỉ định full path đến thiết bị lưu trữ (VD: /dev/vg0/storage_lun1, /storage/lun1.img, /dev/sdb, etc.).  

*) Ta chỉ định những initiator được phép truy cập vào thiết bị lưu trữ này (tên của thiết bị lưu trữ lúc này là `iqn.2017-07.com.example:storage.lun1`).  
Mở file `/etc/iet/initiators.allow` và comment out dòng `ALL ALL` , bởi vì nó đồng ý cho tất cả cac initiators kết nối đến tất cả các target. Tiếp đó, thêm dòng:  
```
iqn.2017-07.com.example:storage.lun1 172.16.69.102
```

Trong đó `172.16.69.102` là **IP của Initiator**.

\- Restart iSCSI target:  
```
service iscsitarget restart
```

<a name="b"></a>

#### b.Trên iSCSI Initiator

*) Cài package `open-iscsi`:  
```
apt-get install open-iscsi
```

*) Mở file `/etc/iscsi/iscsid.conf` và thiết lập:  
```
node.startup = automatic
```

*) Restart lại `open-iscsi`:  
```
service open-iscsi restart
```

*) Check xem những thiết bị lưu trữ nào Target có thể cung cấp:  
```
iscsiadm -m discovery -t st -p 172.16.69.101
```

trong đó `172.16.69.101` là **IP của iSCSI Target**.

<img src="../images/20.png" />

*) Xem các node đã khám phá được:  
```
iscsiadm –m node
```

<img src="../images/21.png" />

*) Thiết lập về các thiết bị được lưu trữ trong thư mục `/etc/iscsi/nodes` .Trong bài lab này, nó được lưu trữ trong file `/etc/iscsi/nodes/iqn.2017-07.com.example:storage.lun1/172.16.69.101,3260,1/default` .  
Ta có sửa trong file default bằng cách thiết lập các dòng như sau:  
```
node.session.auth.authmethod = CHAP
node.session.auth.username = client
node.session.auth.password = 123
```

hoặc chúng ta có sửa file bằng câu lệnh:  
```
iscsiadm -m node --targetname "iqn.2017-07.com.example:storage.lun1" --portal "172.16.69.101:3260" --op=update --name node.session.auth.authmethod --value=CHAP
iscsiadm -m node --targetname "iqn.2017-07.com.example:storage.lun1" --portal "172.16.69.101:3260" --op=update --name node.session.auth.username --value=client
iscsiadm -m node --targetname "iqn.2017-07.com.example:storage.lun1" --portal "172.16.69.101:3260" --op=update --name node.session.auth.password --value=123
```

*) Login vào thiết bị:  
```
iscsiadm -m node --targetname "iqn.2017-07.com.example:storage.lun1" --portal "172.16.69.101:3260" --login
```

<img src="../images/22.png" />

( Ta có thể logout:  
```
iscsiadm -m node --targetname "iqn.2017-07.com.example:storage.lun1" --portal "172.16.69.101:3260" --logout
```

)

*) Sau khi login thành công, ta kiểm tra ổ cứng mới có được:  

<img src="../images/23.png" />

\- Do ở đây mình đã thiết lập phân vùng sdb1 từ trước.
\- Sau khi đã có ổ cứng, ta có thể tạo phân dùng, format phân vùng và mount để dùng bình thường.


<a name="4"></a>
# 4.So sánh NAS và SAN
<img src="../images/24.png" />


