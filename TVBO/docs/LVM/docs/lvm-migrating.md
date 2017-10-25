# 6. Tính năng LVM Migrating

____

# Mục lục


- [6.1 Giới thiệu về tính năng](#about)
- [6.2 Các bước thực hiện để có thể sử dụng tính năng](#set-up)
- [6.3 Kiểm tra kết quả của tính năng](#check-result)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="about">6.1 Giới thiệu về tính năng</a>

    - LVM Migrating là một tính năng tuyệt vời. Với tính năng này, ta có thể tạo ra một bản sao dữ liệu từ một `Logical Volume` này đến một ổ đĩa mới mà không làm mất dữ liệu cũng như xảy ra tình trạng downtime.

    - Mục đích của tính năng này đó là di chuyển dữ liệu của chúng ta từ một đĩa cứng cũ đến một đĩa cứng mới. Điều này được thực hiện khi mà trên đĩa hiện đang lưu dữ liệu phát sinh ra một số lỗi.

- ### <a name="set-up">6.2 Các bước thực hiện để có thể sử dụng tính năng</a>

    - Đầu tiên, giả sử ta có 1 disk với các thông số như sau:

            # fdisk -l
            Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
            Units = sectors of 1 * 512 = 512 bytes
            Sector size (logical/physical): 512 bytes / 512 bytes
            I/O size (minimum/optimal): 512 bytes / 512 bytes

    - Tiếp theo, ta sẽ sử dụng disk `/dev/sdb` để tạo ra 2 phân vùng `/dev/sdb1` và `/dev/sdb2` với dung lượng lần lượt là 10Gb và 9Gb. Các bước được thực hiện như sau:

            # fdisk /dev/sdb
            Command (m for help): n
            Partition type:
               p   primary (0 primary, 0 extended, 4 free)
               e   extended
            Select (default p): p
            Partition number (1-4, default 1): 1
            First sector (2048-41943039, default 2048):
            Using default value 2048
            Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039): +10G
            Partition 1 of type Linux and of size 10 GiB is set

            Command (m for help): t
            Selected partition 1
            Hex code (type L to list all codes): 8e
            Changed type of partition 'Linux' to 'Linux LVM'

            Command (m for help): n
            Partition type:
               p   primary (1 primary, 0 extended, 3 free)
               e   extended
            Select (default p): p
            Partition number (2-4, default 2):
            First sector (20973568-41943039, default 20973568):
            Using default value 20973568
            Last sector, +sectors or +size{K,M,G} (20973568-41943039, default 41943039): +10G
            Value out of range.
            Last sector, +sectors or +size{K,M,G} (20973568-41943039, default 41943039): +9G
            Partition 2 of type Linux and of size 9 GiB is set

            Command (m for help): t
            Partition number (1,2, default 2):
            Hex code (type L to list all codes): 8e
            Changed type of partition 'Linux' to 'Linux LVM'

            Command (m for help): p

            Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
            Units = sectors of 1 * 512 = 512 bytes
            Sector size (logical/physical): 512 bytes / 512 bytes
            I/O size (minimum/optimal): 512 bytes / 512 bytes
            Disk label type: dos
            Disk identifier: 0x39e881bc

               Device Boot      Start         End      Blocks   Id  System
            /dev/sdb1            2048    20973567    10485760   8e  Linux LVM
            /dev/sdb2        20973568    39847935     9437184   8e  Linux LVM

            Command (m for help): w
            The partition table has been altered!

            Calling ioctl() to re-read partition table.
            Syncing disks.

    - Bước thứ 3, ta sẽ tạo ra các `Physical Volume` từ hai đĩa `/dev/sdb1` và `/dev/sdb2` như sau:

            # pvcreate /dev/sdb[1-2]

        kết quả sẽ hiển thị như sau:

              Physical volume "/dev/sdb1" successfully created.
              Physical volume "/dev/sdb2" successfully created.

    - Bước thứ 4, ta sẽ tạo ra một `Volume Group` từ hai `Physical Volume` đã tạo ra:

            # vgcreate LVM_VG_Pool /dev/sdb[1-2]

    - Bước thứ 5, tạo ra một `Mirror Volume` từ `Volume Group` vừa tạo với câu lệnh:

            #  lvcreate -L 5G -m 1 -n LVM_MIRROR_LV LVM_VG_Pool

        trong đó: 

            - `LVM_MIRROR_LV`: là tên của `Logical Volume` sẽ tạo ra
            - `LVM_VG_Pool`: là tên của `Volume Group` sử dụng để tạo `Logical Volume`
            - `-L 5G`: Khai báo dung lượng của `Logical Volume` sẽ tạo ra là 5Gb
            - `-m 1`: Khai báo số bản sao lưu của dữ liệu. Ở đây là 1 (nhưng sẽ tạo ra 2).

        kết quả sẽ hiện thị tương tự như sau:

              Logical volume "LVM_MIRROR_LV" created.

        kiểm tra kết quả với câu lệnh `lvdisplay -v` ta có thể nhận được dòng thông tin như sau:

              Mirrored volumes       2

    - Bước thứ 6, ta sẽ tạo ra một filesystem cho `Mirrored Volume` vừa tạo và thực hiện mount nó vào thư mục `/mnt/Mirror`:

            # mkfs.ext4 /dev/LVM_VG_Pool/LVM_MIRROR_LV

            # mkdir /mnt/Mirror

            # mount /dev/LVM_VG_Pool/LVM_MIRROR_LV /mnt/Mirror

        như vậy, ta đã tạo và sử dụng thành công `Mirror Volume`.

- ### <a name="check-result">6.3 Kiểm tra kết quả của tính năng</a>

    - Đầu tiên, ta tạo một file trong thư mục `/mnt/Mirror` có chưa nội dung. Ví dụ:

            # echo "Hello World." >> greet.txt

    - Tại đây, ta sử dụng câu lệnh ` lvs -a -o +devices` để kiểm tra thông tin về `Logical Volume`. Kết quả hiển thị tương đương như sau:

              LV                       VG          Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices                         
              LVM_MIRROR_LV            LVM_VG_Pool rwi-aor---  5.00g                                    100.00           LVM_MIRROR_LV_rimage_0(0),LVM_MIRROR_LV_rimage_1(0)
              [LVM_MIRROR_LV_rimage_0] LVM_VG_Pool iwi-aor---  5.00g                                                     /dev/sdb1(1)                    
              [LVM_MIRROR_LV_rimage_1] LVM_VG_Pool iwi-aor---  5.00g                                                     /dev/sdb2(1)                    
              [LVM_MIRROR_LV_rmeta_0]  LVM_VG_Pool ewi-aor---  4.00m                                                     /dev/sdb1(0)                    
              [LVM_MIRROR_LV_rmeta_1]  LVM_VG_Pool ewi-aor---  4.00m                                                     /dev/sdb2(0)                    
              root                     cl          -wi-ao---- 17.00g                                                     /dev/sda2(512)                  
              swap                     cl          -wi-ao----  2.00g                                                     /dev/sda2(0)                    

        với kết quả trên, ta thấy:

            - `LVM_MIRROR_LV` đang được gắn kết với 2 thiết bị là `LVM_MIRROR_LV_rimage_0(0)`, `LVM_MIRROR_LV_rimage_1(0)`
            - `LVM_MIRROR_LV_rimage_0(0)`, `LVM_MIRROR_LV_rimage_1(0)` lại là 2 `Logical Volume` lần lượt được gắn kết với
                2 disk là `/dev/sdb1(1)` và `/dev/sdb2(1)`.

    - Như vậy ta thấy được, dữ liệu của `Mirror Volume` đang được lưu trên 2 đĩa. Như vậy, ta có thể tùy ý xóa đi một bản sao của Volume mà không lo đến mất dữ liệu. Để thực hiện xóa đi một `Mirrored Volume`, ta sử dụng câu lệnh:

             lvconvert -m 0 /dev/LVM_VG_Pool/LVM_LV_Mirror /dev/sdb1
        
        trong đó:

            - `-m 0`: Khai báo chuyển đổi từ `Mirror Volume` sang `Linear Volume` (xóa đi)
            - `/dev/sdb1`: Khai báo tên của thiết bị sẽ bị xóa `Mirrored Volume`
            - `/dev/LVM_VG_Pool/LVM_LV_Mirror`: Khai báo tên của `Mirror Volume`

        kiểm tra lại với câu lệnh ` lvs -o+devices -a`, ta có kết quả tương tự như sau:

              LV            VG          Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
              LVM_LV_Mirror LVM_VG_Pool -wi-ao----  5.00g                                                     /dev/sdb2(1)
              root          cl          -wi-ao---- 17.00g                                                     /dev/sda2(512)
              swap          cl          -wi-ao----  2.00g                                                     /dev/sda2(0)

        như trên ta thấy, `LVM_LV_Mirror` đang sử dụng mỗi `/dev/sdb2` để lưu trữ dữ liệu. Ta thử kiểm tra lại thông tin của file `greet.txt` đã tạo và thấy dữ liệu vẫn vẹn toàn.

            # cat greet.txt
            Hello World.


# Tài liệu tham khảo

- [Migrating LVM Partitions to New Logical Volume (Drive) - Part VI](https://www.tecmint.com/lvm-storage-migration/)

____

# <a name="content-others">Các nội dung khác</a>
